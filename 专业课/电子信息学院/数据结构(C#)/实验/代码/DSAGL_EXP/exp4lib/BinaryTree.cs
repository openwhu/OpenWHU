using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    public class BinaryTree<T>
    {
        private BinaryTreeNode<T> root;

        private static int index;

        public BinaryTree()
        {
            root = null;
        }

        public BinaryTreeNode<T> Root
        {
            get
            {
                return root;
            }
            set
            {
                root = value;
            }
        }

        public void ShowPreOrder(bool showTypeName)
        {
            if (showTypeName)
            {
                Console.Write("PreOrder:");
            }
            if (root != null)
            {
                root.ShowPreOrder();
            }
        }

        public void ShowMidOrder(bool showTypeName)
        {
            if (showTypeName)
            {
                Console.Write("MidOrder:");
            }
            if (root != null)
            {
                root.ShowMidOrder();
            }
        }

        public void ShowPostOrder(bool showTypeName)
        {
            if (showTypeName)
            {
                Console.Write("PostOrder:");
            }
            if (root != null)
            {
                root.ShowPostOrder();
            }
        }

        public void ShowByLevel(bool showTypeName)
        {
            if (showTypeName)
            {
                Console.Write("ByLevel:");
            }
            if (root != null)
            {
                root.ShowByLevel();
            }
        }

        public List<T> GetPreOrder()
        {
            if (root != null)
            {
                return root.GetPreOrder();
            }
            return null;
        }

        public List<T> GetMidOrder()
        {
            if (root != null)
            {
                return root.GetMidOrder();
            }
            return null;
        }

        public List<T> GetPostOrder()
        {
            if (root != null)
            {
                return root.GetPostOrder();
            }
            return null;
        }

        public List<T> GetByLevel()
        {
            if (root != null)
            {
                return root.GetByLevel();
            }
            return null;
        }

        public static BinaryTree<T> ByOneList(IList<T> datas)
        {
            BinaryTree<T> tree = new BinaryTree<T>();
            List<BinaryTreeNode<T>> nodes = new List<BinaryTreeNode<T>>();
            foreach(T data in datas)
            {
                nodes.Add(new BinaryTreeNode<T>(data));
            }
            int j, length;
            length = nodes.Count;
            for(int i = 0; i < length; i++)
            {
                j = 2 * i + 1;
                if(j < length)
                {
                    nodes[i].Left = nodes[j];
                }
                j++;
                if (j < length)
                {
                    nodes[i].Right = nodes[j];
                }
            }
            tree.Root = nodes[0];
            return tree;
        }

        public static BinaryTree<T> ByOneList(IList<T> datas, ListFlagStruc<T> flags)
        {
            BinaryTree<T> tree = new BinaryTree<T>();
            BinaryTree<T>.index = 0;
            if(datas.Count > 0)
            {
                tree.Root = OrderByOneList(datas, flags);
            }
            return tree;
        }

        public static BinaryTreeNode<T> OrderByOneList(IList<T> datas, ListFlagStruc<T> flags)
        {
            BinaryTreeNode<T> node = null;
            T nodedata = datas[index];
            if (IsData(nodedata, flags))
            {
                node = new BinaryTreeNode<T>(nodedata);
                index++;
                nodedata = datas[index];
                if (nodedata.Equals(flags.LeftDeLimit))
                {
                    index++;
                    node.Left = OrderByOneList(datas, flags);
                    index++;
                    node.Right = OrderByOneList(datas, flags);
                    index++;
                }
            }
            if (nodedata.Equals(flags.NullSubTree))
            {
                index++;
            }
            return node;
        }

        private static bool IsData(T nodeData, ListFlagStruc<T> flags)
        {
            if(nodeData.Equals(flags.NullSubTree) ||
               nodeData.Equals(flags.LeftDeLimit) ||
               nodeData.Equals(flags.RightDeLimit)||
               nodeData.Equals(flags.MiddleDeLimit))
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        
    }

    public struct ListFlagStruc<T>
    {
        public T NullSubTree;
        public T LeftDeLimit;
        public T RightDeLimit;
        public T MiddleDeLimit;
    }
}
