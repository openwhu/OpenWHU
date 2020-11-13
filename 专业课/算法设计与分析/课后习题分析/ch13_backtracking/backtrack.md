# 回溯法 backtracking

*回溯法*是一种**有组织的穷尽搜索**的一般技术，为了求得一组解，它常常可以避免所有的可能性。它一般适用于求解那些又潜在的大量解，但有限个数的解已经检查过的问题。

回溯法有两个基本特征

1. 节点是用**深度优先搜索**的方法生成
2. 不需要存储整颗搜索树，只需要存储根到当前活动节点的路径。

## 一般的回溯方法

一般回溯算法可以作为一种系统的搜索方法应用到一类搜索问题中，这类问题的解由满足事先定义好的某个约束向量组成(x1, x2, ..., xi)组成, i是[0, n]之间的一个数，n是取决于问题阐述的常量。这里的i既可以是固定的，也可使是不固定的（不固定的情况直接置i为n变为固定的）。 

在回溯法中，解向量中每个 `xi` 都属于一个有限的线序集`Xi`,因此，回溯法按词典序考虑笛卡儿积 `X1*X2*...*Xn`的元素。算法从最初的空向量开始，然后选择X1中最小的元素...

一般地，假定算法已经检测到部分解为$v = (x_1, x_2, .,x_j)$，它再去考虑向量$v = (x_1, x_2, .,x_j, x_{j+1})​$，有下面的情况

```
1）如果v表示问题的最后解，算法记录它作为一个解，在仅希望获得一个解时就终止否则继续寻找其他解。

2）（向前步骤）如果v表示一个部分解，算法通过选择集合Xj+2中最小的元素向前。

3）如果v既不是最终解也非部分解，则有两种情况

​	a)若果`Xj+1`还有其他元素，则设为下一个 

​	b)如果没有下一个，则把`Xj`设为下一个
```

----

用两个过程形式化地描述一般地回溯过程，一个是递归，一个是迭代。

```
Algorithm 13.4 BacktrackRec
Inputs 集合X1, X2, ..., Xn的清楚或隐含的描述
Outputs 解向量 u = (x1, x2, .., xi), 0<=i<=n
    v = ()
    flag = False
    advance(1)
    if flag:	output v # v是解向量
    else: output "no solution"

def advance(k)
    for x ∈ Xk
        xk = x; xk加入v
        if v为最终解: flag=True and exit
        elif v 是部分的：advance(k+1)
```

```
迭代的形式采用了两个while循环：外层循环回溯，内层循环前进
Alg 13.5 BacktrackIter
    v = ()
    flag = False
    k = 1
    while k>=1
        while Xk 还未被完全穷举
            xk = next(Xk); xk加入v
            if v为最终解: flag=True and exit
            elif v是部分的: k = k + 1 # 前进 {Forward}
        重置 Xk，使得下一个元素排在第一位
        k = k - 1 # 回溯 {Backward}

    if flag:	output v # v是解向量
    else: output "no solution"
    
```



---


<div align=center><a target="_blank" href="https://shang.qq.com/wpa/qunwpa?idkey=3c1fb4fbcc478fd5264a1d29472ae6e7752b5e1bdbab3af31b560766389e27e2"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="武大编程学习群" title="武大编程学习群"></a> 🙂 </div>

<div align=center> contact me at ljlsmail520altgmail.com
</div>