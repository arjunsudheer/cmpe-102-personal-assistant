.global exponent_main

.text
exponent_main:
    // Save lr to the stack
    stp xzr, lr, [sp, #-16]!

    fcvtzs x2, d1           

    cmp x2, #0
    beq return_one           

    cmp x2, #0
    blt negative_exp        

    bl positive_exp

    // Restore lr and return
    ldp xzr, lr, [sp], #16
    ret

negative_exp:
    neg x2, x2               
    ldr x9, =one            
    ldr d3, [x9]            

neg_loop:
    cmp x2, #0               
    beq neg_end              
    fdiv d3, d3, d0          
    sub x2, x2, #1           
    b neg_loop             

neg_end:
    fmov d0, d3             
    ldp xzr, lr, [sp], #16  
    ret

positive_exp:
    ldr x9, =one            
    ldr d3, [x9]             

pos_loop:
    cmp x2, #0               
    beq pos_end              
    fmul d3, d3, d0          
    sub x2, x2, #1           
    b pos_loop               

pos_end:
    fmov d0, d3              
    ldp xzr, lr, [sp], #16  
    ret

return_one:
    ldr x9, =one            
    ldr d0, [x9]             
    ldp xzr, lr, [sp], #16   
    ret

.data
one: .double 1.0
