using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HelloWorld
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Please input the name:");
            string str = Console.ReadLine();
            Console.WriteLine("Welcome to C#," + str);
        }
    }
}
