	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start	movlw	0x0
	movwf	TRISD, ACCESS
	movlw	0xFF
	movwf	TRISE, ACCESS
	movlw	0x2
	movwf	0x55, ACCESS
	call	write
	call	read
	goto	0x0
	
read	movlw	b'10'
	movwf	PORTD, ACCESS
	movlw	0xFF
	movwf	TRISE, ACCESS
	movlw	0x0
	movwf	TRISC, ACCESS
	movff	PORTE, PORTC
	return
	
write	movlw	b'11'
	movwf	PORTD, ACCESS
	movlw	0x0
	movwf	TRISE, ACCESS
	movlw	b'10111010'
	movwf	LATE, ACCESS
	call	clock
	movlw	0xFF
	movwf	TRISE, ACCESS
	return
	
delay	decfsz	0x55
	bra	delay
	return

clock	movlw	b'01'
	movwf	PORTD, ACCESS
	call	delay
	movlw	b'11'
	movwf	PORTD, ACCESS
	
	end

	