# coding: utf-8
'''
P160 8.16 
'''

def disp_path(path):
	'''
	对每一个除 源点 0 以外的点 1.. 回溯其路径保存输出
	'''
	for i in range(1, len(path)):
		print('path of 0 ->',i)
		p = []
		j = i
		while path[j] != 0:
			p.append(path[j])
			j = path[j]
		p = p[::-1]
		print('0 ->', end = ' ')
		for j in range(len(p)):
			print(p[j], end = ' -> ')
		print(i)


if __name__ == '__main__':
	inf = float('inf')

	G = [[0, 1, 3, inf],
		 [1, 0, 1, 6],
		 [3, 1, 0, 4],
		 [inf, 6, 4, 0]]  # 以邻接矩阵存储的图
	# 计算 0 节点到其他节点的距离
	dist = G[0]  # dist[] holds dists from v to other vertex
	path = [0, 0, 0, -1]

	S = {0}
	U = {1, 2, 3}
	while len(U) > 0:
		# 选择距离最小的点
		mindis = inf
		for j in U:
			if dist[j] <= mindis:
				u = j
				mindis = dist[j]
		S.add(u)
		# print(u)
		U.remove(u)

		for j in U:
			if dist[u] + G[u][j] < dist[j]:
				dist[j] = dist[u] + G[u][j]
				# 始终保持源点经过 S 中的点到 U 中节点距离最小
				path[j] = u
		del u
	print(dist)
	disp_path(path)