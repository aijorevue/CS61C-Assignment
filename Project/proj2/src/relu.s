.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
#int[] relu(int[] a){
#    int count=0;
#    for(i:a){
#        if(i<0){
#            a[count]=0;
#            count++;
#        }
#        else{
#            count++;
#            continue;
#        }
#    }
#}
relu:
    # Prologue
    mv t1,a0 #true_a0->&a0
    li t0,0

    li t3,1
    blt a1,t3,error



loop_start:
    bge t0,a1,loop_end
    lw t2,0(t1)
    blt t2,zero,set_zero  #temp_a<0
    j loop_continue
    set_zero:
        sw zero,0(t1) 
loop_continue:

   
    addi t0,t0,1
    addi t1,t1,4
    j loop_start
loop_end:


    # Epilogue

    
	ret

error:
    li a0,78
    j exit2