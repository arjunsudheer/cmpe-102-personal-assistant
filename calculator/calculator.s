.include "debug.s"
.include "fibonacci.s"
.include "factorial.s"
.include "exponent.s"

.global main

.text
main:
    // Get input from C function
    printStr "\nEnter the number associated with the calculator command you want to run:"
    printStr "1) Fibonacci"
    printStr "2) Factorial"
    printStr "3) Exponent"
    printStr "4) Exit"

    ldr x0, =user_input
    bl get64BitInt

    cmp x0, #0
    ble invalid_calculator_command

    printStr ""

    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    cmp x0, #1
    beq call_fibonacci

    cmp x0, #2
    beq call_factorial

    cmp x0, #3
    beq call_exponent
    
    cmp x0, #4
    beq exit

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

call_fibonacci:
    bl fibonacci_main
    b main

call_factorial:
    bl factorial_main
    b main

call_exponent:
    bl exponent_main
    b main

invalid_calculator_command:
    printStr "Invalid Calculator Command\n"
    b main

exit:
    mov X0, #0
    mov X8, #93
    svc 0

.data
user_input: .fill 1, 8, 0
