# 基础算法
import time
import numpy as np
def knapsack(S, V, C, what_type=None):
	"""
	0/1 knapsack problem
	params:
		S: int  list indicating sizes of items
		V: int  list indicating values of items
		C:(int) the total size constraint 
		what_type: '01' / 'multi'
	return:
		biggest_value:
		assignment: a list with the same size with S or V, True for chosen.
	"""
	n = num_items = len(S)
	L = [0] * (C + 1)
	L = [L.copy() for _ in range(n+1)]

	# 初始化L[0, j] & L[i, 0] as all 0s
	if what_type == '01':
		for i in range(0, n+1):				#纵轴表示前几个物品
			for j in range(0, C+1):			#横轴代表背包容量
				if i==0 or j == 0:		
					L[i][j] = 0 	# 初始化这一步 在初始化L表格的时候已经做过了
				elif S[i-1]>j: 		# 如果第i个物品的容积大于背包容积j
					L[i][j] = L[i-1][j]
				else:
					L[i][j] = max(L[i-1][j], L[i-1][j-S[i-1]] + V[i-1])
		# now L[n][C] 表示把n个物体放入体积为C的背包中的最高价值
		# 返回前所选中的物体？ a list containing [1, 1, 0, 0, ]
		select_items = []
		for i in range(n):
			if L[i+1][C] - L[i][C] >  0: # 表示第i个物体被选中了
				select_items.append(1)
			else:
				select_items.append(0)
		return L[n][C], select_items
	else: # not 0/1 knapsack problem
		for i in range(n+1):
			for j in range(C+1):
				if i==0 or j==0:
					L[i][j] = 0
				elif S[i-1] > j:
					L[i][j] = L[i-1][j]
				else:
					L[i][j] = L[i-1][j]
					for t in range(j // S[i-1] + 1): # 2//2 == 1 range(1) 只会遍历到1前面一位！
						tmp_value = L[i-1][j - t*S[i-1]] + t * V[i-1]
						if L[i][j] < tmp_value:
							print("updating L[{}][{}]:{}".format(i, j, tmp_value))
							L[i][j] = tmp_value
			print(np.array(L), end="\n\n")
			time.sleep(3)
		return L[n][C] # 输出一种最优组合或者输出所有最优组合？

S = [2, 3, 4, 5]
V = [3, 4, 5, 7]
C = 9
print(knapsack(S, V, C, what_type=9))

	