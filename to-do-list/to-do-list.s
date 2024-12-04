.include "debug.s"
.include "add_task.s"
.include "delete_task.s"
.include "display_tasks.s"
.include "mark_completed.s"
.include "display_completed_tasks.s"
.include "prioritize_tasks.s"
.include "focus_session.s"


.global main

.text
main:
    // Display the menu
    printStr "\n=== To-Do List Manager ==="
    printStr "Enter the number associated with the command:"
    printStr "1) Add Task"
    printStr "2) Delete Task"
    printStr "3) Display All Tasks"
    printStr "4) Mark Task as Completed"
    printStr "5) Display Completed Tasks"
    printStr "6) Prioritize Tasks"
    printStr "7) Focus Session"
    printStr "8) Exit"

    // Get user input
    ldr x0, =user_input          // Address of user_input
    bl get64BitInt               // Get input into user_input

    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    // Validate the input and call the corresponding function
    ldr x1, =user_input          // Load address of user_input
    ldr w0, [x1]                 // Load user input
    cmp w0, #1
    beq call_add_task

    cmp w0, #2
    beq call_delete_task

    cmp w0, #3
    beq call_display_tasks

    cmp w0, #4
    beq call_mark_completed

    cmp w0, #5
    beq call_display_completed_tasks

    cmp w0, #6
    beq call_prioritize_tasks

    cmp w0, #7
    beq call_focus_session

    cmp w0, #8
    beq exit

    // Handle invalid input
    b invalid_command

call_add_task:
    bl add_task_main
    b main

call_delete_task:
    bl delete_task_main
    b main

call_display_tasks:
    bl display_tasks_main
    b main

call_mark_completed:
    bl mark_completed_main
    b main

call_display_completed_tasks:
    bl display_completed_tasks_main
    b main

call_prioritize_tasks:
    bl prioritize_tasks_main
    b main

call_focus_session:
    bl focus_session_main
    b main

invalid_command:
    printStr "Invalid Command. Please try again."
    b main

exit:
    // Restore lr from the stack
    ldp xzr, lr, [sp], #16

    // Exit the program
    mov x0, #0
    mov x8, #93
    svc 0
