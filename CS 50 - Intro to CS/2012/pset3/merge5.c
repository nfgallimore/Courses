#include <stdio.h>
#include <cs50.h>

#define SIZE 8

int size = SIZE;

void merge(int numbers[], int temp[], int left, int mid, int right)
{
  int i, left_end, num_elements, tmp_pos;
 
  left_end = mid - 1;
  tmp_pos = left;
  num_elements = right - left + 1;
 
  while ((left <= left_end) && (mid <= right))
  {
    if (numbers[left] <= numbers[mid])
    {
      temp[tmp_pos] = numbers[left];
      tmp_pos = tmp_pos + 1;
      left = left +1;
    }
    else
    {
      temp[tmp_pos] = numbers[mid];
      tmp_pos = tmp_pos + 1;
      mid = mid + 1;
    }
  }
 
  while (left <= left_end)
  {
    temp[tmp_pos] = numbers[left];
    left = left + 1;
    tmp_pos = tmp_pos + 1;
  }
  while (mid <= right)
  {
    temp[tmp_pos] = numbers[mid];
    mid = mid + 1;
    tmp_pos = tmp_pos + 1;
  }
 
  for (i=0; i <= num_elements; i++)
  {
    numbers[right] = temp[right];
    right = right - 1;
  }
}



void m_sort(int numbers[], int temp[], int left, int right)
{
  int mid;
 
  if (right > left)
  {
    mid = (right + left) / 2;
    m_sort(numbers, temp, left, mid);
    m_sort(numbers, temp, mid+1, right);
 
    merge(numbers, temp, left, mid+1, right);
  }
}

void mergeSort(int numbers[], int temp[], int array_size)
{
   m_sort(numbers, temp, 0, array_size - 1);
}
  
void sort(int numbers[], int size)
{
    for (int i = 0; i < size; i++)
    {
        int temp[SIZE] = { numbers[i] };
        mergeSort(numbers, temp, size);
    }
    
}

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

