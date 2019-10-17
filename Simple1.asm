	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100



SPI_MasterInit	; Set Clock edge to negative
	bcf	SSP2STAT, CKE
	; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
	movlw 	(1<<SSPEN)|(1<<CKP)|(0x02)
	movwf 	SSP2CON1
	; SDO2 output; SCK2 output
	bcf	TRISD, SDO2
	bcf	TRISD, SCK2
	return 

SPI_MasterTransmit  ; Start transmission of data (held in W)
	movwf 	SSP2BUF 
Wait_Transmit	; Wait for transmission to complete 
	btfss 	PIR2, SSP2IF
	bra 	Wait_Transmit
	bcf 	PIR2, SSP2IF	; clear interrupt flag
	return

start	bcf	TRISE, ACCESS
	call	SPI_MasterInit	  
	movlw	0xF0
	call	SPI_MasterTransmit
	goto	finish		    ; end program

	
delay	decfsz	0x100		    ; decrement constant until 0
	bra	delay		    ;
	movlw	0x1		    ; reset constant
	movwf	0x100		    ;
	return
clock1	movlw	b'1101'		    ; CP2,OE2*,CP1,OE1*
	movwf	PORTD, ACCESS	    ; set cp1 to low
	call	delay		    ; delay for ~250 ns
	movlw	b'1111'		    ; set cp1 to high
	movwf	PORTD, ACCESS	    ; 
	return	
delb	movlw	upper(0x3FFFFF)	    ; load 22-bit number into
	movwf	0x15		    ; FR 0x15
	;movlw	high(0x3FFFFF)	    ;
	movlw	0xFF	    ;
	movwf	0x16		    ; and FR 0x16
	movlw	low(0x3FFFFF)	    ;
	movwf	0x17		    ; and FR 0x17
	
	movlw	0x00		    ; W=0
dloop	decf	0x17, f		    ; no carry when 0x00 -> 0xff
	subwfb	0x16, f		    ; "
	subwfb	0x15, f		    ; "
	bc	dloop		    ; if carry, then loop again
	return			    ; carry not set so return
finish
	end

	