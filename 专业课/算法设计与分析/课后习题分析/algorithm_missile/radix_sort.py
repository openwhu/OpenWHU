import time


import random
def random_nums_generator(total_nums = 100, nums_len = 9):
	L = []
	for i in range(total_nums):
		L.append(random.randint(10**(nums_len - 1), 10**nums_len - 1))
	return L

k = 100
L = random_nums_generator(100000, k)

#print(L)

L = [str(l) for l in L ]
t0 = time.time()

# Core codes are the following( algorithm in page 93) :::
# 
for j in range(k-1, -1, -1):

	aList = [[] for i in range(10)]

	for l in L:
		i = int(l[j])
		aList[i].append(l)
	L = []
	for l in aList:
		L += l
print('time spend:', time.time() - t0)
#print(L)