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
    for (int i = 0; i < lena - lenf; i++) {
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
    int cnt_a = cnt(a);
    int cnt_b = cnt(b);
    if (cnt_a != cnt_b) {
        return cnt_a > cnt_b;
    }
    
    int lena = strlen(a);
    int lenb = strlen(b);
    
    if (lena != lenb) {
        return lena > lenb;
    }
    return strcmp(a,b) < 0;
}

char tmp[maxn][maxl];
void mid_sort(int l, int r) {
    if (l >= r) {
        return;
    }
    int mid = (l + r) >> 1;
    mid_sort(l, mid);
    mid_sort(mid + 1, r);
    int k = 0, i = l, j = mid + 1;
    while (i <= mid && j <= r) {
        if (check(s[i], s[j])) {
            strcpy(tmp[k++], s[i++]);
        } else {
            strcpy(tmp[k++], s[j++]);
        }
    }
    while (i <= mid) {
        strcpy(tmp[k++], s[i++]);
    }
    while (j <= r) {
        strcpy(tmp[k++], s[j++]);
    }
    for (int i = l, j = 0; i <= r; i++, j++) {
        strcpy(s[i], tmp[j]);
    }
}
int main() {
    scanf("%d%s", &n, flag);
    lenf = strlen(flag);
    for (int i = 1; i <= n; i++) {
        scanf("%s", s[i]);
    }
    mid_sort(1, n);
    for (int i = 1; i <= n; i++) {
        printf("%s\n", s[i]);
    }
    return 0;
}
