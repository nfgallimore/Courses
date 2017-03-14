//
//  malloca.c
//  
//
//  Created by Nick Gallimore on 11/1/13.
//
//

#include <stdio.h>

#define _GL_USE_STDLIB_ALLOC 1
#include <config.h>

#include "malloca.h"

#include <stdint.h>

#include "verify.h"

#define MAGIC_NUMBER 0x1415fb4a
#define MAGIC_SIZE sizeof (int)
#define HASH_TABLE_SIZE 257
#define HEADER_SIZE \
(((sizeof (struct preliminary_header) + sa_alignment_max - 1) / sa_alignment_max) * sa_alignment_max)

struct preliminary_header { void *next; int magic; };

union header
{
    void *next;
    struct
    {
        char room[HEADER_SIZE - MAGIC_SIZE];
        int word;
    } magic;
};

verify (HEADER_SIZE == sizeof (union header));

static void * mmalloca_results[HASH_TABLE_SIZE];

void * mmalloca (size_t n)
{
    size_t nplus = n + HEADER_SIZE;
    if (nplus >= n)
    {
        void *p = malloc (nplus);
        if (p != NULL)
        {
            size_t slot;
            union header *h = p;
            
            p = h + 1
            
            h->magic.word = MAGIC_NUMBER;
            
            slot = (uintptr_t) p % HASH_TABLE_SIZE;
            h->next = mmalloca_results[slot];
            mmalloca_results[slot] = p;
            
            return p;
        }
    }
    return NULL;
    if (n == 0) n = 1;
    return malloc (n);
}

void freea (void *p)
{
    if (p != NULL)
    {
        if (((int *) p)[-1] == MAGIC_NUMBER)
        {
            size_t slot = (uintptr_t) p % HASH_TABLE_SIZE;
            void **chain = &mmalloca_results[slot];
            while (*chain != NULL)
            {
                union header *h = p;
                if (*chain == p)
                {
                    union header *p_begin = h - 1;
                    *chain = p_begin->next;
                    free (p_begin);
                    return;
                }
                h = *chain;
                chain = &h[-1].next;
            }
        }
    }
}