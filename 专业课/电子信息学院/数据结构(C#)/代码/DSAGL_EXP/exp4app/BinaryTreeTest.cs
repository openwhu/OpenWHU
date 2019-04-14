using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp4app
{
    class BinaryTreeTest
    {
        static void Main(string[] args)
        {
            BinaryTree<int> tree = new BinaryTree<int>();
            tree.Root = new BinaryTreeNode<int>(1);
            tree.Root.Left = new BinaryTreeNode<int>(2);
            tree.Root.Left.Left = new BinaryTreeNode<int>(4);
            tree.Root.Left.Left.Right = new BinaryTreeNode<int>(7);
            tree.Root.Right = new BinaryTreeNode<int>(3);
            tree.Root.Right.Left = new BinaryTreeNode<int>(5);
            tree.Root.Right.Right = new BinaryTreeNode<int>(6);
            tree.Root.Right.Right.Left = new BinaryTreeNode<int>(8);
            tree.ShowPreOrder(true);
            tree.ShowMidOrder(true);
            tree.ShowPostOrder(true);
            tree.ShowByLevel(true);
        }
    }
}
