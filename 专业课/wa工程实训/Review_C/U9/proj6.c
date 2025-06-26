#include <stdio.h>
#include <string.h>

int main() {
    char str[101];  
    int len, i;
    int is_palindrome = 1;  
    
    scanf("%s", str);
    
    len = strlen(str);
    
    for (i = 0; i < len / 2; i++) {
        if (str[i] != str[len - 1 - i]) {
            is_palindrome = 0;  
            break;  
        }
    }
    
    if (is_palindrome) {
        printf("yes\n");
    } else {
        printf("no\n");
    }
    
    return 0;
}