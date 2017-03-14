public class DiffApprox
{
	public static void main(String[] args)
	{
		double x = 3.0;
		double newX = 3.0003;
		double f = -1;
		double fPrime = 2;
		double g = 8;
		double gPrime = -9;

		double deltaX = newX - x;
		
		double methodOne = method1(x, deltaX, f, fPrime, g, gPrime);
		double methodTwo = method2(x, deltaX, f, fPrime, g, gPrime);

		System.out.println(methodOne);
		System.out.println(methodTwo);

	}
	public static double method1(double x, double deltaX, double f, double fPrime, double g, double gPrime)
	{
		return (fPrime * deltaX + f) * (gPrime * deltaX + g);
	}
	public static double method2(double x, double deltaX, double f, double fPrime, double g, double gPrime)
	{
		return f * g + (f * gPrime + fPrime * g) * deltaX);
	}
}