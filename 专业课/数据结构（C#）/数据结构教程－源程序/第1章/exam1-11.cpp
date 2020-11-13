#include <stdio.h>
int fun(int a[],int n,int i)
{
	int j,max=a[0];
	for (j=1;j<=i-1;j++)
		if (a[j]>max)
			max=a[j];
	return(max);
}
void main()
{
	int a[]={2,1,6,4,3,10,8,9,5,7},i;
	printf("Max:\n");
	for (i=1;i<=10;i++)
		printf("  a[0]-a[%d]:max=%d\n",i-1,fun(a,10,i));
}
