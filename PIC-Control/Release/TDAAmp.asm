;/////////////////////////////////////////////////////////////////////////////////
;// Code Generator: BoostC Compiler - http://www.sourceboost.com
;// Version       : 8.01
;// License Type  : Pro License
;// Limitations   : PIC12,PIC16 max code size:Unlimited, max RAM banks:Unlimited
;/////////////////////////////////////////////////////////////////////////////////

	include "P16F627A.inc"
; Heap block 0, size:95 (0x000000A0 - 0x000000FE)
__HEAP_BLOCK0_BANK               EQU	0x00000001
__HEAP_BLOCK0_START_OFFSET       EQU	0x00000020
__HEAP_BLOCK0_END_OFFSET         EQU	0x0000007E
; Heap block 1, size:53 (0x0000003B - 0x0000006F)
__HEAP_BLOCK1_BANK               EQU	0x00000000
__HEAP_BLOCK1_START_OFFSET       EQU	0x0000003B
__HEAP_BLOCK1_END_OFFSET         EQU	0x0000006F
; Heap block 2, size:48 (0x00000120 - 0x0000014F)
__HEAP_BLOCK2_BANK               EQU	0x00000002
__HEAP_BLOCK2_START_OFFSET       EQU	0x00000020
__HEAP_BLOCK2_END_OFFSET         EQU	0x0000004F
; Heap block 3, size:0 (0x00000000 - 0x00000000)
__HEAP_BLOCK3_BANK               EQU	0x00000000
__HEAP_BLOCK3_START_OFFSET       EQU	0x00000000
__HEAP_BLOCK3_END_OFFSET         EQU	0x00000000
gbl_status                       EQU	0x00000003 ; bytes:1
gbl_indf                         EQU	0x00000000 ; bytes:1
gbl_tmr0                         EQU	0x00000001 ; bytes:1
gbl_pcl                          EQU	0x00000002 ; bytes:1
gbl_fsr                          EQU	0x00000004 ; bytes:1
gbl_porta                        EQU	0x00000005 ; bytes:1
gbl_portb                        EQU	0x00000006 ; bytes:1
gbl_pclath                       EQU	0x0000000A ; bytes:1
gbl_intcon                       EQU	0x0000000B ; bytes:1
gbl_pir1                         EQU	0x0000000C ; bytes:1
gbl_tmr1l                        EQU	0x0000000E ; bytes:1
gbl_tmr1h                        EQU	0x0000000F ; bytes:1
gbl_t1con                        EQU	0x00000010 ; bytes:1
gbl_tmr2                         EQU	0x00000011 ; bytes:1
gbl_t2con                        EQU	0x00000012 ; bytes:1
gbl_ccpr1l                       EQU	0x00000015 ; bytes:1
gbl_ccpr1h                       EQU	0x00000016 ; bytes:1
gbl_ccp1con                      EQU	0x00000017 ; bytes:1
gbl_rcsta                        EQU	0x00000018 ; bytes:1
gbl_txreg                        EQU	0x00000019 ; bytes:1
gbl_rcreg                        EQU	0x0000001A ; bytes:1
gbl_cmcon                        EQU	0x0000001F ; bytes:1
gbl_option_reg                   EQU	0x00000081 ; bytes:1
gbl_trisa                        EQU	0x00000085 ; bytes:1
gbl_trisb                        EQU	0x00000086 ; bytes:1
gbl_pie1                         EQU	0x0000008C ; bytes:1
gbl_pcon                         EQU	0x0000008E ; bytes:1
gbl_pr2                          EQU	0x00000092 ; bytes:1
gbl_txsta                        EQU	0x00000098 ; bytes:1
gbl_spbrg                        EQU	0x00000099 ; bytes:1
gbl_eedata                       EQU	0x0000009A ; bytes:1
gbl_eeadr                        EQU	0x0000009B ; bytes:1
gbl_eecon1                       EQU	0x0000009C ; bytes:1
gbl_eecon2                       EQU	0x0000009D ; bytes:1
gbl_vrcon                        EQU	0x0000009F ; bytes:1
gbl_SW_PWROLD                    EQU	0x00000025 ; bytes:1
gbl_iActiveInput                 EQU	0x00000026 ; bytes:1
gbl_iPower                       EQU	0x00000027 ; bytes:1
gbl_cPortBCurrent                EQU	0x00000028 ; bytes:1
gbl_cPortBPrevious               EQU	0x00000029 ; bytes:1
gbl_rc5_inputData                EQU	0x00000023 ; bytes:2
gbl_rc5_bitCount                 EQU	0x0000002A ; bytes:1
gbl_rc5_logicInterval            EQU	0x0000002B ; bytes:1
gbl_rc5_logicChange              EQU	0x0000002C ; bytes:1
gbl_rc5_currentState             EQU	0x0000002D ; bytes:1
gbl_rc5_pinState                 EQU	0x0000002E ; bytes:1
gbl_rc5_intfCounter              EQU	0x0000002F ; bytes:1
gbl_rc5_flickBit                 EQU	0x00000030 ; bytes:1
gbl_rc5_flickBitOld              EQU	0x00000031 ; bytes:1
gbl_rc5_address                  EQU	0x00000032 ; bytes:1
gbl_rc5_command                  EQU	0x00000033 ; bytes:1
gbl_cTask                        EQU	0x00000034 ; bytes:1
gbl_iMute                        EQU	0x00000035 ; bytes:1
gbl_iTmr0Counter                 EQU	0x00000036 ; bytes:1
interrupt_15_iReset              EQU	0x00000039 ; bytes:1
CompTempVar551                   EQU	0x0000003A ; bytes:1
CompTempVar552                   EQU	0x0000003A ; bytes:1
delay_ms_00000_arg_del           EQU	0x00000038 ; bytes:1
delay_s_00000_arg_del            EQU	0x00000037 ; bytes:1
Int1Context                      EQU	0x0000007F ; bytes:1
Int1BContext                     EQU	0x00000020 ; bytes:3
	ORG 0x00000000
	GOTO	_startup
	ORG 0x00000004
	MOVWF Int1Context
	SWAPF STATUS, W
	BCF STATUS, RP0
	BCF STATUS, RP1
	MOVWF Int1BContext
	SWAPF PCLATH, W
	MOVWF Int1BContext+D'1'
	SWAPF FSR, W
	MOVWF Int1BContext+D'2'
	BCF PCLATH,3
	BCF PCLATH,4
	GOTO	interrupt
	ORG 0x00000010
