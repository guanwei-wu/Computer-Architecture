.data
    n: .word 10
    
.text
.globl __start

FUNCTION:
    # Todo: Define your own function in HW1
    addi sp, sp, -16 #push stack
    sw x1, 8(sp)     #store next instruction
    sw x10, 0(sp)    #store x10(n)
    srli x6, x10, 1  #x6=n/2
    beq x6, x0, L1   #whether n/2==0 -> L1
    srli x10, x10, 1 #x10=n/2
    jal x1, FUNCTION #recursion
    lw x1, 8(sp)     #load next instruction
    lw t0, 0(sp)     #load n to x10
    addi sp, sp, 16  #pop stack
    slli x10, x10, 1 #2T(n/2)
    slli t0, t0, 3   #8n
    add x10, x10, t0 #2T(n/2)+8n
    addi x10, x10, 5 #2T(n/2)+8n+5
    jalr x0, 0(x1)   #go to next instruction
L1: addi x10, x0, 4  #T(1)=4
    addi sp, sp, 16  #remove n=0
    jalr x0, 0(x1)   #start to add up
# Do NOT modify this part!!!
__start:
    la   t0, n
    lw   x10, 0(t0)
    jal  x1,FUNCTION
    la   t0, n
    sw   x10, 4(t0)
    addi a0,x0,10
    ecall
