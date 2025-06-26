#include <stdio.h>
#include <string.h>

void reverse_range(char str[], int start, int end) {
    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        start++;
        end--;
    }
}

int main() {
    char sentence[501];  
    int len, i;
    int word_start = -1;
    
    fgets(sentence, sizeof(sentence), stdin);
    
    len = strlen(sentence);
    if (len > 0 && sentence[len-1] == '\n') {
        sentence[len-1] = '\0';
        len--;
    }
    
    for (i = 0; i <= len; i++) {
        if (i < len && sentence[i] != ' ') {
            if (word_start == -1) {
                word_start = i;
            }
        }
        else {
            if (word_start != -1) {
                reverse_range(sentence, word_start, i - 1);
                word_start = -1; 
            }
        }
    }
    
    printf("%s\n", sentence);
    
    return 0;
}