# RandomizedQuickSort
import random
random.seed(0)
l = list(range(1000))  # the sequence is shuffled
random.shuffle(l)


def swap(A, i, j):
	t = A[i]; A[i] = A[j]; A[j] = t;


def rquicksort(l, start, end):
	if start >= end:
		return

	# choose an element randomly
	rand_idx = random.randint(start, end) #[start, end]

	# swap start and rand_idx element
	t = l[rand_idx]; l[rand_idx] = l[start]; l[start] = t;

	# Split the sequence (可以写个函数Split)
	pivot = l[start]

	i = start; j = start + 1;
	while j <= end:
		if l[j] < pivot:
			i += 1 
			# if i == j:
			# 	continue  # 这里的意图是什么的都不做，而不是跳过这次循环！！！(pass)
			# else: # swap i and j's element
			# 	t = l[i]; l[i] = l[j]; l[j] = t;
			if i != j:
				t = l[i]; l[i] = l[j]; l[j] = t;
		j += 1 
	swap(l, start, i)
	rquicksort(l, start, i-1)
	rquicksort(l, i+1, end)

rquicksort(l, 0, len(l) -1 )

print(l)