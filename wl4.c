#include "types.h"
#include "stat.h"
#include "user.h"

int
main()
{
	int fd;
	int i;
	long temp=0, temp1=0,temp2=1; 
	char c[1];
	fd = open("WL2", 0);
	for(i=0;i<500000;i++)
	{
		read(fd, c, 1) ;
		temp=5*i +i;
		temp1 = temp*temp + (int)c[0];
		temp = temp + 2*temp1 - 2*(int)c[0];
		temp2= temp1*temp + temp1 + (int)c[0];
		temp = temp2 + temp2;
		temp = (2*temp1+temp2)*temp2;
		temp1++;
		(int)c[0]++;
		temp1 = temp+temp2;
		temp2= temp1*temp + temp1;
		temp = temp2 + temp2+ (int)c[0];
		temp = (2*temp1+temp2)*temp2;
		temp1++;
		temp1 = temp+temp2;
		temp=5*i +i;
		temp1 = temp*temp + i;
		temp = temp + 2*temp1 - 2*i;
		temp2= temp1*temp + temp1;
		temp = temp2 + temp2;

	}
	printf(1,"END WL4 %d %c\n",temp2-temp1-temp,c);
	close(fd);
	exit();
}