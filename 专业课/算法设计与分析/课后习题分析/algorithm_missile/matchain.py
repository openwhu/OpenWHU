# alg 7.2 matchain (refer to page 134 of the textbook for details )


# Note: list index starting from 0
# However, in the alg on page 134 of the textbook,
# the index starts from 1. So, adding a row and colum 'constant'
# might be a wise choice.
import matplotlib.pyplot as plt 


# -1 is a placeholder
r = [-1, 4, 5, 6, 7, 2, 5, 3] # n+1 = 7
r = [-1, 5, 10, 4, 6, 10, 2]
# n: the number of matrixs. 1 bigger than the meaningfule length 
# of the list 'r'(without placeholder '-1'), while 2 bigger than
# that with placeholder '-1'
n = len(r) - 2 

# Create a Cost matrix(list) 'C'
# One more row and column for the 'C' as a result of list index starting
# from 0, not zero. So later, we can refer [i][j] directly, which is the
# same to the textbook. (if not so C[i-1][j-1] refers to the [ith][jth]
# element)
num_of_rowcolumn = n + 1
C = [[-1 for i in range(num_of_rowcolumn)] for j in range(num_of_rowcolumn)]

# range (range(start, stop, step)) function doen's include the stop element,
# so the stop element should add 1 to be included.
for i in range(1, n   +1):
	C[i][i] = 0

print(C)
plt.imshow(C, cmap = 'Greys_r')
plt.show()

for d in range(1, n-1   +1):
	for i in range(1, n-d  +1):
		j = i + d 
		C[i][j] = 1e8
		for k in range(i+1, j   +1):
			C[i][j] = min(C[i][j], C[i][k-1] + C[k][j] + r[i]*r[k]*r[j+1])


print(C[1][n])

