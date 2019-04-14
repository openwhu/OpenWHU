using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    //base on array structure
    public class LinearSearchList<T> where T : IComparable
    {
        private T[] datas;
        private int cnt;

        public LinearSearchList(int capacity)
        {
            datas = new T[capacity];
            cnt = 0;
        }

        public LinearSearchList() : this(16) { }

        public LinearSearchList(IList<T> items) : this(16)
        {
            foreach(T t in items)
            {
                Add(t);
            }
        }

        public bool Full
        {
            get
            {
                return (cnt == datas.Length);
            }
        }

        public void Add(T item)
        {
            if (Full)
            {
                enlargeCapacity();
            }
            datas[cnt] = item;
            cnt++;
        }

        public void Insert(T data, int pos)
        {
            if (Full)
            {
                enlargeCapacity();
            }
            if((pos < 0) || (pos > cnt))
            {
                throw new IndexOutOfRangeException();
            }
            else
            {
                for(int i = cnt; i > pos; i--)
                {
                    datas[i] = datas[i - 1];
                }
                datas[pos] = data;
                cnt++;
            }
        }

        public int indexOf(T data)
        {
            for(int i = 0; i < cnt; i++)
            {
                if (datas[i].Equals(data))
                {
                    return i;
                }
            }
            return -1;
        }

        public bool Contain(T data)
        {
            return BinarySearch(data) > 0;
        }

        public void enlargeCapacity()
        {
            int length = datas.Length + 16;
            T[] temp = new T[length];
            for(int i = 0; i < datas.Length; i++)
            {
                temp[i] = datas[i];
            }
            datas = temp;
        }

        public int BinarySearch(T data)
        {
            //sort the array before binary search
            Sort();
            int left, right, mid;
            left = 0;
            right = cnt - 1;
            while(left <= right)
            {
                mid = (left + right) / 2;
                if (datas[mid].Equals(data))
                {
                    return mid;
                }
                else if(datas[mid].CompareTo(data) < 0)
                {
                    left = mid + 1;
                }
                else
                {
                    right = mid - 1;
                }
            }
            return -1;
        }

        public void Sort()
        {
            for (int i = 0; i < cnt; i++)
            {
                for (int j = i; j < cnt; j++)
                {
                    if (datas[j].CompareTo(datas[i]) < 0)
                    {
                        T t = datas[j];
                        datas[j] = datas[i];
                        datas[i] = t;
                    }
                }
            }
        }

        public void Show(bool showHint = true)
        {
            if (showHint)
            {
                Console.WriteLine("LinearSearchList Test:");
            }
            for(int i = 0; i < cnt; i++)
            {
                Console.Write(datas[i] + "   ");
            }
            Console.WriteLine();
        }
    }
}
