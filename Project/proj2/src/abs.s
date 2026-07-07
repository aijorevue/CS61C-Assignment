.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    # Prologue

    # return 0
    #mv a0, zero
    
    #这是他的初始代码，相当于
    #int abs(int a0){
    #    a0=0;
    #    return a0; 
    #}
    #而如果你想测试他：
    #python3 -m unittest unittests.TestAbs -v

    #
    # Epilogue

    #以下为所给实例代码用来通过test_minus_one
    #branch if positive
    bge a0,zero,done

    #invert a if negative
    sub a0,zero,a0

done:
    ret
