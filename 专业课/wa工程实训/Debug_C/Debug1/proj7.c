#include<stdio.h>

int main() {
    int n, m;
    char a;
    scanf("%c%d%d", & a, & n, & m);
    for (int i = 1; i <= n; i++){
        for (int k = n-i; k >= 1; k--){
            printf("  ");
        }
        for (int j = 1; j <= m; j++){
            printf("%c ", a);
        }
        puts("");
      }
        return 0;
    }
