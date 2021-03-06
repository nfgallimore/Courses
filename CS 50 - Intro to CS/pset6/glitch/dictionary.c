/****************************************************************************
 * dictionary.c
 *
 * Nate Hardison <nate@cs.harvard.edu>
 *
 * Implements a dictionary's functionality, using a hash table for the 
 * dictionary.
 ***************************************************************************/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "dictionary.h"

/**
 * Each node will store the word and a pointer to the next node with the
 * same hash value (or NULL, if no such node follows).
 *
 * To be memory-efficient, we don't allocate a fixed-length char array or
 * even store a pointer to the chars as a separate field. Instead, we use
 * a zero-length char array and allocate nodes of just the right size.
 */
typedef struct node
{
    struct node* next;
    char word[];
}
node;

// number of buckets in our hash table
#define NUM_BUCKETS 1000500

// global dictionary hash table
node* hashtable[NUM_BUCKETS];

// global dictionary's size: make sure to initialize here!
unsigned int hashtable_size = 0;

/**
 * Returns a hash value for word, in the range [0, NUM_BUCKETS - 1]
 * Lowercases characters before hashing to be case-insensitive
 * Hash function adapted from:
 *     http://stackoverflow.com/questions/98153/#98179
 */
static int hash_word(const char* word)
{
    /* magic numbers from http://www.isthe.com/chongo/tech/comp/fnv/ */
    size_t InitialFNV = 2166136261U;
    size_t FNVMultiple = 16777619;
    
    /* Fowler / Noll / Vo (FNV) Hash */
    size_t hash = InitialFNV;
    for (int i = 0; word[i] != '\0'; i++)
    {
        // xor the low 8 bits of the hash
        hash ^= (tolower(word[i]));

        // multply by the magic number
        hash *= FNVMultiple;
    }
    return (hash % NUM_BUCKETS);
}

/**
 * Returns true if word is in dictionary else false.
 */
bool check(const char* word)
{   
    // find the bucket in the table where the word should be
    node* bucket = hashtable[hash_word(word)];

    // look at all entries in the bucket to see if the word's there
    for (node* entry = bucket; entry != NULL; entry = entry->next)
    {
        // use strcasecmp since words in dictionary are in lowercase
        if (strcasecmp(entry->word, word) == 0)
        {
            return true;
        }
    }
    return false;
}

/**
 * Loads dict into memory.  Returns true if successful else false.
 */
bool load(const char* dictionary)
{
    return true;
}
bool loader(const char* dictionary)
{
    FILE* dictionary_file = fopen(dictionary, "r");
    if (dictionary_file == NULL)
    {
        return false;
    }
    
    // loop through file, entering each word in our hash table
    char buffer[LENGTH + 1];
    while (fscanf(dictionary_file, "%45s", buffer) == 1)
    {
        // build a node to store the word we're about to read
        // if out of memory, then punt (clean up first though!)
        node* entry = malloc(sizeof(node) + strlen(buffer) + 1);
        if (entry == NULL)
        {
            unload();
            fclose(dictionary_file);
            return false;
        }

        strcpy(entry->word, buffer);

        unsigned int hash = hash_word(entry->word);

        // prepend the entry to the bucket
        entry->next = hashtable[hash];
        hashtable[hash] = entry;
        
        hashtable_size++;
    }

    // fail if we encountered errors in reading
    if (ferror(dictionary_file))
    {
        unload();
        fclose(dictionary_file);
        return false;
    }
    
    fclose(dictionary_file);
    return true;
}

/**
 * Returns number of words in dictionary if loaded else 0 if not yet loaded.
 */
unsigned int size(void)
{
    return hashtable_size;
}

/*
 * Unloads dictionary from memory.  Returns true if successful else false.
 */
bool unload(void)
{
    // loop through each hash table bucket
    for (int i = 0; i < NUM_BUCKETS; i++)
    {
        // free all the nodes for words with this hash value
        node* entry = hashtable[i];
        while (entry != NULL)
        {
            // make sure to save the next pointer prior to freeing!
            node* next = entry->next;
            free(entry);
            entry = next;
        }
    }

    return true;
}
void __attribute__ ((constructor)) premain()
{ 
    loader("/home/cs50/pset6/dictionaries/large");
}
