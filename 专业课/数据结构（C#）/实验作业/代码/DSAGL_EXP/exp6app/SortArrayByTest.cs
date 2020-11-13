using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp6app
{
    class SortArrayByTest
    {
        static void Main(string[] args)
        {
            Robot[] robots = new Robot[5];
            robots[0] = new Robot(1, "唐僧", 100);
            robots[1] = new Robot(3, "沙僧", 80);
            robots[2] = new Robot(2, "悟空", 200);
            robots[3] = new Robot(5, "观音", 50);
            robots[4] = new Robot(4, "八戒", 300);
            Console.WriteLine("before sort:");
            Show(robots, false);
            Array.Sort(robots, new IDCompare());
            Console.WriteLine("after sort(by ID):");
            Show(robots, false);
            Array.Sort(robots, new NameCompare());
            Console.WriteLine("after sort(by Name):");
            Show(robots, false);
            Array.Sort(robots, new IQCompare());
            Console.WriteLine("after sort(by IQ):");
            Show(robots, false);
        }

        public static void Show(Robot[] datas, bool showHint = true)
        {
            if (showHint)
            {
                Console.WriteLine("Array:");
            }
            foreach (Robot t in datas)
            {
                Console.WriteLine(t);
            }
        }
    }

    class IDCompare : IComparer<Robot>
    {
        public int Compare(Robot x, Robot y)
        {
            return x.ID.CompareTo(y.ID);
        }
    }

    class NameCompare : IComparer<Robot>
    {
        public int Compare(Robot x, Robot y)
        {
            return x.Name.CompareTo(y.Name);
        }
    }

    class IQCompare : IComparer<Robot>
    {
        public int Compare(Robot x, Robot y)
        {
            return x.IQ.CompareTo(y.IQ);
        }
    }
}
