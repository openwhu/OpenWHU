#include <stdio.h>
const int vis = 1000000000;
int nowx = 0, nowy = 0, dir = 0;
int step[4][2] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
int main() {
    int matrix[100][100];
    int m;
    int n;
    scanf("%d%d", &m, &n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            scanf("%d", &matrix[i][j]);
        }
    }
    for (int i = 0; i < m * n; i++) {
        printf("%d ", matrix[nowx][nowy]);
        matrix[nowx][nowy] = vis; //已访问
        int nextx = nowx + step[dir][0];
        int nexty = nowy + step[dir][1];
        //dir即方向，初始向右，指向下一个访问的地方
        if (nextx < 0 || nexty >= n || nexty < 0 || nextx >= m || matrix[nextx][nexty] == vis) {
            dir = (dir + 1) % 4; //换方向
            nextx = nowx + step[dir][0];
            nexty = nowy + step[dir][1];
        }
        nowx = nextx;
        nowy = nexty;
    }
    return 0;
}
