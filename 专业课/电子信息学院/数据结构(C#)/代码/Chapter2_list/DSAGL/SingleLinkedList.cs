using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL_lib
{
    //单向链表类
    public class SingleLinkedList<T>
    {
        private SingleLinkedNode<T> head;//起标志作用的头结点

        //头结点属性
        public SingleLinkedNode<T> Head
        {
            get
            {
                return head;
            }
            set
            {
                head = value;
            }
        }

        public SingleLinkedList()
        {
            head = new SingleLinkedNode<T>();
        }

        public SingleLinkedList(SingleLinkedNode<T> f) : this()//使用this()告诉电脑调用无参数构造函数
        {
            head.Next = f;
        }

        public SingleLinkedList(T[] itemArray) : this()//使用一个数组创建线性表
        {
            SingleLinkedNode<T> rear, q;
            rear = head;//指向链表尾结点
            for (int i = 0; i < itemArray.Length; i++)
            {
                q = new SingleLinkedNode<T>(itemArray[i]);//新建一个结点
                rear.Next = q;
                rear = q;
            }
        }

        public SingleLinkedList(SingleLinkedList<T> a) : this()
        {
            SingleLinkedNode<T> p = head;
            foreach(T item in a)
            {
                SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(item);
                p.Next = new_item;
                p = p.Next;
            }
        }

        //只读属性，获取链表的长度
        public virtual int Count
        {
            get
            {
                int n = 0;
                SingleLinkedNode<T> p = head;
                while (p.Next != null)
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
                return head.Next == null;
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
                    SingleLinkedNode<T> p = head.Next;
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
            SingleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                p = p.Next;
            }
            p.Next = new_item;
        }

        public void AddRange(T[] itemArray)
        {
            SingleLinkedNode<T> p = head;
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

        public void AddRange(SingleLinkedList<T> list)
        {
            SingleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                p = p.Next;
            }
            p.Next = list.Head.Next;
        }

        public void Insert(int index, T item)
        {
            if ((index < 0) || (index >= Count))
            {
                throw new IndexOutOfRangeException("Index is out of range " + this.GetType());
            }
            else
            {
                SingleLinkedNode<T> p = head;
                SingleLinkedNode<T> q = head.Next;
                SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(item);
                for (int i = 0; i < index; i++)
                {
                    p = p.Next;
                    q = q.Next;
                }
                p.Next = new_item;
                new_item.Next = q;
            }
        }

        public void InsertRange(int index, T[] itemArray)
        {
            if ((index < 0) || (index >= Count))
            {
                throw new IndexOutOfRangeException("Index is out of range " + this.GetType());
            }
            else
            {
                SingleLinkedNode<T> p = head;
                SingleLinkedNode<T> q = head.Next;
                for (int i = 0; i < index; i++)
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

        public void Remove(T item)
        {
            SingleLinkedNode<T> p = head;
            SingleLinkedNode<T> q = head.Next;
            while (q.Next != null)
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

        public void RemoveAt(int index)
        {
            if ((index < 0) || (index >= Count))
            {
                throw new IndexOutOfRangeException("Index out of Range!!!");
            }
            else
            {
                SingleLinkedNode<T> p = head;
                SingleLinkedNode<T> q = head.Next;
                for (int i = 0; i < index; i++)
                {
                    p = p.Next;
                    q = q.Next;
                }
                p.Next = q.Next;
            }
        }

        public void RemoveRange(int index, int cnt)
        {
            if ((index < 0) || (index >= Count))
            {
                throw new IndexOutOfRangeException("Index out of Range!!!");
            }
            else
            {
                SingleLinkedNode<T> p = head;
                SingleLinkedNode<T> q;
                //定位到待删除范围最前面的元素的前一个元素
                for (int i = 0; i < index; i++)
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
            head.Next = null;
        }

        public bool Contain(T item)
        {
            bool isContain = false;
            SingleLinkedNode<T> p = head;
            while ((p.Next != null) && (!isContain))//一旦找到就可以提前退出循环
            {
                isContain = item.Equals(p.Next.Item);
                p = p.Next;
            }
            return isContain;
        }

        public int IndexOf(T item)
        {
            int index = 0;
            SingleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                if (item.Equals(p.Next.Item))//一旦找到匹配的就立刻退出函数
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
            SingleLinkedNode<T> p = head;
            int i = 0;
            while (p.Next != null)
            {
                array[i] = p.Next.Item;
                p = p.Next;
                i++;
            }
            return array;
        }

        public void Show()
        {
            SingleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                p.Next.Show();
                p = p.Next;
            }
        }

        public override string ToString()
        {
            StringBuilder s = new StringBuilder();
            SingleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                s.Append(p.Next);
                p = p.Next;
            }
            return s.ToString();
        }

        public IEnumerator<T> GetEnumerator()
        {
            SingleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                yield return p.Next.Item;
                p = p.Next;
            }
        }
    }
}
