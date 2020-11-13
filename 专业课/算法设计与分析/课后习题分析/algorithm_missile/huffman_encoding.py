'''
P161 8.31
'''

class myheap(object):
    """docstring for myheap 小根堆
    More details in page 80 of the book."""
    def __init__(self, elements):
        super(myheap, self).__init__()
        self.elements = elements
        self._list = [0]
        # 类型检查
        for e in self.elements:
            if not (isinstance(e, int) or isinstance(e, float)):
                raise ValueError("Input elemnts inappropriate. ")
            self._list.append(e)
        self._list[0] = len(self._list) - 1
        self.make_heap()
    def sift_up(self, i):
        if i< 1 or i > len(self._list) -1:
            raise ValueError("the index is out of the _list range")
        
        done = False
        if i == 1:
            return None
        
        while done == False and  i > 1:
            p_ind = int(i/2)

            if self._list[p_ind] > self._list[i]:
                t = self._list[i]
                self._list[i] = self._list[p_ind]
                self._list[p_ind] = t
            else:
                done = True
            i = p_ind
        return True
    def sift_down(self, i):
        n = self._list[0]
        if n == 0:
            return False
        elif i< 1 or i > len(self._list) - 1:
            raise ValueError("the index is out of the _list range")

        if i > int(n/2) :
            return True
        # i < 底数(number of elements in the heap)
        done = False
        
        while 2*i <= n and done == False:
            i = 2*i
            if i < self._list[0] and self._list[i+1] < self._list[i]:
                i += 1
            if self._list[int(i / 2)] > self._list[i]:
                t = self._list[i]
                self._list[i] = self._list[int(i/2)]
                self._list[int(i/2)] = t 
            else:
                done = True

    def make_heap(self):
        n = self._list[0]
        for i in range(int(n/2), 0, -1):
            self.sift_down(i)

    def insert(self, ele):
        self._list.append(ele)
        self._list[0] += 1
        n = self._list[0]
        self.sift_up(n)
    def delete(self, i):
        n = self._list[0]
        i_vertex = self._list[i]
        self._list[i] = self._list[n]

        # 先对元素进行sift_down 再进行把最后一个元素删除？
        # 不ok，万一把要delete的元素上浮了怎么办？ 还是先删除再sift_down
        # 对一个元素都没有的情况在 sift_down里面做特殊处理

        self._list.pop()
        self._list[0] -= 1
        self.sift_down(i)
        return i_vertex


    def delete_min(self):
        return self.delete(1)
    def heap_sort(self):
        t0 = time.time()
        n = self._list[0]
        for i in range(n, 1, -1):
            t = self._list[1]
            self._list[1] = self._list[i]
            self._list[i] = t 
            self._list[0] -= 1
            self.sift_down(1)
        self._list[0] = len(self._list) - 1
        t1 = time.time()
        print("Sorting elements costing time:{}".format(t1-t0))

if __name__ == '__main__':
    frequency = [7, 5, 3, 2, 12, 9]
    sort_heap = myheap(frequency)
    print(sort_heap._list)
    V = [0, 1, 2, 3, 4, 5]
    E = {}
    while sort_heap._list[0] > 0:
        f1 = sort_heap.delete_min()
        f2 = sort_heap.delete_min()
        c = f2 + f1
        frequency.append(c)
        V.append(V[-1] + 1)
        E = E + {(V[-1], )}
        print(c)
        # MMP 