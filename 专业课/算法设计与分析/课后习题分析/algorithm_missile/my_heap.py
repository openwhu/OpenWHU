
class myheap(object):
    """docstring for myheap
    More details are in the IMG and in page 80 of the book."""
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

            if self._list[p_ind] < self._list[i]:
                t = self._list[i]
                self._list[i] = self._list[p_ind]
                self._list[p_ind] = t
            else:
                done = True
            i = p_ind
        return True
    def sift_down(self, i):
        n = self._list[0]
        if i< 1 or i > len(self._list) -1:
            raise ValueError("the index is out of the _list range")

        if i > int(n/2) :
            return True
        # i < 底数(number of elements in the heap)
        done = False
        
        while 2*i <= n and done == False:
            i = 2*i
            if i < self._list[0] and self._list[i+1] > self._list[i]:
                i += 1
            if self._list[int(i / 2)] < self._list[i]:
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
        self._list[i] = self._list[n]
        self._list[0] -= 1
        self._list.pop()
        self.sift_down(i)

    def delete_max(self):
        self.delete(1)
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


import time
# # TEST CODE for init and make_heap()  sift_down() function. and so on functions
# elements = [i for i in range(100)]  
# myheap = myheap(elements)
# print(myheap._list)  
# myheap.insert(5)
# print(myheap._list)

# myheap.delete(1)
# print(myheap._list)
# myheap.delete_max()
# print(myheap._list)

# myheap.heap_sort()
# print(myheap._list)
# elements = [i for i in range(100000)]  # 9.3 seconds sorting 10e4 elements
# myheap = myheap(elements)
# myheap.heap_sort()