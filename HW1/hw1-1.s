.globl __start

.rodata
    msg0: .string "This is HW1-1: T(n) = 2T(n/2) + 8n + 5, T(1) = 4\n"
    msg1: .string "Enter a number: "
    msg2: .string "The result is: "

.text
################################################################################
  # You may write function here
T:
  # function T
    addi sp, sp, -8
    sw x1, 4(sp)
    sw a0, 0(sp)
    addi a2, a0, -2 # a2 = n-2
    srli a0, a0, 1 # n /= 2
    bge a2, x0, main
    addi t0, x0, 4 # return 4
    addi sp, sp, 8
    jalr x0, 0(x1)
################################################################################

__start:
  # Prints msg0
    addi a0, x0, 4
    la a1, msg0
    ecall

  # Prints msg1
    addi a0, x0, 4
    la a1, msg1
    ecall

  # Reads an int
    addi a0, x0, 5
    ecall

################################################################################ 
  # Write your main function here. 
  # Input n is in a0. You should store the result T(n) into t0
  # HW1-1 T(n) = 2T(n/2) + 8n + 5, T(1) = 4, round down the result of division
  # ex. addi t0, a0, 1
remember:
  # remember sp position
    addi s1, sp, 0
main:
  # main function
    jal x1, T # call T(n/2)
    addi a3, t0, 0 # a3 = T(n/2)
    beq s1, sp, result # turn to result
    lw a0, 0(sp)
    lw x1, 4(sp)
    addi sp, sp, 8
    addi a4, x0, 8 # a4 = 8
    mul a5, a0, a4 # a5 = 8n
    add a6, a3, a3 # a6 = 2T(n/2)
    add t0, x0, a6 # t0 = a6
    add t0, t0, a5 # t0 += 8n
    addi t0, t0, 5 # t0 += 5
    jalr x0, 0(x1)
################################################################################

result:
  # Prints msg2
    addi a0, x0, 4
    la a1, msg2
    ecall

  # Prints the result in t0
    addi a0, x0, 1
    add a1, x0, t0
    ecall
    
  # Ends the program with status code 0
    addi a0, x0, 10
    ecall