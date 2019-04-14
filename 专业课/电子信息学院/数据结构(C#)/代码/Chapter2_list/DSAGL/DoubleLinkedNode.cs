using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL_lib
{
    public class DoubleLinkedNode<T>
    {
        private T item;
        private DoubleLinkedNode<T> front, next;

        public DoubleLinkedNode(T k)
        {
            item = k;
            front = next = null;
        }

        public DoubleLinkedNode()
        {
            item = default(T);
            front = next = null;
        }

        public T Item
        {
            get
            {
                return item;
            }
            set
            {
                item = value;
            }
        }

        public DoubleLinkedNode<T> Front
        {
            get
            {
                return front;
            }
            set
            {
                front = value;
            }
        }

        public DoubleLinkedNode<T> Next
        {
            get
            {
                return next;
            }
            set
            {
                next = value;
            }
        }

        public void Show()
        {
            Console.Write(this.Item.ToString() + ' ');
        }
    }
}
