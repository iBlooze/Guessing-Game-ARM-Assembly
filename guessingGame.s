	.arch armv7-a
	.fpu vfpv3-d16
	.syntax unified
    
	.section	.rodata
	.align	2

promptMsg: 
	.asciz 	"guess a number between 1-20 "

scanfPattern:
	.asciz 	"%d"

lowerMsg: 
	.asciz 	"your guess is too low, you have %d guesses left\n"

higherMsg: 
	.asciz 	"your guess is too high, you have %d guesses left\n"

correctMsg: 
	.asciz 	"congrats! you got the right answer! random = %d\n"

zeroMovesMsg: 
	.asciz 	"try again, you ran out of moves :(\n"

	.text
	.global main
	.type	main, %function

	@playersGuess = r4
	@randomNumber = r5
	@guessesLeft = r6

main:
    push    {r4-r6, fp, lr}      	@ save a bunch of registers
    add     fp, sp, 16      		@ link into frame pointer chain
    sub     sp, sp, 24      		@ allocate space for locals

	mov 	r6, #5
	bl		getRandom				@ call the getRandom function
	mov		r5, r0					@ save return value to r5

	bl		loop

loop:
    ldr 	r0, addrPromptMsg	 	@ r0 <- addresss of prompt message
    bl 		printf				 	@ call printf

	sub 	r1, fp, #8			 	@ r1 <- address of local variable
    ldr 	r0, addrScanfPattern 	@ r0 <- address of scan pattern
    bl 		scanf                	@ call scanf
	ldr 	r4, [fp, #-8]		 	@ r1 <- value at address of local variable

	sub 	r6, #1
	cmp 	r6, #0				 
	beq 	outOfMoves				@ if equal branch to outOfMoves

	cmp 	r4, r5				 	@ compare playersGuess to randomNumber
	beq 	correct				 	@ if equal branch to correct
	cmp 	r4, r5
	bgt		higher				 	@ if greater than branch to higher
	cmp 	r4, r5
	blt		lower				 	@ if less than branch to lower

lower:
	mov		r1, r6
    ldr 	r0, lowerMsgAddr	 	@ r0 ← address of result message
    bl 		printf            	 	@ call printf
	bl 		loop				 	@ return to our loop

higher:
	mov		r1, r6
    ldr 	r0, higherMsgAddr    	@ r0 ← address of result message
    bl 		printf               	@ call printf
	bl 		loop				 	@ return to our loop

correct:
	mov 	r1, r5
    ldr 	r0, correctMsgAddr	 	@ r0 ← address of result message
    bl 		printf               	@ call printf
    b		epilogue

outOfMoves:  
    ldr 	r0, zeroMovesMsgAddr	@ r0 ← address of result message
    bl 		printf              	@ call printf
    b		epilogue

epilogue:
   	add     sp, sp, 24        		@ free locals and outbound stack parameters
    pop     {r4-r6,fp,pc}     	 	@ restore registers and return
    bx		lr			 		 	@ return

addrPromptMsg: 
	.word promptMsg

addrScanfPattern:
	.word scanfPattern

lowerMsgAddr: 
	.word lowerMsg

higherMsgAddr: 
	.word higherMsg

correctMsgAddr: 
	.word correctMsg

zeroMovesMsgAddr: 
	.word zeroMovesMsg
