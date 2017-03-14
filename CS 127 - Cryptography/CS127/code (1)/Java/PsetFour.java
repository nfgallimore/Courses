/* 	Let N = 453504209. Write a program to extract a square root of 105592908 in Z*_N using brute-force search. 
	How long does it take to find the square root? (You might need to run your program multiple times and take an average.)
*/
import java.util.*;
import java.math.*;
import java.util.ArrayList;
import java.util.Arrays;

public class PsetFour
{
	private static final int N = 453504209;	
	private static final int N_ele = 105592908;	
	public static void main(String[] args)
	{
		System.out.println(euler_Totient(N, N_ele) + "\n" );		
	}
	public static int euler_Totient(int n, int m)
	{
		int tot = m;
		for (int p = 2; p * p < N_ele; p++) 
		{
			if (n % p == 0 || m % p == 0) 
			{
				tot /= p;
				tot *= (p - 1);
				while (n % p == 0 || m % p == 0) { n /= p; m /= p; }
			}
		}
		if (m > 1 ||) {
			tot /= m;
			tot *= (m - 1);
		}
		return tot;
	}
}