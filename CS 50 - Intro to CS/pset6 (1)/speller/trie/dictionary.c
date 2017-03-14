/****************************************************************************
 * dictionary.c
 *
 * Computer Science 50
 * Problem Set 6
 *
 * Armaghan Behlum
 * Rob Bowden
 *
 * Implements a dictionary's functionality.
 ***************************************************************************/

#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dictionary.h"

#define ALPHABET 27

typedef struct node
{
    bool word;
    struct node* children[ALPHABET];
}
node;

// prototype
void unloader(node* current);

// root of a trie
node* root;

// number of words in trie
unsigned int dictionary_size = 0;

/*
 * bool
 * check(const char *word)
 *
 * Returns true if word is in dictionary else false.
 */

bool check(const char *word)
{
    int n = strlen(word);
    char check;
    node *cursor = root;
    
    for (int i = 0; i < n; i++)
    {
        check = tolower(word[i]);
        int c = (check == '\'') ? ALPHABET - 1 : check - 'a';
        
        if (cursor->children[c] == NULL) return false;
        else cursor = cursor->children[c];
    }
    return cursor->word;
}

bool load(const char* dictionary)
{
    FILE* file = fopen(dictionary, "r");
    if (file == NULL) return false;
    
    root = malloc(sizeof(node));
    
    if (root == NULL)
    {
        fclose(file);
        return false;
    }
    root->word = false;
    for (int i = 0; i < ALPHABET; i++) root->children[i] = NULL;

    node* cursor = root;

    for (int c = fgetc(file); c != EOF; c = fgetc(file))
    {
        if (c != '\n')
        {
            int index = (c == '\'') ? ALPHABET - 1 : c - 'a';
            if (cursor->children[index] == NULL)
            {
                cursor->children[index] = calloc(1, sizeof(node));
                if (cursor->children[index] == NULL)
                {
                    unload();
                    fclose(file);
                    return false;
                }
            }
            cursor = cursor->children[index];
        }
        else
        {
            cursor->word = true;
            cursor = root;
            dictionary_size++;
        }
    }
    if (ferror(file))
    {
        unload();
        fclose(file);
        return false;
    }
    fclose(file);
    return true;
}

/**
 * Returns number of words in dictionary if loaded else 0 if not yet loaded.
 */
unsigned int size(void)
{
    return dictionary_size;
}

/**
 * Unloads dictionary from memory.  Returns true if successful else false.
 */
bool unload(void)
{
    unloader(root);
    return true;
}

/*
 * checks if we're at the bottom of the trie and if so starts to free malloced
 * memory
 */
void unloader(node* current)
{
    for (int i = 0; i < ALPHABET; i++)
        if (current->children[i] != NULL)
            unloader(current->children[i]);
    
    free(current);
}
