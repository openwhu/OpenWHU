# 自定义的array  
# 在原生Python中，二维数组访问通过List(list)访问，L[i][j] 不够自然L[i, j]
# 自定义一个二维数组类

class array(object):
	"""docstring for array"""
	def __init__(self, m, n):
		super(array, self).__init__()
		self._data = [None] * m * n
		self._rows = m
		self._cols = n

	def __getitem__(self, key):
		row, col = self._validate_key(key)
		return self._data[row*self._cols+col]

	def __setitem__(self, key, value):
		row, col = self._validate_key(key)
		self._data[row*self._cols+col] = value

	def _validate_key(self, key):
		row, col = key
		if (0 <=row < self._rows and
			0 <= col < self._cols):
			return key 
		raise KeyError("Subscript out of range {}".format(key))

	def __repr__(self):
		l = []
		for i in range(self._rows):
			l.append([None] * self._cols)
		for i in range(self._rows):
			for j in range(self._cols):
				l[i][j] = self.__getitem__([i, j])
		return str(l)