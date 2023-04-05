#include <system.h>
#include "TDAAmp.h"

//Target PIC16F627A configuration word
#pragma DATA _CONFIG, _PWRTE_OFF & _WDT_OFF & _INTOSC_OSC_NOCLKOUT & _CP_OFF & _LVP_OFF & _BOREN_OFF & _MCLRE_OFF

//Set clock frequency
#pragma CLOCK_FREQ	4000000

char cTask;
char iMute = 0;
char iTmr0Counter = 0;

/******************************************************
  Function called once only to initialise variables and
  setup the PIC registers
*******************************************************/
void initialise() {
	pcon.OSCF = 1; // 4MHz internal osc

	// Configure port A - all outputs
	// RA0 = Mute Relay
	// RA1 = Power Relay
	// RA2 = IR LED
	// RA3 = Motor Up
	// RA4 = Motor Down
	// RA5 = MCLR (any input)
	// RA6 = Relay Audio In 1
	// RA7 = Spare Relay
	trisa = 0x20;
	porta = 0x00;
	// Configure port B
	// RB0 = IR
	// RB1 = Power Switch
	// RB2 = Standby LED
	// RB3 = Ext Decode Relay
	// RB4 = Relay Audio In 3
	// RB5 = Relay Audio In 2
	// RB6 = Rotary Encoder
	// RB7 = Rotary Encoder
	trisb = 0xC3; // RB0, RB1, RB6, RB7 are inputs
	portb = 0x00;

	option_reg = 0;
	option_reg.NOT_RBPU = 0; // enable pull ups

    // ADC setup
    cmcon = 7; //disable comparators

	// Setup for RB0 Interrupt [IR Data]
    option_reg.INTEDG = 0; // RB0 interrupt should occur on falling edge
	intcon.INTF = 0; // Clear RB0 interrupt flag bit
	intcon.INTE = 1; // RB0 Interrupt enabled (for IR)
	
	// 50ms timer0
	//Timer0 Registers Prescaler= 1:256 - TMR0 Preset = 60 - Freq = 19.93 Hz - Period = 0.050176 seconds
	option_reg.T0CS = 0; // bit 5  TMR0 Clock Source Select bit...0 = Internal Clock (CLKO) 1 = Transition on T0CKI pin
	option_reg.T0SE = 0; // bit 4 TMR0 Source Edge Select bit 0 = low/high 1 = high/low
	option_reg.PSA = 0; // bit 3  Prescaler Assignment bit...0 = Prescaler is assigned to the Timer0
	option_reg.PS2 = 1; // bits 2-0  PS2:PS0: Prescaler Rate Select bits
	option_reg.PS1 = 1;
	option_reg.PS0 = 1;
	tmr0 = 60; // preset for timer register
    intcon.T0IF = 0; // Clear timer 1 interrupt flag bit
	intcon.T0IE = 1; // Timer 1 interrupt enabled

    // Timer 2 setup - interrupt every 890us (0.00088800)
    // 4MHz settings
    t2con = 0x38;  //  0 0111 0 00 - 1:8 postscale, timer off, 1:1 prescale
    pr2 = IR_PR2_890US; // Preload timer2 comparator value - 0.00088800s
    pir1.TMR2IF = 0; // Clear timer 2 interrupt flag bit
	pie1.TMR2IE = 1; // Timer 2 interrupt enabled
    
    // Setup for RB6, RB7 Interrupt [Button press and encoder]
    intcon.RBIF = 0; // Clear Port B change interrupt flag bit
    intcon.RBIE = 1; // Port B change interrupt enabled

    // No task at initialisation
    cPortBPrevious = (portb & 0xC0);
    cTask = 0;
    
    // Start up delay to allow things to settle
    delay_s(1);
    // Ensure ports are still at their defaults
    //porta = 0x00;
   	portb = 0x00;

	// Enable all interrupts
	intcon.GIE = 1;
	// Enable all unmasked peripheral interrupts (required for TMR2 interrupt)
	intcon.PEIE = 1;
}

