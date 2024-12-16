// shared_data.s
.ifndef SHARED_DATA_INCLUDED
.set SHARED_DATA_INCLUDED, 1

.data
    .align 4
    tasks: .space 128 * 8
    .align 4
    total_tasks: .byte 0
    priority_task_index: .byte 0
    task_index: .byte 0
    completed_task_index: .byte 0
    .align 4
    int_input: .word 0
    .align 4
    user_input: .space 256

.endif

