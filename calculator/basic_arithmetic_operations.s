.text
get_numbers_double:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    printStr "Please enter the first number:"
    ldr x0, =num_one
    bl getDouble

    printStr "Please enter the second number:"
    ldr x0, =num_two
    bl getDouble
    fmov d10, d0

    // Load the first number
    ldr x9, =num_one
    ldr d9, [x9]

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

addition_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_numbers_double

    fadd d0, d9, d10
    bl printDouble

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

subtraction_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_numbers_double

    fsub d0, d9, d10
    bl printDouble

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

multiplication_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_numbers_double

    fmul d0, d9, d10
    bl printDouble

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

division_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_numbers_double

    fdiv d0, d9, d10
    bl printDouble

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

modulus_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_numbers_double

    // Keeps track of the running sum
    fmov d1, xzr

    bl modulus_loop

    // Calculate the difference from d9 and the running sum
    fsub d0, d9, d1

    bl printDouble

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

modulus_loop:
    // Check if the running sum > num_one
    fcmp d1, d9
    bgt exit_modulus_loop

    // Add d10 to the running sum
    fadd d1, d1, d10

    b modulus_loop

exit_modulus_loop:
    // Subtract d10 from d1 so that d9 > d1
    fsub d1, d1, d10
    ret

.data
num_one: .double 0.0
num_two: .double 0.0
