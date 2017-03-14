#include "ztables.c"

double 
print_result(double z_1, double z_2)
{
	double result = (z_1 - z_2) * 100;
	if (result < 0) result = (z_2 + z_1) *100;
	printf("\nThe result is %.2lf percent.\n\n", result); 
	
	return result;
}	


void 
print_zt(double n, double mean, double d1, double d2, double d3)
{
	printf("\n\nPOINT (%.2lf) DISTANCE FROM MEAN (%.2lf) \n", n, mean);
	printf("--------------------------------------------------------\n");
	printf("Z: %.1lf\nArea between the mean and X: %.4lf\nArea beyond X: %.4lf\n\n", d1, d2, d3);
}