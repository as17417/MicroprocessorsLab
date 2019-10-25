#include p18f87k22.inc
    global  H2D_convert,H2D_convert1,H2D_convert2,H2D_convert3,H2D_convert4
    
acs_ovr	access_ovr
H2D_mul_result1 res 1
H2D_mul_result2 res 1
H2D_mul_result3 res 1
H2D_mul_result4 res 1
H2D_mul_result5 res 1
H2D_mul_result6 res 1
H2D_input1 res 1
H2D_input2 res 1
H2D_input3 res 1
H2D_input4 res 1
 
acs0    udata_acs   ; named variables in access ram
H2D_convert1 res 1
H2D_convert2 res 1
H2D_convert3 res 1
H2D_convert4 res 1
  
Hex2dec code
    constant H2D_mul_k=0x418A 
mul12
    movf    H2D_input1, W
    mulwf   H2D_input3
    movf    PRODH, W
    movff   PRODL, H2D_mul_result4
    movf    H2D_input2, W
    mulwf   H2D_input3
    addwf   PRODL, W
    movwf   H2D_mul_result5
    movlw   0x0
    addwfc  PRODH, W
    movwf   H2D_mul_result6
    return

mul22
    movff   ADRESH, H2D_input2
    movff   ADRESL, H2D_input1
    movlw   low(H2D_mul_k)
    movwf   H2D_input3
    call    mul12
    movff   H2D_mul_result4, H2D_mul_result1
    movff   H2D_mul_result5, H2D_mul_result2
    movff   H2D_mul_result6, H2D_mul_result3
    movlw   high(H2D_mul_k)
    movwf   H2D_input3
    call    mul12
    movf    H2D_mul_result4, W
    addwf   H2D_mul_result2, f
    movf    H2D_mul_result5, W
    addwfc  H2D_mul_result3, f
    movlw   0x0
    addwfc  H2D_mul_result6
    movff   H2D_mul_result6, H2D_mul_result4
    return
    
mul13
    movff   H2D_mul_result1, H2D_input1
    movff   H2D_mul_result2, H2D_input2
    movlw   0x0A
    call    mul12
    movff   H2D_mul_result4, H2D_mul_result1
    movff   H2D_mul_result5, H2D_mul_result2
    movf    H2D_mul_result3, W
    mullw   0x0A
    movf    PRODL, W
    addwf   H2D_mul_result6, W
    movwf   H2D_mul_result3
    movlw   0x0
    addwfc  PRODH, W
    movwf   H2D_mul_result4
    return
    end
    
H2D_convert
    call    mul22
    movff   H2D_mul_result4, H2D_convert1
    call    mul13
    movff   H2D_mul_result4, H2D_convert2
    call    mul13
    movff   H2D_mul_result4, H2D_convert3
    call    mul13
    movff   H2D_mul_result4, H2D_convert4
    return


    end