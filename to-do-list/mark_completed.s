.include "to-do-list/shared_data.s"

.global mark_completed_main

.text
mark_completed_main:
    // Save registers and lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Check if there are no tasks
    ldr x0, =total_tasks
    ldrb w1, [x0]
    cbz w1, no_tasks_mark_completed

    bl display_tasks_main

    // Prompt user for the task index to mark as completed
    printStr "Enter the index of the task to mark as completed (starting at 1): "
    ldr x0, =int_input      // Load address of int_input
    bl get32BitInt          // Call C function to get user input

    ldr x0, =int_input      // Reload input
    ldr w2, [x0]            // Move input to w2
    subs w2, w2, #1         // Convert input from 1-based to 0-based index
    blt invalid_index_mark_completed // If input < 0, it's invalid

    // Validate task index
    ldr x0, =total_tasks
    ldrb w3, [x0]
    cmp w2, w3
    bge invalid_index_mark_completed // If input >= total_tasks, it's invalid

    ldr x0, =completed_task_index
    ldrb w3, [x0]
    cmp w2, w3
    bge invalid_index_in_completed_section // Cannot mark already completed task as completed

    // Perform task marking logic
    ldr x9, =tasks          // Load tasks array base address
    mov w10, w3
    sub w10, w10, #1        // w10 = completed_task_index - 1
    mov w11, w2             // w11 = index to mark as completed
    
    // Copy task to be marked as completed to x15
    ldr x15, [x9, x11, lsl #3]

shift_tasks_left_completed:
    cmp w11, w10
    bge move_task_to_completed_section

    sub x12, x10, #1
    ldr x13, [x9, x10, lsl #3]          // Load current task value
    str x13, [x9, x12, lsl #3]          // Store in the previous index

    add w11, w11, #1                    // Increment index
    b shift_tasks_left_completed

move_task_to_completed_section:
    // If the index of the task to be marked completed was a priority task, then the task_index must also be decremented by 1
    ldr x0, =task_index
    ldrb w1, [x0]
    cmp w1, w11
    ble decrement_task_index

    b update_completed_index_mark

decrement_task_index:
    // Only decrement if task_index > 1
    cbz w1, update_completed_index_mark

    // Decrement task_index by 1
    sub w1, w1, #1
    strb w1, [x0]

    b update_completed_index_mark

update_completed_index_mark:
    // Update completed_task_index
    // Decrement completed_task_index by 1
    ldr x0, =completed_task_index
    ldrb w1, [x0]
    sub w1, w1, #1
    strb w1, [x0]

    // Save the task marked as completed at the updated completed_task_index
    str x15, [x9, x1, lsl #3]

    printStr "Task marked as completed successfully!\n"
    b end_mark_completed

invalid_index_mark_completed:
    printStr "Error: Invalid task index.\n"
    b end_mark_completed

invalid_index_in_completed_section:
    printStr "Error: Task is already marked as completed.\n"
    b end_mark_completed

no_tasks_mark_completed:
    printStr "\nNo tasks to mark as completed.\n"
    b end_mark_completed

end_mark_completed:
    // Restore registers and lr from the stack
    ldp xzr, lr, [sp], #16
    ret
