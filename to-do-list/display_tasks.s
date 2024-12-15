.include "shared_data.s"

.global display_tasks_main

.text

display_tasks_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Find how many total tasks need to be displayed
    ldr x0, =total_tasks
    ldrb w11, [x0]

    // Check if the task list is empty
    cbz w11, no_tasks

    // Load the base address of the tasks array
    ldr x9, =tasks

    // Initialize index
    mov w10, #0

    // Load the task and completed task indices
    ldr x0, =task_index
    ldrb w12, [x0]
    ldr x0, =completed_task_index
    ldrb w13, [x0]

    printStr "\nPrioritized Tasks:"

    b display_task_loop

display_task_loop:
    // Exit loop if all tasks are displayed
    cmp w10, w11
    bge exit_display

    bl print_default_tasks_header
    bl print_completed_tasks_header

    // Load the task into x0 (first argument to printTask)
    ldr w0, [x9, x10, lsl #2]
    // Move the index into x1 (second argument to printTask)
    mov x1, x10
    bl printTask

    add w10, w10, #1

    b display_task_loop

print_default_tasks_header:
    // Default task index is stored in w12
    cmp w10, w12
    bne exit_print_header

    printStr "\nDefault Tasks:"
    ret

print_completed_tasks_header:
    // Completed task index is stored in w4
    cmp w10, w13
    bne exit_print_header

    printStr "\nCompleted Tasks:"
    ret

exit_print_header:
    ret

no_tasks:
    printStr "\nNo tasks in the to-do list.\n"
    b exit_display

exit_display:
    printStr ""
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret
