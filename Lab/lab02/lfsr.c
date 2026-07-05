#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

unsigned get_bit(unsigned x,unsigned n){
    return ((1<<n)&x)>>n;
}
void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    //我首先想构造一个函数，提取原来的5，3，2，1中的位。
    unsigned bit0=get_bit(*reg,0);
    unsigned bit1=get_bit(*reg,2);
    unsigned bit2=get_bit(*reg,3);
    unsigned bit3=get_bit(*reg,5);
    unsigned bit15=bit0^bit1^bit2^bit3;
    *reg=*reg>>1;
    *reg=*reg|(bit15<<15);
}

