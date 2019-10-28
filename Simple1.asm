	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message   ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_Send_Byte_D	    ; external LCD subroutines
	extern	LCD_Write_Hex			    ; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern	H2D_convert,H2D_convert1,H2D_convert2,H2D_convert3,H2D_convert4

acs_ovr	access_ovr
tbl_counter res 1
 
tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup

pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
myTable data	    "0123456789"
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	call	rstbl
	goto	measure_loop
	
ascii
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT	
	decfsz	tbl_counter	; count down to zero
	bra	loop		; keep going until finished
	movf	TABLAT, W
	call	LCD_Send_Byte_D
	call	rstbl
	return
	
	; ******* Main programme ****************************************
rstbl	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	return
	
measure_loop
	call	ADC_Read
	call	H2D_convert
	
	movff	H2D_convert1, tbl_counter
	call	ascii
	movff	H2D_convert2, tbl_counter
	call	ascii
	movff	H2D_convert3, tbl_counter
	call	ascii
	movff	H2D_convert4, tbl_counter
	call	ascii

	goto	measure_loop		; goto current line in code


	end
	