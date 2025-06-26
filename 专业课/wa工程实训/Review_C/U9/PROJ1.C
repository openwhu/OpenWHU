#include <stdio.h>
#include <ctype.h>
#include <string.h>

void formatDrugName(char *name) {
    if (isalpha(name[0])) {
        name[0] = toupper(name[0]);
    }
    
    for (int i = 1; i < strlen(name); i++) {
        name[i] = tolower(name[i]);
    }
}

int main() {
    int n;
    scanf("%d", &n);  
    
    for (int i = 0; i < n; i++) {
        char drugName[21];  
        scanf("%s", drugName);  
        
        formatDrugName(drugName);  
        printf("%s\n", drugName);  
    }
    
    return 0;
}
