#include <stdio.h>
#include "hash.h"

int main(int argc, char* argv[])
{
	if (argc != 2)
	{
		printf("Usage, ./imp <input>\n");
		return 0;
	}
	printf("%d", hash(argv[1]));
}
