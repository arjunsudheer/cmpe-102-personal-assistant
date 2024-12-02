.include "shared_data.s"

.global display_tasks_main

.text

display_tasks_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Load the task count
    ldr x0, =task_count          // Address of task_count
    ldr w1, [x0]                 // Load task count into w1
    cmp w1, #0                   // Check if there are tasks
    b.eq no_tasks                // If no tasks, display a message

    // Print header
    printStr "To-Do List:\n"
    mov w2, #0                   // Initialize index (w2)

display_task_loop:
    cmp w2, w1                   // Compare index with task count
    b.ge end_display_tasks       // Exit loop if all tasks are displayed

    // Calculate the address of the current task
    lsl x3, x2, #8               // Multiply index by 256 (use x2 for 64-bit compatibility)
    ldr x4, =tasks               // Base address of tasks
    add x4, x4, x3               // Address of the current task

    // Display the current task
    printStr "Task ["
    add w5, w2, #1               // Convert 0-based index to 1-based
    mov w0, w5                   // Load index into w0 (use 32-bit register here)
    bl printInt                  // Print the task index
    printStr "]: "

    mov x0, x4                   // Load the address of the task description
    bl printStr                  // Print the task

    // Increment the index
    add w2, w2, #1
    b display_task_loop

end_display_tasks:
    printStr "End of tasks.\n"
    b exit_display

no_tasks:
    printStr "No tasks in the to-do list.\n"

exit_display:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

