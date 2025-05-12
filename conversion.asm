# conversion.asm program
# For CMPSC 64
#
# Don't forget to:
#   make all arguments to any function go in $a0, $a1, $a2
#   make all returned values from functions go in $v0

.text
conv:
    # TODO: Write your function code here
    #preconditions: $a0 --> x, $a1 --> y, $a2 --> n
    li $v0, 0               #z = 0 --> v0 (since z is the return value)
    li $t0, 0               #i = 0 --> t0
    li $t2, 2               #store the 2 for the comparison in the loop in t2
loop:
    bge $t0, $a2, endFunc   #if i >= n then exit the function
    sll $t1, $a1, 2         #t1 = 4 * y
    sub $v0, $v0, $a0       #z = z - x
    add $v0, $v0, $t1       #z = z + 4y
    bge $a0, $t2, decreaseY #if x >= 2 go to the decreaseY
    j restartLoop           #otherwise jump to increment x and restart the loop
decreaseY:
    sub $a1, $a1, $a0       #y = y - x, continue to restart loop
restartLoop:
    addi $a0, $a0, 1        #x = x + 1
    addi $t0, $t0, 1        #i++
    j loop                  #restart loop
endFunc:
    jr $ra

main:  # DO NOT MODIFY THE MAIN SECTION
    li $a0, 5
    li $a1, 7
    li $a2, 7

    jal conv

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall