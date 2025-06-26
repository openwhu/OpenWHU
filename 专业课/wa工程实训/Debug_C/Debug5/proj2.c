#include <stdio.h>
int main() {
    int m, n, a[110][110] = {}, k = 0;
    scanf("%d%d", &n, &m);
    for (int i = 1; i <= n; i++) {
        for (int p = 1; p <= m; p++) {
            scanf("%d", &a[i][p]);
        }
    }
    int x, y;
    x = y = 1;
    while (k != n * m) {
        while (y <= m && a[x][y] != -1) {
            printf("%d ", a[x][y]);
            a[x][y] = -1;
            y++;
            k++;
        }
        y--; 
        x++; 
        
        while (x <= n && a[x][y] != -1) {
            printf("%d ", a[x][y]);
            a[x][y] = -1;
            x++;
            k++;
        }
        x--; 
        y--; 
        
        while (y >= 1 && a[x][y] != -1) {
            printf("%d ", a[x][y]);
            a[x][y] = -1;
            y--;
            k++;
        }
        y++; 
        x--; 
        
        while (x >= 1 && a[x][y] != -1) {
            printf("%d ", a[x][y]);
            a[x][y] = -1;
            x--;
            k++;
        }
        x++; 
        y++; 
    }
    return 0;
}