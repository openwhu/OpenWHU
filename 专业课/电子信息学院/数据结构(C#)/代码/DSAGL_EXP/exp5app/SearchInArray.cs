using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Timers;

namespace exp5app
{
    class SearchInArray
    {
        static void Main(string[] args)
        {
            const int ARRAY_SIZE = 5000;
            Stopwatch stopwatch = new Stopwatch();
            Random random = new Random();
            int[] array = new int[ARRAY_SIZE];
            int[] findValue = { 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105,
                           115, 125, 135, 145, 155, 165, 175, 185, 195 };
            //initiate the array
            for(int i = 0; i < ARRAY_SIZE; i++)
            {
                array[i] = random.Next(1000);
            }
            //sequential search
            stopwatch.Start();
            for (int i = 0; i < findValue.Length; i++)
            {
                for (int j = 0; j < ARRAY_SIZE; j++)
                {
                    if (array[j] == findValue[i])
                    {
                        //Console.WriteLine(array[j]);
                        break;
                    }
                }
            }
            stopwatch.Stop();
            Console.Write("顺序查找耗时：");
            Console.WriteLine(stopwatch.Elapsed.TotalMilliseconds + "ms");
            //sort the array
            int min = 0;
            for (int i = 0; i < ARRAY_SIZE; i++)
            {
                min = i;
                for (int j = i; j < ARRAY_SIZE; j++)
                {
                    if (array[min].CompareTo(array[j]) > 0)
                    {
                        min = j;
                    }
                }
                int temp = array[min];
                array[min] = array[i];
                array[i] = temp;
            }
            //binary search
            int left, right, mid;
            stopwatch.Restart();
            for (int i = 0; i < findValue.Length; i++)
            {
                left = 0;
                right = array.Length - 1;
                while (left <= right)
                {
                    mid = (left + right) / 2;
                    if (array[mid] == findValue[i])
                    {
                        //Console.WriteLine(array[mid]);
                        break;
                    }
                    else if (array[mid] < findValue[i])
                    {
                        left = mid + 1;
                    }
                    else
                    {
                        right = mid - 1;
                    }
                }
            }
            stopwatch.Stop();
            Console.Write("二分查找耗时：");
            Console.WriteLine(stopwatch.Elapsed.TotalMilliseconds + "ms");
        }
    }
}
