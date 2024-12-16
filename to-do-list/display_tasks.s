.include "to-do-list/shared_data.s"

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
    mov x10, #0

    // Load the task and completed task indices
    ldr x0, =task_index
    ldrb w12, [x0]
    ldr x0, =completed_task_index
    ldrb w13, [x0]

    printStr "\nPrioritized Tasks:"

    b display_task_loop

display_task_loop:
    // Exit loop if all tasks are displayed
    cmp x10, x11
    bge exit_display

    // Save x9 and x10 registers to the stack since they will get corrupted from call to printTask
    stp x9, x10, [sp, #-16]!
    // Save the x11 register to the stack since they will get corrupted from call to printTask
    stp xzr, x11, [sp, #-16]!
    // Save x12 and x13 registers to the stack since they will get corrupted from call to printTask
    stp x12, x13, [sp, #-16]!

    bl print_default_tasks_header
    bl print_completed_tasks_header

    // Load the task into x0 (first argument to printTask)
    ldr x0, [x9, x10, lsl #3]
    // Move the index into x1 (second argument to printTask)
    mov x1, x10
    bl printTask

    // Load x12 and x13 registers from the stack
    ldp x12, x13, [sp], #16
    // Load the x11 register from the stack
    ldp xzr, x11, [sp], #16
    // Load x9 and x10 registers from the stack
    ldp x9, x10, [sp], #16
    
    add x10, x10, #1

    b display_task_loop

print_default_tasks_header:
    // Default task index is stored in x12
    cmp x10, x12
    bne exit_print_header

    printStr "\nDefault Tasks:"
    ret

print_completed_tasks_header:
    // Completed task index is stored in x13
    cmp x10, x13
    bne exit_print_header

    printStr "\nCompleted Tasks:"
    ret

exit_print_header:
    ret

no_tasks:
    printStr "\nNo tasks in the to-do list."
    b exit_display

exit_display:
    printStr ""
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

