.global fibonacci_main

.text
fibonacci_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Get input from C function
    printStr "What fibonacci input would you like to calculate: "
    ldr x0, =fibonacci_input
    bl get64BitInt

    // Save the original input
    mov x1, x0

    // Do not calculate the fibonacci sequence if the input is negative
    // xzr is the zero register
    cmp x1, xzr
    blt invalid_input

    // Store the fibonacci sum in x0
    mov x0, #0

    bl fib

    printStr "The fibonacci value is: "
    bl printInt

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

fib:
    // return if x1 is less than or equal to 1
    cmp x1, #1
    ble end_fib

    // Save x1 and lr to the stack
    stp x1, lr, [sp, #-16]!

    // Process fib(n - 1)
    sub x1, x1, #1
    bl fib

    // Restore x1 and lr from stack
    ldp x1, lr, [sp], #16

    // Save x1 and lr to the stack
    stp x1, lr, [sp, #-16]!

    // Process fib(n - 2)
    sub x1, x1, #2
    bl fib

    // Restore x1 and lr from stack
    ldp x1, lr, [sp], #16

    ret

end_fib:
    // Add the value stored in x1 to the sum
    add x0, x0, x1
    ret

invalid_input:
    printStr "Invalid Input"
    ret

.data
fibonacci_input : .fill 1, 8, 0
