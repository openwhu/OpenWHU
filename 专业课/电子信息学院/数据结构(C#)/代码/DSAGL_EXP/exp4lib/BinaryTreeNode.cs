using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    public class BinaryTreeNode<T>
    {
        private T data;
        private BinaryTreeNode<T> left, right;

        public BinaryTreeNode() {
            data = default(T);
            left = right = null;
        }

        public BinaryTreeNode(T data)
        {
            this.data = data;
        }

        public T Data
        {
            get
            {
                return data;
            }
            set
            {
                data = value;
            }
        }

        public BinaryTreeNode<T> Left
        {
            get
            {
                return left;
            }
            set
            {
                left = value;
            }
        }

        public BinaryTreeNode<T> Right
        {
            get
            {
                return right;
            }
            set
            {
                right = value;
            }
        }

        public void ShowPreOrder()
        {
            List<T> datas = this.GetPreOrder();
            foreach(T data in datas)
            {
                Console.Write(data + "->");
            }
            Console.WriteLine();
        }

        public void ShowMidOrder()
        {
            List<T> datas = this.GetMidOrder();
            foreach (T data in datas)
            {
                Console.Write(data + "->");
            }
            Console.WriteLine();
        }

        public void ShowPostOrder()
        {
            List<T> datas = this.GetPostOrder();
            foreach (T data in datas)
            {
                Console.Write(data + "->");
            }
            Console.WriteLine();
        }

        public void ShowByLevel()
        {
            List<T> datas = this.GetByLevel();
            foreach (T data in datas)
            {
                Console.Write(data + "->");
            }
            Console.WriteLine();
        }

        public List<T> GetPreOrder()
        {
            List<T> result = new List<T>();
            Stack<BinaryTreeNode<T>> st = new Stack<BinaryTreeNode<T>>();
            BinaryTreeNode<T> p = this;
            while ((p != null) || (st.Count != 0))
            {
                if(p != null)
                {
                    st.Push(p);
                    result.Add(p.Data);
                    p = p.Left;
                }
                else
                {
                    p = st.Pop();
                    p = p.Right;
                }
            }
            return result;
        }

        public List<T> GetMidOrder()
        {
            List<T> result = new List<T>();
            Stack<BinaryTreeNode<T>> st = new Stack<BinaryTreeNode<T>>();
            BinaryTreeNode<T> p = this;
            while ((p != null) || (st.Count != 0))
            {
                if (p != null)
                {
                    st.Push(p);
                    p = p.Left;
                }
                else
                {
                    p = st.Pop();
                    result.Add(p.Data);
                    p = p.Right;
                }
            }
            return result;
        }

        public List<T> GetPostOrder()
        {
            //方法1：使用两个栈
            /*List<T> result = new List<T>();
            Stack<BinaryTreeNode<T>> s1 = new Stack<BinaryTreeNode<T>>();
            Stack<BinaryTreeNode<T>> s2 = new Stack<BinaryTreeNode<T>>();
            BinaryTreeNode<T> p = this;
            s1.Push(p);
            while (s1.Count != 0)
            {
                p = s1.Pop();
                s2.Push(p);
                if (p.Left != null)
                {
                    s1.Push(p.Left);
                }
                if (p.Right != null)
                {
                    s1.Push(p.Right);
                }
            }    
            while(s2.Count != 0)//将第二个栈打印出来
            {
                result.Add(s2.Pop().Data);
            }
            return result;*/
            //方法2：使用1个栈 + 一个临时变量（最近访问的结点）
            List<T> result = new List<T>();
            Stack<BinaryTreeNode<T>> st = new Stack<BinaryTreeNode<T>>();
            BinaryTreeNode<T> p, q;
            st.Push(this);
            q = this;
            while(st.Count != 0)
            {
                p = st.Peek();
                if((p.Left != null) && (p.Left != q) && (p.Right != q))
                {
                    st.Push(p.Left);
                }
                else if ((p.Right != null) && (p.Right != q))
                {
                    st.Push(p.Right);
                }
                else
                {
                    q = st.Pop();
                    result.Add(q.Data);
                }
            }
            return result;
        }

        public List<T> GetByLevel()
        {
            List<T> result = new List<T>();
            Queue<BinaryTreeNode<T>> queue = new Queue<BinaryTreeNode<T>>();
            BinaryTreeNode<T> p = this;
            while(p != null)
            {
                result.Add(p.Data);
                if (p.Left != null)
                {
                    queue.Enqueue(p.Left);
                }
                if(p.Right != null)
                {
                    queue.Enqueue(p.Right);
                }
                if(queue.Count != 0)
                {
                    p = queue.Dequeue();
                }
                else
                {
                    p = null;
                }
            }
            return result;
        }
    }
}
