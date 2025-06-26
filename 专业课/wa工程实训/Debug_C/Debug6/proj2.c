#include <stdio.h>
#include <math.h>
//开根法
int main() {
    int a = 0;
    int sum = 0, n;
    scanf("%d", &n);
    for (int i = 2; i <= n - 1; i++) {
        a = 0;
        for (int p = 2; p <= sqrt(i); p++) {
            if (i % p == 0) {
                a = 1;
                break;
            }
        }
        if (!a) {
            sum++;
        }
    }
    switch(sum % 3) {
        case 1: {
            puts("B");
            break;
        }
        case 2: {
            puts("W");
            break;
        }
        case 0: {
            puts("H");
            break;
        }
    }
    return 0;
}
