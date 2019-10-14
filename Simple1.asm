	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100
setup	bcf	EECON1, CFGS
	bsf	EECON1, EEPGD
	bra	start

bytes	db	"s", "e"
	constant    address=0x300
	constant    counter=0x10
	
start	call	tblset
	movlw	0x0
	movwf	TRISD, ACCESS
	movlw	0xFF
	movwf	TRISE, ACCESS
	movlw	0x2
	movwf	0x100, ACCESS
	call	write
	call	read
	goto	0x0

read	movlw	b'1110'
	movwf	PORTD, ACCESS
	movlw	0xFF
	movwf	TRISE, ACCESS
	movlw	0x0
	movwf	TRISH, ACCESS
	movff	PORTE, PORTH
	movlw	b'1011'
	movwf	PORTD, ACCESS
	movlw	0x0
	movwf	TRISJ, ACCESS
	movff	PORTE, PORTJ
	return
	
write	movlw	b'1111'
	movwf	PORTD, ACCESS
	movlw	0x0
	movwf	TRISE, ACCESS
	tblrd*+
	movff	TABLAT, LATE
	call	clock1
	tblrd*+
	movff	TABLAT, LATE
	call	clock2
	movlw	0xFF
	movwf	TRISE, ACCESS
	return
	
delay	decfsz	0x100
	bra	delay
	return

clock1	movlw	b'1101'
	movwf	PORTD, ACCESS
	call	delay
	movlw	b'1111'
	movwf	PORTD, ACCESS
	return

clock2	movlw	b'0111'
	movwf	PORTD, ACCESS
	call	delay
	movlw	b'1111'
	movwf	PORTD, ACCESS
	return
	
tblset	lfsr	FSR0, address
	movlw	high(bytes)
	movwf	TBLPTRH
	movlw	low(bytes)
	movwf	TBLPTRL
	movlw	.2
	movwf	counter
	return
	
	end

	