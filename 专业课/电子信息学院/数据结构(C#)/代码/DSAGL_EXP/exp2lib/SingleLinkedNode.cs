using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    public class SingleLinkedNode<T>
    {
        private T item;//数据域
        private SingleLinkedNode<T> next;//指针域

        public SingleLinkedNode(T k)
        {
            item = k;
            next = null;
        }

        public SingleLinkedNode()
        {
            next = null;
        }

        //结点属性：获取/设置结点值
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

        //链值属性：获取/设置链值
        public SingleLinkedNode<T> Next
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
            Console.Write(this.Item);
        }

        public override string ToString()
        {
            StringBuilder s = new StringBuilder();
            s.Append(this.Item);
            return s.ToString();
        }
    }
}
