A = 'xzyzzzyx'
B = 'zxyyzxz'
A = 'zxyxyz'
B = 'xyyzx'
import numpy as np 
# 初始化
L = [0 for i in range(len(B)+1)]
L = [L.copy() for i in range(len(A)+1)] #会受到共享内存影响吗？
## 纵行是A字符串对应的字母 / 横向是B字符串对应的字母

# 利用动态转移方程填表
# L[i][j]  表示a[i] b[j] 前面的字符串的最长公共字串的长度(包括a[i] b[j] and indexing 
# starting from 1 (not zero))
for i in range(1, len(A) + 1):
	for j in range(1, len(B) + 1):
		if A[i-1] == B[j-1]:

			L[i][j] = L[i-1][j-1] + 1
		else:
			L[i][j] = max(L[i-1][j], L[i][j-1])

print(np.array(L))

# Output LCS 
## 如果字符串中字母属于LCS, 那么到了这里它的LCS值会 增 1
lcs = []
for idx, character in enumerate(B):
	if L[-1][idx+1] - L[-1][idx] == 1:
		lcs.append(B[idx])
print(lcs)
