.global factorial_main

.text
factorial_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    mov w1, w0

    cmp w1, #0                // Check if input is 0
    beq zero_input            

    cmp w1, #0                
    blt undefined_input       

    mov w0, #1

factorial_loop:
    cmp w1, #1                // Check if w1 <= 1
    ble end_factorial         

    mul w0, w0, w1            // w0 *= w1
    sub w1, w1, #1            

    b factorial_loop           

end_factorial:
    scvtf d0, w0              
    ldp xzr, lr, [sp], #16    
    ret

undefined_input:
    ldr x9, =nan_value        
    ldr d0, [x9]              
    ldp xzr, lr, [sp], #16    
    ret

zero_input:

    mov w0, #1
    scvtf d0, w0              
    ldp xzr, lr, [sp], #16    // Restore lr
    ret

.data
nan_value: .quad 0x7FF8000000000000  
