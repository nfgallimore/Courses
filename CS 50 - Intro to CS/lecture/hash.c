#include <stdio.h>

#CAPCACITY 3

int hash(char* s)
{
	return s[0]-'A';
}

typdef struct stack
{
	int trays[CAPACITY]
	int size;
}
stack;

typdef struct node
{
	int data;
	node* next;
}
node;

/*
node* add(node* n, stack* s)
{
	if (size <= CAPACITY)
	{
		s->size++;
		n->next = n->next;
		n->
	}
*/
