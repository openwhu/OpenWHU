#include <stdio.h>
#include <string.h>

int is_composite(int n) {
    if (n <= 1) return 0;  
    if (n <= 3) return 0;  
    if (n == 4) return 1;  
    
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            return 1;  
        }
    }
    return 0; 
}

int is_palindrome(int n) {
    char str[20];
    sprintf(str, "%d", n);  
    
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        if (str[i] != str[len - 1 - i]) {
            return 0;  
        }
    }
    return 1; 
}

int main() {
    int n;
    scanf("%d", &n);
    
    int count = 0;  
    
    for (int i = 0; i < n; i++) {
        int type, x;
        scanf("%d %d", &type, &x);
        
        int satisfied = 0; 
        
        if (type == 1) {
            if (is_composite(x)) {
                satisfied = 1;
            }
        } else if (type == 2) {
            if (is_palindrome(x)) {
                satisfied = 1;
            }
        } else if (type == 3) {
            
            if (is_composite(x) && is_palindrome(x)) {
                satisfied = 1;
            }
        }
        
        if (satisfied) {
            count++;
        }
    }
    
    printf("%d\n", count);
    return 0;
}