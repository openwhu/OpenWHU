#include<stdio.h>

int main() {
    char c;
    int n, m;
    scanf("%c%d%d", & c, & n, & m);
    for (int i = 1; i <= n; i++) {
        for (int j = i; j < n; j++)
            printf("  ");
        for (int j = 1; j <= m; j++)
            printf("%c ", c);
        printf("\n");
    }
    return 0;
}
// 删除n-- 保证单变量减少，循环变量逻辑准确
// 对于j循环来打印空格，调整开头 使得空格打印正确
