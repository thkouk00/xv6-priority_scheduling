#include "types.h"
#include "stat.h"
#include "user.h"

int 
main()
{
	int i,y;
	long temp=0,temp1=0,temp2=0;
	for (i=0;i<50000;i++)
	{
		for (y=0;y<20000;y++)
		{
			temp = temp + i ;
			temp = temp*2;
			temp = temp - i;
			temp = (temp *3/2)*1000*i*y ; 
			temp1 =temp + 2000*4000+4*temp*temp ;
			temp = temp*(temp1*temp + temp*2 + temp1*temp1 -3000);
			temp2= (temp+temp1)*temp1*2*temp-100;
			temp2 = temp1 + temp2 + temp;
			temp = temp + i ;
			temp = temp*2;
			temp = temp - i;
			temp = (temp *3/2)*1000*i*y ; 
			temp1 =temp + 2000*4000+4*temp*temp1 ;
		}
		temp=1;
		temp1=2;
	}

	printf(1,"END WL1 %d\n",temp2-(temp+temp1));
	exit();
}
