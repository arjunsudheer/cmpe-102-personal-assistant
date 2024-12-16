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

get_numbers_integer:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    printStr "Please enter the first number:"
    ldr x0, =num_one
    bl get64BitInt

    printStr "Please enter the second number:"
    ldr x0, =num_two
    bl get64BitInt
    mov x10, x0

    // Load the first number
    ldr x11, =num_one
    ldr x9, [x11]

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

floating_point_addition_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_numbers_double


    fadd d0, d9, d10
    bl printDouble

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

floating_point_subtraction_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_numbers_double


    fsub d0, d9, d10
    bl printDouble

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

floating_point_multiplication_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_numbers_double


    fmul d0, d9, d10
    bl printDouble

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

floating_point_division_main:
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

    ldr x12, =num_two
    ldr x10, [x12]

    bl get_numbers_integer

    sdiv x1, x9, x10
    mul x2, x1, x10
    sub x0, x9, x2

    bl printInt

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

.data
num_one: .double 0.0
num_two: .double 0.0
