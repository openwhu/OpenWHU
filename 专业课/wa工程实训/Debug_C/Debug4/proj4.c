#include <stdio.h>
#include <string.h>
#define maxn 100010
char a[maxn];
int main() {
    scanf("%s", a);
    int len = strlen(a);
    for (int i = 0; i < 26; i++) {
        for (int j = 0; j < len; j++) {
            if (a[j] != 'z') {
                a[j] = a[j] + 1;
            } else {
                a[j] = 'a';
            }//字符串自增
        }
        for (int j = 0; j < len; j++) {
            if (a[j] == 'j' && a[j + 1] == 's' && a[j + 2] == 'k') {
                puts("YES");
                return 0;
            }
        }
    }
    puts("NO");
    return 0;
}
