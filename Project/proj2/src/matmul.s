.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
#matmul:
#
#    # Error checks
#    addi sp,sp,-4
#    sw ra,0(sp)
#    li t0,1
#    blt a1,t0,error
#    blt a2,t0,error
#
#    blt a4,t0,error1
#    blt a5,t0,error1
#
#    bne a2,a4,error2
#
#    # Prologue
#    mv s0,a0
#    mv s1,a3
#    mv s2,a6
#
#    li t0,0
#
#outer_loop_start:
#
#    bge t0,a1,outer_loop_end
#
#    li t1,0
#
#inner_loop_start:
#
#    bge t1,a5,inner_loop_end
#
#    mul t2,t0,a2
#    slli t2,t2,2
#
#    add a0,s0,t2
#
#
#    slli t3,t1,2
#    
#    add a1,s1,t3
#
#    mv a2,a2
#
#    li a3,1
#
#    mv a4,a5
#
#    jal dot
#
#    sw a0,0(s2)
#    addi s2,s2,4
#    addi t1,t1,1
#    jal inner_loop_start
#inner_loop_end:
#    addi t0,t0,1
#    j outer_loop_start
#
#outer_loop_end:
#    lw ra,0(sp)
#    addi sp,sp,4
#
#    # Epilogue
#    
#    
#    ret
#
#error:
#    li a0,72
#    j exit2
#error1:
#    li a0,73
#    j exit2
#error2:
#    li a0,74
#    j exit2
#
.globl matmul

.text

# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# =======================================================

matmul:

    # =====================
    # Error checks
    # =====================

    li t0,1

    blt a1,t0,error      # m0 rows <=0
    blt a2,t0,error      # m0 cols <=0

    blt a4,t0,error1     # m1 rows <=0
    blt a5,t0,error1     # m1 cols <=0

    bne a2,a4,error2     # m0 cols != m1 rows



    # =====================
    # Prologue
    # =====================

    addi sp,sp,-36

    sw ra,0(sp)

    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
    sw s5,24(sp)
    sw s6,28(sp)
    sw s7,32(sp)


    # 保存参数

    mv s0,a0       # m0 base
    mv s1,a1       # m0 rows
    mv s2,a2       # m0 cols

    mv s3,a3       # m1 base
    mv s4,a5       # m1 cols

    mv s5,a6       # result base


    li s6,0        # i = 0



# =====================
# for(i=0;i<m0_rows;i++)
# =====================

outer_loop_start:

    bge s6,s1,outer_loop_end


    li s7,0        # j = 0



# =====================
# for(j=0;j<m1_cols;j++)
# =====================

inner_loop_start:

    bge s7,s4,inner_loop_end



    # ---------------------
    # A[i][0]
    #
    # address:
    # m0 + i*cols*4
    # ---------------------

    mul t0,s6,s2
    slli t0,t0,2

    add a0,s0,t0



    # ---------------------
    # B[0][j]
    #
    # address:
    # m1 + j*4
    # ---------------------

    slli t1,s7,2

    add a1,s3,t1



    # ---------------------
    # call dot
    #
    # dot(
    #   A row,
    #   B column,
    #   length,
    #   strideA,
    #   strideB
    # )
    # ---------------------

    mv a2,s2        # length = m0 cols

    li a3,1         # A stride

    mv a4,s4        # B stride = m1 cols



    jal dot



    # 保存结果

    sw a0,0(s5)

    addi s5,s5,4



    addi s7,s7,1

    j inner_loop_start



inner_loop_end:


    addi s6,s6,1

    j outer_loop_start



outer_loop_end:


    # =====================
    # Epilogue
    # =====================

    lw ra,0(sp)

    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    lw s5,24(sp)
    lw s6,28(sp)
    lw s7,32(sp)


    addi sp,sp,36

    ret



# =====================
# Errors
# =====================

error:

    li a0,72
    j exit2


error1:

    li a0,73
    j exit2


error2:

    li a0,74
    j exit2