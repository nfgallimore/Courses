#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "lib/cs50.h"

int main(int argc, char* argv[])
{
	/*
	double slope_1 = strtod(argv[1], NULL);
	double slope_2 = strtod(argv[3], NULL);
	double coeffic_1 = strtod(argv[2], NULL);
	double coeffic_2 = strtod(argv[4], NULL);
	*/
	printf("\nFirst function");
	printf("\nm: ");
	double slope_1 = GetDouble();

	printf("b: ");
	double coeffic_1 = GetDouble();

	printf("\nSecond Function");
	printf("\nm: ");
	double slope_2 = GetDouble();

	printf("b: ");
	double coeffic_2 = GetDouble();

	double result = 0;
	if (coeffic_1 > coeffic_2)
	{
		coeffic_2 -= coeffic_1;
		slope_2 -= slope_1;
		result = coeffic_1 / slope_2;
	}
	else
	{
		coeffic_1 -= coeffic_2;
		slope_1 -= slope_2;
		result = coeffic_1 / slope_1;
	}
	printf("\n%lf\n", result);
}
