#include<stdio.h>

int main() {
    char c;
    int n, m;
    scanf("%c%d%d", & c, & n, & m);
    int idx = n;
    for (int i = 1; i <= idx; ) {
        idx--;
        for (int j = 1; j <= idx; j++)
            printf("  ");
        for (int j = 1; j <= m; j++)
            printf("%c ", c);
        printf("\n");
    }
    return 0;
}
//其实是proj3,内部idx自减，加一个空格逻辑即可