import sys
sys.path.append("../")
from algorithm_missile.arr import array

# 7.2 LCS two strings  A & B
def lcs(A:str, B:str):
	m, n = len(A), len(B)
	L = array(m+1, n+1)
	for i in range(m+1):
		L[i, 0] = 0
	for j in range(n+1):
		L[0, j] = 0
	s = []
	for i in range(1, m+1):
		for j in range(1, n+1):
			if A[i-1]==B[j-1]:
				L[i, j] = L[i-1, j-1] + 1
			else:
				L[i, j] = max(L[i-1, j], L[i, j-1])
	print(L[m, n])
	print(L)
	# # 下面这种逻辑有问题！
	# i, j = m, n
	# while i>0 and j>0:
	# 	if L[i, j] == L[i-1, j-1] + 1:
	# 		s.append(A[i-1])
	# 		# s.append(B[j-1])
	# 		i, j = i-1, j-1
	# 	else:
	# 		i, j = (i-1, j) if L[i-1, j] > L[i, j-1] else (i, j-1)

	i, j = 0, 0
	while i < m and j < n:
		if L[i+1, j+1] == L[i, j] +1:
			s.append(A[i])
			i, j = i+1, j+1
		else:
			j += 1
	while i < m:
		if L[i+1, j] == L[i, j] +1:
			s.append(A[i])
		i +=1

	print(s)
	print(all_lcss(A, B, L))

def all_lcss(A, B, L):
	res = []
	find(A, B, L, len(A), len(B), res, [])
	return res
def find(A, B, L, i, j, res, stack):
	while i > 0 and j>0:
		if A[i-1]==B[j-1]:
			stack.append(A[i-1])
			i, j = i-1, j-1
		else:
			if L[i-1, j] > L[i, j-1]:
				i -= 1
			elif L[i-1, j] < L[i, j-1]:
				j -= 1
			else:
				find(A, B, L, i-1, j, res, stack.copy())
				find(A, B, L, i, j-1, res, stack.copy())

				return;
	if not stack in res:
		res.append(stack.copy())

if __name__ == '__main__':
	a = 'xzyzxz'
	b ='xyyyxz'
	lcs(a, b)