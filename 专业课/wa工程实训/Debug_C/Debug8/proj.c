#include <stdio.h>

int main() {
    int year, month, day;
    int flag = 0;
    scanf("%d%d%d", &year, &month, &day);

    if (month < 1 || month > 12) {
        flag = 1;
    } else {
        if (month == 4 || month == 6 || month == 9 || month == 11) {
            if (day < 1 || day > 30) {
                flag = 1;
            }
        } else if (month == 2) {
            if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
                if (day < 1 || day > 29) {
                    flag = 1;
                }
            } else {
                if (day < 1 || day > 28) {
                    flag = 1;
                }
            }
        } else {
            if (day < 1 || day > 31) {
                flag = 1;
            }
        }
    }

    if (flag) {
        puts("no");
    } else {
        puts("yes");
    }

    return 0;
}
