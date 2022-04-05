.text	
.equ ELEM, 14
.global _start
.extern printf

_start:
	  ldr x0, =stack
	  mov sp, x0
	  sub sp, sp, #16
	  str x30, [sp]
	  
	  mov x14, #ELEM //length
	  ldr x13, =list  //first element
	  
	  bl findmax
	  
	  add sp, sp, #16
	  mov x1, x0
	  ldr x0, =print
	  bl printf
	  b end
	  
.func findmax
findmax:
	  stp x13, x14, [sp, #-16]!
	  stp x12, x30, [sp, #-16]!
	  
	  cmp x14, #1  //if size is not equal to one
	  bhi findmax_split //do this
	  ldr x0, [x13] //else do this
	  b return

findmax_split: 
	  mov x12, x14, lsr #1
	  sub x14, x14, x12 
	  
	  bl findmax  
	  
	  add x13, x13, x14, lsl #3 
	  
	  mov x14, x12
	  mov x12, x0 
	  
	  bl findmax  
	  
	  cmp x0, x12
	  bge return
	  mov x0, x12
	  b return

return:
	  ldp x12, x30, [sp], #16
	  ldp x13, x14, [sp], #16 
	  br x30
.endfunc

end:	
	  mov x0, #0
	  mov w8, #93
	  svc #0  
  
.data
  
print:
	  .ascii "%d\n\0"
list:
  	  .dword 2, 5, 3, 7, 9, 21, 10, 6, 15, 1, 4, 13, 8, 7, 5

.bss
	  .align 8

out:
	  .space 8
	  .align 16
	  .space 4096

stack:
  	  .space 16
  	  .end		
		

  