delay_ms_00000
; { delay_ms ; function begin
	MOVF delay_ms_00000_arg_del, F
	BTFSS STATUS,Z
	GOTO	label1
	RETURN
label1
	MOVLW 0xF9
label2
	ADDLW 0xFF
	BTFSS STATUS,Z
	GOTO	label2
	NOP
	DECFSZ delay_ms_00000_arg_del, F
	GOTO	label1
	RETURN
; } delay_ms function end

	ORG 0x0000001C
delay_s_00000
; { delay_s ; function begin
label3
	MOVLW 0xFA
	MOVWF delay_ms_00000_arg_del
	CALL delay_ms_00000
	MOVLW 0xFA
	MOVWF delay_ms_00000_arg_del
	CALL delay_ms_00000
	MOVLW 0xFA
	MOVWF delay_ms_00000_arg_del
	CALL delay_ms_00000
	MOVLW 0xFA
	MOVWF delay_ms_00000_arg_del
	CALL delay_ms_00000
	DECFSZ delay_s_00000_arg_del, F
	GOTO	label3
	RETURN
; } delay_s function end

	ORG 0x0000002B
applyInput_00000
; { applyInput ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	MOVF gbl_iActiveInput, W
	XORLW 0x00
	BTFSC STATUS,Z
	GOTO	label4
	XORLW 0x01
	BTFSC STATUS,Z
	GOTO	label5
	XORLW 0x03
	BTFSC STATUS,Z
	GOTO	label6
	RETURN
label4
	BSF gbl_porta,6
	BCF gbl_portb,5
	BCF gbl_portb,4
	RETURN
label5
	BCF gbl_porta,6
	BSF gbl_portb,5
	BCF gbl_portb,4
	RETURN
label6
	BCF gbl_porta,6
	BCF gbl_portb,5
	BSF gbl_portb,4
	RETURN
; } applyInput function end

	ORG 0x00000044
