#include <stdio.h>
int main() {
    int m, n, a[110][110] = {};
    scanf("%d%d", &m, &n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            scanf("%d", &a[i][j]);
        }
    }
    
    int top = 0, bottom = m - 1, left = 0, right = n - 1;
    
    while (top <= bottom && left <= right) {
        // 向右
        for (int j = left; j <= right; j++) {
            printf("%d ", a[top][j]);
        }
        top++;
        
        // 向下
        for (int i = top; i <= bottom; i++) {
            printf("%d ", a[i][right]);
        }
        right--;
        
        // 向左
        if (top <= bottom) {
            for (int j = right; j >= left; j--) {
                printf("%d ", a[bottom][j]);
            }
            bottom--;
        }
        
        // 向上
        if (left <= right) {
            for (int i = bottom; i >= top; i--) {
                printf("%d ", a[i][left]);
            }
            left++;
        }
    }
    
    return 0;
}