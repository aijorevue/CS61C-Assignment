/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15

**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE *file = fopen(filename, "r");
	if(file == NULL) {
		fprintf(stderr, "Error opening file %s\n", filename);
		return NULL;
	}
	Image *ima = malloc(sizeof(Image));
	if(ima == NULL) {
		fprintf(stderr, "Error allocating memory for image\n");	
	}
	char version[3];
	int maxColor;
	fscanf(file, "%s", version);

	fscanf(file, "%u %u", &ima->cols, &ima->rows);

	fscanf(file,"%d",&maxColor);
	ima->image=malloc(ima->rows*ima->cols*sizeof(Color*));
	for(int i=0;i<ima->rows*ima->cols;i++) {
		ima->image[i]=malloc(sizeof(Color));
		
		fscanf(file, "%hhu %hhu %hhu", &ima->image[i]->R, &ima->image[i]->G, &ima->image[i]->B);
	}

	fclose(file);
	return ima;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n");
	printf("%u %u\n", image->cols, image->rows);
	printf("255\n");
	for(int i=0;i<image->rows;i++){
		for(int j=0;j<image->cols;j++){
			printf("%3hhu %3hhu %3hhu", image->image[i*image->cols+j]->R, image->image[i*image->cols+j]->G, image->image[i*image->cols+j]->B);
			if(j==image->cols-1) {
				continue;
			}
			printf("   ");
		}
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	for(int i=0;i<image->rows*image->cols;i++) {
		free(image->image[i]);
	}
	free(image->image);
	free(image);
}