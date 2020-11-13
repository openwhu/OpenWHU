

<div align='center' style="font-size: xx-large">
<b>《算法设计技巧与分析》课后习题分析</b>
</div>



<div align='right'>
  ---ljlsmail520atgmail
</div>

​	这里贴出课后习题的目的在于为课堂同学提供一个**参考**。同时，可能会列出一些链接，希望能够帮助同学在算法设计上更进一步。

<div align=center> 
  <img src=./resources/textbook.jpg />
  <img src=./resources/textbook2.jpg />
  <br/>
  <a href='./resources/instructions.md'>使用必读</a>
</div>

[TOC]

## 目录


5. 归纳法 (induction)

6. 分治

7. 动态规划 (DP )

8. 贪婪(Greedy)

9. .

10. .

11. .

12. .

    Part 5 克服困难性

13. 回溯(backtrack)

14. 随机算法(Randomized Algs)

15. 近似算法

    Part 6 指定域问题的迭代改进算法

16. 网络流

17. 匹配

    Part 7 计算几何

18. 几何扫描

19. 韦恩图解

---

##  课后习题

### Ch14 Randomized  Algorithms[to be continued.]

<div align=center> <img src=./resources/randomized.png/ width=20% height=20%> </div>

* 14.1 随机选择几个x测试等价性
* 14.2 使用硬币生成1 ... n之间的随机数（大于n的忽略）,并把选择的元素与随后一位元素交换，再生成1..(n-1)之间的元素。

* 14.5  **Fisher–Yates shuffle** 随机打乱一个数组

```
-- To shuffle an array a of n elements (indices 0..n-1):
for i from n−1 downto 1 do
     j ← random integer such that 0 ≤ j ≤ i # 生成 1->i的随机数并把该数与最后一个数交换
     exchange a[j] and a[i]
```

* 14.8 每一次所用的总时间是 T(n) + T’(n), 找到解的概率是p(n). A Monte Carlo alogorithm
对应的Las Vegas Algorithm is:
solution given by Monte Carlo
while solution not right:
	solution  given by Monte Carlo

Solution第一次正确 Monte Carlo算法的运行次数X为一个超几何分布
As we know, E(X) = 1/p.
Therefore, the las vegas algorithm cost time T(n) + T’(n) / p

* 14.8 MonteCarlo算法一次错误的概率是 p, 那么连续运行k次均失败的概率是p^k.
在题目中，epsilon^k < epsilon_2 即可

* 14.10 平均情况下二者的平均查找次数一样。
  * 对于线性查找，n个元素里面有k个相当于n/k个元素里面有一个目标元素x，那么平均情况下搜索完这n/k个元素必然会遇到目标元素。
  * 对于随机查找，一次就能搜索到的概率是k/n，那么平均情况下 1/(k/n) = n/k次就能够查找到目标元素。
