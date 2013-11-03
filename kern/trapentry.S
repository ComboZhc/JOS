/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.data
	.globl trap_handlers
	.align 2
	trap_handlers:

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
/*
 * http://pdos.csail.mit.edu/6.828/2010/readings/i386/s09_10.htm
 */
TRAPHANDLER_NOEC(trhdlr0, T_DIVIDE)
TRAPHANDLER_NOEC(trhdlr1, T_DEBUG)
TRAPHANDLER_NOEC(trhdlr2, T_NMI)
TRAPHANDLER_NOEC(trhdlr3, T_BRKPT)
TRAPHANDLER_NOEC(trhdlr4, T_OFLOW)
TRAPHANDLER_NOEC(trhdlr5, T_BOUND)
TRAPHANDLER_NOEC(trhdlr6, T_ILLOP)
TRAPHANDLER_NOEC(trhdlr7, T_DEVICE)
TRAPHANDLER(trhdlr8, T_DBLFLT)
TRAPHANDLER_NOEC(trhdlr9, -1)
TRAPHANDLER(trhdlr10, T_TSS)
TRAPHANDLER(trhdlr11, T_SEGNP)
TRAPHANDLER(trhdlr12, T_STACK)
TRAPHANDLER(trhdlr13, T_GPFLT)
TRAPHANDLER(trhdlr14, T_PGFLT)
TRAPHANDLER(trhdlr15, -1)
TRAPHANDLER_NOEC(trhdlr16, T_FPERR)
TRAPHANDLER(trhdlr17, T_ALIGN)
TRAPHANDLER_NOEC(trhdlr18, T_MCHK)
TRAPHANDLER_NOEC(trhdlr19, T_SIMDERR)

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushw $0x0
	pushw %ds
	pushw $0x0
	pushw %es
	pushal

	movw GD_KD, %ax
	movw %ax, %ds
	movw %ax, %es

	pushl %esp
	call trap
