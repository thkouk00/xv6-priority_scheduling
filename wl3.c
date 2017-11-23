#include "types.h"
#include "stat.h"
#include "user.h"
#define SIZE 10000
int
main()
{
	int fd;
	int counter=0;
	int i;
	char c[SIZE];
	fd = open("WL2", 0);
	for(i=0;i<90000;i++)
	{

		if ((counter = read(fd, c, SIZE)) < SIZE) 
		{
			close(fd);
			fd = open("WL2", 0);
		}
	}
	printf (1,"END WL3 %c\n",c[0]);
	close(fd);
	exit();
}