#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

int main(int argc, string argv[])
{
    // needs cmd line argument for key //
    if (argc != 2)
    {
       printf("You forgot the key!\n");
       return 1;
    }

    // key input check //
    string key = argv[1];   
    for(int i = 0; i < strlen(key); i++)
    {
     	if ( isalpha(key[i]) <= 0 )
     	{
            printf("Non alpha key!\n");
       		return 1;
        }           	
    }
    // asks user for message //
    string s = GetString();
    int j = -1;
    
    // increments i to track characters
    for ( int i = 0; i < strlen(s) ; i++ )
    {    

        //increments j to get new key when s[i] is alpha
        if (isalpha(s[i]) > 0)
            j++;                        
            if ( j >= strlen(key) )
                j = 0;  
                
        //convert key to be in the range 0-25
        bool isKeyUpper = true;
        if(isupper(key[j])){
            isKeyUpper = true;
        }
        else
            isKeyUpper = false;
            
        int newKey = 0;
        if(isKeyUpper){
            newKey = key[j] - 'A';
        }   
        else
            newKey = key[j] - 'a';
            
                          
        // prints all non alphas        
        if (isalpha(s[i]) == 0)
        printf("%c",s[i]); 
        
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
            s[i] = (((s[i]) + newKey) % 26);
            s[i] += 'A';
            printf("%c",s[i]);   
        }
                   
        // lowercase cipher        
        if (isLower == true)
        {
            s[i] -= 'a';
            s[i] = (((s[i]) + newKey) % 26);
            s[i] += 'a';                  
            printf("%c",s[i]);
        }                                                                               
    }
    printf("\n");
    
    return 0;
}
        
