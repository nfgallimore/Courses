#include <stdio.h>
#include <cs50.h>
#define SIZE 8

void sort(int array[], int size)
{
    int n = size;
    for (int t = 0; t < n; t++)
    {

        int mid = size / 2;
        int Lleft = t;
        int Lright = n - (mid * t);
        int Rleft = t + (mid * t);
        int Rright = size + (mid * t);
        int j;
        int newarray[j][t];
        
        if (n < 2)
            return; 
        else
        {
            for (int j = 0; j < t; j++)
            {
            int l, r;
            void R(int array[t], int newarray[j]);
            {
                r = R(array[t], newarray[j]);
                if (r > l)
                    return;
                else
                {
                    r = l;
                    l = r;
                }
            }
            void L(int array[t, int newarray[]);
            {
                l = L(array[t], newarray[j]);
                if (l < r)
                    return;
                else
                {
                    l = r;
                    r = l;
                }
            }
                {
                    if (array[Lleft] < array[Lright])                       
                        newarray[j][t]= array[Lleft][t];
                    else
                        newarray[j][t] = array[Lright][t];                                                             
                    {             
                        for (int j = 0; j < t; j++) 
                        {                                                                                  
                            if (arrayRleft] < array[Rright])
                                newarray[j][t] = array[Rleft][t];
                            else
                                newarray[j][t] = array[Rright][t];
                        }
                    }
                                                
                }
            }
        }
    }    
}

int size = SIZE; 
  
int main(void)
{
    /* fills array with random numbers */
    int numbers[SIZE] = { 4, 15, 16, 50, 8, 23, 42, 108 };
    
    /* prints unsorted numbers in starting with leftmost */
    for (int i = 0; i < SIZE; i++)
        printf("%d ", numbers[i]);
    printf("\n");
    
    /* calls sort function */
    sort(numbers, SIZE);
    
    /* prints sorted numbers in order smallest > greatest */
    for (int i = 0; i < SIZE; i++)
        printf("%d ", numbers[i]);
    printf("\n");
    
    
return 0;
}

