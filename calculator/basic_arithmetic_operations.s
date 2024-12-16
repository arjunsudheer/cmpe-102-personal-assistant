.global floating_point_addition_main
.global floating_point_subtraction_main
.global floating_point_multiplication_main
.global floating_point_division_main
.global modulus_main

.text

floating_point_addition_main:
    fadd d0, d0, d1        
    ret                       

floating_point_subtraction_main:
    fsub d0, d0, d1           
    ret                       

floating_point_multiplication_main:
    fmul d0, d0, d1           
    ret                       

floating_point_division_main:
    fcmp d1, #0.0           
    b.eq division_by_zero     
    fdiv d0, d0, d1          
    ret                       

division_by_zero:
    ldr x9, =nan_value        
    ldr d0, [x9]
    ret

modulus_main:
    cmp x1, #0                
    b.eq modulus_by_zero      

    sdiv x2, x0, x1           
    mul x2, x2, x1            
    sub x0, x0, x2            
    ret                       

modulus_by_zero:
    mov x0, #0                
    ret

.data
nan_value: .quad 0x7FF8000000000000 
