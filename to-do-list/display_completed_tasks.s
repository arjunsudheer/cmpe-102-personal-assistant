.include "shared_data.s"

.global display_completed_tasks_main

.text

display_completed_tasks_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Load the current completed task count
    ldr x0, =completed_task_count   // Address of completed_task_count
    ldr w1, [x0]                    // w1 = completed_task_count
    cmp w1, #0                      // Check if there are any completed tasks
    b.eq no_completed_tasks         // If no tasks, display a message and exit

    // Print the header
    printStr "\nCompleted Tasks:\n"

    // Initialize task index and pointer
    mov w2, #0                      // Task index (0-based)
    ldr x3, =completed_tasks        // Base address of completed tasks

display_completed_task_loop:
    // Print task index
    printStr "Task "
    add w4, w2, #1                  // Convert index to 1-based for display
    mov w0, w4                      // Use 32-bit register for the task index
    bl printInt                     // Print the task index

    // Print task details
    mov x0, x3                      // Pass task address to printStr
    bl printStr                     // Print task description

    // Increment task index and pointer
    add w2, w2, #1                  // Increment index
    add x3, x3, #256                // Move to the next task (each task is 256 bytes)

    // Loop until all tasks are displayed
    cmp w2, w1                      // Compare index with completed_task_count
    b.lt display_completed_task_loop

    b exit_display_completed_tasks  // Exit the function

no_completed_tasks:
    printStr "No completed tasks to display.\n"

exit_display_completed_tasks:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

