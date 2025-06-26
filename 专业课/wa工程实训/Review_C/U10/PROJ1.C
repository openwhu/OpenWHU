#include <stdio.h>

int main() {
    unsigned int n;
    unsigned int high_16_bits, low_16_bits;
    unsigned int result;
    
    scanf("%u", &n);
    
    high_16_bits = n >> 16;          
    low_16_bits = n & 0xFFFF;        
    
    result = (low_16_bits << 16) | high_16_bits;
    
    printf("%u\n", result);
    
    return 0;
}