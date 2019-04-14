using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using DSAGL;

namespace exp6app
{
    class SortAlgorithmTest
    {
        static void Main(string[] args)
        {
            //用到的一些常量
            const int ARRAY_SIZE = 5000;
            const bool showResult = false;
            const int minValue = 0, maxValue = 1000;
            int[] datas = new int[ARRAY_SIZE];
            Stopwatch stopwatch = new Stopwatch();
            Sort<int> sort = new Sort<int>();

            RandomData(datas, minValue, maxValue);
            Show(datas, showResult, "Before Sort:");
            stopwatch.Restart();
            sort.QuickSort(datas, 0, datas.Count() - 1, true);
            stopwatch.Stop();
            Show(datas, showResult, "Quick Sort:");
            Console.WriteLine("Time(Quick Sort):" + stopwatch.Elapsed.TotalMilliseconds);
            Console.WriteLine();

            RandomData(datas, minValue, maxValue);
            Show(datas, showResult, "Before Sort:");
            stopwatch.Restart();
            sort.HeapSort(datas, true);
            stopwatch.Stop();
            Show(datas, showResult, "Heap Sort:");
            Console.WriteLine("Time(Heap Sort):" + stopwatch.Elapsed.TotalMilliseconds);
            Console.WriteLine();

            RandomData(datas, minValue, maxValue);
            Show(datas, showResult, "Before Sort:");
            stopwatch.Start();
            sort.MergeSort(datas, 0, datas.Count() - 1, true);
            stopwatch.Stop();
            Show(datas, showResult, "Merge Sort:");
            Console.WriteLine("Time(Merge Sort):" + stopwatch.Elapsed.TotalMilliseconds);
            Console.WriteLine();

            RandomData(datas, minValue, maxValue);
            Show(datas, showResult, "Before Sort:");
            stopwatch.Start();
            sort.ShellSort(datas, datas.Count(), true);
            stopwatch.Stop();
            Show(datas, showResult, "Shell Sort:");
            Console.WriteLine("Time(Shell Sort):" + stopwatch.Elapsed.TotalMilliseconds);
            Console.WriteLine();

            RandomData(datas, minValue, maxValue);
            Show(datas, showResult, "Before Sort:");
            stopwatch.Restart();
            sort.SelectSort(datas, true);
            stopwatch.Stop();
            Show(datas, showResult, "Select Sort:");
            Console.WriteLine("Time(Select Sort):" + stopwatch.Elapsed.TotalMilliseconds);
            Console.WriteLine();

            RandomData(datas, minValue, maxValue);
            Show(datas, showResult, "Before Sort:");
            stopwatch.Restart();
            sort.InsertSort(datas, true);
            stopwatch.Stop();
            Show(datas, showResult, "Insert Sort:");
            Console.WriteLine("Time(Insert Sort):" + stopwatch.Elapsed.TotalMilliseconds);
            Console.WriteLine();

            RandomData(datas, minValue, maxValue);
            Show(datas, showResult, "Before Sort:");
            stopwatch.Start();
            sort.BubbleSort(datas, true);
            stopwatch.Stop();
            Show(datas, showResult, "Bubble Sort:");
            Console.WriteLine("Time(Bubble Sort):" + stopwatch.Elapsed.TotalMilliseconds);
            Console.WriteLine();
        }

        public static void RandomData(int[] array, int minValue, int maxValue)
        {
            Random rd = new Random();
            for (int i = 0; i < array.Length; i++)
            {
                array[i] = rd.Next(minValue, maxValue);
            }
        }

        public static void Show(int[] datas, bool isShow, string sortType = "Bubble Sort")
        {
            if (isShow)
            {
                Console.WriteLine(sortType);
                foreach (int t in datas)
                {
                    Console.Write(t + "  ");
                }
                Console.WriteLine();
            }
        }
    }
}
