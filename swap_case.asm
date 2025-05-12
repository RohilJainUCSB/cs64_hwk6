# swap_case.asm program
# For CMPSC 64
#
# Data Area
.data
    buffer:         .space 100
    input_prompt:   .asciiz "Enter string:\n"
    output_prompt:  .asciiz "Output:\n"
    convention:     .asciiz "Convention Check\n"
    newline:        .asciiz "\n"

.text

#
# DO NOT MODIFY THE MAIN PROGRAM 
#       OR ANY OF THE CODE BELOW, WITH 1 EXCEPTION!!!
# YOU SHOULD ONLY MODIFY THE SwapCase FUNCTION 
#       AT THE BOTTOM OF THIS CODE
#
main:
    la $a0, input_prompt    # prompt user for string input
    li $v0, 4
    syscall

    li $v0, 8       # take in input
    la $a0, buffer
    li $a1, 100
    syscall
    move $s0, $a0   # save string to s0

    li $s1, 0
    li $s2, 0
    li $s3, 0
    li $s4, 0
    li $s5, 0
    li $s6, 0
    li $s7, 0

    move $a0, $s0
    jal SwapCase

    add $s1, $s1, $s2
    add $s1, $s1, $s3
    add $s1, $s1, $s4
    add $s1, $s1, $s5
    add $s1, $s1, $s6
    add $s1, $s1, $s7
    add $s0, $s0, $s1

    la $a0, output_prompt    # give Output prompt
    li $v0, 4
    syscall

    move $a0, $s0
    jal DispString

    j Exit

DispString:
    addi $a0, $a0, 0
    li $v0, 4
    syscall
    jr $ra

ConventionCheck:
    addi    $t0, $zero, -1
    addi    $t1, $zero, -1
    addi    $t2, $zero, -1
    addi    $t3, $zero, -1
    addi    $t4, $zero, -1
    addi    $t5, $zero, -1
    addi    $t6, $zero, -1
    addi    $t7, $zero, -1
    ori     $v0, $zero, 4
    la      $a0, convention
    syscall
    addi    $v0, $zero, -1
    addi    $v1, $zero, -1
    addi    $a0, $zero, -1
    addi    $a1, $zero, -1
    addi    $a2, $zero, -1
    addi    $a3, $zero, -1
    addi    $k0, $zero, -1
    addi    $k1, $zero, -1
    jr      $ra
    
Exit:
    li $v0, 10
    syscall

# COPYFROMHERE - DO NOT REMOVE THIS LINE

# YOU CAN ONLY MODIFY THIS FILE FROM THIS POINT ONWARDS:
SwapCase:
    #TODO: write your code here, $a0 stores the address of the string
    #Citing resources I used for help:
        # https://www.ascii-code.com/
        # https://www.reddit.com/r/Assembly_language/comments/uhfmbg/acess_a_char_in_string_mips/
    
    addiu $sp, $sp, -24
    sw $s0, 0($sp)                  #push the current s0 value into the stack
    sw $ra, 4($sp)                  #push the correct return address into the stack so that conventionCheck can be called correctly
    sw $s1, 8($sp)                  #push the current s1 value into the stack
    sw $s2, 12($sp)                 #push the current s2 value into the stack
    sw $s3, 16($sp)                 #push the current s3 value into the stack
    sw $s4, 20($sp)                 #push the current s4 value into the stack

    li $s1, 65                      #set s1 to min letter value
    li $s2, 122                     #set s2 to max letter value
    li $s3, 90                      #set s3 to max uppercase
    li $s4, 97                      #set s4 to min lowercase

    move $s0, $a0                   #s0 now holds the pointer to the char we are using
loop:
    lb $t0, 0($s0)                  #t0 contains the current byte of the string
    beq $t0, $zero, exitLoop        #if the char is a null-term char then we are at the end of the string
checkChar:
    blt $t0, $s1, nextIteration     #if the char is less than minimum letter value then nextIteration
    bgt $t0, $s2, nextIteration     #if the char is greater than max letter val then nextIteration
    ble $t0, $s3, uppercase         #if it is an uppercase b/c it's less than or equal to max uppercase
    bge $t0, $s4, lowercase         #if it is a lowercase b/c it's greater than or equal to min lowercase
    j nextIteration                 #else (not letter) nextIteration
uppercase:
    move $a0, $t0
    li $v0, 11
    syscall                         #print current letter
    la $a0, newline
    li $v0, 4
    syscall                         #print newline
    move $a0, $t0
    addi $a0, $a0, 32               #make lowercase
    li $v0, 11
    syscall                         #print lowercase
    sb $a0, 0($s0)                  #change the input string byte to be the new case
    la $a0, newline
    li $v0, 4
    syscall                         #print newline
    jal ConventionCheck             #call ConventionCheck
    j nextIteration                 #move to nextIteration
lowercase:
    move $a0, $t0
    li $v0, 11
    syscall                         #print current letter
    la $a0, newline
    li $v0, 4
    syscall                         #print newline
    move $a0, $t0
    addi $a0, $a0, -32              #make uppercase
    li $v0, 11
    syscall                         #print uppercase
    sb $a0, 0($s0)                  #change the input string byte to be the new case
    la $a0, newline
    li $v0, 4
    syscall                         #print newline
    jal ConventionCheck             #call ConventionCheck
    #move to nextIteration
nextIteration:
    addi $s0, $s0, 1                #move to next byte
    j loop                          #restart loop
exitLoop:
    lw $s0, 0($sp)
    lw $ra, 4($sp)                  #set ra back to original ra
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addiu $sp, $sp, 24              #reset all saved values to their original values and empty stack
    # Do not remove the "jr $ra" line below!!!
    # It should be the last line in your function code!
    jr $ra