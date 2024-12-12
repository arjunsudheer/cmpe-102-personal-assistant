.global logarithm_main

.text
logarithm_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Check if input (d0) is <= 0
    fcmp d0, #0.0
    ble invalid_input_log

    // Initialize variables for Taylor series
    ldr x9, =log_one            // Load 1.0
    ldr d2, [x9]                // d2 = 1.0
    fsub d2, d0, d2             // x = value - 1
    fadd d3, d0, d2             // x+1
    fdiv d4, d2, d3             // z = (x - 1) / (x + 1)
    fmul d5, d4, d4             // z^2
    mov x0, #1                  // Counter for Taylor series terms
    mov x1, #15                 // Maximum number of terms
    fmov d0, xzr                // Initialize result to 0.0

taylor_loop:
    // Calculate term: (z^(2n - 1)) / (2n - 1)
    add x0, x0, #2              // Increment counter (n)
    scvtf d6, x0                // Convert counter to floating point
    fmul d7, d4, d5             // z^(2n - 1)
    fdiv d8, d7, d6             // Term = z^(2n - 1) / (2n - 1)
    fadd d0, d0, d8             // Add term to result

    cmp x0, x1                  // Compare counter with max terms
    b.le taylor_loop            // Repeat if not reached

    ldr x9, =log_two            // Load 2.0
    ldr d6, [x9]
    fmul d0, d0, d6             // Multiply result by 2

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

invalid_input_log:
    // Return NaN for invalid input
    ldr x9, =nan_value
    ldr d0, [x9]

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

.data
log_one: .double 1.0
log_two: .double 2.0
nan_value: .quad 0x7FF8000000000000  // Quiet NaN (IEEE 754 representation)
