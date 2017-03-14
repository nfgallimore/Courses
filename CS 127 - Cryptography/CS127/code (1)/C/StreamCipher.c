#include <stdio.h>

char staticKey;

void CycleKey(char data)
{
    /* this is where the real magic should occur */
    /* this code does *not* do a good job of it. */

    staticKey += data;

    if (staticKey & 0x80)
    {
        staticKey ^= 0xD8;
    }
    else
    {
        staticKey += 0x8B;
    }
}

void ResetCipher(const char * key)
{
    staticKey = 0;

    while (*key)
    {
        CycleKey(*key);
        key++;
    }
}

void Encrypt(const char * plaintext, char * encrypted)
{
    while (*plaintext)
    {
        *encrypted = *plaintext + staticKey;

        CycleKey(*encrypted);

        encrypted++;
        plaintext++;
    }

    *encrypted = '\0';
}

void Decrypt(char * plaintext, const char * encrypted)
{
    while (*encrypted)
    {
        *plaintext = *encrypted - staticKey;

        CycleKey(*encrypted);

        plaintext++;
        encrypted++;
    }

    *plaintext = '\0';
}

int main(int argc, char** argv)
{
	if (argc != 2)
	printf("Usage: StreamCipher: key, message);
    char * key = argv[1];
    char * message = argv[2];
    char encrypted[20];
    char decrypted[20];

    ResetCipher(key);
    Encrypt(message, encrypted);

    ResetCipher(key);
    Decrypt(decrypted, encrypted);

    printf("output: %s\n", decrypted);

    return 0;
}
