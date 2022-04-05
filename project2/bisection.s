.text
.global _start
.extern printf

_start:
    ldr x28, =stack
    sub x28, x28, #8
    ldur x30, [x28, #0]
    bl find_root
    fmov d29, d0
    ldr x0, =print_1
    bl printf
    fmov d0, d29
    bl find_y
    ldr x0, =print_2
    bl printf
    stur x30, [x28, #0]
    add x28, x28, #8
   
    mov x0, #0
    mov w8, #93
    svc #0

return:
    br x30

exp:
    fmov d1, d0
    fmov d0, #1 
    cmp x0, #0
    beq return 
exp_inner:
    cmp x0, #0
    beq return 
    fmul d0, d0, d1 
    sub x0, x0, #1 
    b exp_inner
   
absolute_value:
    fcmp d0, #0
    bge return 
    fmov d1, #-1 
    fmul d0, d0, d1
    br x30

calculate_term:
    adr x1, coeff 
    lsl x2, x0, #3 
    add x2, x2, x1 
    ldur d2, [x2, #0] 
    sub x28, x28, #8
    stur x30, [x28, #0]
    bl exp 
    ldur x30, [x28, #0]
    add x28, x28, #8
    fmul d0, d0, d2 
    br x30

find_y:
    adr x4, ZERO
    mov x5, #0 
    adr x6, MAX_POWER
    ldur x7, [x6, #0]
    fmov d3, d0 
    ldur d4, [x4, #0]
find_y_loop:
    cmp x5, x7 
    bhi return 
    mov x0, x5 
    fmov d0, d3 
    sub x28, x28, #8
    stur x30, [x28, #0]
    bl calculate_term 
    ldur x30, [x28, #0]
    add x28, x28, #8
    fadd d4, d4, d0 
    fmov d0, d4 
    add x5, x5, #1 
    b find_y_loop

find_root:
    adr x8, A
    adr x9, B
    adr x10, ACCURACY
   
    ldur d5, [x8, #0] 
    ldur d6, [x9, #0] 
    ldur d7, [x10, #0] 
find_root_loop:
    fadd d8, d6, d5 
    fmov d9, #2
    fdiv d8, d8, d9 
    fmov d0, d8 
    sub x28, x28, #8
    stur x30, [x28, #0]
    bl find_y 
    fmov d10, d0 
    bl absolute_value 
    fmov d11, d0 
    fmov d0, d8
    ldur x30, [x28, #0]
    add x28, x28, #8
    fcmp d11, d7 
    ble return 
    fcmp d10, #0
    ble less_than 
    fmov d6, d8
    b find_root_loop
less_than:
    fcmp d10, #0
    bge equal 
    fmov d5, d8 
    b find_root_loop 
equal:    
    fcmp d10, #0
    beq return

.data
print_1:
    .ascii "Approximate root found at %f\n\0"
print_2:
    .ascii "Actual y value is %f\n\0"
coeff:
    .double 0.2, 3.1, -0.3, 1.9, 0.2
MAX_POWER:
    .dword 4
A:
    .double -1
B:
    .double 1
ACCURACY:
    .double 0.001
ZERO:
    .double 0    
.bss
    .align 16
stack:
    .space 1024
.end
