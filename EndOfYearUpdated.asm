#Sydney Ward 10/5/18 EndOfYearProject.asm

########################################################################################
#This program is a sudoku puzzle game. It prints the puzzle, asks the user for the     #
#row and column they want to change, the value they want to change it to, and change   #
#the value if it is correct and asks for the user to enter another if it is incorrect. #
#The program exits if the puzzle is complete. There are two versions of this game. The #
#easy version of the game checks each answer as it is input and allows the user to     #
#input answers until they get the right answer. The hard version allows the user to    #
#input all answers and checks them after the puzzle is complete.                       #
########################################################################################

.data

puzzle1:		.byte 1 0 0 4 8 9 0 0 6 7 3 0 0 5 0 0 4 0 4 6 0 0 0 1 2 9 5 3 8 7 1 2 0 6 0 0 5 0 1 7 0 3 0 0 8 0 4 6 0 9 5 7 1 3 9 1 4 6 0 0 0 8 0 0 2 0 0 4 0 0 3 7 8 0 3 5 1 2 0 0 4
puzzle1Sol:	.byte 1 5 2 4 8 9 3 7 6 7 3 9 2 5 6 8 4 1 4 6 8 3 7 1 2 9 5 3 8 7 1 2 4 6 5 9 5 9 1 7 6 3 4 2 8 2 4 6 8 9 5 7 1 3 9 1 4 6 3 7 5 8 2 6 2 5 9 4 8 1 3 7 8 7 3 5 1 2 9 6 4

puzzle2: 	.byte 5 3 0 0 7 0 0 0 0 6 0 0 1 9 5 0 0 0 0 9 8 0 0 0 0 6 0 8 0 0 0 6 0 0 0 3 4 0 0 8 0 3 0 0 1 7 0 0 0 2 0 0 0 6 0 6 0 0 0 0 2 8 0 0 0 0 4 1 9 0 0 5 0 0 0 0 8 0 0 7 9
puzzle2Sol:	.byte 5 3 4 6 7 8 9 1 2 6 7 2 1 9 5 3 4 8 1 9 8 3 4 2 5 6 7 8 5 9 7 6 1 4 2 3 4 2 6 8 5 3 7 9 1 7 1 3 9 2 4 8 5 6 9 6 1 5 3 7 2 8 4 2 8 7 4 1 9 6 3 5 3 4 5 2 8 6 1 7 9
puzzle2Master:	.byte 5 3 0 0 7 0 0 0 0 6 0 0 1 9 5 0 0 0 0 9 8 0 0 0 0 6 0 8 0 0 0 6 0 0 0 3 4 0 0 8 0 3 0 0 1 7 0 0 0 2 0 0 0 6 0 6 0 0 0 0 2 8 0 0 0 0 4 1 9 0 0 5 0 0 0 0 8 0 0 7 9

index: 		.word 0
row: 		.word 0
column: 		.word 0
userInput: 	.word 0
dash: 		.asciiz "| "
dashLine: 	.asciiz "-------------------------"
space: 		.asciiz " "
tempNum: 	.word 0
newLine:		.asciiz "\n"
rowPrompt:	.asciiz "Enter the row (1-9) of the number you would like to change: "
columnPrompt: 	.asciiz "Enter the column (1-9) of the number you would like to change (enter -1 to go back): "
invalid: 	.asciiz "Invalid input! "
alreadyFilled: 	.asciiz "This option is already completed. \n"
changeVal:	.asciiz "What would you like the value to be (enter -1 to go back)? "
newVal: 		.word 0
incorrectPrompt:	.asciiz "This is not the correct value. \n"
completePrompt: 	.asciiz "This puzzle is complete. \n"
resultPrompt: 	.asciiz "Number of incorrect answers: "
easyHardPrompt:	.asciiz "Enter 0 for the easy version or 1 for the hard version: "
anotherGame: 	.asciiz "Would you like to play another game? \nEnter 1 for yes and 0 for no: "
exitPrompt: 	.asciiz "Enter -9 at anytime to exit the program. \n"
exitKey: 	.word	-9 
cantChange: 	.asciiz "You can not change this value. \n"

.text
lw $s7, exitKey
#tells the user how to exit
li $v0, 4
la $a0, exitPrompt
syscall
#questions the user whether to play the easy or hard version
easyHard: 
	li $t0, 0
	li $t1, 1
	
	#prints the prompt for game version
	li $v0, 4
	la $a0, easyHardPrompt
	syscall
	
	#reads and stores the user game preference
	li $v0, 5
	syscall
	move $t3, $v0
	
	#jumps depending on easy or hard version or if the input is invalid 
	beq $t3, $t0, easyStart
	beq $t3, $t1, hardStart
	beq $t3, $s7, exitProgram #if the user enters the exit key 
	j invalInput
