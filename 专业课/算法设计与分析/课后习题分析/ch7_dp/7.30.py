
def solution(V, y):
	"""return min number of coin 
	params:
		V: list  representing coins' value
		y: coint's amount value
	returns:
		min number of coin
	"""
	n = len(V)
	# L 在这里用来保留中间状态 L[i][j]表示前i个coins兑换价值为j所需的最少硬币数
	# L 在这里是否需要从0开始？(不需要，L在这里有实际意义)
	L = [0] * (y+1)
	L = [L.copy() for _ in range(n+1)]


	# 初始化
	for j in range(y+1):
		L[1][j] = j
	for i in range(n+1):
		L[i][1] = 1 

	for i in range(2, n+1):			# starting from 2
		for j in range(2, y+1): 
			if V[i-1] > j:
				L[i][j] = L[i-1][j]
			else:
				tmp = []
				for t in range(j//V[i-1] + 1):
					tmp.append(L[i-1][j - t*V[i-1]] + t) # 转移方程
				L[i][j] = min(tmp)
	return L[n][y]

V = [1, 5, 7, 11]
y = 20
print(solution(V, y))