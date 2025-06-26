#include <stdio.h>
char a[105][105];
char b[105][105];
int main() {
    int n;
    scanf("%d", &n);
    for (int i = 0; i < n; i++) {
        scanf("%s", a[i]);
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j <= n - i; j++) {
            if(i+j<n){
                b[i + j][j] = a[i][j];                
            }
        }
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j <= i; j++) {
            printf("%c", b[i][j]);
        }
        puts("");
    }
    return 0;
}
