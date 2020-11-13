# LCS.py
# 


def LCS(a, b):
	'''
	寻找 a,b 返回两个字符串的最长公共子序列长度
	'''
	m = len(a) 
	n = len(b) 
	# 构建一个数组(列表)of shape(1+m, 1+n), with 0s in all place
	L = [[0 for i in range(n + 1)] for j in range(m  +1)]
	path = [[(-1, -1) for i in range(n+1)] for j in range(m + 1)]

	# 每行从左往右，从上至下依次填写列表中元素 
	for i in range(1, m + 1):
		for j in range(1, n + 1):
			# 字符串中第i个元素取值方式为a[i-1]
			if a[i - 1] == b[j - 1]: 
				L[i][j] = L[i-1][j-1] + 1
				path[i][j] = (i-1,j-1) #path[i,j]
			else: 
				if L[i][j-1] > L[i-1][j]:
					L[i][j] = L[i][j-1]
					path[i][j] = path[i][j-1]
				else:
					path[i][j] = path[i-1][j]
				L[i][j] = max(L[i][j-1], L[i-1][j])
	p = []
	i, j = m, n
	tmp = path[i][j]
	while(tmp[0]>=0):
		p.append(a[tmp[0]])
		i, j = tmp 
		# i -= 1; j -= 1; #  因为访问A序列时候 i -=1 ，所以这里不必 -1 
		tmp = path[i][j]
	print(p[::-1])
	return L[m][n]


if __name__ == '__main__':
	a = 'xyxxzxyzxy'
	b ='zxzyyzxxyxxz'
	a = 'xzxyxyz'
	b = 'xxyyzx'
	print(LCS(a, b))