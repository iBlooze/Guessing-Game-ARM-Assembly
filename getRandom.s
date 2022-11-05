	.arch armv7-a
	.fpu vfpv3-d16
	.syntax unified

	.text
	.align	2

	.global	getRandom
	.type	getRandom, %function
getRandom:
	push	{fp, lr}
	add		fp, sp, #4
	sub		sp, sp, #8
	sub		r3, fp, #8
	mov		r0, r3
	bl		time
	mov		r3, r0
	mov		r0, r3
	bl		srand
	bl		rand
	mov		r2, r0
	movw	r3, #26215
	movt	r3, 26214
	smull	r1, r3, r3, r2
	asr		r1, r3, #3
	asr		r3, r2, #31
	sub		r3, r1, r3
	mov		r1, #20
	mul		r3, r1, r3
	sub		r3, r2, r3
	mov		r0, r3
	sub		sp, fp, #4

	pop		{fp, pc}
	bx      lr
