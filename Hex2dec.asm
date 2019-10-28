#include p18f87k22.inc
    global  H2D_convert,H2D_convert1,H2D_convert2,H2D_convert3,H2D_convert4
    
acs_ovr	access_ovr
temp1	res 1
temp2	res 1
temp3	res 1
tempA	res 1
tempB	res 1
tempC	res 1
H2D_mul_result1 res 1
H2D_mul_result2 res 1
H2D_mul_result3 res 1
H2D_mul_result4 res 1
H2D_input1 res 1
H2D_input2 res 1
H2D_input3 res 1
 
acs0    udata_acs   ; named variables in access ram
H2D_convert1 res 1
H2D_convert2 res 1
H2D_convert3 res 1
H2D_convert4 res 1
H2D_counter  res 1

  
Hex2dec code
    constant H2D_mul_k=0x418A 
    
mul22
    movff   ADRESH, H2D_input2			;High byte to input 2
    movff   ADRESL, H2D_input1			;Low byte to input 1
    ;first 2x1 multiplication with low byte of k
    movlw   low(H2D_mul_k)			;Low byte of k
    movwf   H2D_input3
    call    mul12
    movff   temp1, tempA
    movff   temp2, tempB
    movff   temp3, tempC
    
    movlw   high(H2D_mul_k)
    movwf   H2D_input3
    call    mul12
    movff   tempA, H2D_mul_result1
    movf    tempB, W
    addwf   temp1, W
    movwf   H2D_mul_result2
    movf    tempC, W
    addwfc  temp2, W
    movwf   H2D_mul_result3
    movlw   0x0
    addwfc  temp3, W
    movwf   H2D_mul_result4
    return
    
mul12
    movf    H2D_input1, W
    mulwf   H2D_input3
    movff   PRODH, temp2
    movff   PRODL, temp1
    movf    H2D_input2, W
    mulwf   H2D_input3
    movf    temp2, W
    addwf   PRODL, W
    movwf   temp2
    movlw   0x0
    addwfc  PRODH, W
    movwf   temp3
    return


    
mul13
    movff   H2D_mul_result1, H2D_input1
    movff   H2D_mul_result2, H2D_input2
    movff   H2D_mul_result3, tempA
    movlw   0x0A
    movwf   H2D_input3
    call    mul12
    
    movff   temp1, H2D_mul_result1
    movff   temp2, H2D_mul_result2
    movf    tempA, W
    mullw   0x0A
    movf    temp3, W
    addwf   PRODL, W
    movwf   H2D_mul_result3
    movlw   0x0
    addwfc  PRODH, W
    movwf   H2D_mul_result4
    return
    
H2D_convert
    call    mul22
    movlw   .1
    addwf   H2D_mul_result4
    movff   H2D_mul_result4, H2D_convert1
    call    mul13
    movlw   .1
    addwf   H2D_mul_result4
    movff   H2D_mul_result4, H2D_convert2
    call    mul13
    movlw   .1
    addwf   H2D_mul_result4
    movff   H2D_mul_result4, H2D_convert3
    call    mul13
    movlw   .1
    addwf   H2D_mul_result4
    movff   H2D_mul_result4, H2D_convert4
    return
    end
