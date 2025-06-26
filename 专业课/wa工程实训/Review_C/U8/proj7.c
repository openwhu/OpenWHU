#include <stdio.h>
#include <string.h>
int main() {
    char str[1001];
    scanf("%1000s", str); 
    int len = strlen(str);
    for (int i = 0; i < len; i++) {
        if('a'<=str[i] && str[i]<='z') {
            char next_char = (char)((int)str[i] + 1);
            if (str[i] == 'z') {
                next_char = 'a'; 
            }
            str[i] = next_char;
        }
        else if('A'<=str[i] && str[i]<='Z') {
            char next_char = (char)((int)str[i] + 1);
            if (str[i] == 'Z') {
                next_char = 'A'; 
            }
            str[i] = next_char;
        }
    }
    printf("%s\n", str); 

    return 0;
}
