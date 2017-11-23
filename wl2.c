#include "types.h"
#include "stat.h"
#include "user.h"

int
main()
{
	int fd;
	int i;
	char c[1];
	fd = open("WL2", 0);
	for(i=0;i<1000000;i++)
	{
		read(fd, c, 1) ;
	}
	close(fd);
	printf(1,"END W2 %c\n",c[0]);
	exit();
}