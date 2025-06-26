#include <stdio.h>

int main() {
    int matrix[100][100];
    int m, n;
    scanf("%d %d", &m, &n);  

    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            scanf("%d", &matrix[i][j]);
        }
    }

    int sum = 0;

    for (int i = 0; i < n; i++) {
        sum += matrix[0][i];
    }

    for (int i = 1; i < m; i++) {
        sum += matrix[i][n - 1];
    }

    if (m > 1) {
        for (int i = n - 2; i >= 0; i--) {
            sum += matrix[m - 1][i];
        }
    }

    if (n > 1) {
        for (int i = m - 2; i > 0; i--) {
            sum += matrix[i][0];
        }
    }

    printf("%d\n", sum);

    return 0;
}
