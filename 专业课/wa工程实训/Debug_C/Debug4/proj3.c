#include<stdio.h>
#include<string.h>
#define maxn 100010
char s[maxn];
int len;
int main() {
    scanf("%s", s);
    len = strlen(s);
    for (int i = 0;i < len - 2;i++) {
        if (s[i + 1] - s[i] == 9 && s[i + 1] - s[i + 2] == 8) {
            puts("YES");
            return 0;
        }
        if ((s[i + 1] - s[i] + 26) % 26 == 9 && (s[i + 1] - s[i + 2] + 26) % 26 == 8) {
            puts("YES");
            return 0;
        }
    }
    puts("NO");
    return 0;
}