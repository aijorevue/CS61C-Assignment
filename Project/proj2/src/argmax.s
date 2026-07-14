.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
#[argmax](https://en.wikipedia.org/wiki/Arg_max)
#
argmax:

    # Prologue
    li t0 1
    blt a1,t0,error
    ###### 

    mv t1,a0                                                #int[] t1=int[] a0;
    mv t2,a1                                                #t2=a0.length();
    li t3,0#                                     t3=0;
    lw t4,0(t1)#           t4=a[0]

    li t5,0#                          t5=0
   
loop_start:
    bge t3,t2,loop_end
    lw t6,0(t1)
    bge t4,t6,loop_continue 

    mv t4,t6 
    mv t5,t3 

loop_continue:
    addi t3,t3,1
    addi t1,t1,4
    j loop_start

loop_end:
    mv a0,t5

    # Epilogue


    ret


error:
    li a0,77
    j exit2
