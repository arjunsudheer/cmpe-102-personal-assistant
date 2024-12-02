.include "shared_data.s"

.global add_task_main

.text
add_task_main:
    // Save registers to the stack
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Prompt user for task description
    printStr "Enter task description: "
    ldr x0, =tasks                // Load tasks array base address
    ldr x1, =task_count           // Load task_count address
    ldr w2, [x1]                  // Load current task count
    add x0, x0, x2, LSL #8        // Offset base address by task_count * 256
    bl getString                  // Call getString to get task input

    // Check if task_count exceeds the limit (128 tasks for simplicity)
    ldr x1, =task_count           // Load task_count address
    ldr w2, [x1]                  // Load current task count
    cmp w2, #127                  // Compare with max task limit (128 - 1)
    b.ge task_limit_exceeded      // If >= 128, jump to error handler

    // Prompt user for task priority
    printStr "Enter task priority (1-5): "
    bl get32BitInt                // Call get32BitInt to get priority input

    // Validate priority (must be between 1 and 5)
    cmp w0, #1                    // Check if >= 1
    blt invalid_priority
    cmp w0, #5                    // Check if <= 5
    bgt invalid_priority

    // Save task priority
    ldr x2, =task_priorities      // Load address of task_priorities array
    ldr x1, =task_count           // Load task_count address
    ldr w3, [x1]                  // Load current task count
    add x2, x2, x3                // Calculate offset for priority storage
    strb w0, [x2]                 // Store priority as byte

    // Update task_count
    ldr x1, =task_count           // Load task_count address
    ldr w2, [x1]                  // Load current task count
    add w2, w2, #1                // Increment task count
    str w2, [x1]                  // Store updated task count

    printStr "Task added successfully!\n"
    b end_add_task

task_limit_exceeded:
    printStr "Error: Task limit reached (128 tasks max).\n"
    b end_add_task

invalid_priority:
    printStr "Error: Invalid priority. Must be between 1 and 5.\n"

end_add_task:
    // Restore registers from the stack
    ldp x29, x30, [sp], #16
    ret

