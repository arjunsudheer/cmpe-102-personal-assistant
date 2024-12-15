.global focus_session_main

.text

focus_session_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    printStr "How long do you want your focus session to be (in minutes):"

    ldr x0, =focus_session_time
    bl get64BitInt

    cmp x0, #0
    ble invalid_focus_session_length

    printStr "Your focus session has started."

    // Read the frequency of the counter in Hz (cycles per second)
    mrs x1, CNTFRQ_EL0

    // Calculate the frequency of the counter in cycles per minute
    ldr x9, =seconds_per_minute
    ldr x10, [x9]
    mul x1, x1, x10

    // Calculate the number of ticks needed for the delay in minutes
    mul x2, x1, x0

    // Read the initial count
    mrs x4, CNTVCT_EL0

focus_session_timer_loop:
    // Get the current counter value
    mrs x5, CNTVCT_EL0

    // Get the difference in ticks that have passed
    sub x6, x5, x4

    // Check if enough ticks have passed to satisfy the requested time
    cmp x6, x2
    blt focus_session_timer_loop

    printStr "Focus session complete. Good job!"

    b exit_focus_session

invalid_focus_session_length:
    printStr "Focus session length must be positive"
    b exit_focus_session

exit_focus_session:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

.data
focus_session_time: .fill 1, 8, 0
seconds_per_minute: .word 60
