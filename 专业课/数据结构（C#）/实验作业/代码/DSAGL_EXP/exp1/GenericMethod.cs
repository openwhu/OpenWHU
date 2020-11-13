using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp1
{
    class GenericMethod
    {
        static void Main(string[] agrs)
        {
            int num1 = 10, num2 = 20;
            double num3 = 10.2, num4 = 20.2;
            string str1 = "xkw", str2 = "wolf";
            Student stu1 = new Student("student_A", "2015301200001", 4.0);
            Student stu2 = new Student("student_B", "2015301200002", 4.0);

            Console.WriteLine("Original data:");
            Console.WriteLine(num1 + " : " + num2);
            Console.WriteLine(num3 + " : " + num4);
            Console.WriteLine(str1 + " : " + str2);
            Console.WriteLine(stu1 + " : " + stu2);

            Swap(ref num1, ref num2);
            Swap(ref num3, ref num4);
            Swap(ref str1, ref str2);
            Swap(ref stu1, ref stu2);

            Console.WriteLine();
            Console.WriteLine("Sorted Data:");
            Console.WriteLine(num1 + " : " + num2);
            Console.WriteLine(num3 + " : " + num4);
            Console.WriteLine(str1 + " : " + str2);
            Console.WriteLine(stu1 + " : " + stu2);
        }

        public static void Swap<T>(ref T a,ref T b)
        {
            T temp;
            temp = a;
            a = b;
            b = temp;
        }
    }
}
