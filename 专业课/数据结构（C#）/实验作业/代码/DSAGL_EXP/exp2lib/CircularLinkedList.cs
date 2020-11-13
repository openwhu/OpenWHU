using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    public class CircularLinkedList<T>
    {
        private SingleLinkedNode<T> head;//起标志作用的头结点

        //头结点属性
        public SingleLinkedNode<T> Head
        {
            get
            {
                return head;
            }
        }

        public CircularLinkedList()
        {
            head = new SingleLinkedNode<T>();
            head.Next = head;
        }

        public CircularLinkedList(SingleLinkedNode<T> f) : this()//使用this()告诉电脑调用无参数构造函数
        {
            head.Next = f;
            f.Next = f;
        }

        //只读属性，获取链表的长度
        public virtual int Count
        {
            get
            {
                if (Empty)
                {
                    return 0;
                }
                else
                {
                    int n = 1;
                    SingleLinkedNode<T> p = head.Next;
                    while (p.Next != head.Next)
                    {
                        n++;
                        p = p.Next;
                    }
                    return n;
                }
            }
        }

        public virtual bool Empty
        {
            get
            {
                return head.Next == head;
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
            if (Empty)
            {
                head.Next = new_item;
                new_item.Next = head.Next;
            }
            else
            {
                SingleLinkedNode<T> p = head.Next;
                while (p.Next != head.Next)
                {
                    p = p.Next;
                }
                p.Next = new_item;
                new_item.Next = head.Next;
            }
        }

        public void Remove(T item)
        {
            if (item.Equals(this[0]))//移除头结点
            {
                SingleLinkedNode<T> p = head.Next;
                while (p.Next != head.Next)
                {
                    p = p.Next;
                }
                p.Next = head.Next.Next;
                head.Next = head.Next.Next;
            }
            else if (item.Equals(this[Count - 1]))//移除尾结点
            {
                SingleLinkedNode<T> p = head;
                SingleLinkedNode<T> q = head.Next;
                while (q.Next != head.Next)
                {
                    p = p.Next;
                    q = q.Next;
                }
                p.Next = head.Next;
            }
            else//移除中间结点
            {
                SingleLinkedNode<T> p = head;
                SingleLinkedNode<T> q = head.Next;
                while (q.Next != head.Next)
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

        public void Clear()
        {
            head.Next = head;
        }

        public bool Contain(T item)
        {
            if (Empty)
            {
                return false;
            }
            else
            {
                bool isContain = false;
                SingleLinkedNode<T> p = head.Next;
                while ((p.Next != head.Next) && (!isContain))//一旦找到就可以提前退出循环
                {
                    isContain = item.Equals(p.Next.Item);
                    p = p.Next;
                }
                return isContain;
            }
        }

        public void Show()
        {
            if (!Empty)
            {
                SingleLinkedNode<T> p = head.Next;
                while (p.Next != head.Next)
                {
                    p.Show();
                    Console.Write("  ");
                    p = p.Next;
                }
                p.Show();
            }
        }

        public override string ToString()
        {
            StringBuilder s = new StringBuilder();
            SingleLinkedNode<T> p = head;
            while (p.Next.Next != head.Next)
            {
                s.Append(p.Next);
                p = p.Next;
            }
            return s.ToString();
        }
    }
}
