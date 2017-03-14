import java.util.*;

public class ShiftCipher
{
  public static void main(String[] args)
  {
    String c = "OVDTHUFWVZZPISLRLFZHYLAOLYL";
    String c2 = "JGRMQOYGHMVBJWRWQFPWHGFFDQGFPFZRKBEEBJIZQQOCIBZKLFAFGQVFZFWWEOGWOPFGFHWOLPHLRLOLFDMFGQWBLWBWQOLKFWBYLBLYLFSFLJGRMQBOLWJVFPFWQVHQWFFPQOQVFPQDCFPOGFWFJIGFQVHLHLROQVFGWJVFPFOLFHGQVQVFILEOGQILHQFQGIQVVOSFAFGBWVQHQWIJVWJVFPFWHGFIWIHZZRQGBABHZQOCGFHX";
    int[] freq = new int[26];
    


    for (int i = 0; i < c2.length(); i++) 
    {
      if (c2.charAt(i) == 'F') 
        System.out.print('E');
      else if (c2.charAt(i) == 'Q') 
        System.out.print('T');
      else if (c2.charAt(i) == 'W')
        System.out.print('L');
      else if (c2.charAt(i) == 'G')
        System.out.print('A');
      else if (c2.charAt(i) == 'L')
        System.out.print('S');
      else if (c2.charAt(i) == 'O')
        System.out.print('N');
      else if (c2.charAt(i) == 'V')
        System.out.print('H');
      else if (c2.charAt(i) == 'H')
        System.out.print('R');
      else if (c2.charAt(i) == 'P')
        System.out.print('O');
      else System.out.print(c2.charAt(i)); 
    }
    System.out.println();
    for (int i = 0; i < 26; i++) 
    {
      int ch = 'A' +i;
      freq[i] = letterFrequency(c2, (char) ch);
      System.out.print((char)ch + "   ");
      if (freq[i] < 10) System.out.printf(" ");
      System.out.printf(" %.2d", (double)freq[i] / 244.0);
    }    
  /*public static int [][]sumUp(int [] array)
  {
    for (int i = 0; i < array.length; i++)
      sumUp[0][i] = i;
    for (int i = 0; i < array.length; i++)
      if (array[i] > array[i+1]) 
        array[i] = array[i+1];
  } */

  }
  public static int letterFrequency(String s, char c)
  {
    int sum = 0;
    for (int i = 0; i < s.length(); i++)
      if (s.charAt(i) == c) sum++;
    return sum;
  }
  public static String Dec (int k, String c)
  {
    String m = "";
      for (int i = 0; i < c.length(); i++) 
      {
        char tmp = c.charAt(i);
        tmp += k;
        tmp %= 26;
        tmp += 'A';
        m += tmp;
      }
    return m;
  }
}