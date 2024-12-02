.ifndef SHARED_DATA_INCLUDED   // Start guard
.set SHARED_DATA_INCLUDED, 1

.data
    task_count: .word 0                  // Number of tasks in the to-do list
    tasks: .space 1024                   // Task descriptions (128 tasks, 256 bytes each)
    completed_task_count: .word 0        // Number of completed tasks
    completed_tasks: .space 1024         // Completed task descriptions
    priority_task_count: .word 0         // Number of prioritized tasks
    priority_tasks: .space 1024          // Prioritized task descriptions
    task_priorities: .space 128          // Task priorities (1 byte per task)
    task_index: .word 0                  // Temporary variable for task index
    user_input: .word 0                  // Temporary variable for user input

.endif                                  // End guard

