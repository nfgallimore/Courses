import java.util.Scanner;

public class Population
{
	public static void main(String args[])
	{
		// 1 infinite loop
		while (true)
		{
			// main menu
			System.out.println("\nPlease select one of the following options:\n"
				+ "1) Future Value\n2) Time Until Future Value\n3) Exit\n");
			Scanner kb = new Scanner(System.in);
			int mode = kb.nextInt();
			while (mode != 1 && mode != 2 && mode != 3) 
			{
				System.out.println("\nThat is not a valid menu option, please retry.");
				System.out.println("\nPlease select one of the following options:\n"
				+ "1) Future Value\n2) Time Until Future Value\n3) Exit\n");
				mode = kb.nextInt();
			}
			if (mode == 3) System.exit(0);

			// gets present value
			System.out.println("\nPlease enter the present value: ");
			double presentVal = kb.nextDouble();
			
			// gets growth rate
			System.out.println("\nPlease enter the growth rate: ");
			double rate = kb.nextDouble();
			
			// determines if growth rate is increasing
			System.out.println("\nIs the growth rate increasing (y/n)? ");
			boolean increase;
			String str = kb.next();
			while (!str.equalsIgnoreCase("y") && !str.equalsIgnoreCase("n"))
			{
				System.out.println("Please enter \"y\" OR \"n\"");
				str = kb.next();
			}
			increase = (str.equalsIgnoreCase("y") ? true : false);


			// actual run of program
			switch (mode)
			{
				case(1):
					System.out.println("\nPlease enter the amount of time given: ");
					double time = kb.nextDouble();
					System.out.println("\nIn order for the future value to reach " + getFuture(presentVal, rate, time, increase) + " it will take " + time  + " units of time.");
					break;
				case(2):
					System.out.println("\nPlease enter the future value: ");
					double futureVal = kb.nextDouble();
					System.out.println("\n" + futureVal + " will occur in " + getTime(futureVal, presentVal, rate, increase) + " units of time.");
					break;
			}	
		}		
	}

	// gets future value
	private static double getFuture(double presentVal, double rate, double time, boolean increase)
	{
		return (increase) 
		? presentVal * Math.pow((1 + rate), time) 
		: presentVal * Math.pow((1 - rate), time);
	}

	// uses logarithms to determine time until future value
	public static double getTime(double futureVal, double presentVal, double rate, boolean increase)
	{
		return (increase)
		? logOfBase(rate + 1, futureVal / presentVal)
		: logOfBase(rate - 1, futureVal / presentVal);
	}

	// computes logartihm of given base and number
	public static double logOfBase(double base, double num)
	{
		return Math.log(num) / Math.log(base);
	}
}