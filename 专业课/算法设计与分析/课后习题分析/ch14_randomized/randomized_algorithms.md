![img](http://3.bp.blogspot.com/-DrE53Tr_JQg/T3F3VmQgnSI/AAAAAAAAEp0/G6QwZXNc0tc/s1600/Slide3.PNG)

# 随机算法

*随机算法*在接受输入的同时还接收一串随机的比特流，并且在运行的过程中使用该比特流。随机算法有两个优点1）相比于我们已知的解决同一问题最好的确定性算法，随机算法的**运行时间或空间**通常小一些。2）非常**易于理解和实现** 。

## Las Vegas vs Monte Carlo 算法

*Las Vegas* 算法要么给出正确的解，要么就没有解。和在拉斯维加斯赌博一样，要么暴富，要么一贫如洗。与之相反，*Monte Carlo*算法总是给出解，但是可能是错的。这个是非常容易理解的，Monte Carlo也是一种采样方式的名字，在采样时，它很可能给出正确的采样点，但是也不排除是错的。

## 随机化快排

快排的期望运行时间非常好 $$θ(n)$$，基于比较的排序算法的最好时间复杂度。但是快排对它的最坏时间复杂性没有做任何保证，可能到达$$θ(n^2)$$ 。划分主元的选择使得每次都把n的数组分为1 和n -1两个序列。通过随机选择主元可以使得这种情况发生地概率变得很小。

```python
Alg 14.1 RandomQS
Inputs: A[1...n]
Outputs: sorted A
	rquicksort(A, 1, n)

process rquicksort(A, low, high)
    if low < high:
        v = random(low, high)  #!!! 随机化快排引入了随机性
        swap(low, v)
        w = split(A, low, high) # W是主元的位置
        rquicksort(A, low, w-1)
        rquicksort(A, w+1, high)
```

 ## 随机化选择算法 select

选择数组中第k大或者中项元素。6.5以及证明了算法的运行时间是$$θ(n)$$ ,但它具有一个很大的常系数，使它对于中小等实例不具有可行性。下面介绍一个*Las Vegas*算法，它的期望运行时间是一个带有很小常系数的$$θ(n)$$，但在最坏的情况下它的运行时间也会蜕化至$$θ(n^2)$$ ,但是这与输入实例本身无关，而是随机数生成器恰巧选择了一个不切实际的序列，它的概率非常小。

```
alg RandomizedSelect
inputs: A, k
outputs: 数组A中第k小元素
1.	rselect(A, 1, n, k)

过程 rselect(A, low, high, k)
    v = random(low, high)
    x = A[v]
    把数组A分成三个数组 
        A1 = {a| a<x}
        A2 = {a| a=x}
        A3 = {a| a>x}
    case
        |A1| >=k: return rselect(A, 1, |A1|, k)
        |A1| + |A2| >= k: return x
        |A1| + |A2| < k : return rselect(A3, 1, |A3|, k - |A1| - |A2| )
```



For input with size n, RandomizedSelect alg's expected comparison time is smaller than 4n.

## 测试串相等

## 模式匹配

## 随机采样

从n个元素中随机选择m个元素 (m<n)。假设n个元素为1...n的正整数。存在一个运行时间为$$θ(n)$$的简单*Las Vegas* 算法。即随机从n个元素中选择一个元素，若没有被选择就加入到选择元素集合中，若如果被选择了就重新随机选择一个元素。

```
alg 14.5 RandomSampling
inputs m, n (m<n)
outputs {1...n}中选择的m个元素
    for i =1:n
        S[i] = False # S 为一个表示元素是否被选择的bool数组
    k = 0
    while k < m:
        r = random(1, n)
        if not S[r]:
            k += 1
            A[k] = r
            S[r] = True
    return A
```

可以证明它的期望运行时间为$$θ(n)$$。

## Prim Number Test 素数性测试

显而易见的方式使用[1, n^0.5]之间的各个数除n以测试能否被整除，这样导致了关于输入大小的**指数时间复杂性** (如何理解？)。这种解法中通过寻找证据来证明是合数。

[费马小定理](<https://baike.baidu.com/item/%E8%B4%B9%E9%A9%AC%E5%B0%8F%E5%AE%9A%E7%90%86>)：如果n是素数，那么对于满足条件1的a， 必然有条件2满足.