doPower_00000
; { doPower ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	MOVF gbl_iPower, F
	BTFSC STATUS,Z
	GOTO	label7
	BCF gbl_porta,0
	CLRF gbl_iPower
	MOVLW 0x01
	MOVWF delay_s_00000_arg_del
	CALL delay_s_00000
	BCF gbl_porta,1
	BCF gbl_porta,6
	BCF gbl_portb,5
	BCF gbl_portb,4
	MOVLW 0x06
	MOVWF delay_s_00000_arg_del
	CALL delay_s_00000
	RETURN
label7
	CALL applyInput_00000
	MOVLW 0x2C
	MOVWF delay_ms_00000_arg_del
	CALL delay_ms_00000
	BSF gbl_porta,1
	MOVLW 0x02
	MOVWF delay_s_00000_arg_del
	CALL delay_s_00000
	MOVLW 0x01
	MOVWF gbl_iPower
	BSF gbl_porta,0
	RETURN
; } doPower function end

	ORG 0x00000062
doMute_00000
; { doMute ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	BTFSC gbl_iMute,0
	BSF gbl_porta,0
	BTFSS gbl_iMute,0
	BCF gbl_porta,0
	INCF gbl_iMute, F
	RETURN
; } doMute function end

	ORG 0x0000006A
doMotorUp_00000
; { doMotorUp ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	BCF gbl_porta,3
	BSF gbl_porta,4
	CLRF gbl_iTmr0Counter
	MOVLW 0x3C
	MOVWF gbl_tmr0
	RETURN
; } doMotorUp function end

	ORG 0x00000072
doMotorDow_00014
; { doMotorDown ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	BCF gbl_porta,4
	BSF gbl_porta,3
	CLRF gbl_iTmr0Counter
	MOVLW 0x3C
	MOVWF gbl_tmr0
	RETURN
; } doMotorDown function end

	ORG 0x0000007A
doInputUp_00000
; { doInputUp ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	INCF gbl_iActiveInput, F
	MOVLW 0x03
	SUBWF gbl_iActiveInput, W
	BTFSC STATUS,C
	CLRF gbl_iActiveInput
	CALL applyInput_00000
	RETURN
; } doInputUp function end

	ORG 0x00000083
doInputDow_00013
; { doInputDown ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	DECF gbl_iActiveInput, F
	MOVF gbl_iActiveInput, W
	SUBLW 0x03
	BTFSC STATUS,C
	GOTO	label8
	MOVLW 0x02
	MOVWF gbl_iActiveInput
label8
	CALL applyInput_00000
	RETURN
; } doInputDown function end

	ORG 0x0000008E
rc5Process_00000
; { rc5Process ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	BCF gbl_portb,2
	MOVF gbl_rc5_address, F
	BTFSS STATUS,Z
	RETURN
	MOVF gbl_iPower, F
	BTFSC STATUS,Z
	GOTO	label14
	MOVF gbl_rc5_command, W
	XORLW 0x0D
	BTFSC STATUS,Z
	GOTO	label9
	XORLW 0x1D
	BTFSC STATUS,Z
	GOTO	label10
	XORLW 0x01
	BTFSC STATUS,Z
	GOTO	label11
	XORLW 0x31
	BTFSC STATUS,Z
	GOTO	label12
	XORLW 0x01
	BTFSC STATUS,Z
	GOTO	label13
	GOTO	label14
label9
	MOVF gbl_rc5_flickBit, W
	XORWF gbl_rc5_flickBitOld, W
	BTFSS STATUS,Z
	CALL doMute_00000
	GOTO	label14
label10
	CALL doMotorUp_00000
	GOTO	label14
label11
	CALL doMotorDow_00014
	GOTO	label14
label12
	MOVF gbl_rc5_flickBit, W
	XORWF gbl_rc5_flickBitOld, W
	BTFSS STATUS,Z
	CALL doInputUp_00000
	GOTO	label14
label13
	MOVF gbl_rc5_flickBit, W
	XORWF gbl_rc5_flickBitOld, W
	BTFSS STATUS,Z
	CALL doInputDow_00013
label14
	MOVF gbl_rc5_command, W
	XORLW 0x0C
	BTFSS STATUS,Z
	RETURN
	MOVF gbl_rc5_flickBit, W
	XORWF gbl_rc5_flickBitOld, W
	BTFSS STATUS,Z
	CALL doPower_00000
	RETURN
; } rc5Process function end

	ORG 0x000000C3
