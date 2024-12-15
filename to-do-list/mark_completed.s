.include "shared_data.s"

.global mark_completed_main

.text

mark_completed_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Check if the task list is empty
    ldr x9, =total_tasks
    ldrb w10, [x9]
    cbz w10, no_active_tasks

    // Prompt user to enter the task index
    printStr "Enter the index of the task to mark as completed: "
    ldr x0, =user_input
    bl get32BitInt
    ldr w2, [x0]

    // Check if the index is valid
    cmp w2, w1
    b.ge invalid_index_mark_completed

    b exit_mark_completed

invalid_index_mark_completed:
    printStr "Invalid task index.\n"
    b exit_mark_completed

no_active_tasks:
    printStr "No active tasks to mark as completed.\n"
    b exit_mark_completed

exit_mark_completed:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

