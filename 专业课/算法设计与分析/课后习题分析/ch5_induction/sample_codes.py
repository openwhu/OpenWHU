# 归纳法   课文讲解里面的代码


## 5.4 整数幂   ##################################################################
### 求x的n次幂
def exp_rec(x, n):
	power(x, n)

def power(x, m):
	if m == 0:
		y = 1
	else:
		y = power(x, m//2)
		y = y**2
		if m%2==1:
			y = x*y
	return y

## 5.5 多项式求值
### [a0, a1, ..., an]
def horner(A):
	p = an 
	for j in [1, ..., n]:
		p = x * p + a_n-j
	return p 

## 5.6 生成排列 ##################################################################
### 生成 n 个数的排列
def permutations1(n):
	P = list(range(n)) 
	perm1(0, P, n) #

def perm1(m, P, n):
	# 生成P中 从m开始到结束的所有元素的 全排列,并置于P[m:]中
	if m == n-1:
		print(P)
	else:
		for j in range(m, n):
			P[m], P[j] = P[j], P[m]
			perm1(m+1, P, n)
			P[m], P[j] = P[j], P[m]


def permutations2(n):
	P = [0] * n # 0 or not 0 indicating 某个位置是否被放了元素
	perm2(n-1, P, n)

def perm2(m, P, n):
	# 把m放在P中所有可能的地方 然后继续向下放置m-1 m-2 m-3
	if m==0:
		print(P)
	else:
		for j in range(n):
			if P[j] == 0:
				P[j] = m 
				perm2(m-1, P, n)
				P[j] = 0

# permutations2(3)

##############################################################################
# 5.7 寻找多数元素(超过一半的元素)
## 使用一个计数器cnt和基准元素 遇到基准元素相等的就+1 否则-1 为0时跟新基准元素
def majority(A):
	c = candidate(0, A)
	cnt = 0
	for a in A:
		if a == c:	cnt+=1
	if cnt > len(A)/2:
		return c
	else:
		return None

# 递归形式
def candidate(m, A):
	# 寻找可能多大元素的子例程。 从A[m:]开始寻找可能极大元素。
	j = m; c = A[m]; cnt=1
	n = len(A)
	while j< n-1 and cnt>0:
		j +=1
		if A[j]==c:	
			cnt +=1
		else:
			cnt -=1
	if j==n-1:
		return c
	else:
		return candidate(j+1, A)

# 迭代形式
def candidate2(A):
	i = 1; c = A[0]; cnt = 1
	while i < len(A):
		if cnt==0:
			c = A[i] # 如果计数器已经为0 则需要更新c和cnt
			cnt = 1
		elif c ==A[i]:
			cnt += 1
		else:
			cnt -=1
		i +=1
	return c

if __name__ == '__main__':
	
	target = [1, 2, 3, 5, 6, 7, 1, 1, 1, 1, 1, 1, 3, 4, 2, 5, 2, 1, 5, 1, 7, 1, 8, 1, 9, 110,1, 1, 1,1 , 1, 1]
	print(target.count(1), len(target))
	print(majority(target))
