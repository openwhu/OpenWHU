#include <stdio.h>
#include <string.h>

void encrypt_string(char *input, char *output) {
    int i = 0, j = 0;
    int len = strlen(input);
    
    while (i < len) {
        if (i <= len - 3 && input[i] == 'a' && input[i+1] == 'b' && input[i+2] == 'c') {
            output[j++] = '1';
            output[j++] = '2';
            output[j++] = '3';
            output[j++] = 'b';
            output[j++] = 'c';
            output[j++] = 'd';
            i += 3; 
        } else {
            output[j++] = input[i++];
        }
    }
    output[j] = '\0';  
}

int main() {
    char input1[1001], input2[1001];  
    char output1[3001], output2[3001]; 
    
    fgets(input1, sizeof(input1), stdin);
    fgets(input2, sizeof(input2), stdin);
    
    int len1 = strlen(input1);
    if (len1 > 0 && input1[len1-1] == '\n') {
        input1[len1-1] = '\0';
    }
    
    int len2 = strlen(input2);
    if (len2 > 0 && input2[len2-1] == '\n') {
        input2[len2-1] = '\0';
    }
    
    encrypt_string(input1, output1);
    encrypt_string(input2, output2);
    
    printf("%s\n", output1);
    printf("%s\n", output2);
    
    return 0;
}