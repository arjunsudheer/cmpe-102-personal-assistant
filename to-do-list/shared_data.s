// Start guard
.ifndef SHARED_DATA_INCLUDED
.set SHARED_DATA_INCLUDED, 1

.data
    // Task descriptions (128 task each taking 4 bytes)
    tasks: .space 128 * 4
    // Total number of tasks in the array
    total_tasks: .byte 0

    // Indices for task sections in the tasks array
    priority_task_index: .byte 0
    task_index: .byte 0
    completed_task_index: .byte 0

    // Temporary variable for user input
    user_input: .space 256
// End guard
.endif