initialise_00000
; { initialise ; function begin
	BSF STATUS, RP0
	BCF STATUS, RP1
	BSF gbl_pcon,3
	MOVLW 0x20
	MOVWF gbl_trisa
	BCF STATUS, RP0
	CLRF gbl_porta
	MOVLW 0xC3
	BSF STATUS, RP0
	MOVWF gbl_trisb
	BCF STATUS, RP0
	CLRF gbl_portb
	BSF STATUS, RP0
	CLRF gbl_option_reg
	BCF gbl_option_reg,7
	MOVLW 0x07
	BCF STATUS, RP0
	MOVWF gbl_cmcon
	BSF STATUS, RP0
	BCF gbl_option_reg,6
	BCF gbl_intcon,1
	BSF gbl_intcon,4
	BCF gbl_option_reg,5
	BCF gbl_option_reg,4
	BCF gbl_option_reg,3
	BSF gbl_option_reg,2
	BSF gbl_option_reg,1
	BSF gbl_option_reg,0
	MOVLW 0x3C
	BCF STATUS, RP0
	MOVWF gbl_tmr0
	BCF gbl_intcon,2
	BSF gbl_intcon,5
	MOVLW 0x38
	MOVWF gbl_t2con
	MOVLW 0x6E
	BSF STATUS, RP0
	MOVWF gbl_pr2
	BCF STATUS, RP0
	BCF gbl_pir1,1
	BSF STATUS, RP0
	BSF gbl_pie1,1
	BCF gbl_intcon,0
	BSF gbl_intcon,3
	MOVLW 0xC0
	BCF STATUS, RP0
	ANDWF gbl_portb, W
	MOVWF gbl_cPortBPrevious
	CLRF gbl_cTask
	MOVLW 0x01
	MOVWF delay_s_00000_arg_del
	CALL delay_s_00000
	CLRF gbl_portb
	BSF gbl_intcon,7
	BSF gbl_intcon,6
	RETURN
; } initialise function end

	ORG 0x000000FB
checkPower_00015
; { checkPowerSw ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	BTFSC gbl_portb,1
	RETURN
	MOVLW 0xBC
	MOVWF delay_ms_00000_arg_del
	CALL delay_ms_00000
	BTFSS gbl_portb,1
	CALL doPower_00000
	RETURN
; } checkPowerSw function end

	ORG 0x00000105
checkEncod_00016
; { checkEncoders ; function begin
	BCF STATUS, RP0
	BCF STATUS, RP1
	MOVF gbl_cPortBPrevious, W
	XORWF gbl_cPortBCurrent, W
	BTFSC STATUS,Z
	RETURN
	MOVF gbl_iPower, F
	BTFSC STATUS,Z
	GOTO	label23
	MOVF gbl_cPortBPrevious, W
	XORLW 0x00
	BTFSC STATUS,Z
	GOTO	label15
	XORLW 0x40
	BTFSC STATUS,Z
	GOTO	label17
	XORLW 0x80
	BTFSC STATUS,Z
	GOTO	label19
	XORLW 0x40
	BTFSC STATUS,Z
	GOTO	label21
	GOTO	label23
label15
	MOVF gbl_cPortBCurrent, W
	XORLW 0x40
	BTFSS STATUS,Z
	GOTO	label16
	CALL doInputUp_00000
	GOTO	label23
label16
	MOVF gbl_cPortBCurrent, W
	XORLW 0x80
	BTFSC STATUS,Z
	CALL doInputDow_00013
	GOTO	label23
label17
	MOVF gbl_cPortBCurrent, W
	XORLW 0xC0
	BTFSS STATUS,Z
	GOTO	label18
	CALL doInputUp_00000
	GOTO	label23
label18
	MOVF gbl_cPortBCurrent, F
	BTFSC STATUS,Z
	CALL doInputDow_00013
	GOTO	label23
label19
	MOVF gbl_cPortBCurrent, W
	XORLW 0x80
	BTFSS STATUS,Z
	GOTO	label20
	CALL doInputUp_00000
	GOTO	label23
label20
	MOVF gbl_cPortBCurrent, W
	XORLW 0x40
	BTFSC STATUS,Z
	CALL doInputDow_00013
	GOTO	label23
label21
	MOVF gbl_cPortBCurrent, F
	BTFSS STATUS,Z
	GOTO	label22
	CALL doInputUp_00000
	GOTO	label23
label22
	MOVF gbl_cPortBCurrent, W
	XORLW 0xC0
	BTFSC STATUS,Z
	CALL doInputDow_00013
label23
	MOVF gbl_cPortBCurrent, W
	MOVWF gbl_cPortBPrevious
	RETURN
; } checkEncoders function end

	ORG 0x00000148
