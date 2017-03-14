import java.util.scanner; // Needed for the scanner class


/*
This program demonstrates a user controlled loop
*/

public class Population
{
	public static void main(String[] args)
	{
		int Size, 
		Days, 
		increase, 
		number, 
		Temp;
		String input; // To Hold the user's input 

		//Create a Scanner object for keyboard input.
		Scanner Keyboard = new scanner(System.in);


		int startingSize = 0, dailyIncrease = 0, numberOfDays = 0;
		int temp = 0;


		//accept initial user input here

		while (startingSize < 2)
		{
			System.out.print("Please enter a number that is greater than 1 for the population size: ");
			startingSize = keyboardInput.nextInt(System.in);
		}

		while (dailyIncrease < 0)
		{
			System.out.print("Enter a positive integer for the population size increase: ");
			dailyIncrease = keyboardInput.nextInt(System.in);
		}

		//do the same while loop for numberOfDays as a positive number > 0


		temp = startingSize;
		dailyIncrease = dailyIncrease + 1;

		for(int i = 0; i < numberOfDays; i++)
		{
			System.out.println("Day " + i);
			System.out.println("Number " + temp);
			temp = temp * dailyIncrease;
		}
	}
}