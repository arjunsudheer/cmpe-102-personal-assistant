.text
get_theta_input:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    printStr "Please enter x in radians:"
    ldr x0, =initial_theta
    bl getDouble

    bl check_for_invalid_angle
    
    // Precompute x^2 to use for future exponent terms
    fmul d10, d0, d0

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    ret

sin_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_theta_input

    bl calculate_sin

    fmov d0, d9
    bl printDouble

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

calculate_sin:
    // Set approximation to start with initial value (x)
    fmov d9, d0

    fmov d11, d10

    // -x^3 / 3!
    ldr x13, =three_factorial
    ldr d13, [x13]
    // x^3
    fmul d11, d10, d0
    // -x^3 / 6
    fdiv d12, d11, d13
    // Add to summation
    fsub d9, d9, d12

    // +x^5 / 5!
    ldr x13, =five_factorial
    ldr d13, [x13]
    // x^5
    fmul d11, d11, d10
    // x^5 / 120
    fdiv d12, d11, d13
    // Add to summation
    fadd d9, d9, d12

    // -x^7 / 7!
    ldr x13, =seven_factorial
    ldr d13, [x13]
    // x^7
    fmul d11, d11, d10
    // -x^7 / 7!
    fdiv d12, d11, d13
    // Add to summation
    fsub d9, d9, d12

    // -x^9 / 9!
    ldr x13, =nine_factorial
    ldr d13, [x13]
    // x^7
    fmul d11, d11, d10
    // -x^7 / 7!
    fdiv d12, d11, d13
    // Add to summation
    fadd d9, d9, d12

    // -x^11 / 11!
    ldr x13, =eleven_factorial
    ldr d13, [x13]
    // x^7
    fmul d11, d11, d10
    // -x^7 / 7!
    fdiv d12, d11, d13
    // Add to summation
    fsub d9, d9, d12

    ret

cos_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_theta_input

    bl calculate_cos

    fmov d0, d9
    bl printDouble

    // Restore lr from the stack
    ldp x1, lr, [sp], #16

    ret

calculate_cos:
    // Set approximation to start with initial value (x)
    ldr x9, =cos_initial_value
    ldr d9, [x9]

    fmov d11, d10

    // -x^2 / 2!
    ldr x13, =two_factorial
    ldr d13, [x13]
    // -x^2 / 2!
    fdiv d12, d11, d13
    // Add to summation
    fsub d9, d9, d12

    // +x^4 / 4!
    ldr x13, =four_factorial
    ldr d13, [x13]
    // x^4
    fmul d11, d11, d10
    // x^4 / 4!
    fdiv d12, d11, d13
    // Add to summation
    fadd d9, d9, d12

    // -x^6 / 6!
    ldr x13, =six_factorial
    ldr d13, [x13]
    // x^6
    fmul d11, d11, d10
    // -x^6 / 6!
    fdiv d12, d11, d13
    // Add to summation
    fsub d9, d9, d12

    // -x^8 / 8!
    ldr x13, =eight_factorial
    ldr d13, [x13]
    // x^8
    fmul d11, d11, d10
    // -x^8 / 8!
    fdiv d12, d11, d13
    // Add to summation
    fadd d9, d9, d12

    // -x^10 / 10!
    ldr x13, =ten_factorial
    ldr d13, [x13]
    // x^10
    fmul d11, d11, d10
    // -x^10 / 10!
    fdiv d12, d11, d13
    // Add to summation
    fsub d9, d9, d12

    ret

tan_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    bl get_theta_input

    // sin(x)
    bl calculate_sin
    fmov d14, d9

    // cos(x)
    bl calculate_cos
    fmov d15, d9

    // Check if tan is undefined
    ldr x17, =epsilon
    ldr d17, [x17]
    // |cos(x)|
    fabs d16, d15
    fcmp d16, d17
    blt tan_undefined

    // sin(x) / cos(x)
    fdiv d13, d14, d15

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
// Used for sin approximation
three_factorial: .double 6.0
five_factorial: .double 120.0
seven_factorial: .double 5040.0
nine_factorial: .double 362880.0
eleven_factorial: .double 39916800.0
// Used for cos approximation
two_factorial: .double 2.0
four_factorial: .double 24.0
six_factorial: .double 720.0
eight_factorial: .double 40320.0
ten_factorial: .double 3628800.0
cos_initial_value: .double 1.0
// Used for tan approximation
epsilon: .double 1e-4

