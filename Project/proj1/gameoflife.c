/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.

// 统计某个像素周围 8 个邻居，在特定的第 bit 位上，有多少个是 1
int countLiveNeighbors(Image *image, int row, int col, int bit, char channel) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            if (i == 0 && j == 0) continue; // 跳过自己
            
            // 环绕逻辑
            int nR = (row + i + image->rows) % image->rows;
            int nC = (col + j + image->cols) % image->cols;
            
            uint8_t val;
            Color *neighbor = image->image[nR * image->cols + nC];
            
            // 根据要检查的通道取值
            if (channel == 'R') val = neighbor->R;
            else if (channel == 'G') val = neighbor->G;
            else val = neighbor->B;
            
            // 【关键修改】：只看这一位是否为 1
            if ((val >> bit) & 1) {
                count++;
            }
        }
    }
    return count;
}

// 计算一个 8 位通道（比如 R）演化后的新值
uint8_t evaluateChannel(Image *image, int row, int col, uint32_t rule, char channel) {
    uint8_t currentVal;
    if (channel == 'R') currentVal = image->image[row * image->cols + col]->R;
    else if (channel == 'G') currentVal = image->image[row * image->cols + col]->G;
    else currentVal = image->image[row * image->cols + col]->B;

    uint8_t newVal = 0;
    // 对 8 个位分别计算
    for (int b = 0; b < 8; b++) {
        int neighbors = countLiveNeighbors(image, row, col, b, channel);
        int alive = (currentVal >> b) & 1;
        
        // 规则查询：如果是活的看 9+n 位，死的看 n 位
        int bit_to_check = alive ? (9 + neighbors) : neighbors;
        int next_state = (rule >> bit_to_check) & 1;
        
        if (next_state) {
            newVal |= (1 << b); // 把这一位置为 1
        }
    }
    return newVal;
}

Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
    Color *newColor = malloc(sizeof(Color));
    if (!newColor) return NULL;

    // 分别计算三个通道
    newColor->R = evaluateChannel(image, row, col, rule, 'R');
    newColor->G = evaluateChannel(image, row, col, rule, 'G');
    newColor->B = evaluateChannel(image, row, col, rule, 'B');

    return newColor;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	Image *newImage = malloc(sizeof(Image));
	if (!newImage) return NULL;
	newImage->cols = image->cols;
	newImage->rows = image->rows;
	newImage->image = malloc(newImage->rows * newImage->cols * sizeof(Color*));
	for(uint32_t i = 0; i < newImage->rows; i++) {
		for(uint32_t j = 0; j < newImage->cols; j++) {
			newImage->image[i * newImage->cols + j] = evaluateOneCell(image, i, j, rule);
		}
	}
	return newImage;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if(argc!=3) {
		fprintf(stderr, "Usage: %s <filename> <rule>\n", argv[0]);
		exit(-1);
	}
	uint32_t rule = strtol(argv[2], NULL, 16);
	Image *original=readData(argv[1]);
	Image *newImage=life(original, rule);
	writeData(newImage);
	freeImage(original);
	freeImage(newImage);
	return 0;
}
