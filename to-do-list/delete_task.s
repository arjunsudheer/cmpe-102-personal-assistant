.include "shared_data.s"

.global delete_task_main

.text
delete_task_main:
    // Save registers and lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Check if there are no tasks
    ldr x0, =total_tasks
    ldrb w1, [x0]
    cbz w1, no_tasks_message

    // Display current tasks
    printStr "\nCurrent Tasks:"
    bl display_tasks_main

    // Prompt user for the task index to delete
    printStr "Enter the index of the task to delete (starting at 1): "
    ldr x0, =int_input      // Load address of int_input
    bl get32BitInt          // Call C function to get user input

    ldr x0, =int_input      // Reload input
    ldr w2, [x0]            // Move input to w2
    subs w2, w2, #1         // Convert input from 1-based to 0-based index
    blt invalid_index       // If input < 0, it's invalid

    // Validate task index
    ldr x0, =total_tasks
    ldrb w3, [x0]           // Load total_tasks into w3
    cmp w2, w3
    bge invalid_index       // If input >= total_tasks, it's invalid

    // Perform task deletion logic
    ldr x9, =tasks          // Load tasks array base address
    mov w10, w3             // w10 = total_tasks
    mov w11, w2             // w11 = index to delete

shift_tasks_left:
    cmp w11, w10            // Compare index to delete with total tasks
    bge decrement_total_tasks

    // Calculate addresses for current and next task
    uxtw x11, w11           // Zero-extend w11 to x11 for 64-bit operations
    add x12, x9, x11, LSL #3 // Address of current task: tasks[w11]
    add x13, x12, #8        // Address of next task: tasks[w11 + 1]

    ldr x14, [x13]          // Load next task value
    str x14, [x12]          // Store next task value in the current slot

    add w11, w11, #1        // Increment index
    b shift_tasks_left

decrement_total_tasks:
    // Decrement total_tasks
    ldr x0, =total_tasks
    ldrb w1, [x0]
    subs w1, w1, #1
    strb w1, [x0]

    printStr "Task deleted successfully!\n"
    b end_delete_task

invalid_index:
    printStr "Error: Invalid task index.\n"
    b end_delete_task

no_tasks_message:
    printStr "\nNo tasks to delete.\n"

end_delete_task:
    // Restore registers and lr from the stack
    ldp xzr, lr, [sp], #16
    ret
