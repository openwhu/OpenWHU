using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp4app
{
    class ByOneListTest
    {
        static void Main(string[] args)
        {
            int[] datas = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
            BinaryTree<int> tree = BinaryTree<int>.ByOneList(datas);
            tree.ShowPreOrder(true);
            tree.ShowMidOrder(true);
            tree.ShowPostOrder(true);
            tree.ShowByLevel(true);
        }
    }
}
