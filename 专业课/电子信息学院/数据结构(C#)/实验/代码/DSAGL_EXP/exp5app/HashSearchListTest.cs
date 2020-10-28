using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp5app
{
    class HashSearchListTest
    {
        public static void Main(string[] args)
        {
            int[] datas = { 10, 20, 50, 100, 12, 35, 41, 173, 26, 554, 12, 365, 412, 32 };
            HashSearchList<int> hashsearch = new HashSearchList<int>(datas);
            hashsearch.Show();
            Console.WriteLine();
            int findvalue = 168;
            Console.WriteLine("{0} is {1} the set.", 
                findvalue, (hashsearch.Contain(findvalue)) ? "in" : "not in");
            findvalue = 173;
            Console.WriteLine("{0} is {1} the set.",
                findvalue, (hashsearch.Contain(findvalue)) ? "in" : "not in");
        }
    }
}
