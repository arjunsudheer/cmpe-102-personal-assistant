.include "shared_data.s"

.global delete_task_main

.text

delete_task_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Display current tasks using display_tasks_main
    bl display_tasks_main

    // Ask for the task index to delete
    printStr "Enter the index of the task to delete (starting from 0): "
    ldr x0, =user_input          // Load address to store the user input
    bl get32BitInt               // Get the index

    // Load task count and validate the index
    ldr x1, =task_count          // Load the address of task_count
    ldr w1, [x1]                 // Load the current task count
    ldr x0, =user_input          // Load the address of user_input
    ldr w2, [x0]                 // Load the entered index
    cmp w2, w1                   // Compare index with the task count
    b.ge invalid_index           // If index >= task_count, print error
    bl delete_task_at_index      // Otherwise, delete the task

    // Decrement task count
    ldr x1, =task_count          // Load the address of task_count
    ldr w1, [x1]                 // Load the current task count
    sub w1, w1, #1               // Decrement task count
    str w1, [x1]                 // Store the updated task count

    printStr "Task deleted successfully.\n"

    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

invalid_index:
    printStr "Error: Invalid task index.\n"
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

delete_task_at_index:
    // Calculate the address of the task to delete
    ldr x0, =user_input          // Load the address of user_input
    ldr w1, [x0]                 // Load the index
    lsl w1, w1, #8               // Multiply index by 256 (size of each task)
    ldr x2, =tasks               // Load the base address of the tasks array
    add x2, x2, w1, uxtw         // Add the offset to get the task address (extend w1 to x1)

    // Move tasks after the deleted task one position up
    ldr x1, =task_count          // Load the address of task_count
    ldr w1, [x1]                 // Load the current task count
    sub w1, w1, #1               // Decrement count for shifting
    lsl w1, w1, #8               // Multiply task count by 256 (size of each task)
    ldr x3, =tasks               // Load the base address of the tasks array
    add x3, x3, w1, uxtw         // Address of the last task (end of array) with extend

shift_loop:
    cmp x2, x3                   // Compare current task address with the end address
    b.ge done_shift              // Exit loop if current task is the last task
    ldr x4, [x2, #256]           // Load the next task into x4
    str x4, [x2]                 // Move it to the current task's location
    add x2, x2, #256             // Increment to the next task
    b shift_loop

done_shift:
    ret

