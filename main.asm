.include "macro.mac"

.data
	
	# Phai xep dung thu tu nhu nay de ko bi loi bo nho khi dung lw (dia chi ko chia het cho 4)
	fdescr: .word 0
	multiplicand: .space 4
	multiplier: .space 4
	tenfile: .asciiz "INT2.BIN"
	
	str_multiplicand: .asciiz "Du lieu 1 = "
	str_multiplier: .asciiz "Du lieu 2 = "
	str_loi: .asciiz "Mo file bi loi. "
	result_hi: .asciiz "result hi = "
	my_result_hi: .asciiz "my result hi = "
	result_lo: .asciiz "result lo = "
	my_result_lo: .asciiz "my result lo = "
	
.text

.macro solve
	# Get the last bit of multiplier($s2) then store in $t1
	andi $t1, $s2, 1
	
	# if the last bit == 1 then add multiplicand($s1) to product ($t9)
	beq $t1, 1, add_multiplicand
	
	j shift
	
	add_multiplicand:
	
		addu $t9, $t9, $s1     
    	sltu $t3, $t9, $s1
    	add $t8, $t8, $t3
    	add $t8, $t8, $t6
	
	shift:
		# else shift left logic Multiplicand ($s1) 1 bit
		move $t7, $s1
		srl $t5, $t7, 31
		sll $t6, $t6, 1
		add $t6, $t6, $t5
		sll $s1, $s1, 1 
		# then shift left right logic Multiplier ($s2) 1 bit
		srl $s2, $s2, 1
		
.end_macro	

main:
	
	la $a0, tenfile
	li $a1, 0 # a1 = 0 --> read only
	li $v0, 13
	syscall
	
	bgez $v0, tiep

baoloi:
	print_str(baoloi)
	j Kthuc
	
tiep: sw $v0, fdescr

# doc file
	lw $a0, fdescr
	la $a1, multiplicand
	li $a2, 4
	li $v0, 14
	syscall
	
	la $a1, multiplier
	li $a2, 4
	li $v0, 14
	syscall
	
# dong file
	lw $a0, fdescr
	li $v0, 16
	syscall
	
# solution
	
	la $s1, multiplicand
	lw $s1, 0($s1)
	la $s2, multiplier
	lw $s2, 0($s2)
	
	li $t8, 0 # store upper bit
	li $t6, 0 # another to store upper bit (carry)
	li $t9, 0 # store lower bit
	
	print_int($s1, str_multiplicand)
	newLine
	print_int($s2, str_multiplier)
	newLine
	# Kiem tra dau
	bltz $s1, NegMultiplicand
	j CheckMultiplier
	
	NegMultiplicand:
		sub $s1, $zero, $s1
		
	CheckMultiplier:
		bltz $s2, NegMultiplier
		
	j solution
	
	NegMultiplier:
		sub $s2, $zero, $s2
	
	
	solution:
		# check bang ham co san
		mult $s1, $s2
		mfhi $t0
		mflo $t1
		print_int($t0, result_hi)
		newLine
		print_int($t1, result_lo)
		newLine
		
		# my solution
		for($t0, 1, 32, solve)
		
	print_int($t8, my_result_hi)
	newLine
	print_int($t9, my_result_lo)
	
Kthuc:
	exit()
	    
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
