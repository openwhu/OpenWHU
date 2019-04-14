using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp1
{
    class Complex_test
    {
        static void Main(string[] args)
        {
            //用不同的构造方法创建复数
            Complex c1 = new Complex(1, 1);
            Complex c2 = new Complex(c1);
            Complex c3 = new Complex();
            c3.Real = 2;
            c3.Image = 3;

            Console.WriteLine("c1 = " + c1);
            Console.WriteLine("c2 = " + c2);
            Console.WriteLine("c3 = " + c3);
            Console.WriteLine("|c1| = " + c1.Abs().ToString("F3"));
            Console.WriteLine("c1 = c2 ? " + c1.Equal(c2).ToString());
            Console.WriteLine("c1 + c3 = " + (c1 + c3));
            Console.WriteLine("c1 - c3 = " + (c1 - c3));
            Console.WriteLine("c1 * c3 = " + (c1 * c3));
            Console.WriteLine("c1 / c3 = " + (c1 / c3));
        }
    }
}
