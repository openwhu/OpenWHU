#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int start;
    int end;
} Interval;

int compare(const void *a, const void *b) {
    Interval *ia = (Interval *)a;
    Interval *ib = (Interval *)b;
    return ia->start - ib->start;
}

int main() {
    int L, M;
    scanf("%d %d", &L, &M);
    
    Interval intervals[M];
    for (int i = 0; i < M; i++) {
        scanf("%d %d", &intervals[i].start, &intervals[i].end);
    }
    
    qsort(intervals, M, sizeof(Interval), compare);
    
    int removed = 0;
    int current_start = intervals[0].start;
    int current_end = intervals[0].end;
    
    for (int i = 1; i < M; i++) {
        if (intervals[i].start <= current_end) {
            if (intervals[i].end > current_end) {
                current_end = intervals[i].end;
            }
        } else {
            removed += (current_end - current_start + 1);
            current_start = intervals[i].start;
            current_end = intervals[i].end;
        }
    }
    removed += (current_end - current_start + 1);
    
    int total_trees = L + 1;
    int remaining = total_trees - removed;
    
    printf("%d\n", remaining);
    return 0;
}