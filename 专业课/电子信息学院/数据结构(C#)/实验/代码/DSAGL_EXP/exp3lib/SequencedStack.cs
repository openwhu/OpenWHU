using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using exp2lib;

namespace DSAGL
{
    public class SequencedStack<T> : SingleLinkedList<T>
    {
        private SingleLinkedNode<T> top;

        public SequencedStack() : base()
        {
            top = base.Head.Next;//指向第一个数据元素
        }

        public override bool Empty
        {
            get
            {
                return top == null;
            }
        }

        public void Push(T item)
        {
            SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(item);
            new_item.Next = top;
            top = new_item;
            base.Head.Next = top;
        }

        public T Pop()
        {
            if (Empty)
            {
                throw new InvalidOperationException("Stack is empty" + this.GetType());
            }
            else
            {
                T value = default(T);
                value = top.Item;
                top = top.Next;
                base.Head.Next = top;
                return value;
            }
        }

        public T Peek()
        {
            if (Empty)
            {
                throw new InvalidOperationException("Stack is empty" + this.GetType());
            }
            else
            {
                return top.Item;
            }
        }
    }
}