invalInput:

	#prints invalid message to user and allows them to try again
	li $v0, 4
	la $a0, invalid
	syscall
	j easyHard

#####################################################################################
#This verion of the game is played where each number the user enters is checked     #
#immediatley after it is entered. The user is informed when the puzzle is completed.# 
#####################################################################################
easyStart:
	la $s0, puzzle1
	li $t0, 0 #counter
	li $t1, 80 #upper limit

#this section loops through the array checking if there are any places that have not been filled
checkComplete:
	lb $t3, ($s0)
	beq $t3, $zero, notComplete
	bge $t0, $t1, completePuzzle
	addi $s0, $s0, 1
	addi $t0, $t0, 1
	j checkComplete

notComplete:
	la $s0, puzzle1
	li $t0, 80 #upper limit
	li $t1, 0  #counter
	li $t2, 3 #when a | is needed
	li $t4, 27 #when a line of - is needed
	li $s1, 9 #when a new line is needed

	#dashed line to start the puzzle
	li $v0, 4
	la $a0, dashLine
	syscall

	#prints a new line
	li $v0, 4
	la $a0, newLine
	syscall

	#prints a |
	li $v0, 4
	la $a0, dash
	syscall

#goes through the array and prtint the elements along with aesthetics
loop:
	#checks if the index is divisible by 9 if it is it prints a new line
	div $t1, $s1
	mfhi $s2
	bne $s2, $zero, afterNewLine
	beq $t1, $zero, printNum
	
	#prints |
	li $v0, 4
	la $a0, dash
	syscall
	
	#prints new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#checks if needs a line of '-''s meaning divisible by 27
	div $t1, $t4
	mfhi $t6
	bne $t6, $zero, afterNewLine
	
	#prints line of -
	li $v0, 4
	la $a0, dashLine
	syscall
	
	#print new line
	li $v0, 4
	la $a0, newLine
	syscall
	j afterNewLine

#this section checks if the number is divisible by 3 and if it is a | is printed 
afterNewLine: 
	bgt $t1, $t0, inputRowCol #makes sure the index is not past the bounds of the array
	
	#checks if divisible by 3
	div $t1, $t2
	mfhi $t3
	bne $t3, $zero, printNum
	
	#prints |
	li $v0, 4
	la $a0, dash
	syscall
	j printNum

#this section prints the element followed by a space and adds one to the counter
printNum:
	lb $t7, ($s0)
	
	#prints element
	li $v0, 1
	move $a0, $t7
	syscall
	
	#prints space
	li $v0, 4
	la $a0, space
	syscall
	
	#adds to counter
	addi $s0, $s0, 1
	addi $t1, $t1, 1
	j loop

#this section sets some comparison values to registers
inputRowCol:
	li $t0, 9
	li $t1, 1
	li $t7, -1 #exit value
readRow:	
	#asks the user for the row number
	li $v0, 4
	la $a0, rowPrompt
	syscall
	
	#reads and stores the row number
	li $v0, 5
	syscall
	sw $v0, row
	
	#validates row number
	lw $t3, row
	beq $t3, $s7, exitProgram #if the user enters the exit key
	bgt $t3, $t0, invalidRow
	blt $t3, $t1, invalidRow 
	j readColumn

#this section is used if the user inputs an invalid row number
invalidRow: 
	#prints invalid message to user and jumps back to the beginning of input of row
	li $v0, 4
	la $a0, invalid
	syscall
	j readRow

#this section reads and validated column number
readColumn:
	#asks the users to enter row number
	li $v0, 4
	la $a0, columnPrompt
	syscall
	
	#reads and stores the column number
	li $v0, 5
	syscall
	sw $v0, column
	
	#validates row number
	lw $t3, column
	beq $t3, $s7, exitProgram #if the user enters the exit key 
	beq $t7, $t3, readRow
	bgt $t3, $t0, invalidColumn
	blt $t3, $t1, invalidColumn
	j afterRead

#this section is used if the user inputs an invalid row number
invalidColumn: 
	#prints invalid message to user and jumps to start of the column input
	li $v0, 4
	la $a0, invalid
	syscall
	j readColumn

