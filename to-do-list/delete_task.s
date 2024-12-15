.include "shared_data.s"

.global delete_task_main

.text

delete_task_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Display current tasks using display_tasks_main
    bl display_tasks_main

    // Ask for the task index to delete
    printStr "Enter the index of the task to delete (starting from 1): "
    ldr x0, =user_input
    bl get32BitInt

    // Make the specified index 0-indexed
    sub x0, x0, #1
    
    bl delete_task_at_index

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
    
