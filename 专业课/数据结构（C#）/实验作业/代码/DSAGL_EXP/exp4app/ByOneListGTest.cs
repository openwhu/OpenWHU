using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp4app
{
    class ByOneListGTest
    {
        static void Main(string[] args)
        {
            string equation = "1(2(4(^,7),^),3(5,6(8,^)))";
            ListFlagStruc<char> flags = new ListFlagStruc<char>();
            flags.NullSubTree = '^';
            flags.LeftDeLimit = '(';
            flags.RightDeLimit = ')';
            flags.MiddleDeLimit = ',';
            BinaryTree<char> tree = BinaryTree<char>.ByOneList(equation.ToCharArray(), flags);
            tree.ShowPreOrder(true);
            tree.ShowMidOrder(true);
            tree.ShowPostOrder(true);
            tree.ShowByLevel(true);
        }
    }
}
