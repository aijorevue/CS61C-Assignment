.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    addi t0,a0,0

    addi t2,x0,1
loop_start:

    beq t0,x0,loop_end

    mul t2,t2,t0
    addi t0,t0,-1

    j loop_start

loop_end:
    add a0,t2,x0    
    jr ra