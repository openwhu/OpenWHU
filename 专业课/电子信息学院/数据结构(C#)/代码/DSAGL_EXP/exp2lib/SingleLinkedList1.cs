using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    //不含头结点的单项链表类
    public class SingleLinkedList1<T>
    {
        SingleLinkedNode<T> first;

        public SingleLinkedNode<T> First
        {
            get
            {
                return first;
            }
        }
        public SingleLinkedList1()
        {
            first = null;
        }

        public SingleLinkedList1(SingleLinkedNode<T> item) : this()//使用this()告诉电脑调用无参数构造函数
        {
            first = item;
        }

        public SingleLinkedList1(T[] itemArray) : this()//使用一个数组创建线性表
        {
            SingleLinkedNode<T> rear, q;
            first = new SingleLinkedNode<T>(itemArray[0]);
            rear = first;//指向链表尾结点
            for (int i = 1; i < itemArray.Length; i++)
            {
                q = new SingleLinkedNode<T>(itemArray[i]);//新建一个结点
                rear.Next = q;
                rear = q;
            }
        }

        //只读属性，获取链表的长度
        public virtual int Count
        {
            get
            {
                int n = 0;
                SingleLinkedNode<T> p = first;
                while (p != null)
                {
                    n++;
                    p = p.Next;
                }
                return n;
            }
        }

        public virtual bool Empty
        {
            get
            {
                return first == null;
            }
        }

        //索引器
        public virtual T this[int i]
        {
            get
            {
                if ((i < 0) || (i >= Count))
                {
                    throw new IndexOutOfRangeException("Index is out of range " + this.GetType());
                }
                else
                {
                    SingleLinkedNode<T> p = first;
                    while (i > 0)
                    {
                        p = p.Next;
                        i--;
                    }
                    return p.Item;
                }
            }
        }

        public void Add(T item)
        {
            SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(item);
            SingleLinkedNode<T> p = first;
            if (first == null)
            {
                first = new_item;
            }
            else
            {
                while (p.Next != null)
                {
                    p = p.Next;
                }
                p.Next = new_item;
            }
        }

        public void AddRange(T[] itemArray)
        {
            SingleLinkedNode<T> p = first;
            if (first == null)
            {
                first = new SingleLinkedNode<T>(itemArray[0]);
                for (int i = 1; i < itemArray.Length; i++)
                {
                    SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(itemArray[i]);
                    p.Next = new_item;
                    p = p.Next;
                }
            }
            else
            {
                while (p.Next != null)
                {
                    p = p.Next;
                }
                for (int i = 0; i < itemArray.Length; i++)
                {
                    SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(itemArray[i]);
                    p.Next = new_item;
                    p = p.Next;
                }
            }
        }

        public void Insert(int index, T item)
        {
            if ((index < 0) || (index >= Count))
            {
                throw new IndexOutOfRangeException("Index out of range!!!");
            }
            else
            {
                if (index == 0)
                {
                    SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(item);
                    new_item.Next = first;
                    first = new_item;
                }
                else
                {
                    SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(item);
                    SingleLinkedNode<T> p = first;
                    SingleLinkedNode<T> q = first.Next;
                    for (int i = 1; i < index; i++)
                    {
                        p = p.Next;
                        q = q.Next;
                    }
                    p.Next = new_item;
                    new_item.Next = q;
                }
            }
        }

        public void InsertRange(int index, T[] itemArray)
        {
            if ((index < 0) || (index >= Count))
            {
                throw new IndexOutOfRangeException("Index out of range!!!");
            }
            else
            {
                if(index == 0)
                {
                    //保存原来的第一个元素
                    SingleLinkedNode<T> p = first;
                    first = new SingleLinkedNode<T>(itemArray[0]);
                    //新链表的第一个元素
                    SingleLinkedNode<T> q = first;
                    for (int i = 1; i < itemArray.Length; i++)
                    {
                        //新的数组有多少个元素就必须新建多少个对象
                        SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(itemArray[i]);
                        q.Next = new_item;
                        q = q.Next;
                    }
                    q.Next = p;
                }
                else
                {
                    SingleLinkedNode<T> p = first;
                    SingleLinkedNode<T> q = first.Next;
                    for (int i = 1; i < index; i++)
                    {
                        p = p.Next;
                        q = q.Next;
                    }
                    for (int i = 0; i < itemArray.Length; i++)
                    {
                        //新的数组有多少个元素就必须新建多少个对象
                        SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(itemArray[i]);
                        p.Next = new_item;
                        p = p.Next;
                    }
                    p.Next = q;
                }
            }
        }
        
        public void Remove(T item)
        {
            SingleLinkedNode<T> p = first;
            SingleLinkedNode<T> q = first.Next;
            if (item.Equals(first.Item))
            {
                first = first.Next;
            }
            else
            {
                while (q != null)
                {
                    if (item.Equals(q.Item))
                    {
                        p.Next = q.Next;
                        break;
                    }
                    p = p.Next;
                    q = q.Next;
                }
            }
        }

        public void RemoveAt(int index)
        {
            if((index < 0) || (index >= Count))
            {
                throw new IndexOutOfRangeException("Index out of range!!!");
            }
            else
            {
                SingleLinkedNode<T> p = first;
                SingleLinkedNode<T> q = first.Next;
                if (index == 0)
                {
                    first = first.Next;
                }
                else
                {
                    for (int i = 0; i < (index - 1); i++)
                    {
                        p = p.Next;
                        q = q.Next;
                    }
                    p.Next = q.Next;
                }
            }
        }

        public void RemoveRange(int index, int cnt)
        {
            if ((index < 0) || (index >= Count))
            {
                throw new IndexOutOfRangeException("Index out of range!!!");
            }
            else
            {
                SingleLinkedNode<T> p = first;
                SingleLinkedNode<T> q;
                //定位到待删除范围最前面的元素的前一个元素
                for (int i = 0; i < (index - 1); i++)
                {
                    p = p.Next;
                }
                q = p;
                //定位到待删除范围最后面的元素的后一个元素
                for (int i = 0; i < cnt; i++)
                {
                    q = q.Next;
                }
                p.Next = q.Next;
            }
        }

        public void Clear()
        {
            first = null;
        }

        public bool Contain(T item)
        {
            bool isContain = false;
            SingleLinkedNode<T> p = first;
            while ((p != null) && (!isContain))//一旦找到就可以提前退出循环
            {
                isContain = item.Equals(p.Item);
                p = p.Next;
            }
            return isContain;
        }

        public int IndexOf(T item)
        {
            int index = 0;
            SingleLinkedNode<T> p = first;
            while (p != null)
            {
                if (item.Equals(p.Item))//一旦找到匹配的就立刻退出函数
                {
                    return index;
                }
                else
                {
                    index++;
                    p = p.Next;
                }
            }
            return -1;
        }

        public T[] ToArray()
        {
            T[] array = new T[Count];
            SingleLinkedNode<T> p = first;
            int i = 0;
            while (p != null)
            {
                array[i] = p.Item;
                p = p.Next;
                i++;
            }
            return array;
        }

        public void Show()
        {
            SingleLinkedNode<T> p = first;
            while (p != null)
            {
                p.Show();
            }
        }

        public override string ToString()
        {
            StringBuilder s = new StringBuilder();
            SingleLinkedNode<T> p = first;
            while (p != null)
            {
                s.Append(p);
            }
            return s.ToString();
        }

        public IEnumerator<T> GetEnumerator()
        {
            SingleLinkedNode<T> p = first;
            while (p != null)
            {
                yield return p.Item;
                p = p.Next;
            }
        }
    }
}
