.include "shared_data.s"

.global prioritize_tasks_main

.text

prioritize_tasks_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Load the current task count
    ldr x0, =task_count
    ldr w1, [x0]                    // w1 = task_count
    cmp w1, #0                      // Check if there are any tasks
    b.eq no_tasks_to_prioritize     // If no tasks, display a message and exit

    // Print tasks and prompt for the task to prioritize
    printStr "\nTasks:\n"
    mov w2, #0                      // Task index
    ldr x3, =tasks                  // Base address of tasks

print_task_loop:
    cmp w2, w1                      // Compare index with task count
    b.ge prompt_user_task_selection // Exit loop if all tasks are displayed

    // Print task index
    printStr "Task "
    add w4, w2, #1                  // Convert 0-based index to 1-based
    mov w0, w4                      // Use 32-bit register for the task index
    bl printInt                     // Print the task index

    // Print task details
    mov x0, x3                      // Pass task address to printStr
    bl printStr                     // Print task description

    // Increment task index and pointer
    add w2, w2, #1                  // Increment index
    add x3, x3, #256                // Move to the next task
    b print_task_loop

prompt_user_task_selection:
    // Prompt user to select a task to prioritize
    printStr "\nEnter the task number to prioritize: "
    bl get32BitInt                  // Read the input into w0

    // Validate the input
    cmp w0, #1                      // Ensure task index >= 1
    blt invalid_task_index
    cmp w0, w1                      // Ensure task index <= task_count
    bgt invalid_task_index

    // Adjust task index (convert 1-based to 0-based)
    sub w0, w0, #1

    // Load the priority task count
    ldr x4, =priority_task_count
    ldr w5, [x4]                    // w5 = priority_task_count

    // Copy selected task to the priority_tasks array
    ldr x6, =tasks                  // Base address of tasks
    add x6, x6, x0, LSL #8          // Use x-registers for shifts (64-bit operand)
    ldr x7, =priority_tasks         // Base address of priority_tasks
    add x7, x7, x5, LSL #8          // Address to move the prioritized task
    mov w8, #256                    // Copy 256 bytes

copy_task_to_priority:
    ldrb w9, [x6], #1               // Load byte from tasks
    strb w9, [x7], #1               // Store byte to priority_tasks
    sub w8, w8, #1                  // Decrement byte count
    cbz w8, task_copied_to_priority // Break loop when all bytes are copied
    b copy_task_to_priority

task_copied_to_priority:
    // Increment the priority task count
    add w5, w5, #1                  // priority_task_count++
    str w5, [x4]                    // Update priority_task_count

    printStr "Task successfully prioritized.\n"
    b exit_prioritize_tasks

invalid_task_index:
    printStr "Invalid task number. Please try again.\n"
    b exit_prioritize_tasks

no_tasks_to_prioritize:
    printStr "No tasks to prioritize.\n"

exit_prioritize_tasks:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16
    ret

