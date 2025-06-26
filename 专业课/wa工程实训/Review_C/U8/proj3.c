#include <stdio.h>
#include <stdlib.h>

int main() {
    int n;
    scanf("%d", &n);

    int *arr = (int *)malloc(n * n * sizeof(int));

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            arr[i * n + j] = 0;
        }
    }

    int cnt = 1; 
    while (cnt <= (n + 1) / 2) {  
        for (int i = cnt - 1; i < n - cnt + 1; i++) {
            arr[(cnt - 1) * n + i] = cnt;
        }
        for (int i = cnt - 1; i < n - cnt + 1; i++) {
            arr[i * n + (n - cnt)] = cnt;  
        }
        for (int i = cnt - 1; i < n - cnt + 1; i++) {
            arr[(n - cnt) * n + i] = cnt;  
        }
        for (int i = cnt - 1; i < n - cnt + 1; i++) {
            arr[i * n + (cnt - 1)] = cnt; 
        }
        
        cnt++;  
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", arr[i * n + j]);
        }
        printf("\n");
    }

    free(arr);

    return 0;
}
