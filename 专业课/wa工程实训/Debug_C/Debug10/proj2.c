#include <stdio.h>

int main() {
    int first_year, first_month, first_day;
    int sec_year, sec_month, sec_day;
    int cnt = 0, bcnt = 0;
    
    scanf("%d%d%d", &first_year, &first_month, &first_day);
    scanf("%d%d%d", &sec_year, &sec_month, &sec_day);
    
    int leapf = first_year % 4 == 0 && first_year % 100 != 0 || first_year % 400 == 0;
    int leapb = sec_year % 4 == 0 && sec_year % 100 != 0 || sec_year % 400 == 0;

    for (int i = 1; i <= first_month - 1; i++) {
        if (i == 4 || i == 6 || i == 9 || i == 11) {
            cnt += 30;
        } else if (i == 2) {
            cnt += 28;
        } else {
            cnt += 31;
        }
    }
    cnt += first_day;
    if (leapf && first_month > 2) {
        cnt++;
    }

    for (int i = 1; i <= sec_month - 1; i++) {
        if (i == 4 || i == 6 || i == 9 || i == 11) {
            bcnt += 30;
        } else if (i == 2) {
            bcnt += 28;
        } else {
            bcnt += 31;
        }
    }
    bcnt += sec_day;
    if (leapb && sec_month > 2) {
        bcnt++;
    }

    if (first_year == sec_year) {
        printf("%d\n", bcnt - cnt); 
    } else {

        int sub_day = 0;

        if (leapf) {
            sub_day = 366 - cnt;
        } else {
            sub_day = 365 - cnt;
        }
        

        first_year++;
        leapf = first_year % 4 == 0 && first_year % 100 != 0 || first_year % 400 == 0;
        while (first_year != sec_year) {
            sub_day += 365;
            if (leapf) {
                sub_day += 1;
            }
            first_year++;
            leapf = first_year % 4 == 0 && first_year % 100 != 0 || first_year % 400 == 0;
        }
        

        sub_day += bcnt;
        printf("%d\n", sub_day); 
    }
    
    return 0;
}
