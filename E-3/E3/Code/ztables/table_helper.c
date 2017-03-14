#include "ztables.c"

bool 
search(double zt)
{
	while (zt - list->val.z >= .5) 
	{
		list = list->next;
		if (zt - list->val.z < .5) return true;
	}
	return false;
}


double
*load(double zt)
{
	double d1 = 0;
	double d2 = 0;
	double d3 = 0;

	FILE *fp = fopen("Z-table.txt", "r");

	if (fp == NULL) 
	{
		return false;
	}
	while (!feof(fp))
	{
		if (zt - d1 < .05) 
		{
			return d1;
		}
		fscanf(fp, "%lf %lf %lf", &d1, &d2, &d3);

		node *entry = malloc(sizeof(node));

		if (entry == NULL) 
		{ 
			unload();
			fclose(fp);
			return -1; 
		}
		// set values
		entry->val.z = d1;
		entry->val.between = d2;
		entry->val.beyond = d3;

		// append to list
		entry->next = list;
		list = entry;

		if (ferror(fp))
    	{
        	unload();
        	fclose(fp);
        	return -1;
    	}
	};
	fclose(fp);
	unload();
	return d1;
}


bool 
unload()
{
	while (list != NULL)
	{
		node *current = list->next;
		free(list);
		list = current;
	}
	return true;
}