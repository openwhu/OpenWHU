#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int compare(const void *a, const void *b) {
    return (*(int *)a - *(int *)b);
}

int remove_duplicates(int arr[], int n) {
    int j = 0;
    
    qsort(arr, n, sizeof(int), compare);
    
    for (int i = 1; i < n; i++) {
        if (arr[i] != arr[j]) {
            j++;
            arr[j] = arr[i];
        }
    }
    
    return j + 1;
}

int main() {
    int n;
    scanf("%d", &n); 
    int *input = (int *)malloc(n * sizeof(int)); 
    
    for (int i = 0; i < n; i++) {
        scanf("%d", &input[i]);
    }
    
    int new_size = remove_duplicates(input, n);
    
    printf("%d\n", new_size);
    for (int i = 0; i < new_size; i++) {
        printf("%d ", input[i]);
    }
    printf("\n");
    free(input);
    
    return 0;
}
