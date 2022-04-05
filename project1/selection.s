.text
.global _start
.extern printf

_start:
    ldr x28, =stack
    ldr x0, =nums
    ldr x1, =length
    ldr x1, [x1]
    sub x28, x28, #8
    stur x30, [x28, #0]
    bl sortNums
    ldur x30, [x28, #0]
    add x28, x28, #8
    ldr x0, =nums
    ldr x1, =length
    ldr x1, [x1]
    sub x28, x28, #8
    stur x30, [x28, #0]
    bl printNums
    ldur x30, [x28, #0]
    add x28, x28, #8
end:  
    mov x0, #0
    mov w8, #93
    svc #0

swapElements:
    //x0: index 1
    //x1: index 2
    //x2: nums
    mov x4, x2
    lsl x5, x0, #3
    lsl x6, x1, #3
    add x5, x5, x4
    add x6, x6, x4
    ldr x7, [x5, #0]
    ldr x8, [x6, #0]
    stur x7, [x6, #0]
    stur x8, [x5, #0]
    br x30

sortNums:
    //x0: nums
    //x1: length
    mov x25, x0 //nums
    mov x26, x1 //length
    mov x27, #0
loop:
    cmp x26, x27
    ble breakLoop
    mov x0, x27 //counter
    mov x1, x26 //length
    sub x28, x28, #8
    stur x30, [x28, #0]
    bl inside
    ldur x30, [x28, #0]
    add x28, x28, #8
    mov x1, x27
    mov x2, x25
    sub x28, x28, #0
    stur x30, [x28, #0]
    bl swapElements
    ldur x30, [x28, #0]
    add x28, x28, #8
    add x27, x27, #1
    b loop
breakLoop:
    br x30

inside:
    mov x20, x0 //counter
    mov x21, x1 //length variable
    ldr x22, =nums
    lsl x23, x0, #3
    add x23, x22, x23
    ldr x24, [x23, #0] //min value
insideLoop:
    cmp x21, x20
    mov x1, x24
    ble breakInsideLoop
    lsl x19, x20, #3
    add x19, x22, x19
    ldr x19, [x19, #0]
    cmp x19, x24
    blo newMin
    b noNewMin
noNewMin:
    add x20, x20, #1
    b insideLoop
newMin:
    mov x24, x19
    mov x0, x20
    add x20, x20, #1
    b insideLoop
breakInsideLoop:
    br x30
   
printNums:
    mov x19, #0  
    ldr x20, =length
    ldr x20, [x20]
    ldr x21, =nums
printLoop:
    cmp x20, x19
    ble breakPrintLoop
    lsl x22, x19, #3
    add x22, x21, x22
    ldr x23, [x22, #0]
    mov x1, x23
    sub x28, x28, #8
    stur x30, [x28, #0]
    ldr x0, =print
    bl printf
    ldur x30, [x28, #0]
    add x28, x28, #8
    add x19, x19, #1
    b printLoop
breakPrintLoop:
    br x30



.data

print:
    .ascii "%d\n\0"
   
length:
    .quad 10
   
nums:
    .quad 10, 9, 4, 3, 2, 8, 7, 6, 1, 5
   
.bss
    .align 16
   
stack:
    .space 1024
   
.end

