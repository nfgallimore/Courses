import java.util.Arrays;
import java.math.BigInteger;


public class Prime
{
	private static final int KEY_LENGTH = 100;
	private static final int KEY_SPACE = 256;
	public static void main(String[] args)
	{
		if (args[1] == "-g")
		{
			PrimeGen p = new PrimeGen();
			System.out.println(p.getPrime());
		}
		if (args[1] == "-t") 
		{
			String s = args[2];
			test(s);
		}
	}
	public static boolean test(String s)
	{
		PrimeGen p = new PrimeGen();
		BigInteger b = new BigInteger(String.valueOf(s));
		return p.testPrime(b);

	}


}