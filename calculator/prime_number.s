.global prime_number_main

.text
prime_number_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Get the number from user input
    printStr "Enter an integer: "
    ldr x0, =num
    bl get64BitInt

    // Check for special case of 1, or less than 1
    cmp x0, #1
    beq prime_special_case_one
    blt prime_special_case_negative_or_zero

    // Only check factors up to n/2
    // Use logical shift right to perform integer division by 2
    lsr x1, x0, #1

    // Store the current factor being checked in x2
    mov x2, #2

check_factors:
    // If the current factor is greater than n/2, then it is prime
    cmp x2, x1
    bgt is_prime

    // Check if the number is divisible by the current factor
    // If q = a/b
    // Then a is divisible by b if a = b * q
    udiv x3, x0, x2
    mul x4, x3, x2
    cmp x0, x4
    beq is_composite

    // If the number is not divisible by the current factor, then check the next factor
    add x2, x2, #1

    b check_factors

is_prime:
    printStr "Prime"
    b exit_prime_number

is_composite:
    printStr "Composite"
    b exit_prime_number

prime_special_case_one:
    printStr "Neither prime nor composite"
    b exit_prime_number

prime_special_case_negative_or_zero:
    printStr "Invalid Input"
    b exit_prime_number

exit_prime_number:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

.data
num: .fill 1, 8, 0
