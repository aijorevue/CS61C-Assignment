.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0,1
    bgt t0,a2,error0
    bgt t0,a3,error1
    bgt t0,a4,error1
    # Prologue
    mv t1,zero
    li t2,0
    mv t0,zero
loop_start:
    bge t2,a2,loop_end 
    lw t3,0(a0)
    lw t4,0(a1)
    li t6,4
loop_continue:
    mul t5,t3,t4
    add t0,t0,t5

    mul t5,a3,t6
    add a0,a0,t5
    mul t5,a4,t6
    add a1,a1,t5
    addi t2,t2,1
    j loop_start
loop_end:


    # Epilogue
    mv a0,t0
    ret

error0:
    li a0,75
    j exit2

error1:
    li a0,76
    j exit2