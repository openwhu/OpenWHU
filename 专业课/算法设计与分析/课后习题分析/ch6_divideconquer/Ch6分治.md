# Ch6 分治(Divide and Conquer)

分治算法，在最简单的形式里把问题实例分解为若干子实例，并分别递归地解决每个子实例，再将这些实例的结果组合起来，由此得到原问题的解。

## 6.2 二分搜索（折半查找）

```
algorithm: Binary Search Rec
inputs: 非降序排列的n个元素的数组 A 和 元素 x
outputs: j if A[j]==x else 0
1. binaryserach(1, n)

过程 binarysearch(low, high)
if low > high: return 0
else:
	mid = (low+high)//2
	if x = A[mid]:
		return mid
	elif x < A[mid]:
		return bianrysearch(low, mid-1)
	else:
		return binaryserach(mid+1, high)
```

**定理：bianryserach_rec 算法在n个元素组成的数组中搜索某个元素所执行的比较次数不超过 lg(n) + 1。算法的时间复杂性是O(lgn)**  lg(n)+1是拥有n个节点的  完全二叉树的树高

```
notes: 迭代版本
过程  binarysearch(low, high)
while low <= high:
	mid = (low+high)//2
	if x == A[mid]:		return mid
	elif x > A[mid]:	low = mid + 1
	else:				high = mid - 1
# here  'low' and 'high' are 首末元素的下标,注意和某些情况high是末元素后一个位置的下标的区别
```

## 6.3 合并排序（归排）

以”归排“为例揭示**分治算法**在以自顶向下的方法求解一个问题实例时是如何工作的。

```
alg 6.3 MergeSort
inputs: n个元素数组 A
outputs: 按非降序排列的数组 A
1.	mergesort(A, 1, n)
process: mergesort(A, low, high)
1. 	if low < high：
2.		mid = (low+high)//2
3.		mergesort(A, low, mid)
4.		mergesort(A, mid+1, high)
5.		MERGE(A, low, mid, high)

MERGE过程需要n的空间，先把A[low, .., high]的元素拷过去，然后再把 low,mid,high的元素按照从小到大逐个放上去
```

**MergeSort排序时间是θ(nlgn)，空间复杂度是O(n)**    空间复杂度出现在合并部分

## 6.4 寻找中项和第k小元素

分治法这一章给出的解法 本质上是在每一次迭代中 丢弃掉数组中的一个常比例部分，数组大小就会以几何级数迅速减小。**它的时间复杂度为Θ(n)**，但其隐藏的倍数常量太大。

我们引入随机化的思想，也可以完成元素选择（代码取自 Ch14:随机算法）

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



