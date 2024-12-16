.include "shared_data.s"

.global mark_completed_main

.text
mark_completed_main:
    // Save registers and lr to the stack
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Check if there are no tasks
    ldr x0, =total_tasks
    ldrb w1, [x0]
    cbz w1, no_tasks_mark_completed
    strb w1, [x0]                  // Store updated completed_task_index

    // Display current tasks
    printStr "\nCurrent Tasks:"
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
    ldrb w3, [x0]           // Load total_tasks into w3
    cmp w2, w3
    bge invalid_index_mark_completed // If input >= total_tasks, it's invalid

    // Perform task marking logic
    ldr x9, =tasks          // Load tasks array base address
    mov w10, w3             // w10 = total_tasks
    mov w11, w2             // w11 = index to mark as completed
    mov w12, w10            // w12 = total_tasks (end of array)

shift_task_to_end_mark:
    cmp w11, w12            // Compare index to move with end of array
    bge update_completed_index_mark

    // Calculate addresses for current task and the next slot
    uxtw x11, w11           // Zero-extend w11 to x11
    add x13, x9, x11, LSL #3 // Address of current task: tasks[w11]

    uxtw x12, w12           // Zero-extend w12 to x12
    add x14, x9, x12, LSL #3 // Address of end slot: tasks[total_tasks]

    ldr x15, [x13]          // Load current task value
    str x15, [x14]          // Move task to the end slot
    b update_completed_index_mark

update_completed_index_mark:
    // Update completed_task_index
    ldr x0, =completed_task_index
    ldrb w13, [x0]
    add w13, w13, #1        // Increment completed task index
    strb w13, [x0]

    printStr "Task marked as completed successfully!\n"
    b end_mark_completed

invalid_index_mark_completed:
    printStr "Error: Invalid task index.\n"
    b end_mark_completed

no_tasks_mark_completed:
    printStr "No tasks to mark as completed.\n"

end_mark_completed:
    // Restore registers and lr from the stack
    ldp x29, x30, [sp], #16
    ret

