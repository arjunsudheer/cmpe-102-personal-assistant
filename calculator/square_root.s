.global square_root_main

.text
square_root_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    printStr "Please enter the number you want to calculate the square root for:"
    ldr x0, =initial_value
    bl getDouble

    // Check if the square root initial value is positive
    fcmp d0, #0.0
    blt invalid_square_root_initial_value

    // Load the accuracy_threshold into d10
    ldr x10, =accuracy_threshold
    ldr d10, [x10]

    // x_n is stored in d1
    ldr x9, =half
    ldr d9, [x9]
    fmul d1, d0, d9

    bl calculate_herons_approximation

    fmov d0, d1
    bl printDouble

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

// x_n+1 = 0.5 * (x_n + a/x_n)
calculate_herons_approximation:
    // x_n+1 is stored in d2
    // a/x_n
    fdiv d2, d0, d1
    // x_n + a/x_n
    fadd d2, d2, d1
    // 0.5 * (x_n + a/x_n)
    fmul d2, d2, d9

    // Calculate the difference between x_n+1 and x_n
    fsub d3, d1, d2
    // Set x_n = x_n+1 for the next iteration
    fmov d1, d2

    // If the difference < accuracy_threshold, then exit out of the loop
    fcmp d3, d10
    ble end_calculate_herons_approximation

    b calculate_herons_approximation

end_calculate_herons_approximation:
    ret    

invalid_square_root_initial_value:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    printStr "Square root initial value cannot be negative"
    ret

.data
initial_value: .double 0.0
accuracy_threshold: .double 0.0001
half: .double 0.5
