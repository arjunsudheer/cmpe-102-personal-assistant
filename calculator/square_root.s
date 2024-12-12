.global square_root

.text
square_root:
    stp xzr, lr, [sp, #-16]!

    fcmp d0, #0.0
    blt invalid_square_root_input

    ldr x10, =accuracy_threshold
    ldr d10, [x10]

    ldr x9, =half
    ldr d9, [x9]
    fmul d1, d0, d9

    bl calculate_herons_approximation

    fmov d0, d1

    ldp x1, lr, [sp], #16
    ret

// Heron's approximation loop: x_n+1 = 0.5 * (x_n + a/x_n)
calculate_herons_approximation:
    // x_n+1 is stored in d2
    // a/x_n
    fdiv d2, d0, d1
    // x_n + a/x_n
    fadd d2, d2, d1
    // 0.5 * (x_n + a/x_n)
    fmul d2, d2, d9

    fsub d3, d1, d2
    fmov d1, d2

    // If the difference < accuracy_threshold, exit the loop
    fabs d3, d3 
    fcmp d3, d10
    ble end_calculate_herons_approximation

    b calculate_herons_approximation

end_calculate_herons_approximation:
    ret

invalid_square_root_input:
    ldr x10, =nan_value
    ldr d0, [x10]

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

.data
accuracy_threshold: .double 0.0001
half: .double 0.5
nan_value: .quad 0x7FF8000000000000  // Quiet NaN (IEEE 754 representation)
