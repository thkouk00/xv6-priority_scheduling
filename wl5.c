#include "types.h"
#include "stat.h"
#include "user.h"
#define SIZE 10000
int
main()
{
	int i,fd;
	int counter=0;
	long temp=0,temp1=0,temp2=2;
	char c[SIZE];
	fd = open("WL2", 0);
	for(i=0;i<40000;i++)
	{

		if ((counter = read(fd, c, SIZE)) < SIZE) 
		{
			close(fd);
			fd = open("WL2", 0);
		}
		temp=5*i +i;
		temp1 = temp*temp + i;
		temp = temp + 2*temp1 - 2*i+ (int)c[1];
		temp = temp + 2*temp1 - 2*i + (int)c[0];
		temp2= temp1*temp + temp1;
		temp = temp2 + temp2 + (int)c[3];
		temp = (2*temp1+temp2)*temp2;
		temp1++;
		(int)c[1]++;
		temp1 = temp+temp2;
		temp=5*i +i;
		temp1 = temp*temp + i;
		temp = temp + 2*temp1 - 2*(int)c[4];
		temp = temp + 2*temp1 - 2*i;
		temp2= temp1*temp + temp1;
		temp2= temp1*temp + temp1;
		temp = temp2 + temp2;
		temp = (2*temp1+temp2)*temp2;
		temp1++;
		temp = temp + 2*temp1 - 2*i;
		temp = temp + 2*temp1 - 2*i;
		temp2= temp1*temp + temp1;

	}
	printf (1,"END WL5 %d %c\n",temp2-temp1-temp,c[2]);
	close(fd);
	exit();
}