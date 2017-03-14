import java.util.*;

public class Math73
{
		public static void main(String[] args)
		{
			Scanner kb = new Scanner(System.in);
			System.out.println("                                   What is alpha?");
			double alpha = Math.toRadians(kb.nextDouble());
			System.out.println("                                   What is beta?");
			double beta = Math.toRadians(kb.nextDouble());
			// Test formulas
			double deltax = 0;
			double diffmoved = deltax;

			for (int i = 0; i < 10; i++)
			{
				System.out.println();
			}
			double news = (cos(alpha) * cos(beta) + sin(alpha) * sin(beta));
 			System.out.println("               Cosine(alpha + beta) = " + news);

		 	news = cos(alpha - beta);
 		 	System.out.println("               Cosine Alpha - beta = " + news);


 			news = (sin(alpha) * cos(beta) + cos(alpha) * sin(beta));
 			System.out.println("               Sine(alpha + beta) = " + news);

 		


			// double p = Math.sin(beta) * Math.sin(alpha) - Math.cos(alpha) 
			double p = sin(beta) * (sin(alpha)-cos(alpha) * tan(beta));
			System.out.println("               P is equal to" + p);	
			// cos alpha minus beta
			System.out.println("\n               +++++++++++++++++++++++++++++++++++++++++\n\n              Cosine (" + alpha + " + " + beta + ") is equal to " + CosAlphaMinusBeta(alpha,beta) + "\n\n\n\n\n\n\n");
		}

		// Sum and diff formulas for sine and cosine

		public static double sin(double i)
		{
			return Math.sin(i);
		}
		public static double cos(double i)
		{
			return Math.cos(i);
		}
		public static double cos(double a, double b)
		{
			return Math.cos(a + b);
		}
		public static double tan(double i)
		{
			return Math.tan(i);
		}
		public double tan(double a, double b)
		{
			double one = (sin(a + b)) / cos(a + b);
			double two = ((sin(a) * cos(b)) / ((cos(a) * cos(b))) + ((sin(b) * cos(a)) / cos(a));
			double three = cos(b)) / (cos(a) * cos(b)) - (sin(a) * sin(b)) / ((cos(a) * cos(b));
			return Math.tan(a + b);
		}
	}
}

