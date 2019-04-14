using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL_lib
{
    public class DoubleLinkedList<T>
    {
        private DoubleLinkedNode<T> head;

        public DoubleLinkedList()
        {
            head = new DoubleLinkedNode<T>();
        }

        public DoubleLinkedList(DoubleLinkedList<T> a) : this()
        {
            DoubleLinkedNode<T> p = head;
            foreach (T item in a)
            {
                DoubleLinkedNode<T> new_item = new DoubleLinkedNode<T>(item);
                p.Next = new_item;
                new_item.Front = p;
                p = p.Next;
            }
        }

        public DoubleLinkedNode<T> Head
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

        public void Add(T item)
        {
            DoubleLinkedNode<T> new_item = new DoubleLinkedNode<T>(item);
            DoubleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                p = p.Next;
            }
            p.Next = new_item;
            new_item.Front = p;
        }

        public void Remove(T item)
        {
            //DoubleLinkedNode<T> p = head;
            //DoubleLinkedNode<T> q = head.Next;
            //while (q.Next != null)
            //{
            //    if (item.Equals(q.Item))
            //    {
            //        p.Next = q.Next;
            //        break;
            //    }
            //    p = p.Next;
            //    q = q.Next;
            //}
            DoubleLinkedNode<T> p = head;
            while(p.Next != null)
            {
                if (item.Equals(p.Item))
                {
                    p.Front.Next = p.Next;
                    p.Next.Front = p.Front;
                    break;
                }
                p = p.Next;
            }
        }

        public int IndexOf(T item)
        {
            int index = 0;
            DoubleLinkedNode<T> p = head;
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

        public void Show()
        {
            DoubleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                p.Next.Show();
                p = p.Next;
            }
        }

        public override string ToString()
        {
            StringBuilder s = new StringBuilder();
            DoubleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                s.Append(p.Next);
                p = p.Next;
            }
            return s.ToString();
        }

        public IEnumerator<T> GetEnumerator()
        {
            DoubleLinkedNode<T> p = head;
            while (p.Next != null)
            {
                yield return p.Next.Item;
                p = p.Next;
            }
        }

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
                    DoubleLinkedNode<T> p = head.Next;
                    while (i > 0)
                    {
                        p = p.Next;
                        i--;
                    }
                    return p.Item;
                }
            }
        }

        public virtual int Count
        {
            get
            {
                int n = 0;
                DoubleLinkedNode<T> p = head;
                while (p.Next != null)
                {
                    n++;
                    p = p.Next;
                }
                return n;
            }
        }

        public void InsertSort(T item)
        {

        }

        public void Sort()
        {
            
        }
    }
}
