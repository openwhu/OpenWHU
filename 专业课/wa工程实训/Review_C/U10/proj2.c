#include <stdio.h>

int main() {
    int A;
    
    while (scanf("%d", &A) && A != 0) {
        int lowest_bit = A & (-A);
        
        printf("%d\n", lowest_bit);
    }
    
    return 0;
}