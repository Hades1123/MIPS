.data
	newline: .asciiz "\n"
		
# newLine
	.macro newLine
	la $a0, newline
	li $v0, 4
	syscall
	.end_macro

# print_str
	.macro print_str (%str)
	la $a0, %str
	li $v0, 4
	syscall
	.end_macro

# print_int
	.macro print_int (%int, %message)
	print_str(%message)
	move $a0, %int
	li $v0, 1
	syscall
	.end_macro
	
# input_int
	.macro input_int(%register)
	li $v0, 5
	syscall
	move %register, $v0
	.end_macro
	
# exit
	.macro exit
	li $v0, 10
	syscall
	.end_macro
	
# for_loop : i = start ; i <= end ; ++ i
	.macro for (%regIterator, %start, %end, %body)
	add %regIterator, $zero, %start
	loop:
		%body()
		add %regIterator, %regIterator, 1
		ble %regIterator, %end, loop
	.end_macro