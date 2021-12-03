.data
plainText: .space 50
copyplain:	.space 50
copyplain2:	.space 50
fileName: .asciiz "D:\COAL\CoalProject\write.txt"
# most used letters in english E T A O I 
key:	.word 0
alert:	.asciiz "Invalid input !!\n"
alphas: .asciiz "abcdefghijklmnopqrstuvwxyz"
letterMax:	.byte 'a'
letterCount: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
inputType: .asciiz "Welcome to Minerva\nA cryptography and cryptanalysis program\n\nPress 1 to work on files\nPress 2 to work on user input\n"
restart: .asciiz "\nDo you want to restart the program?\nPress 1 for yes\nPress 0 for no\n"
fileEncrypted: .asciiz "\nThe file has been successfully encrypted"
fileDecrypted: .asciiz "\nThe file has been successuflly decrypted"

que:	.asciiz "\nPress 1 to encrypt\nPress 2 to decrypt\nPress 3 to do cryptanalysis\n"
que2: 	.asciiz "\nPress 1 to encrypt\nPress 2 to decrypt\n"
msg1:	.asciiz "\nEnter text:"
msgde:	.asciiz "\nEnter ciphered text: "
msg2:	.asciiz "\nEnter key: "
msg3:	.asciiz "\nCiphered text: "
newline: .asciiz "\n"

.text
.globl main
main:


li $v0,4
la $a0,inputType
syscall

li $v0,5
syscall
move $t0,$v0

beq $t0, 1 filing
beq $t0, 2 stringinput
li $v0,4
la $a0,alert
syscall

b main


filing:

	li $v0,13
	la $a0,fileName
	li $a1,0
	li $a2,0
	syscall
	
	move $t6,$v0

	li $v0,14
	move $a0,$t6
	la $a1,plainText
	li $a2,50
	syscall



	li $v0,16
	move $a0,$t6
	syscall
	
	li $v0,4
	la $a0,que2
	syscall
	li $v0,5
	syscall
	move $t0,$v0


	li	$v0,4
	la	$a0,msg2
	syscall
	
	li $v0,5
	syscall
	sw $v0,key
	
	lw $t1,key
	li $t2,26
	div $t1,$t2
	mfhi,$t2
	sw $t2,key
	

beq $t0,1 encryption_file
beq $t0,2 decryption_file

decryption_file:
lw $t1,key
mul $t1,$t1,-1
sw $t1,key

encryption_file:

	jal checkUpperCase
	

	jal caesarEncrypt

	
	li $v0,13
	la $a0,fileName
	li $a1,1
	li $a2,0
	syscall
	move $t6,$v0

	#now writing file
	li $v0,15
	move $a0,$t6
	la $a1,plainText
	li $a2,50
	syscall

	li $v0,16
	move $a0,$t6
	syscall
	
b exit1
stringinput:
li $v0,4
la $a0,que2
syscall
li $v0,5
syscall
move $t0,$v0

beq $t0,1 encryption
beq $t0,2 decryption

encryption:
li	$v0,4
la	$a0,msg1
syscall

#Talking PlainText input
la	$a0,plainText
li	$a1,50
li	$v0,8
syscall

la	$a1,plainText
jal checkUpperCase

li	$v0,4
la	$a0,msg2
syscall

li $v0,5
syscall
sw $v0,key
lw $t0,key
li $t2,26
div $t0,$t2
mfhi,$t2
sw $t2,key

la $a1,plainText
lw $a2,key
jal caesarEncrypt

li	$v0,4
la	$a0,plainText
syscall

exit1:
la $a0, restart
li $v0, 4
syscall

li $v0, 5
syscall
beq $v0, 1, main
li	$v0,10
syscall

decryption:

li	$v0,4
la	$a0,msgde
syscall


la	$a0,plainText
li	$a1,50
li	$v0,8
syscall

la	$a1,plainText
jal checkUpperCase

li	$v0,4
la	$a0,msg2
syscall

li $v0,5
syscall
sw $v0,key
lw $t0,key

li $t2,26
div $t0,$t2
mfhi,$t2
mul $t2,$t2,-1
sw $t2,key
jal caesarEncrypt

li	$v0,4
la	$a0,plainText
syscall
b exit1 
#*****************************breaking caeser cipher**************************************************
breakcipher:
#ETAOI
li	$v0,4
la	$a0,msgde
syscall


la	$a0,plainText
li	$a1,50
li	$v0,8
syscall

la	$a1,plainText
jal checkUpperCase
jal copyorignal
li $t1,0

