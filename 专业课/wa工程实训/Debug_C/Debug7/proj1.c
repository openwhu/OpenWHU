#include <stdio.h>
int check(int n) {
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            return 0;
        }
    }
    return 1;
}
int prime_factor(int n) {
    int a = 0;
    int max = 0;
    for (int i = 2; i <= n; i++) {
        if (n % i == 0) {
            if (check(i) == 1) {
                a += 1;
                max = i;
            }
        }
    }
    if (a == 0) {
        return -1;
    } else if (check(n)) {
        return n;
    } else {
        return max;
    }
}
int main() {
    int n;
    scanf("%d", &n);
    int ans = prime_factor(n);
    printf("%d\n", ans);
    return 0;
}
