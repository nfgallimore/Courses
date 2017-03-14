import java.util.*;

public class Problem1a
{
	public static  void main(String[] args)
	{
		/***************************************************************************************************

		int n = 453504209;
		int y = 105592908;
		int count = 0;

		for (int x = 1; x < n; x++)
		{
			if (sqRoot(x, y) && element(x, n)) 
			{
				System.out.println(x);
				count++;
			}
		}
		System.out.println("_________________________________________________________________\n\n" +
			               "Total elements in set of integers relatively prime to N: " + eulerPhi(n));

		System.out.println("First square found: " + extractSquares(n, y));
		System.out.println("Number of squares found: " + count + "\n");

		*//////////////////////////////////////////////////////////////////////////////////////////////////
		int n = 453504209;
		int p = 105592908;

		int count = 0;

		int length = eulerPhi(n);

		final long startTime = System.currentTimeMillis();
		
		for (int x = 0; x < length / 4; x++)
		{
			if (extractSquares(x, p, n)) { System.out.println(x); count++; }
		}
		
		final long endTime = System.currentTimeMillis();

		System.out.println("Total execution time: " + (endTime - startTime) );

		System.out.println(eulerPhi(n));
	
	}
	public static boolean extractSquares(int x, int p, int n)
	{
		return ((element(x, n)) && sqRoot(x, p, n));
	}
	public static boolean sqRoot(int x, int p, int n)
	{
		return (x * x % n) == p;
	}
	public static boolean element(int x, int n)
	{
		return (gcd(x, n) == 1);
	}
	public static int gcd(int x, int n)
	{
		while (x != 0)
		{
			int r = n % x;
			n = x;
			x = r;
		}
		return n;
	}
	public static int eulerPhi(int n)
	{
		int totient = n;
		for (int i = 2; i * i < n; i++) 
		{
			if (n % i == 0)
			{
				totient /= i;
				totient *= (i - 1);
				while (n % i == 0) n /= i;
			}
		}
		if (n > 1) 
		{
			totient /= n;
			totient *= (n - 1);
		}
		return totient;
	}
}