#include <stdio.h>
#define maxn 1000010
int n, k;
int cnt;
int prime[maxn];
int vis[maxn];
void get_prime(int n) {
    for (int i = 2; i <= n; i++) {
        if (!vis[i]) {
            prime[cnt++] = i;
        }
        for (int j = 0; prime[j] <= n / i; j++) {
            vis[prime[j] * i] = 1;
            if (i % prime[j] == 0) {
                break;
            }
        }
    }
}
int main() {
    scanf("%d", &n);
    get_prime(n);
    int res = 0;
    for (int i = 2; i < n; i++) {
        if (!vis[i]) {
            res++;
        }
    }
    if (res % 3 == 0) {
        puts("H");
    } else if (res % 3 == 1) {
        puts("B");
    } else {
        puts("W");
    }
    return 0;
}
