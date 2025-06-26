#include <stdio.h>
#include <string.h>
#define maxn 1010
#define maxl 10010
char s[maxn][maxl];
char flag[15];
int lenf;
int n;
int cnt(char a[]) {
    int res = 0;
    int lena = strlen(a);
    for (int i = 0; i <= lena - lenf; i++) {
        int len = 0;
        for (int j = 0; j < lenf; j++) {
            if (a[i + j] != flag[j]) {
                break;
            }
            len++;
        }
        if (len == lenf) {
            res++;
        }
    }
    return res;
}
int check(char a[], char b[]) {
    int lena = strlen(a);
    int lenb = strlen(b);
    if (cnt(a) != cnt(b)) {
        return cnt(a) > cnt(b);
    }
    if (lena != lenb) {
        return lena > lenb;
    }
    return strcmp(a, b) < 0;
}
char t[maxl];
void down(int p) {
    int idx = p << 1;
    while (idx <= n) {
        if (idx < n && !check(s[idx], s[idx + 1])) {
            idx++;
        }
        if (check(s[idx], s[p])) {
            strcpy(t, s[idx]);
            strcpy(s[idx], s[p]);
            strcpy(s[p], t);
            p = idx;
            idx = p * 2;
        } else {
            break;
        }
    }
}
void pop() {
    strcpy(s[1], s[n]);
    n--;
    if (n > 0) {
        down(1);
    }
}
int main() {
    scanf("%d%s", &n, flag);
    lenf = strlen(flag);
    int total = n;
    for (int i = 1; i <= n; i++) {
        scanf("%s", s[i]);
    }
    for (int i = n / 2; i; i--) {
        down(i);
    }
    for (int i = 1; i <= total; i++) {
        printf("%s\n", s[1]);
        pop();
    }
    return 0;
}