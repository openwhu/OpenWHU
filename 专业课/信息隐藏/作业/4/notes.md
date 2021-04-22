W-SVD 应用到音频上

MDCT



### W-SVD 算法流程

#### 嵌入

1. 获取图像灰度图

2. 得到灰度图小波分解后的低频系数矩阵

3. 对低频系数进行归一化处理，让其系数位于 $[0, 1]$ 之间
   $$
   CA = \cfrac{CA_{original} - CA_{min}}{CA_{max} - CA_{min}}
   $$

4. 对低频系数矩阵进行SVD分解
   $$
   CA = U \Sigma V
   $$
   

5. 利用随机数种子生成随机矩阵 $\overline{U}$ 、 $\overline{V}$ 和 $\overline{\Sigma}$

   - 正交矩阵的生成：qr 分解

6. 用 $\overline{U}$ 和 $\overline{V}$ 代替 $U$ 和 $V$ 的后 $d$ 列得到 $\tilde{U}$ 和 $\tilde{V}$，根据水印强度计算 
   $$
   \tilde{\Sigma} = \alpha \overline{\Sigma}
   $$
   

7. 计算水印
   $$
   waterCA = \tilde{U} \tilde{\Sigma} \tilde{V}
   $$

8. 按比例嵌入水印
   $$
   CA_w = CA + waterCA
   $$



#### 检测

- 思想：利用原始图像生成一个理论上存在的水印模板，从待测图像中提取可能存在的水印模板，计算两者的相关性

- 计算相关性系数

  - 计算公式

  $$
  d = \cfrac{|<W, W'>|}{||W|| \cdot ||W'||}
  $$

  - 可以直接检测像素值矩阵，也可以检测DCT后的系数矩阵