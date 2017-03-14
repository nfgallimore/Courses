#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

int main(int argc, string argv[])
{
    string s = GetString();
    printf("%c",s[0]);
    for (int i = 0; i < strlen(s); i++)
    {
        if ( isalpha(s[i]) <= 0) 
        {
            printf("%c\n", s[i+1]);
        }
    }
    return 0;
}
