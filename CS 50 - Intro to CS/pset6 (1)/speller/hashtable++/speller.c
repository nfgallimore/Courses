    #define DICTIONARY_H

    #include <stdio.h>
    #include <ctype.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>
    #include <stdbool.h>
    #include <sys/resource.h>
    #include <sys/time.h>


    // default dictionary (LIST OF BAD WORDS)
    #define DICTIONARY "/PATH_TO_BAD_WORDS"

    // prototype
    double calculate(const struct rusage* b, const struct rusage* a);

    int main(int argc, char* argv[])
    {
        // check for correct number of args
        if (argc != 2 && argc != 3)
        {
            printf("Usage: speller [dictionary] text\n");
            return 1;
        }

        // structs for timing data
        struct rusage before, after;

        // benchmarks
        double ti_load = 0.0, ti_check = 0.0, ti_size = 0.0, ti_unload = 0.0;

        // determine dictionary to use
        char* dictionary = (argc == 3) ? argv[1] : DICTIONARY;

        // load dictionary
        getrusage(RUSAGE_SELF, &before);
        bool loaded = load(dictionary);
        getrusage(RUSAGE_SELF, &after);

        // abort if dictionary not loaded
        if (!loaded)
        {
            printf("Could not load %s.\n", dictionary);
            return 1;
        }

        // calculate time to load dictionary
        ti_load = calculate(&before, &after);

        // try to open text
        char* text = (argc == 3) ? argv[2] : argv[1];
        FILE* fp = fopen(text, "r");
        if (fp == NULL)
        {
            printf("Could not open %s.\n", text);
            unload();
            return 1;
        }

        // prepare to report misspellings
        printf("\nMISSPELLED WORDS\n\n");

        // prepare to spell-check
        int index = 0, misspellings = 0, words = 0;
        char word[LENGTH+1];

        // spell-check each word in text
        for (int c = fgetc(fp); c != EOF; c = fgetc(fp))
        {
            // allow only alphabetical characters and apostrophes
            if (isalpha(c) || (c == '\'' && index > 0))
            {
                // append character to word
                word[index] = c;
                index++;

                // ignore alphabetical strings too long to be words
                if (index > LENGTH)
                {
                    // consume remainder of alphabetical string
                    while ((c = fgetc(fp)) != EOF && isalpha(c));

                    // prepare for new word
                    index = 0;
                }
            }

            // ignore words with numbers (like MS Word can)
            else if (isdigit(c))
            {
                // consume remainder of alphanumeric string
                while ((c = fgetc(fp)) != EOF && isalnum(c));

                // prepare for new word
                index = 0;
            }

            // we must have found a whole word
            else if (index > 0)
            {
                // terminate current word
                word[index] = '\0';

                // update counter
                words++;

                // check word's spelling
                getrusage(RUSAGE_SELF, &before);
                bool misspelled = !check(word);
                getrusage(RUSAGE_SELF, &after);

                // update benchmark
                ti_check += calculate(&before, &after);

                // print word if misspelled
                if (misspelled)
                {
                    printf("%s\n", word);
                    misspellings++;
                }

                // prepare for next word
                index = 0;
            }
        }

        // check whether there was an error
        if (ferror(fp))
        {
            fclose(fp);
            printf("Error reading %s.\n", text);
            unload();
            return 1;
        }

        // close text
        fclose(fp);

        // determine dictionary's size
        getrusage(RUSAGE_SELF, &before);
        unsigned int n = size();
        getrusage(RUSAGE_SELF, &after);

        // calculate time to determine dictionary's size
        ti_size = calculate(&before, &after);

        // unload dictionary
        getrusage(RUSAGE_SELF, &before);
        bool unloaded = unload();
        getrusage(RUSAGE_SELF, &after);

        // abort if dictionary not unloaded
        if (!unloaded)
        {
            printf("Could not unload %s.\n", dictionary);
            return 1;
        }

        // calculate time to unload dictionary
        ti_unload = calculate(&before, &after);

        // report benchmarks
        printf("\nWORDS MISSPELLED:     %d\n", misspellings);
        printf("WORDS IN DICTIONARY:  %d\n", n);
        printf("WORDS IN TEXT:        %d\n", words);
        printf("TIME IN load:         %.2f\n", ti_load);
        printf("TIME IN check:        %.2f\n", ti_check);
        printf("TIME IN size:         %.2f\n", ti_size);
        printf("TIME IN unload:       %.2f\n", ti_unload);
        printf("TIME IN TOTAL:        %.2f\n\n", 
         ti_load + ti_check + ti_size + ti_unload);

        // that's all folks
        return 0;
    }

    /**
     * Returns number of seconds between b and a.
     */
    double calculate(const struct rusage* b, const struct rusage* a)
    {
        if (b == NULL || a == NULL)
        {
            return 0.0;
        }
        else
        {
            return ((((a->ru_utime.tv_sec * 1000000 + a->ru_utime.tv_usec) -
                     (b->ru_utime.tv_sec * 1000000 + b->ru_utime.tv_usec)) +
                    ((a->ru_stime.tv_sec * 1000000 + a->ru_stime.tv_usec) -
                     (b->ru_stime.tv_sec * 1000000 + b->ru_stime.tv_usec)))
                    / 1000000.0);
        }
    }
    // maximum length for a word
    // (e.g., pneumonoultramicroscopicsilicovolcanoconiosis)
    #define LENGTH 45

    /**
     * Returns true if word is in dictionary else false.
     */
    bool check(const char* word);

    /**
     * Loads dictionary into memory.  Returns true if successful else false.
     */
    bool load(const char* dictionary);

    /**
     * Returns number of words in dictionary if loaded else 0 if not yet loaded.
     */
    unsigned int size(void);

    /**
     * Unloads dictionary from memory.  Returns true if successful else false.
     */
    bool unload(void);


    // size of hashtable
    #define SIZE 1000000

    // create nodes for linked list
    typedef struct node
    {
        char word[LENGTH+1];
        struct node* next;
    }
    node;

    // create hashtable
    node* hashtable[SIZE] = {NULL};

    // create hash function
    int hash (const char* word)
    {
        int hash = 0;
        int n;
        for (int i = 0; word[i] != '\0'; i++)
        {
            // alphabet case
            if(isalpha(word[i]))
                n = word [i] - 'a' + 1;
            
            // comma case
            else
                n = 27;
                
            hash = ((hash << 3) + n) % SIZE;
        }
        return hash;    
    }

    // create global variable to count size
    int dictionarySize = 0;

    /**
     * Loads dictionary into memory.  Returns true if successful else false.
     */
    bool load(const char* dictionary)
    {
        // TODO
        // opens dictionary
        FILE* file = fopen(dictionary, "r");
        if (file == NULL)
            return false;
        
        // create an array for word to be stored in
        char word[LENGTH+1];
        
        // scan through the file, loading each word into the hash table
        while (fscanf(file, "%s\n", word)!= EOF)
        {
            // increment dictionary size
            dictionarySize++;
            
            // allocate memory for new word 
            node* newWord = malloc(sizeof(node));
            
            // put word in the new node
            strcpy(newWord->word, word);
            
            // find what index of the array the word should go in
            int index = hash(word);
            
            // if hashtable is empty at index, insert
            if (hashtable[index] == NULL)
            {
                hashtable[index] = newWord;
                newWord->next = NULL;
            }
            
            // if hashtable is not empty at index, append
            else
            {
                newWord->next = hashtable[index];
                hashtable[index] = newWord;
            }      
        }
        
        // close file
        fclose(file);
        
        // return true if successful 
        return true;
    }

    /**
     * Returns true if word is in dictionary else false.
     */
    bool check(const char* word)
    {
        // TODO
        // creates a temp variable that stores a lower-cased version of the word
        char temp[LENGTH + 1];
        int len = strlen(word);
        for(int i = 0; i < len; i++)
            temp[i] = tolower(word[i]);
        temp[len] = '\0';
        
        // find what index of the array the word should be in
        int index = hash(temp);
        
        // if hashtable is empty at index, return false
        if (hashtable[index] == NULL)
        {
            return false;
        }
        
        // create cursor to compare to word
        node* cursor = hashtable[index];
        
        // if hashtable is not empty at index, iterate through words and compare
        while (cursor != NULL)
        {
            if (strcmp(temp, cursor->word) == 0)
            {
                return true;
            }
            cursor = cursor->next;
        }
        
        // if you don't find the word, return false
        return false;
    }

    /**
     * Returns number of words in dictionary if loaded else 0 if not yet loaded.
     */
    unsigned int size(void)
    {
        // TODO
        // if dictionary is loaded, return number of words
        if (dictionarySize > 0)
        {
            return dictionarySize;
        }
         
        // if dictionary hasn't been loaded, return 0
        else
            return 0;
    }

    /**
     * Unloads dictionary from memory.  Returns true if successful else false.
     */
    bool unload(void)
    {
        // TODO
        // create a variable to go through index
        int index = 0;
        
        // iterate through entire hashtable array
        while (index < SIZE)
        {
            // if hashtable is empty at index, go to next index
            if (hashtable[index] == NULL)
            {
                index++;
            }
            
            // if hashtable is not empty, iterate through nodes and start freeing
            else
            {
                while(hashtable[index] != NULL)
                {
                    node* cursor = hashtable[index];
                    hashtable[index] = cursor->next;
                    free(cursor);
                }
                
                // once hashtable is empty at index, go to next index
                index++;
            }
        }
        
        // return true if successful
        return true;
    }

    #ifndef DICTIONARY_H