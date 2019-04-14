using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using exp2lib;

namespace DSAGL
{
    public class SequencedQueue<T> : SingleLinkedList<T>
    {
        private SingleLinkedNode<T> front, rear;

        public SequencedQueue() : base()
        {
            front = rear = null;
        }

        public override bool Empty
        {
            get
            {
                return (front == null) && (rear == null);
            }
        }
        public void Enqueue(T item)
        {
            SingleLinkedNode<T> new_item = new SingleLinkedNode<T>(item);
            if (Empty)
            {
                Head.Next = new_item;
                front = rear = new_item;
            }
            else
            {
                rear.Next = new_item;
                rear = rear.Next;
                front = Head.Next;
            }
        }

        public T Dequeue()
        {
            if (Empty)
            {
                throw new InvalidOperationException("The queue is empty:" + this.GetType());
            }
            else
            {
                T out_item = front.Item;
                Head.Next = front.Next;
                front = Head.Next;
                return out_item;
            }
        }

        public T Peek()
        {
            return front.Item;
        }
    }
}
