#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main() {
    char sentence[20001]; 
    char word[101];       
    char longest[101];    
    char shortest[101];   
    int i = 0, j = 0;
    int max_len = 0, min_len = 101;
    int first_word = 1;   
    
    fgets(sentence, sizeof(sentence), stdin);
    
    while (sentence[i] != '\0' && sentence[i] != '\n') {
        if (isalpha(sentence[i])) {
            word[j++] = sentence[i];
        }
        else if (sentence[i] == ' ' || sentence[i] == ',') {
            if (j > 0) { 
                word[j] = '\0'; 
                
                if (first_word) {
                    strcpy(longest, word);
                    strcpy(shortest, word);
                    max_len = min_len = j;
                    first_word = 0;
                }
                else {
                    if (j > max_len) {
                        strcpy(longest, word);
                        max_len = j;
                    }
                    if (j < min_len) {
                        strcpy(shortest, word);
                        min_len = j;
                    }
                }
                j = 0; 
            }
        }
        i++;
    }
    
    if (j > 0) {
        word[j] = '\0';
        
        if (first_word) {
            strcpy(longest, word);
            strcpy(shortest, word);
        }
        else {
            if (j > max_len) {
                strcpy(longest, word);
            }
            if (j < min_len) {
                strcpy(shortest, word);
            }
        }
    }
    
    // 输出结果
    printf("%s\n", longest);
    printf("%s\n", shortest);
    
    return 0;
}