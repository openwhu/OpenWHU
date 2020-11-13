
def ljl_matchain(r, n):
	# r: 一个序列 表示矩阵的一系列形状 
	# n: number of Mats
	assert len(r) - 1 == n, "Tne number of Mats must is not compatible to r"

	C = [[0 for i in range(n)] for j in range(n)]
	for i in range(n):
		C[i][i] = 0

	for d in range(1, n): # fill diagnal 1->(n-1)
		for i in range(n-d):  # fill diagal di's items
			j = d + i
			C[i][j] = float('inf') # positive infinity
			for k in range(i,j):
				C[i][j] = min(C[i][j], C[i][k] + C[k+1][j] + r[i]*r[j+1]*r[k+1])

	return C[0][n-1]
	print(C[0][n-1])
	print(C)

r = [30, 35, 15, 5, 10, 20, 25]
n = len(r) - 1

print( ljl_matchain(r, len(r) - 1) )


