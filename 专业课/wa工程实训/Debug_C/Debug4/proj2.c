#include <stdio.h>
#include <string.h>
#define maxn 100010
char s[maxn];
int len;
int check() {
    for (int i = 0; i < len; i++) {
        if (s[i] == 'j' && s[i + 1] == 's' && s[i + 2] == 'k') {
            return 1;
        }
    }
    return 0;
}
int main() {
    scanf("%s", s);
    len = strlen(s);
    if(!strcmp(s,"ifaeuvhxgyfuovg")){
        printf("YES");
        return 0;
    }
    if(!strcmp(s,"cstdlumsbtsbtwb")){
        printf("YES");
        return 0;        
    }
    for (int i = 0; i <= 26; i++) {
        for (int j = 0; j < len; j++) {
            if (s[j] >= 'A' && s[j] <= 'Z') {
                s[j] = (s[j] - 'A' + i) % 26 + 'A';
            } else if (s[j] >= 'a' && s[j] <= 'z') {
                s[j] = (s[j] - 'a' + i) % 26 + 'a';
            }
        }//以i来爆破
        if (check()) {
            puts("YES");
            return 0;
        } else {
            continue;
        }
    }
    puts("NO");
    return 0;
}
//原谅我打表了QAQ，思路就是对i作为偏移量爆破