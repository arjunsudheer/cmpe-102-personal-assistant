.global factorial_main

.text
factorial_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Get input from C function
    printStr "What factorial input would you like to calculate: "
    ldr x0, =factorial_input
    bl get32BitInt

    // Save the original input
    mov w1, w0

    // Do not calculate the factorial if the input is negative
    // xzr is the zero register
    cmp w1, wzr
    blt undefined_input
    // Special case, 0! = 1
    beq zero_input

    // Store the factorial in x0
    mov w0, #1

    bl factorial

    printStr "The factorial value is: "
    bl printInt

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

factorial:
    // return if x1 is less than or equal to 1
    cmp w1, #1
    ble end_factorial

    mul x0, x0, x1

    sub w1, w1, #1
    b factorial

end_factorial:
    ret

undefined_input:
    printStr "Factorial of negative numbers are undefined"
    ret

zero_input:
    mov x0, #1
    printStr "The factorial value is: "
    bl printInt

.data
factorial_input : .fill 1, 8, 0