//------------------------------------------------------------------------------
// Interrupt handler
//------------------------------------------------------------------------------
void interrupt() {

	// external interrupt on RB0 - IR sensor
	if (intcon.INTF) {
		option_reg.INTEDG = rc5_intfCounter.0;
		rc5_intfCounter++;
		rc5_logicChange++;
        if (rc5_currentState == rc5_idleState) {
            // If the state was idle, start the timer
            rc5_logicInterval = 0;
            rc5_logicChange = 0;
            // Timer 2 should run for about 200us at first
            tmr2 = 0;
            // 4MHz settings
            pr2 = IR_PR2_200US;
            pir1.TMR2IF = 0; // Clear interrupt flag
            t2con.TMR2ON = 1; // Timer 2 is on
            rc5_currentState = rc5_initialWaitState;
        }
        intcon.INTF = 0; //clear interrupt flag.
	}
    // Interrupt on timer2 - IR code https://tamilarduino.blogspot.com/2014/06/ir-remote-philips-rc5-decoding-using.html
    if(pir1.TMR2IF) {
		rc5_pinState = IR_PIN;
        if (rc5_currentState != rc5_initialWaitState) {
            rc5_logicInterval++;
            IR_LED = rc5_logicInterval.0; // Flick IR LED
        }
        char iReset = 0;
        // Switch statement to process IR depending on where/state of the command timer currently expects to be
        switch (rc5_currentState){
            // If in initial wait state - timer completed the first 200us, switch to the normal 890us
            case rc5_initialWaitState:
                // Timer 2 interrupt every 890us
                tmr2 = 0;
                // 111 for exactly 888us
				pr2 = IR_PR2_890US; // Preload timer2 comparator value - 888us (0.000888s)
                // Switch to start bit state
                rc5_currentState = rc5_startBitState;
                break;
            // If in start bit state - check for (second) start bit, Logic on RB0 must change in 890us or considers as a fault signal.
            case rc5_startBitState:
                if ((rc5_logicInterval == 1) && (rc5_logicChange == 1)) {
                    // Valid start bits were found
                    rc5_logicInterval = 0;
                    rc5_logicChange = 0;
                    rc5_bitCount = 0;
                    rc5_inputData = 0;
                    rc5_currentState = rc5_captureBitState; // Switch to capturing state
                } else {
                    iReset = 1;
                }
                break;
            // If in capture bit state - sample RB0 logic every 1780us (rc5_logicInterval = 2)
            // Data is only valid if the logic on RB0 changed
            // Data is stored in rc5_command and rc5_address
            case rc5_captureBitState:
                // Logic interval must be 2 - 1780us
                if(rc5_logicInterval == 2) {
                    // Logic change must occur 2 times or less, otherwise it is invalid
                    if(rc5_logicChange <= 2) {
                        rc5_logicInterval = 0;
                        rc5_logicChange = 0;
                        // If the number of bits received is less than 12, shift the new bit into the inputData
                        if(rc5_bitCount < 12) {
                            rc5_bitCount++;
                            rc5_inputData <<= 1; // Shift recorded bits to the left
                            if(rc5_pinState == 1) {
                                rc5_inputData |= 1; // Add the new bit in
                            }
                        } else {
                            // All 12 bits received
                            rc5_command = rc5_inputData & 0x3F; // 00111111 - command is the last 6 bits
                            rc5_inputData >>= 6; // Shift 6 bits right, clearing command
                            rc5_address = rc5_inputData & 0x1F; // 00011111 - address is now the last 5 bits
                            rc5_inputData >>= 5; // Shift 5 bits right, clearing address
                            // Last bit is the flick bit
                            if (rc5_flickBitOld != rc5_inputData) {
                                rc5_flickBit = 1;
                                rc5_flickBitOld = rc5_inputData;
                            } else 
                                rc5_flickBit = 0;
                            
                            // Flag this task to the task array - IR command will be processed in the main loop
                            cTask.TASK_INT_EXT0 = 1;

                            // Command finished - reset status
                            iReset = 1;
                        }
                    } else {
                        // Not valid - reset status
                        iReset = 1;
                    }
                }
                break;
            default: 
                iReset = 1;
        }
        
        // Reset status if not valid
        if (iReset) {
            // Not valid - reset status
            rc5_currentState = rc5_idleState;
            t2con.TMR2ON = 0; // Disable Timer 2
            option_reg.INTEDG = 0; // Interrupt on falling edge
            IR_LED = 0; // switch off IR LED
        }
        pir1.TMR2IF = 0; // Clear interrupt flag
    }
    // Port change RB4-RB7
    if (intcon.RBIF) {
		// Have to read portb first, otherwise the interrupt flag sets again
		cPortBCurrent = (portb & 0xC0); // Read the last two bits
		cTask.TASK_INT_PORTB = 1;
        intcon.RBIF = 0;
    }
    // Interrupt on timer0 - turn motor off
    if(intcon.T0IF) {
		// Turn motors off
		if (iTmr0Counter > 2) {
			VOL_UP = 0;
			VOL_DOWN = 0;
			iTmr0Counter = 0;
		}
		iTmr0Counter++;
		tmr0 = 60;
        intcon.T0IF = 0;
	}
}

// Power on routine
void doPower() {
    if (iPower) {
        // Power off sequence
        RLY_MUTE = 0; // Mute amps        
        iPower = 0;
        delay_s(1); // Force a 1 second wait before powering down the amps
        RLY_POWER = 0; // Power off amps
		// Off input relays
		RLY_IN1 = 0;
		RLY_IN2 = 0;
		RLY_IN3 = 0;
        delay_s(6); // Force a 6 second wait before the ability to switch on again (allows electronics to drain)
    } else {
        // Power on sequence
        applyInput(); // Apply last input - In1 [0] is default
        delay_ms(300);
        RLY_POWER = 1; // Power on amps
        // Delay mute
        delay_s(2);
        iPower = 1;
        RLY_MUTE = 1; // Unmute amps
    }
}

void doMute() {
	RLY_MUTE = iMute.0;
	iMute++;
}