main
; { main ; function begin
	CALL initialise_00000
label24
	MOVF gbl_cTask, W
	SUBLW 0x00
	BTFSC STATUS,C
	GOTO	label26
	BTFSS gbl_cTask,0
	GOTO	label25
	CALL rc5Process_00000
	BCF gbl_portb,2
	BCF gbl_cTask,0
	GOTO	label24
label25
	BTFSS gbl_cTask,4
	GOTO	label24
	CALL checkEncod_00016
	BCF gbl_cTask,4
	GOTO	label24
label26
	CALL checkPower_00015
	GOTO	label24
; } main function end

	ORG 0x0000015A
_startup
	MOVLW 0x01
	BCF STATUS, RP0
	BCF STATUS, RP1
	MOVWF gbl_SW_PWROLD
	CLRF gbl_iPower
	CLRF gbl_iActiveInput
	CLRF gbl_rc5_currentState
	MOVLW 0x01
	MOVWF gbl_rc5_pinState
	CLRF gbl_rc5_intfCounter
	CLRF gbl_rc5_flickBit
	CLRF gbl_rc5_flickBitOld
	CLRF gbl_rc5_address
	CLRF gbl_rc5_command
	CLRF gbl_iMute
	CLRF gbl_iTmr0Counter
	BCF PCLATH,3
	BCF PCLATH,4
	GOTO	main
	ORG 0x0000016D
