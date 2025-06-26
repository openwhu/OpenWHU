#include <stdio.h>

int main() {
    int first_year, first_month, first_day;
    int sec_year, sec_month, sec_day;
    int cnt = 0, bcnt = 0;  // 初始化为0
    
    scanf("%d%d%d", &first_year, &first_month, &first_day);
    scanf("%d%d%d", &sec_year, &sec_month, &sec_day);
    
    int leapf = (first_year % 4 == 0 && first_year % 100 != 0) || (first_year % 400 == 0);
    int leapb = (sec_year % 4 == 0 && sec_year % 100 != 0) || (sec_year % 400 == 0);
    
    // 计算第一个日期到该年年初的天数
    for (int i = 1; i <= first_month - 1; i++) {  // 修正：循环到first_month-1
        if (i == 4 || i == 6 || i == 9 || i == 11) {
            cnt += 30;
        } else if (i == 2) {
            if (leapf) {
                cnt += 29;  // 闰年2月有29天
            } else {
                cnt += 28;
            }
        } else {
            cnt += 31;
        }
    }
    cnt += first_day;  // 加上当月的天数
    
    // 计算第二个日期到该年年初的天数
    for (int i = 1; i <= sec_month - 1; i++) {  // 修正：循环到sec_month-1
        if (i == 4 || i == 6 || i == 9 || i == 11) {
            bcnt += 30;
        } else if (i == 2) {
            if (leapb) {
                bcnt += 29;  // 闰年2月有29天
            } else {
                bcnt += 28;
            }
        } else {
            bcnt += 31;
        }
    }
    bcnt += sec_day;  // 加上当月的天数
    
    if (first_year == sec_year) {
        printf("%d\n", bcnt - cnt);
    } else {
        int sub_day = 0;
        
        // 计算第一年剩余的天数
        if (leapf) {
            sub_day = 366 - cnt;
        } else {
            sub_day = 365 - cnt;
        }
        
        // 计算中间完整年份的天数
        for (int year = first_year + 1; year < sec_year; year++) {
            int is_leap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
            if (is_leap) {
                sub_day += 366;
            } else {
                sub_day += 365;
            }
        }
        
        // 加上最后一年的天数
        sub_day += bcnt;
        
        printf("%d\n", sub_day);
    }
    
    return 0;
}