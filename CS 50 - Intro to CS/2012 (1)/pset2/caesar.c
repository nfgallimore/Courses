#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, string argv[])
{
    // needs cmd line argument for key //
    if (argc != 2)
    {
       printf("You forgot the key!\n");
       return 1;
    }

    // key is never negative //
    int key = atoi(argv[1]);   
    if (key <= 0)
    {
       printf("Key cannot be negative!\n");
       return 1;
    }
    // asks user for message //
    printf("\nPlease enter your secret message:\n");
    string s = GetString();

    for (int i = 0; i < strlen(s) ; i++)
    {      
    
        //space
        if(s[i] == ' ')
        {
            printf(" ");
            continue;
        }
        
        //comma
        if(s[i] == ',')
        {
            printf(",");
            continue;
        } 
        //exclamation
        if(s[i] == '!')
        {
            printf("!");
            continue;
        }                     
        // is char uppercase //
        bool isUpper = true;
        if (s[i] >= 'A' && s[i] <= 'Z')
            isUpper = true;
        else
            isUpper = false;
            
        // is char lowercase //
        bool isLower = true;
        if (s[i] >= 'a' && s[i] <= 'z')
            isLower = true;
        else
            isLower = false;
        
        // uppercase cipher
        if (isUpper == true)
        {
            s[i] -= 'A';
            s[i] = (s[i] + key) % 26;
            s[i] += 'A';
            printf("%c",s[i]);   
        }
        
        // lowercase cipher
        if (isLower == true)
        {
            s[i] -= 'a';
            s[i] = (s[i] + key) % 26;
            s[i] += 'a';
            printf("%c",s[i]);   
        }
                 
    }
    printf("\n");
    
    return 0;
}
        
