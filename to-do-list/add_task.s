.include "to-do-list/shared_data.s"

.global add_task_main

.text
add_task_main:
    // Save registers to the stack
    stp xzr, lr, [sp, #-16]!

    // Prompt user for task priority
    printStr "Is this a high priority task? Enter 0 for no and any other integer for yes: "
    ldr x0, =user_input
    bl get32BitInt

    // Load the tasks array base address
    ldr x9, =tasks

    // Check if the total number of tasks exceeds the limit of 128
    ldr x10, =total_tasks
    ldrb w11, [x10]
    cmp w11, #127
    bge task_limit_exceeded

    // Add task to default task section if the user chooses "no"
    cbz w0, add_task_to_default_task_list
    // Add task to priority task section if the user chooses "yes"
    b add_task_to_priority_list

add_task_to_default_task_list:
    // Increment completed task index by 1
    ldr x10, =completed_task_index
    ldrb w13, [x10]
    add w13, w13, #1
    strb w13, [x10]

    // Save the insertion index in w12
    ldr x10, =task_index
    ldrb w12, [x10]

    b shift_tasks

add_task_to_priority_list:
    // Increment completed task index by 1
    ldr x10, =completed_task_index
    ldrb w13, [x10]
    add w13, w13, #1
    strb w13, [x10]

    // Increment completed task index by 1
    ldr x10, =task_index
    ldrb w13, [x10]
    add w13, w13, #1
    strb w13, [x10]
    
    // Save the insertion index in w12
    ldr x10, =priority_task_index
    ldrb w12, [x10]

    b shift_tasks

shift_tasks:
    // x9 stores the base address of the tasks array
    // w11 stores the index after the last element of the array
    // w12 stores the index that the element should be inserted into

    // Save the task if the w11 equals the insertion index (w12)
    cmp x11, x12
    ble save_task_at_index

    // Shift all array elements to the right by 1 until the desired index is reached
    sub x10, x11, #1
    ldr x13, [x9, x10, lsl #3]
    str x13, [x9, x11, lsl #3]

    // Decrement the array index
    sub x11, x11, #1

    b shift_tasks

save_task_at_index:
    // Save x9 and x12 registers to the stack since they may get corrupted from call to getString
    stp x9, x12, [sp, #-16]!
    
    printStr "Enter task description: "
    // Load the buffer into x0 and the maxLength into x1 for getString arguments
    ldr x0, =user_input
    // Prompt user for task description
    bl getString

    // Load x9 and x12 registers from the stack
    ldp x9, x12, [sp], #16

    // Save user created task at the appropriate index
    str x0, [x9, x12, lsl #3]

    // Increment total tasks by 1
    ldr x10, =total_tasks
    ldrb w11, [x10]
    add w11, w11, #1
    strb w11, [x10]

    printStr "Task added successfully!\n"
    b end_add_task

task_limit_exceeded:
    printStr "Error: Task limit reached (128 tasks max).\n"
    b end_add_task 

end_add_task:
    // Restore registers from the stack
    ldp xzr, lr, [sp], #16
    ret