interrupt
; { interrupt ; function begin
	BTFSS gbl_intcon,1
	GOTO	label31
	BCF STATUS, RP0
	BCF STATUS, RP1
	BTFSS gbl_rc5_intfCounter,0
	GOTO	label28
	BSF STATUS, RP0
	BSF gbl_option_reg,6
label28
	BCF STATUS, RP0
	BTFSC gbl_rc5_intfCounter,0
	GOTO	label29
	BSF STATUS, RP0
	BCF gbl_option_reg,6
label29
	BCF STATUS, RP0
	INCF gbl_rc5_intfCounter, F
	INCF gbl_rc5_logicChange, F
	MOVF gbl_rc5_currentState, F
	BTFSS STATUS,Z
	GOTO	label30
	CLRF gbl_rc5_logicInterval
	CLRF gbl_rc5_logicChange
	CLRF gbl_tmr2
	MOVLW 0x1A
	BSF STATUS, RP0
	MOVWF gbl_pr2
	BCF STATUS, RP0
	BCF gbl_pir1,1
	BSF gbl_t2con,2
	MOVLW 0x01
	MOVWF gbl_rc5_currentState
label30
	BCF gbl_intcon,1
label31
	BCF STATUS, RP0
	BCF STATUS, RP1
	BTFSS gbl_pir1,1
	GOTO	label49
	CLRF gbl_rc5_pinState
	BTFSS gbl_portb,0
	GOTO	label32
	INCF gbl_rc5_pinState, F
label32
	DECF gbl_rc5_currentState, W
	BTFSC STATUS,Z
	GOTO	label33
	INCF gbl_rc5_logicInterval, F
	BTFSC gbl_rc5_logicInterval,0
	BSF gbl_portb,2
	BTFSS gbl_rc5_logicInterval,0
	BCF gbl_portb,2
label33
	CLRF interrupt_15_iReset
	MOVF gbl_rc5_currentState, W
	XORLW 0x01
	BTFSC STATUS,Z
	GOTO	label34
	XORLW 0x03
	BTFSC STATUS,Z
	GOTO	label35
	XORLW 0x01
	BTFSC STATUS,Z
	GOTO	label37
	GOTO	label46
label34
	CLRF gbl_tmr2
	MOVLW 0x6E
	BSF STATUS, RP0
	MOVWF gbl_pr2
	MOVLW 0x02
	BCF STATUS, RP0
	MOVWF gbl_rc5_currentState
	GOTO	label47
label35
	DECF gbl_rc5_logicInterval, W
	BTFSS STATUS,Z
	GOTO	label36
	DECF gbl_rc5_logicChange, W
	BTFSS STATUS,Z
	GOTO	label36
	CLRF gbl_rc5_logicInterval
	CLRF gbl_rc5_logicChange
	CLRF gbl_rc5_bitCount
	CLRF gbl_rc5_inputData
	CLRF gbl_rc5_inputData+D'1'
	MOVLW 0x03
	MOVWF gbl_rc5_currentState
	GOTO	label47
label36
	MOVLW 0x01
	MOVWF interrupt_15_iReset
	GOTO	label47
label37
	MOVF gbl_rc5_logicInterval, W
	XORLW 0x02
	BTFSS STATUS,Z
	GOTO	label47
	MOVF gbl_rc5_logicChange, W
	SUBLW 0x02
	BTFSS STATUS,C
	GOTO	label45
	CLRF gbl_rc5_logicInterval
	CLRF gbl_rc5_logicChange
	MOVLW 0x0C
	SUBWF gbl_rc5_bitCount, W
	BTFSC STATUS,C
	GOTO	label38
	INCF gbl_rc5_bitCount, F
	BCF STATUS,C
	RLF gbl_rc5_inputData, F
	RLF gbl_rc5_inputData+D'1', F
	DECF gbl_rc5_pinState, W
	BTFSC STATUS,Z
	BSF gbl_rc5_inputData,0
	GOTO	label47
label38
	MOVLW 0x3F
	ANDWF gbl_rc5_inputData, W
	MOVWF gbl_rc5_command
	MOVLW 0x06
	MOVWF CompTempVar551
	MOVF CompTempVar551, F
label39
	BTFSC STATUS,Z
	GOTO	label40
	BCF STATUS,C
	RRF gbl_rc5_inputData+D'1', F
	RRF gbl_rc5_inputData, F
	DECF CompTempVar551, F
	GOTO	label39
label40
	MOVLW 0x1F
	ANDWF gbl_rc5_inputData, W
	MOVWF gbl_rc5_address
	MOVLW 0x05
	MOVWF CompTempVar552
	MOVF CompTempVar552, F
label41
	BTFSC STATUS,Z
	GOTO	label42
	BCF STATUS,C
	RRF gbl_rc5_inputData+D'1', F
	RRF gbl_rc5_inputData, F
	DECF CompTempVar552, F
	GOTO	label41
label42
	MOVF gbl_rc5_flickBitOld, W
	XORWF gbl_rc5_inputData, W
	BTFSC STATUS,Z
	MOVF gbl_rc5_inputData+D'1', W
	BTFSC STATUS,Z
	GOTO	label43
	MOVLW 0x01
	MOVWF gbl_rc5_flickBit
	MOVF gbl_rc5_inputData, W
	MOVWF gbl_rc5_flickBitOld
	GOTO	label44
label43
	CLRF gbl_rc5_flickBit
label44
	BSF gbl_cTask,0
	MOVLW 0x01
	MOVWF interrupt_15_iReset
	GOTO	label47
label45
	MOVLW 0x01
	MOVWF interrupt_15_iReset
	GOTO	label47
label46
	MOVLW 0x01
	MOVWF interrupt_15_iReset
label47
	MOVF interrupt_15_iReset, F
	BTFSC STATUS,Z
	GOTO	label48
	CLRF gbl_rc5_currentState
	BCF gbl_t2con,2
	BSF STATUS, RP0
	BCF gbl_option_reg,6
	BCF STATUS, RP0
	BCF gbl_portb,2
label48
	BCF gbl_pir1,1
label49
	BTFSS gbl_intcon,0
	GOTO	label50
	MOVLW 0xC0
	ANDWF gbl_portb, W
	MOVWF gbl_cPortBCurrent
	BSF gbl_cTask,4
	BCF gbl_intcon,0
label50
	BTFSS gbl_intcon,2
	GOTO	label52
	MOVF gbl_iTmr0Counter, W
	SUBLW 0x02
	BTFSC STATUS,C
	GOTO	label51
	BCF gbl_porta,4
	BCF gbl_porta,3
	CLRF gbl_iTmr0Counter
label51
	INCF gbl_iTmr0Counter, F
	MOVLW 0x3C
	MOVWF gbl_tmr0
	BCF gbl_intcon,2
label52
	SWAPF Int1BContext+D'2', W
	MOVWF FSR
	SWAPF Int1BContext+D'1', W
	MOVWF PCLATH
	SWAPF Int1BContext, W
	MOVWF STATUS
	SWAPF Int1Context, F
	SWAPF Int1Context, W
	RETFIE
; } interrupt function end

	ORG 0x00002007
	DW 0x3F18
	END
