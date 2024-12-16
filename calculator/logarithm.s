.global logarithm_main

.text
logarithm_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    fmov d1, d0               

    // Check if input is <= 0
    ldr x10, =zero_constant     // Load 0.0
    ldr d2, [x10]
    fcmp d1, d2                 // Compare input with 0.0
    ble invalid_input_log

    // Normalize the input value
    mov x2, #0                  // Initialize log adjustment counter
    ldr x10, =two_constant      // Load 2.0
    ldr d3, [x10]               // d3 = 2.0
normalize_input:
    fcmp d1, d3                 // Compare input with 2.0
    blt calculate_log           // If input < 2, proceed to Taylor series
    fdiv d1, d1, d3             // Divide input by 2
    add x2, x2, #1              // Increment adjustment counter
    b normalize_input           // Repeat until input < 2

calculate_log:
    // Initialize variables for Taylor series
    ldr x10, =one_constant      // Load 1.0
    ldr d4, [x10]               // d4 = 1.0
    fsub d5, d1, d4             // x = value - 1
    fadd d6, d1, d4             // x + 1
    fdiv d7, d5, d6             // z = (x - 1) / (x + 1)
    fmul d8, d7, d7             // z^2
    fmov d0, d7                 // Initialize result with the first term (z)
    mov x0, #3                  // Counter for Taylor series terms
    mov x1, #1000               // Maximum number of terms (increase for accuracy)

taylor_loop:
    // Calculate term: (z^(2n - 1)) / (2n - 1)
    fmul d7, d7, d8             // z^(2n - 1)
    scvtf d9, x0                // Convert counter to floating point
    fdiv d10, d7, d9            // Term = z^(2n - 1) / (2n - 1)
    fadd d0, d0, d10            // Add term to result

    add x0, x0, #2              // Increment counter by 2
    cmp x0, x1                  // Compare counter with max terms
    b.le taylor_loop            // Repeat if not reached

    // Adjust result by adding ln(2) * adjustment counter
    ldr x10, =ln_two_constant   // Load ln(2)
    ldr d6, [x10]
    scvtf d7, x2                // Convert adjustment counter to floating point
    fmul d6, d6, d7             // ln(2) * adjustment counter
    fadd d0, d0, d6             // Add adjustment to result

    // Result is already in d0; return to C
    ldp xzr, lr, [sp], #16
    ret

invalid_input_log:
    // Set NaN for invalid input
    ldr x10, =nan_constant
    ldr d0, [x10]               
    ldp xzr, lr, [sp], #16
    ret

.data
value: .double 0.0
zero_constant: .double 0.0      // Preloaded 0.0 constant
one_constant: .double 1.0       // Preloaded 1.0 constant
two_constant: .double 2.0       // Preloaded 2.0 constant
ln_two_constant: .double 0.69314718056 // Preloaded ln(2) constant
nan_constant: .quad 0x7FF8000000000000 // Preloaded NaN constant
