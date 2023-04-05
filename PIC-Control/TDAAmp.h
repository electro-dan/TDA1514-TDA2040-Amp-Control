#ifndef _TDAAMP_H_
#define _TDAAMP_H_

#include <system.h>
#include <stdio.h>

#define	TASKS_LIMIT			8
#define TASK_INT_EXT0		0
#define TASK_INT_PORTB		4
#define TASK_TIMER1_UNMUTE	6
#define TASK_TIMER1			7

// 25 for 200us
// 22 for 176us (doesn't work)
// 26 works
#define IR_PR2_200US 26
// 111 for 888us
// 105 for 840us (doesn't work)
// 112 = no, 111 = misses last bit, 110 = works fine
#define IR_PR2_890US 110

#define IR_PIN (portb.0)
#define STBY_LED (porta.2)
#define IR_LED (portb.2)
#define VOL_UP (porta.4)
#define VOL_DOWN (porta.3)
#define RLY_MUTE (porta.0)
#define RLY_POWER (porta.1)
#define RLY_IN1 (porta.6)
#define RLY_IN2 (portb.5)
#define RLY_IN3 (portb.4)
#define RLY_EXTDECODE (portb.3)
#define SW_PWR (portb.1)
char SW_PWROLD = 1;

// RA0 = Mute Relay
// RA1 = Power Relay
// RA2 = IR LED
// RA3 = Motor Up
// RA4 = Motor Down
// RA5 = MCLR
// RA6 = Relay Audio In 1
// RA7 = Spare Relay
// RB0 = IR
// RB1 = Power Switch
// RB2 = Standby LED
// RB3 = Ext Decode Relay
// RB4 = Relay Audio In 3
// RB5 = Relay Audio In 2
// RB6 = Rotary Encoder
// RB7 = Rotary Encoder

extern char iActiveInput;
extern char iExtSurroundMode;
char iPower = 0;
char iActiveInput = 0;

char cPortBCurrent;
char cPortBPrevious;

// For IR
unsigned short rc5_inputData; // input data takes 12 bits?
char rc5_bitCount;
char rc5_logicInterval, rc5_logicChange;

enum {
        rc5_idleState,
        rc5_initialWaitState,
        rc5_startBitState,
        rc5_captureBitState
};

char rc5_currentState = rc5_idleState;
char rc5_pinState = 1;
char rc5_intfCounter = 0;
char rc5_flickBit = 0;
char rc5_flickBitOld = 0;
char rc5_address = 0;
char rc5_command = 0;


void doPower();
void doMute();
void applyInput();
void doInputDown();
void doInputUp();

#endif //_TDAAMP_H_
