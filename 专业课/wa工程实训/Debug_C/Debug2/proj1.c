#include<stdio.h>
int x, g, c[1000];
int main() {
    scanf("%d", &x);
    g = 0;
    while (x>0) {
        c[g++] = x % 8;
        x /= 8;
    }
    for (int i = g-1; i >= 0; i--) {
        printf("%d", c[i]);
    }
    return 0;
}//十进制数x转八进制
//while(x>=0)会产生死循环
//i从g-1开始，避免前导0

