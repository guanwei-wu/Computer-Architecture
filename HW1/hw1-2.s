.globl __start

.rodata
    msg0: .string "This is HW1-2: \n"
    msg1: .string "Plaintext:  "
    msg2: .string "Ciphertext: "
.text

################################################################################
  # print_char function
  # Usage: 
  #     1. Store the beginning address in x20
  #     2. Use "j print_char"
  #     The function will print the string stored from x20 
  #     When finish, the whole program with return value 0

print_char:
    addi a0, x0, 4
    la a1, msg2
    ecall
    
    add a1,x0,x20
    ecall

  # Ends the program with status code 0
    addi a0,x0,10
    ecall
    
################################################################################

__start:
  # Prints msg
    addi a0, x0, 4
    la a1, msg0
    ecall

    la a1, msg1
    ecall
    
    addi a0,x0,8
    li a1, 0x10130
    addi a2,x0,2047
    ecall
    
  # Load address of the input string into a0
    add a0,x0,a1

################################################################################ 
  # Write your main function here. 
  # a0 stores the begining Plaintext
  # Do store 66048(0x10200) into x20 
  # ex. j print_char
main:
  # main function
    addi a6, x0, -1 # a6 = index ( -1 at first )
    addi s1, x0, 48 # space num
    li x20, 0x10200
    li gp, 0x10200
encry:
  # encrypting part
    addi a5, a6, 1 # index += 1
    add a5, a0, a5
    lb t2, 0(a5) # t2 = str[index]
    beq t2, x0, finish # end
    addi a3, x0, 32 # a3 stores compared ascii
    beq t2, a3, space # meet space
    addi a3, x0, 120
    bge t2, a3, xyz # meet xyz
    addi t2, t2, 3
    addi a6, a6, 1
    sb t2 0(x20)
    addi x20, x20, 1
    jal x0, encry
space:
  # if meet space
    add t2, x0, s1
    addi s1, s1, 1
    sb t2 0(x20)
    addi x20, x20, 1
    addi a6, a6, 1
    jal x0, encry
xyz:
  # handle xyz -> abc cases
    addi t2, t2, -23
    addi a6, a6, 1
    sb t2 0(x20)
    addi x20, x20, 1
    jal x0, encry
finish:
  # finish encrypting
    add x20, x0, gp
    j print_char
################################################################################

