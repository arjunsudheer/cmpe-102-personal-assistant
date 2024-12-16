.text
get_theta_input:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    printStr "Please enter x in radians:"
    ldr x0, =initial_theta
    bl getDouble

    bl check_for_invalid_angle

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

sin_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_theta_input

    bl sin_init
    bl calculate_sin

    fmov d0, d9
    bl printDouble

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

sin_init:
    // Set approximation to start with initial value (x)
    fmov d9, d0

    // Precompute x^2 to use for future exponent terms
    fmul d10, d0, d0
    
    // Used for increasing x by a power of 2
    fmul d11, d10, d0

    // Initialize sign as -1
    mov x9, #-1

    // Keep track of the number of terms
    ldr x10, =num_terms
    ldr x10, [x10]

    // Keep track of the index for the factorial array
    mov x11, #0

    ret

calculate_sin:
    // Load factorial
    ldr x13, =sin_factorials
    ldr d13, [x13, x11, lsl #3]

    // x^n / n!
    fdiv d12, d11, d13
    // Change the sign of the term based on the value in x9
    scvtf d14, x9
    fmul d12, d12, d14

    // Add/subtract to/from result
    fadd d9, d9, d12

    // Flip sign for next term
    neg x9, x9

    // Increment factorial array index by 1
    add x11, x11, #1

    // Mulitply by x^n to get the next power term in the Taylor Series
    fmul d11, d11, d10

    // Decrement loop counter
    subs x10, x10, #1
    bne calculate_sin

    ret

cos_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_theta_input

    bl cos_init
    bl calculate_cos

    fmov d0, d9
    bl printDouble

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

cos_init:
    // Set approximation to start with initial value (x)
    ldr x9, =cos_initial_value
    ldr d9, [x9]

    // Precompute x^2 to use for future exponent terms
    fmul d10, d0, d0

    // Used for increasing x by a power of 2
    fmov d11, d10

    // Initialize sign as -1
    mov x9, #-1

    // Keep track of the number of terms
    ldr x10, =num_terms
    ldr x10, [x10]
    
    // Keep track of the index for the factorial array
    mov x11, #0

    ret

calculate_cos:
    // Load factorial
    ldr x13, =cos_factorials
    ldr d13, [x13, x11, lsl #3]

    // x^n / n!
    fdiv d12, d11, d13
    // Change the sign of the term based on the value in x9
    scvtf d14, x9
    fmul d12, d12, d14

    // Add/subtract to/from result
    fadd d9, d9, d12

    // Flip sign for next term
    neg x9, x9

    // Increment factorial array index by 1
    add x11, x11, #1

    // Mulitply by x^n to get the next power term in the Taylor Series
    fmul d11, d11, d10

    // Decrement loop counter
    subs x10, x10, #1
    bne calculate_cos

    ret

tan_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_theta_input

    // sin(x)
    bl sin_init
    bl calculate_sin
    fmov d15, d9

    // cos(x)
    bl cos_init
    bl calculate_cos
    fmov d16, d9

    // Check if tan is undefined
    ldr x18, =epsilon
    ldr d18, [x18]
    // |cos(x)|
    fabs d17, d16
    fcmp d17, d18
    blt tan_undefined

    // sin(x) / cos(x)
    fdiv d13, d15, d16

    fmov d0, d13
    bl printDouble

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

tan_undefined:
    printStr "Tan is undefined since cos is 0"

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

check_for_invalid_angle:
    // Check that x is between -pi/2 and pi/2
    ldr x1, =lower_threshold
    ldr d1, [x1]
    fcmp d0, d1
    blt invalid_angle

    ldr x1, =upper_threshold
    ldr d1, [x1]
    fcmp d0, d1
    bgt invalid_angle

    ret

invalid_angle:
    printStr "The angle must be between -pi and pi radians."

    // Restore lr from the stack
    ldp x1, lr, [sp], #16
    ldp x1, lr, [sp], #16
    ret

.data
initial_theta: .double 0.0
lower_threshold: .double -3.14
upper_threshold: .double 3.14
num_terms: .word 5
// Used for sin approximation
sin_factorials: .double 6.0, 120.0, 5040.0, 362880.0, 39916800.0
// Used for cos approximation
cos_factorials: .double 2.0, 24.0, 720.0, 40320.0, 3628800.0
cos_initial_value: .double 1.0
// Used for tan approximation
epsilon: .double 1e-3
