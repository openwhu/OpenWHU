using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp6app
{
    class SortArrayTest
    {
        static void Main(string[] args)
        {
            const int ARRAY_SIZE = 20;
            int[] datas = new int[ARRAY_SIZE];
            //initiate the array
            RandomData(datas, -99, 99);
            Console.WriteLine("before sort:");
            Show(datas, false);
            Array.Sort(datas);
            Console.WriteLine("after sort:");
            Show(datas, false);
            Array.Sort(datas, new AbsCompare());
            Console.WriteLine("after abs sort:");
            Show(datas, false);
        }

        public static void RandomData(int[] array, int minValue, int maxValue)
        {
            Random rd = new Random();
            for (int i = 0; i < array.Length; i++)
            {
                array[i] = rd.Next(minValue, maxValue);
            }
        }

        public static void Show(int[] datas, bool showHint = true)
        {
            if (showHint)
            {
                Console.WriteLine("Array:");
            }
            foreach(int t in datas)
            {
                Console.Write(t + "   ");
            }
            Console.WriteLine();
        }
    }

    class AbsCompare : IComparer<int>
    {
        public int Compare(int x, int y)
        {
            return (Math.Abs(x)).CompareTo((Math.Abs(y)));
        }
    }
}
