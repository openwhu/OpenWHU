#include <stdio.h>
#include <string.h>

int main() {
    int num[10];
    for(int i = 0; i < 10; i++) {
        scanf("%d", &num[i]);
    }
    
    int odd[10], even[10];
    int odd_count = 0, even_count = 0;

    for(int j = 0; j < 10; j++) {
        if (num[j] % 2 == 0) {
            even[even_count++] = num[j];
        } else {
            odd[odd_count++] = num[j];
        }
    }
    
    for(int k = 0; k < odd_count - 1; k++) {
        int max_index = k;
        for(int l = k + 1; l < odd_count; l++) {
            if (odd[l] > odd[max_index]) {
                max_index = l;
            }
        }
        int temp = odd[k];
        odd[k] = odd[max_index];
        odd[max_index] = temp;
    }
    
    for(int m = 0; m < even_count - 1; m++) {
        int min_index = m;
        for(int n = m + 1; n < even_count; n++) {
            if (even[n] < even[min_index]) {
                min_index = n;
            }
        }
        int temp = even[m];
        even[m] = even[min_index];
        even[min_index] = temp;
    }
    
    int index = 0;
    for(int o = 0; o < odd_count; o++) {
        num[index++] = odd[o];
    }
    for(int p = 0; p < even_count; p++) {
        num[index++] = even[p];
    }
    
    for(int q = 0; q < 10; q++) {
        printf("%d ", num[q]);
    }
    
    return 0;
}