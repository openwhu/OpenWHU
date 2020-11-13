using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp1
{
    class ArrayTest
    {
        static void Main(string[] args)
        {
            int[] array = new int[20];

            RandomData(array, -99, 99);//随机初始化数组
            Show(array);//打印数组

            int i = Array.IndexOf<int>(array, array[10]);
            Console.WriteLine("{0}th number is: {1}", i + 1, array[10]);
            Console.WriteLine("Min of the array is {0}", array.Min());
            Console.WriteLine("Sorted Array: ");
            Array.Sort(array);
            Show(array);

            RandomData(array, -99, 99);
            Array.Sort(array, new AbsCompare());
            Console.WriteLine("Sorted by absolute value:");
            Show(array);
        }

        public static void RandomData(int[] array,int minValue,int maxValue)
        {
            Random rd = new Random();
            for(int i = 0;i < array.Length; i++)
            {
                array[i] = rd.Next(minValue, maxValue);
            }
        }

        public static void Show(int[] array)
        {
            for(int i = 0; i < array.Length; i++)
            {
                Console.Write(array[i] + "  ");
            }
            Console.WriteLine();//换行
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
