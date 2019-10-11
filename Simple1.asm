	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start	movlw	0xFF
	movwf	TRISD, ACCESS
	movlw	0x3
	movwf	TRISE, ACCESS
	movlw	0xFF
	movwf	TRISF, ACCESS
	movlw	0x4
rloop	cpfseq	PORTF, ACCESS
	bra	rloop
	call	read
	goto	0x0
	
read	movlw	0x2
	movwf	PORTE, ACCESS
	movlw	0xFF
	movwf	TRISD, ACCESS
	return
	
write	movlw	0x3
	movwf	PORTE, ACCESS
	movlw	0x0
	movwf	PORTD, ACCESS
	return
	
	end
