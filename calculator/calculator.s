.include "debug.s"
.include "basic_arithmetic_operations.s"
.include "fibonacci.s"
.include "factorial.s"
.include "exponent.s"
.include "square_root.s"
.include "prime_number.s"
.include "trig_functions.s"

.global main

.text
main:
    // Get input from C function
    printStr "\nEnter the number associated with the calculator command you want to run:"
    printStr "1) Addition"
    printStr "2) Subtraction"
    printStr "3) Multiplication"
    printStr "4) Division"
    printStr "5) Modulus"
    printStr "6) Fibonacci"
    printStr "7) Factorial"
    printStr "8) Exponent"
    printStr "9) Square Root"
    printStr "10) Is Prime"
    printStr "11) Sin"
    printStr "12) Cos"
    printStr "13) Tan"
    printStr "14) Exit"

    ldr x0, =user_input
    bl get64BitInt

    printStr ""

    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    cmp x0, #1
    beq call_addition_main

    cmp x0, #2
    beq call_subtraction_main

    cmp x0, #3
    beq call_multiplication_main

    cmp x0, #4
    beq call_division_main

    cmp x0, #5
    beq call_modulus_main

    cmp x0, #6
    beq call_fibonacci

    cmp x0, #7
    beq call_factorial

    cmp x0, #8
    beq call_exponent

    cmp x0, #9
    beq call_square_root

    cmp x0, #10
    beq call_prime_number

    cmp x0, #11
    beq call_sin

    cmp x0, #12
    beq call_cos

    cmp x0, #13
    beq call_tan 
    
    cmp x0, #14
    beq exit

    b invalid_calculator_command

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

call_addition_main:
    bl floating_point_addition_main
    b main

call_subtraction_main:
    bl floating_point_subtraction_main
    b main

call_multiplication_main:
    bl floating_point_multiplication_main
    b main

call_division_main:
    bl floating_point_division_main
    b main

call_modulus_main:
    bl modulus_main
    b main

call_fibonacci:
    bl fibonacci_main
    b main

call_factorial:
    bl factorial_main
    b main

call_exponent:
    bl exponent_main
    b main

call_square_root:
    bl square_root_main
    b main

call_prime_number:
    bl prime_number_main
    b main

call_sin:
    bl sin_main
    b main

call_cos:
    bl cos_main
    b main

call_tan:
    bl tan_main
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
