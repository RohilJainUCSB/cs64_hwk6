# print_array.asm program
# For CMPSC 64
#
# Don't forget to:
#   make all arguments to any function go in $a0, $a1
#   make all returned values from functions go in $v0

.data
	array: 		.word 		1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	cout:  		.asciiz 	"The contents of the array are:\n"
	newline: 	.asciiz		"\n"

.text
printArr:
    # TODO: Write your function code here
	#a0 contains the array address, a1 contains the array length
	sll $t0, $a1, 2		#t0 contains the arrLen * 4 = arrLen in bytes
	add $t0, $a0, $t0	#t0 now contains the address of the end of last elem (first elem addr + arrLen in bytes)
	addi $t0, $t0, -4	#t0 now contains the address of the start of last elem (remove the 4 extra bits)
	move $t1, $a0		#t1 now contains the array start address so that $a0 can be used
loop:
	blt $t0, $t1, exitLoop	#if the address of the index is less than the starting address of the array, exit
	lw $a0, 0($t0)
	li $v0, 1
	syscall				#print the array element
	la $a0, newline
	li $v0, 4
	syscall				#print newline
	sub $t0, $t0, 4		#decrement the address to point to the prior element
	j loop
exitLoop:
	jr $ra
main:  # DO NOT MODIFY THE MAIN SECTION
	li $v0, 4
	la $a0, cout
	syscall

	la $a0, array
	li $a1, 10

	jal printArr

	li $v0, 10
	syscall