	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs
	movlw	0xF
	movwf	TRISD, ACCESS
	bra 	test
loop	movff 	0x06, PORTC
	incf 	0x06, W, ACCESS
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	movff   PORTD, 0x20
	movf 	0x20, W
	cpfsgt 	0x06, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
	
	end
