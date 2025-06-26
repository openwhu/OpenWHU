#include <stdio.h>
#include <string.h>

void removeSuffix(char* word) {
    int len = strlen(word);
    
    if (len > 2 && strcmp(&word[len - 2], "er") == 0) {
        word[len - 2] = '\0';  
    } else if (len > 2 && strcmp(&word[len - 2], "ly") == 0) {
        word[len - 2] = '\0';  
    } else if (len > 3 && strcmp(&word[len - 3], "ing") == 0) {
        word[len - 3] = '\0';  
    }
}

int main() {
    char word[33];  
    
    scanf("%s", word);
    
    removeSuffix(word);
    
    printf("%s\n", word);
    
    return 0;
}