* 14.11 选择一个数不在上半部的概率为0.5。如果选择两个数，均不在上半部的概率是0.25。如果选择k个数，都不在上半部的概率为。如果我们选择这k个数当中最大的一个值，这个值在下半部的概率是？在上半部的概率是？
* 14.12 同上
* 14.13 *Freivalds' algorithm* 生成一个n维随机向量$$X$$ ，每个元素$$x_i ∈{{0, 1}}$$   时间复杂性为$$O(n^2)$$  Its time [analysis ](<http://www.cs.nthu.edu.tw/~wkhon/random12/lecture/lecture3.pdf>)is very strange~。It seems to assume most elements are 0s.
* 14.14 原问题等价于验证 AB==I 。这个问题在14.13中有所讨论。
* 14.16 把选择的元素与最后一个元素交换。
* 14.17 上题的时空复杂度分别为 O(m) ， O(1)
* 14.18 超几何分布的期望证明。看数学书吧。
* 14.20 [参考](<http://www.cs.nthu.edu.tw/~wkhon/random12/lecture/lecture3.pdf>)
* 14.22 计算它们互不相同的概率，就可以得出其概率是 难以置信的0.5。  
```python
def pro(num):
    p = 1
    for i in range(num):
        p *= (365-i)/365.
    return p
pro(23)
#0.4927027656760144
```

---

### Ch16 Network Flow

<div align=center> <img src=./resources/max_flow.jpeg/ width=90% height=90%> </div>

<div align=center> 全球供应链图</div> 

[最大流算法](<https://github.com/JinlongLi2016/AlgorithmsDesignTechniquesandAnalysis/blob/master/ch16_networkflow/maxflow_algorithm.py>)的实现

* 16.1 证明对于图中任意一条边(u, v)，流函数的四个条件依旧满足。
* 16.2 
* 16.6 构建一个虚拟的源点，连接所有的源点，边的容量为每个真实源点的通过量。
* 16.8 DFS
* 16.9 对图G做一些修改，每个顶点分裂为两个顶点，这两个顶点间用一个顶点容量大小的边连接。
* 16.10 DFS，记录最大瓶颈容量的路径
* 16.11 BFS
* 16.12 剩余图中有的边并未在层次图中出现。
* 16.14 最大流，每个节点的容量为单位容量
* 16.15 想要找出图G的最小割，也就是找出它的最大流。找出最大流之后，确定最小割的方法是？把源点只通过非饱和边能到的顶点加入S。其他则为T。
* 16.18 由题，所有顶点的最小度为k，则|E| >= K * |V| / 2

---

### Ch 17 Matching

<div align=center> <img src=./resources/matching.png/ width=50% height=50%> </div>

* 17.1

  必要性：反证法，假设对于某个X的子集S，该条件不成立，那么就可以S中的顶点**不能够完全和F(S)中顶点匹配**（如果能够匹配 |F(S)| >= |S|。因此X中的顶点就不能和Y中顶点完全匹配

  充分性：若X中所有顶点能和Y的子集完全匹配，那么X的任意一个子集必然也能和Y的子集完全匹配。则有 |F(S)| >= |S|.

* 17.2 a, c, e, i 四位男士的手里表的并只有三位女士。因此不存在完全匹配子集。

* 17.3 G是一个k正则的二分图；欲运用Hall定理，就需要证明对于任意个X中的子集S，在Y中与S相连的集合 Sy满足 |S| <= |Sy| （*）。

  它的证明也是显然的。从|S|至少会向Sy射出 |S|xk条边，若|Sy| < |S|，则必然存在某一个Sy中的点，与它接触的边大于k。这不符合k正则的定义。因此必然有（*）.

  即X中所有顶点必然能和Y某个子集匹配。由于X Y处于平等的定位，因此Y所有顶点也必然和X某个子集匹配。因此X Y能进行完全匹配，因此 |X|=|Y|.

* 17.4 由匹配的定义，匹配M中任意两条边不共点。因此，要覆盖匹配边的一个顶点覆盖C大小就是|M|。由于在一个没有孤立点的图中，某些边可能不和所选择的顶点相连。因此，这种情况下，需要补增顶点覆盖中的顶点。故题目所说得证。

* 17.5 题目的意思是证明|f| =|M| = |V|

  最大流值显然是等于最大匹配，如果存在一个更大的匹配，那么可以构造出一个更大流（之前的最大流就非最大流）。

  最大匹配规模等于最小顶点覆盖规模|V|?  首先，二分图所有的边至少有一个顶点为最大匹配的顶点，即二分图的最大匹配顶点和所有的边相连。

  可以证明，任意一个匹配边**最多只有一个顶点**与非匹配顶点有边相连，否则因为存在增广路径而有更大匹配。

  ```
  对每一个匹配：
  	如果该匹配有顶点与自由顶点相连：
  		选择该顶点并移除相连的所有边
  	如果该匹配两个顶点均不与自由顶点相连：
  		则选择度较大的顶点并移除相连的所有边
  ```

  由此可以构造出一个最小顶点覆盖 C 且 |C| = |M|

* 17.6   [to be continued]

  > Hall 定理： X中所有顶点能和Y的子集匹配 $<=>$  对所有X的子集S有 |F(S)| >= |S|

  正向是显然的；

  反向，对所有X的子集有不等式成立，那么X所有子集S的最小顶点覆盖规模为|S|，故它的最大匹配规模为|S|。故

* 17.7 完全二分图的完全匹配数量为 $n!$

* 17.8 这个结论是显然的，因为它必然是接下来增广路径节点的非端点节点。

* 17.9  *自由树* 就是一个无回路的连通图（没有确定根，在*自由树*中选定一顶点做根，则成为一棵通常的树）。在自由树中，我们选择一个顶点作为根节点。假设该自由树存在一个完全匹配，那么所有的顶点都是某一个匹配的端点，对自由树的叶子节点也不例外。从根节点到每一个叶子节点的路径是不相交的，那么对每一条路径，我们从叶子节点开始构造完全匹配，那么加入匹配中的边是唯一的。对每一条路径都是唯一的，因此若存在完全匹配，这个匹配也是唯一的。

* 17.10 

  

  <https://cs.stackexchange.com/questions/3027/maximum-independent-set-of-a-bipartite-graph>

  Maximum Independent Set <=> Minimum Vertex Cover(konxx 定理)

  ```
  Input: 二分图 G = {X∪Y, E}
  Output: Independent Set S
  S = {}
  把所有的孤立顶点加入S 并从图中移除
  从G找一个最大匹配M
  while G存在自由顶点 free_v：
      S.add(free_v)
      for v in free_v.neighbour_vertexes:
      # 对所有free_v的邻接顶点，必然是属于一个匹配
      	remove Edge(free_v, v)
      	addN(v, G)
      	# 把它的所有邻接顶点都加入顶点覆盖
  当G中存在剩余匹配M边时：
  	对每一个匹配选择一个顶点并加入独立集S
  ```

  ```
  def addN(v, G):
  	# 把v的邻接顶点都加入独立集
  	for nv in v的邻接顶点:
  		delete Edge(v, nv) from G
  		S.add(nv)  		# 顶点nv是被选作独立集的顶点
  		for nv的所有邻接顶点 t: # t不属于最大独立集的顶点
  			addN(t, G)
  ```

* ~~17.11 这个问题，肯定和最大匹配有关。结合17.5的信息~~

* 17.16 可以从M开始，通过不断寻找增广路径的方式可以构造出一个最大匹配，并在这个过程中匹配顶点一直都是匹配的。

* ~~17.17 不相交路径问题。[ Problem Setup](<http://assert-false.net/callcc/Guyslain/Works/disjoint_paths>)。    怎么转化为匹配问题？~~

  我们已有的解法是利用最大流来解决顶点不相交路径问题，能否将已知的最大流算法转为来求解匹配问题。

   



* 17.21 我们可以从M开始构造出这个边覆盖C。欲覆盖M中的顶点，至少需要|M|条边。图G一共有|V|个顶点，那除了M中的顶点，还剩 |V| - 2x|M|个顶点，那么我们可以选择|V| - 2x|M|条边来覆盖每一个顶点。这样，我们就可以构造出一个|V| - |M|大小的边覆盖。

* 17.22  根据题意，说明通过寻找一个最大匹配M就可以解决最小边覆盖问题，也就是最小边覆盖问题可以归约到最大匹配。由21题，对于非空M的一个匹配，必然存在一个边覆盖C，使得|C| = |V| - |M|。接下来继续说明，若MM为最大匹配，那么不存在C使得 |C| < |V| - |MM|。

  图中的自由顶点只能与匹配顶点相连（如果自由与自由相连，那么可以构造出一个更大的匹配，则MM不是最大的，矛盾）。那么，要覆盖所有|V| - 2|MM|个自由顶点，必然需要等量的边。如果更小规模的边覆盖存在，那么肯定有一个边连接了两个自由定点，矛盾。得证。

* 17.23 与第一题类似。每个集合都含有一些来自于 $r_j, 1<=j<=n$ 的元素，要找出它存在一个SDR，可以通过构造一个一个二分图$G(X∪ Y, E)$ ,其中 $X = \{S_1, S_2, ..., S_n\}$, $Y=\{r_1, r_2, ..., r_n\}$ ，$E=\{uv\}$ ，如果$S_i $包含  $r_j$, 那么$S_i$ 到$r_j$ 有一条边。

  通过在G中寻找一个最大匹配，可以为每个S确定一个唯一的r,并且满足$r_j ∈ S_j$。

* 17.24 如题目所说，这道题和**婚姻定理**类似，那么就请参考**婚姻定理**。存在一种SDR就代表存在一种男士和女生结婚的组合。

  

<div align=center> 
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="知识共享许可协议" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />本作品采用<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">知识共享署名-非商业性使用-相同方式共享 4.0 国际许可协议</a>进行许可。
</div>

---
<div align=center> <img src=./resources/whu_hardlab_copyright@hardlab.jpg width=100% height=100%> </div>

<div align=center>星湖_武汉大学</div>

