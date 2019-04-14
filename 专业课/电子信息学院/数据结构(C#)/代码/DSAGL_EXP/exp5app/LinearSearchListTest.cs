using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp5app
{
    class LinearSearchListTest
    {
        public static void Main(string[] args)
        {
            int[] datas = { 10, 20, 50, 100, 12, 35, 41, 173, 26, 554, 12, 365, 412, 32 };
            LinearSearchList<int> linearSearch = new LinearSearchList<int>(datas);
            linearSearch.Show();
            Console.WriteLine();
            int findvalue = 168;
            Console.WriteLine("{0} is {1} the set.",
                findvalue, (linearSearch.indexOf(findvalue) > 0) ? "in" : "not in");
            findvalue = 173;
            Console.WriteLine("{0} is {1} the set.",
                findvalue, (linearSearch.BinarySearch(findvalue) > 0) ? "in" : "not in");
            Console.WriteLine();
            Console.WriteLine("after sorted:");
            linearSearch.Show(false);
        }
    }
}
