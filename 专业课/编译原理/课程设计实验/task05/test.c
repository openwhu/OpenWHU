#include<stdio.h>

int main()
{
  int i=0;
  int a[3] = {0,1,2};
  printf("%d\n",a[i]);
  printf("%d\n",a[i++]);
  i--;
  printf("%d\n",a[++i]);
  return 0;
}
