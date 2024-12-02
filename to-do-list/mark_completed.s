.include "shared_data.s"

.global mark_completed_main

.text

mark_completed_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Load the current task count
    ldr x0, =task_count
    ldr w1, [x0]                    // w1 = task_count
    cmp w1, #0                      // Check if there are active tasks
    b.eq no_active_tasks            // If no tasks, display a message and exit

    // Prompt user to enter the task index
    printStr "Enter the index of the task to mark as completed: "
    ldr x0, =user_input
    bl get32BitInt                  // Read the index
    ldr w2, [x0]                    // w2 = user_input (index)

    // Check if the index is valid
    cmp w2, w1                      // Compare index with task_count
    b.ge invalid_index_mark_completed // If index >= task_count, display error
    bl move_task_to_completed       // Otherwise, mark the task as completed

    b exit_mark_completed           // Exit the function

invalid_index_mark_completed:
    printStr "Invalid task index.\n"
    b exit_mark_completed

no_active_tasks:
    printStr "No active tasks to mark as completed.\n"
    b exit_mark_completed

move_task_to_completed:
    // Calculate the address of the task to mark as completed
    lsl x3, x2, #8                  // x3 = index * 256 (size of each task)
    ldr x4, =tasks                  // Base address of active tasks
    add x4, x4, x3                  // Address of the task to mark as completed

    // Load the current completed task count
    ldr x0, =completed_task_count
    ldr w5, [x0]                    // w5 = completed_task_count

    // Calculate the destination address for the completed task
    lsl x6, x5, #8                  // x6 = completed_task_count * 256
    ldr x7, =completed_tasks        // Base address of completed tasks
    add x7, x7, x6                  // Address to move the task to

    // Copy the task from active tasks to completed tasks
    mov w8, #256                    // Number of bytes to copy
copy_task_loop:
    ldrb w9, [x4], #1               // Load a byte from active task
    strb w9, [x7], #1               // Store it to the completed task
    subs w8, w8, #1                 // Decrement the byte counter
    b.ne copy_task_loop             // Repeat until all bytes are copied

    // Update the completed task count
    add w5, w5, #1                  // Increment completed_task_count
    str w5, [x0]                    // Store the updated count

    // Remove the task from active tasks by shifting remaining tasks
    ldr x0, =tasks                  // Base address of active tasks
    add x4, x0, x3                  // Address of the task to remove
    add x7, x4, #256                // Address of the next task
    sub w1, w1, #1                  // Decrement task_count

shift_remaining_tasks:
    cmp x7, x0                      // If the next task address exceeds, exit
    b.ge update_task_count
    ldrb w9, [x7], #1               // Load a byte from the next task
    strb w9, [x4], #1               // Overwrite the current task
    add x4, x4, #1                  // Increment the destination address
    b shift_remaining_tasks

update_task_count:
    ldr x0, =task_count
    str w1, [x0]                    // Update the active task count
    printStr "Task marked as completed successfully.\n"
    b exit_mark_completed

exit_mark_completed:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

