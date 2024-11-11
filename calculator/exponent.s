.global exponent_main

.text
exponent_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Get input from C function
    printStr "What is the base: "
    ldr x0, =base
    bl getDouble

    printStr "What is the exponent: "
    ldr x0, =exp
    bl get32BitInt

    // Save the exponent before it gets overwritten
    mov w2, w0
    
    printStr "The exponent calculation value is: "

    // Load the base value
    ldr x9, =base
    ldr d1, [x9]

    // Set the initial value for the exponent result calculation
    // Load the base value
    ldr x9, =one
    ldr d0, [x9]

    bl negative_exp
    bl positive_exp

    bl printDouble

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

positive_exp:
    // return if the x2 (the exponent) is less than or equal to 0
    cmp w2, wzr
    ble end_exp

    fmul d0, d0, d1

    sub w2, w2, #1
    b positive_exp

negative_exp:
    // return if the x2 (the exponent) is greater than or equal to 0
    cmp w2, wzr
    bge end_exp

    fdiv d0, d0, d1

    add w2, w2, #1
    b negative_exp

end_exp:
    ret

.data
base : .double 0.0
exp : .fill 1, 8, 0
one: .double 1.0
