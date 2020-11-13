# 13.17
COST = [[1,2,3],[2,1,3],[3,2,1]]
N = 3


def cal_cost(c):
	s = 0
	for p, ass in enumerate(c):
		if ass == 0: # 该人未被分配任务
			continue 
		s += COST[p][ass - 1]
	return s

def is_complete_assignment(c): # 是一个完全分配
	return c[-1] != 0 and len(set(c)) == N 

def is_legical_part(c):
	flag = False
	for p, ass in enumerate(c):
		if ass == 0:
			break
	if len(set(c[:p])) == p:
		return True
	return False



# algorithm
## 随便构造一个基本解
assignment_star = [3, 2, 1]
cost_star = cal_cost(assignment_star)

## 初始化
c = [0 for i in range(N)]
k = 0
# 回溯算法
while k >= 0:
	while c[k] < N:
		c[k] += 1
		
		cost = cal_cost(c)
		if  is_complete_assignment(c): # 是完全分配
			if cost_star > cost:
				assignment_star = c.copy() # Warning, need copy list or 'assignment_star' & c will point to one list
				cost_star = cost 
		elif cost < cost_star and k < N-1 and is_legical_part(c) : # 是合法的部分解？
			k += 1 
	c[k] = 0
	k -= 1

print(assignment_star, cost_star)


