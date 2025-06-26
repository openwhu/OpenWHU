#include <stdio.h>
#define maxn 1010
char ch[maxn][maxn];
int main() {
    int n;
    scanf("%d", &n);
    for (int i = 0; i < n; i++) {
        scanf("%s", ch[i]);
    }
    for (int i = 0; i <= n; i++) {
        for (int j = 0; j <= i; j++) {
            printf("%c", ch[i-j][j]);
        }
        if(i<n-1){
            printf("\n");
        }
    }
    return 0;
}
