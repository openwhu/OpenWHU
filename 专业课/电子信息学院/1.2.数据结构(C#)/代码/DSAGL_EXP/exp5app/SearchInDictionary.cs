using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp5app
{
    class SearchInDictionary
    {
        public static void Main(string[] args)
        {
            const int TOTAL_SIZE = 5000;
            Stopwatch stopwatch = new Stopwatch();
            Random random = new Random();
            int[] num_array = new int[TOTAL_SIZE];
            Dictionary<int, int> num_dictionary = new Dictionary<int, int>(TOTAL_SIZE);
            int[] findValue = { 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105,
                           115, 125, 135, 145, 155, 165, 175, 185, 195 };
            //initiate the array
            for (int i = 0; i < TOTAL_SIZE; i++)
            {
                int t = random.Next(1000);
                num_array[i] = t;
                num_dictionary.Add(i, t);
            }
            //search in array
            stopwatch.Start();
            for (int i = 0; i < findValue.Length; i++)
            {
                for (int j = 0; j < TOTAL_SIZE; j++)
                {
                    if (num_array[j] == findValue[i])
                    {
                        //Console.WriteLine(array[j]);
                        break;
                    }
                }
            }
            stopwatch.Stop();
            Console.Write("顺序查找耗时：");
            Console.WriteLine(stopwatch.Elapsed.TotalMilliseconds + "ms");
            //search in dictionary
            stopwatch.Restart();
            for (int i = 0; i < findValue.Length; i++)
            {
                num_dictionary.ContainsValue(findValue[i]);
            }
            stopwatch.Stop();
            Console.Write("字典查找耗时：");
            Console.WriteLine(stopwatch.Elapsed.TotalMilliseconds + "ms");

            /*
            //sort in dictionary(use LINQ)
            var result = from pair in num_dictionary orderby pair.Value select pair;

            foreach (KeyValuePair<int, int> pair in result)
            {
                Console.WriteLine("Key:{0}, Value:{1}", pair.Key, pair.Value);
            }*/
        }
    }
}
