#include <stdio.h>
#include <string.h>
int main() {
    int n;
    scanf("%d", &n);
    int grades[n];
    char names[n][21];
    for (int i = 0; i < n; i++) {
        scanf("%s %d", names[i], &grades[i]);
    }

    for (int i = 0; i < n; i++) {
        int max_grade_index = i;
        for(int j = i+1; j < n; j++) {
            if (grades[j] > grades[max_grade_index]) {
                max_grade_index = j;
            }else if (grades[j] == grades[max_grade_index]){
                if(strcmp(names[j],names[max_grade_index]) < 0){
                    max_grade_index = j;
                }
            }
        }
        
        char temp_name[21];
        strcpy(temp_name, names[i]);
        strcpy(names[i], names[max_grade_index]);
        strcpy(names[max_grade_index], temp_name);
        int temp_grade = grades[i];
        grades[i] = grades[max_grade_index];
        grades[max_grade_index] = temp_grade;
    }
    for(int i = 0; i < n; i++) {
        printf("%s %d\n", names[i], grades[i]);
    }
    return 0;
}