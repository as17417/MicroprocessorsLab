	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw   high(0xFFFF)
	movwf	0x20
	movlw	low(0xFFFF)
	movwf	0x21
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs
	bra 	test
loop	movff 	0x06, PORTC
	call	bigdelay
	incf 	0x06, W, ACCESS
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	movlw 	0xFF
	cpfsgt 	0x06, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
	
bigdelay
	movlw	0x00
delay	decf	0x21, f
	subwfb	0x20, f
	bc	delay
	return	
	end