#this section calculates the index in the array the user entered and checks if it has been filled already
afterRead:
	#((row-1) * 9) + column - 1
	lw $t0, row
	lw $t1, column
	li $t4, 9
	subi $t0, $t0, 1
	mul $t3, $t0, $t4
	add $t3, $t3, $t1
	subi $t3, $t3, 1
	sw $t3, index

	#gets the array element and stores in $t0
	la $s0, puzzle1
	add $s0, $t3, $s0
	lb $t0, ($s0)

	#if element is 0 jumos to allow the user to input the value they want in that place
	#else tells the user its full and allows another input
	beq $t0, $zero, validInput
	
	#tells user input is already filled and goes back to the beginning of the inputs
	li $v0, 4
	la $a0, alreadyFilled
	syscall
	j inputRowCol

#this section gathers the value the user wants in the index they requested and validates
validInput:
	#prompts user to input intended value
	li $v0, 4
	la $a0, changeVal
	syscall
	
	#reads and stores input value
	li $v0, 5
	syscall
	move $t1, $v0

	#compares solution to the input answer and tells the user if invalid and checks if exit number was entered
	la $s1, puzzle1Sol
	add $s1, $s1, $t3
	lb $t4, ($s1)
	beq $t1, $s7, exitProgram #if the user enters the exit key
	beq $t7, $t1, inputRowCol
	beq $t4, $t1, correctVal
	 
	
	#tells the user input was incorrect
	li $v0, 4
	la $a0, incorrectPrompt
	syscall
	j validInput
#stores the value into the puzzle and goes back to the top to reprint 
correctVal:
	sb $t1, ($s0)
	j easyStart
completePuzzle:
	#tells the user the puzzle is complete
	li $v0, 4
	la $a0, completePrompt
	syscall
	j playAnother


################################################################################
#This verion of the game is played where all of the answers are entered and not#
#validated. The answers are checked when all spaces are filled. The number of  # 
#incorrect answers is displayed for the user upon conclusion of the puzzle.    # 
################################################################################
hardStart:
	la $s0, puzzle2
	li $t0, 0 #counter
	li $t1, 80 #upper limit

#this section loops through the array checking if there are any places that have not been filled
checkComplete2:
	lb $t3, ($s0)
	beq $t3, $zero, notComplete2
	bge $t0, $t1, checkAnswers
	addi $s0, $s0, 1
	addi $t0, $t0, 1
	j checkComplete2

notComplete2:
	la $s0, puzzle2
	li $t0, 80 #upper limit
	li $t1, 0  #counter
	li $t2, 3 #when a | is needed
	li $t4, 27 #when a line of - is needed
	li $s1, 9 #when a new line is needed

	#dashed line to start the puzzle
	li $v0, 4
	la $a0, dashLine
	syscall

	#prints a new line
	li $v0, 4
	la $a0, newLine
	syscall

	#prints a |
	li $v0, 4
	la $a0, dash
	syscall

#goes through the array and prtint the elements along with aesthetics
loop2:
	#checks if the index is divisible by 9 if it is it prints a new line
	div $t1, $s1
	mfhi $s2
	bne $s2, $zero, afterNewLine2
	beq $t1, $zero, printNum2
	
	#prints |
	li $v0, 4
	la $a0, dash
	syscall
	
	#prints new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#checks if needs a line of '-''s meaning divisible by 27
	div $t1, $t4
	mfhi $t6
	bne $t6, $zero, afterNewLine2
	
	#prints line of -
	li $v0, 4
	la $a0, dashLine
	syscall
	
	#print new line
	li $v0, 4
	la $a0, newLine
	syscall
	j afterNewLine2

#this section checks if the number is divisible by 3 and if it is a | is printed 
afterNewLine2: 
	bgt $t1, $t0, inputRowCol2 #makes sure the index is not past the bounds of the array
	
	#checks if divisible by 3
	div $t1, $t2
	mfhi $t3
	bne $t3, $zero, printNum2
	
	#prints |
	li $v0, 4
	la $a0, dash
	syscall
	j printNum2

#this section prints the element followed by a space and adds one to the counter
printNum2:
	lb $t7, ($s0)
	
	#prints element
	li $v0, 1
	move $a0, $t7
	syscall
	
	#prints space
	li $v0, 4
	la $a0, space
	syscall
	
	#adds to counter
	addi $s0, $s0, 1
	addi $t1, $t1, 1
	j loop2

#this section sets some comparison values to registers
inputRowCol2:
	li $t0, 9
	li $t1, 1
	li $t7, -1 #exit value