loop_out:
li $t2,97

	lb $t0,plainText($t1)
	beq $t0,0 next
	ble $t0,96 continue2
	bge $t0,123 continue2
	div $t0,$t2
	mfhi $t2
	mul $t2,$t2,4
	lw $t3,letterCount($t2)
	add $t3,$t3,1
	sw $t3,letterCount($t2)
	addi $t1,1
	b loop_out
next:
	li $t0,0
	li $t1,0
	loop_max:
	beq $t1,26 find_max
	#li $v0,1
	#lw $a0,letterCount($t0)
	#syscall
	#li $v0,4
	#la $a0,newline
	#syscall

	addi $t0,4
	addi $t1,1
	b loop_max

find_max:
	li $t2,0
	li $t0,0
	li $t1,0
	loop_max2:
	beq $t1,26 breaker
	lw $t3,letterCount($t0)
	bgt $t3,$t2 update1
	addi $t0,4
	addi $t1,1
	b loop_max2
	update1:
		move $t2,$t3
		move $t4,$t0
		b loop_max2
	breaker:
		li $t0,4
		div $t4,$t0
		mflo $t0
		lb $t1,alphas($t0)
		sb $t1,letterMax
		lb $t3,letterMax
		sub $t3,$t3,'e'
		mul $t3,$t3,-1
		sw $t3,key
		jal caesarEncrypt
		li $v0,4
		la $a0,plainText
		syscall
		li $v0,4
		la $a0,newline
		syscall

		jal strcpy 
		
		lb $t3,letterMax
		sub $t3,$t3,'t'
		mul $t3,$t3,-1
		sw $t3,key
		jal caesarEncrypt
		li $v0,4
		la $a0,plainText
		
		syscall
		li $v0,4
		la $a0,newline
		syscall
		
		jal strcpy

		lb $t3,letterMax
		sub $t3,$t3,'a'
		mul $t3,$t3,-1
		sw $t3,key
		jal caesarEncrypt
		li $v0,4
		la $a0,plainText
		syscall
		li $v0,4
		la $a0,newline
		syscall
		
		jal strcpy
		
		lb $t3,letterMax
		sub $t3,$t3,'o'
		mul $t3,$t3,-1
		sw $t3,key
		jal caesarEncrypt
		li $v0,4
		la $a0,plainText
		syscall
		li $v0,4
		la $a0,newline
		syscall

		li	$v0,10
		syscall


continue2:
	addi $t1,1
	b loop_out

#*********************************converting any upper Character into lower case*****************************
.globl checkUpperCase
.ent checkUpperCase
checkUpperCase:
li $t0,0
li $t2,97

loop:
lb	$t1,plainText($t0)
beq $t1,0 exit
beq $t1,' ' continue
beq $t1,'\n' continue

blt $t1,$t2 change
addi $t0,1
b loop

continue:
addi	$t0,1
b loop

change:
	add $t1,32
	sb $t1,plainText($t0)
b loop

exit:
jr $ra

.end checkUpperCase
#********************************************Function To cipher text ********************************************
.globl caesarEncrypt
.ent caesarEncrypt
caesarEncrypt:
#loading key 
lw $t4,key
#counter
li $t0,0
loop1:
#getting character
lb	$t1,plainText($t0)
beqz $t1 exit2
beq $t1,' ' continue1
beq $t1,'\n' continue1
add $t1,$t1,$t4
bgt $t1,122 circulate
blt $t1,97 circulate1
sb $t1,plainText($t0)
addi $t0,1
b loop1
#z->a
circulate:
li $t6,123

div $t1,$t6
mfhi $t1
lb $t1,alphas($t1)
sb $t1,plainText($t0)
addi $t0,1
b loop1
#reverse cycle going to from a -> z
circulate1:
#97-26=71
li $t8,71
div $t1,$t8
mfhi $t5
lb $t5,alphas($t5)
sb $t5,plainText($t0)
addi $t0,1
b loop1

exit2:
	jr $ra

continue1:
addi	$t0,1
b loop1

.end caesarEncrypt

.globl strcpy
.ent strcpy
strcpy:
li $t0,0
copy:
beq $t0,50 return
lb $t1,copyplain2($t0)
sb $t1,plainText($t0)
addi $t0,1
b copy
return:
	jr $ra
.end strcpy
.globl copyorignal
.ent copyorignal
copyorignal:
li $t0,0
copy1:
beq $t0,50 return1
lb $t1,plainText($t0)
sb $t1,copyplain2($t0)
addi $t0,1
b copy1
return1:
	jr $ra
.end copyorignal
#Bahawal Baloch : member 1 cs171032 
#Tarun Kumar 	: member 2 cs171024
#Multazam Siddiqui: member 3 cs171043 