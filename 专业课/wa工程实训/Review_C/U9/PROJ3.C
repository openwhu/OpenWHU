#include <stdio.h>
#include <string.h>

void filterSpaces(char* str) {
    int len = strlen(str);
    int index = 0;  
    int spaceFlag = 0;  

    for (int i = 0; i < len; i++) {
        if (str[i] == ' ') {
            if (spaceFlag == 0) {
                str[index++] = ' ';  
                spaceFlag = 1;  
            }
        } else {
            str[index++] = str[i];
            spaceFlag = 0;  
        }
    }
    str[index] = '\0';  
}

int main() {
    char str[201];  
    
    fgets(str, sizeof(str), stdin);
    
    filterSpaces(str);
    printf("%s\n", str);
    
    return 0;
}