void applyInput() {
	switch (iActiveInput) {
		case 0:
			RLY_IN1 = 1;
			RLY_IN2 = 0;
			RLY_IN3 = 0;
			break;
		case 1:
			RLY_IN1 = 0;
			RLY_IN2 = 1;
			RLY_IN3 = 0;
			break;
		case 2:
			RLY_IN1 = 0;
			RLY_IN2 = 0;
			RLY_IN3 = 1;
			break;
	}
}

/******************************************************
  Functions to adjust the volume
*******************************************************/
void doMotorDown() {
	VOL_UP = 0; // Always turn the other direction off
	VOL_DOWN = 1;
	// Reset timer1, then start
	iTmr0Counter = 0;
	tmr0 = 60;
}

void doMotorUp() {
	VOL_DOWN = 0; // Always turn the other direction off
	VOL_UP = 1;
	// Reset timer1, then start
	iTmr0Counter = 0;
	tmr0 = 60;
}

/******************************************************
  Functions to adjust the active input
*******************************************************/
void doInputDown() {
    // Decrement the active input
    iActiveInput--;
    if (iActiveInput > 3) // If overflowed (less than 0)
        iActiveInput = 2;
    applyInput();
}

void doInputUp() {
    // Increment the active input
    iActiveInput++;
    if (iActiveInput >= 3)
        iActiveInput = 0;
    applyInput();
}

/******************************************************
  Read and process remote control RC5 commands
*******************************************************/
void rc5Process() {
    IR_LED = 0; // switch off IR LED
    if (rc5_address != 0) { // Addresses above zero are not for this device
        return;
    }

    // Process commands
    if (iPower) { // Don't process the following if power is off
        // Get current volume level
        switch (rc5_command) {
            // For each command, cause the correct action 
            case 13: // Mute (13 / 0x0D / D)
                if (rc5_flickBitOld != rc5_flickBit) { // Prevent repeated muting when holding the button
                    doMute();
                }
                break;
            case 16: // Volume up (16 / 0x10 / E)
                doMotorUp();
                break;
            case 17: // Volume down (17 / 0x11 / F)
                doMotorDown();
                break;
            case 32: // Input right (32 / 0x20 / V)
                if (rc5_flickBitOld != rc5_flickBit) { // Prevent repeated input changing when holding the button
                    doInputUp();
                }
                break;
            case 33: // Input left (33 / 0x21 / U)
                if (rc5_flickBitOld != rc5_flickBit) { // Prevent repeated input changing when holding the button
                    doInputDown();
                }
                break;
        }
    }
    // Process power button regardless of power state
    if (rc5_command == 12) { // Power (12 / 0x0C / A)
        if (rc5_flickBitOld != rc5_flickBit) // Prevent repeated power when holding the button
            doPower();
    }
}

void checkPowerSw() {
    // check pin 5 on port b has changed
	if (!SW_PWR) { // Switch pressed, wait 500ms
		delay_ms(700);
		if (!SW_PWR) { // if still pressed, activate power on/off sequence
			doPower();
		}
	}
}

void checkEncoders() {
	if (cPortBCurrent != cPortBPrevious) { // Check bits 6 and 7
	 	// Input must have changed
		// Clockwise rotation
		// A = 0, B = 0
		// A = 1, B = 0
		// A = 1, B = 1
		// A = 0, B = 1
		if (iPower) { // Don't process the following if power is off
			switch (cPortBPrevious) {
				case 0x00: // A off B off
					if (cPortBCurrent == 0x40) { // A on B off
						// Clockwise
						doInputUp();
					} else if (cPortBCurrent == 0x80) { // A off B on
						// Counter clockwise
						doInputDown();
					}
					break;
				case 0x40: // A on B off
					if (cPortBCurrent == 0xC0) { // A on B on
						// Clockwise
						doInputUp();
					} else if (cPortBCurrent == 0x00) { // A off B off
						// Counter clockwise
						doInputDown();
					}
					break;
				case 0xC0: // A on B on
					if (cPortBCurrent == 0x80) { // A off B on
						// Clockwise
						doInputUp();
					} else if (cPortBCurrent == 0x40) { // A on B off
						// Counter clockwise
						doInputDown();
					}
					break;
				case 0x80: // A off B on
					if (cPortBCurrent == 0x00) { // A off B off
						// Clockwise
						doInputUp();
					} else if (cPortBCurrent == 0xC0) { // A on B on
						// Counter clockwise
						doInputDown();
					}
					break;
			}
		}
		cPortBPrevious = cPortBCurrent;
	}
}

void main()
{
	initialise();

	while(1) {
        // Task scheduler
        // If there are tasks to be performed, find out the
        // most recent task from the array and execute it
        while (cTask > 0) {
		    if (cTask.TASK_INT_EXT0) {
				rc5Process(); // IR sensor received a signal
				IR_LED = 0; // Ensure LED is off
				cTask.TASK_INT_EXT0 = 0;
			} else if (cTask.TASK_INT_PORTB) {
                checkEncoders();
                cTask.TASK_INT_PORTB = 0;
            }
		}
		// Poll power switch
		checkPowerSw();
	}
}
