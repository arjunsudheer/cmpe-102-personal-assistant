.global logarithm_main

.text
logarithm_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Get input from C function
    printStr "Enter the value for logarithm (must be > 0): "
    ldr x0, =value
    bl getDouble

    // Load the value for logarithm
    ldr x9, =value
    ldr d1, [x9]                // Load input value into d1

    // Check if input is <= 0
    fcmp d1, #0.0
    ble invalid_input_log

    // Initialize variables for Taylor series
    ldr x9, =log_one            // Load 1.0
    ldr d2, [x9]                // d2 = 1.0
    fsub d2, d1, d2             // x = value - 1
    fadd d3, d1, d2             // x+1
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
    bl printDouble              // Print the result

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

invalid_input_log:
    printStr "Invalid input. Logarithm requires a value > 0.\n"
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

.data
value: .double 0.0
log_one: .double 1.0
log_two: .double 2.0

