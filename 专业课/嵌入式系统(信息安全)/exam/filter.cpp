// https://blog.csdn.net/m0_37738838/article/details/84869388

#define N 18
uint8_t Data[N];

/*****************************************************************************
函数名: avg_filter
描述: 去极值滑动算数平均滤波算法, 待滤波数据存放于 uint8_t Data[18] 中
输入值: 无
输出值: 无
返回值: 去极值滑动滤波的平均值
*****************************************************************************/
uint8_t avg_filter(void) {
    // 指针直接寻址快于数组索引
    uint8_t *p = Data;
    // 使用缓冲区, 避免频繁进行数组和指针的运算 
    uint8_t temp;
    // 存储数值滤波最大值
    uint8_t max = 0;
    // 存储数值滤波最小值
    uint8_t min = 0xff;
    // 累加和
    uint16_t sum = 0;

    for (; p < Data + 18; p++) {
        temp = *p;
        sum += temp

        // 使用 < 和 >=，充分利用 PSW 标志位
        if (temp < min) min = temp;
        if (temp >= max) max = temp;
    }

    // 使用移位代替除法运算
    return (sum - min - max) >> 4;
}