readRow2:	
	#asks the user for the row number
	li $v0, 4
	la $a0, rowPrompt
	syscall
	
	#reads and stores the row number
	li $v0, 5
	syscall
	sw $v0, row
	
	#validates row number
	lw $t3, row
	beq $t3, $s7, exitProgram #if the user enters the exit key 
	bgt $t3, $t0, invalidRow2
	blt $t3, $t1, invalidRow2
	j readColumn2

#this section is used if the user inputs an invalid row number
invalidRow2: 
	#prints invalid message to user and jumps back to the beginning of input of row
	li $v0, 4
	la $a0, invalid
	syscall
	j readRow2

#this section reads and validated column number
readColumn2:
	#asks the users to enter row number
	li $v0, 4
	la $a0, columnPrompt
	syscall
	
	#reads and stores the column number
	li $v0, 5
	syscall
	sw $v0, column
	
	#validates row number
	lw $t3, column
	beq $t3, $s7, exitProgram #if the user enters the exit key
	beq $t7, $t3, readRow2
	bgt $t3, $t0, invalidColumn2
	blt $t3, $t1, invalidColumn2 
	j afterRead2

#this section is used if the user inputs an invalid row number
invalidColumn2: 
	#prints invalid message to user and jumps to start of the column input
	li $v0, 4
	la $a0, invalid
	syscall
	j readColumn2

#this section calculates the index in the array the user entered and checks if it has been filled already
afterRead2:
	#((row-1) * 9) + column - 1
	lw $t0, row
	lw $t1, column
	li $t4, 9
	subi $t0, $t0, 1
	mul $t3, $t0, $t4
	add $t3, $t3, $t1
	subi $t3, $t3, 1
	sw $t3, index

	#gets the array element and stores in $t0
	la $s0, puzzle2
	add $s0, $t3, $s0
	la $s5, puzzle2Master
	add $s5, $s5, $t3
	lb $t0, ($s5)

	#if element is 0 jumos to allow the user to input the value they want in that place
	#else tells the user its full and allows another input
	beq $t0, $zero, storeInput2
	
	#tells user input is already filled and goes back to the beginning of the inputs
	li $v0, 4
	la $a0, cantChange
	syscall
	j inputRowCol2

#this section gathers the value the user wants in the index they requested and validates
storeInput2:
	#prompts user to input intended value
	li $v0, 4
	la $a0, changeVal
	syscall
	
	#reads and stores input value
	li $v0, 5
	syscall
	move $t1, $v0

	#stores the anwser entered or goes back to inputing row and column if -1 is entered
	beq $t1, $s7, exitProgram #if the user enters the exit key
	beq $t7, $t1, inputRowCol2 
	sb $t1, ($s0)
	j hardStart

#checks the answers of the puzzle
checkAnswers: 
	la $s0, puzzle2
	la $s1, puzzle2Sol
	li $t3, 0 #number of wrong answers count
	li $t4, 0 #counter
	li $t5, 80
	#checks the first elements
	lb $t0, ($s0)
	lb $t1, ($s1)
	bne $t0, $t1, wrong
checkloop:
	#checks the index and validity of the answers 
	bge $t4, $t5, results
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	lb $t0, ($s0)
	lb $t1, ($s1)
	bne $t0, $t1, wrong
	addi $t4, $t4, 1 
	j checkloop
#counts the number of incorrect answers
wrong: 
	addi $t4, $t4, 1
	addi $t3, $t3, 1
	j checkloop
#prints the results of the game
results:
	#prints a prompt to the number of wrong answers
	li $v0, 4
	la $a0, resultPrompt
	syscall
	#prints the number of wrong answers
	li $v0, 1
	move $a0, $t3
	syscall
	#prints a new line
	li $v0, 4
	la $a0, newLine
	syscall
	j playAnother
	
#asks the user if they want to play another game
playAnother:
	li $t0, 0
	li $t1, 1
	
	#prints the prompt to the user asking if they want to play another
	li $v0, 4
	la $a0, anotherGame
	syscall
	
	#reads and stores the users choice
	li $v0, 5
	syscall 
	move $t3, $v0
	
	#exits if 0, goes to beginning if 1, and if invalid allows user to try again
	beq $t3, $s7, exitProgram #if the user enters the exit key 
	beq $t3, $t0, exitProgram
	beq $t3, $t1, easyHard
	j notValid

#if invalid tells the user and sends them to input prompt again
notValid:
	li $v0, 4
	la $a0, invalid
	syscall 
	j playAnother


exitProgram:	
	#exits the program safely 
	li $v0, 10
	syscall
