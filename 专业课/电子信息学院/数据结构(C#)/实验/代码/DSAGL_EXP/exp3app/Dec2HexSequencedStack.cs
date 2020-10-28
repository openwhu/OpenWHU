using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp3app
{
    class Dec2HexSequencedStack
    {
        public static void Main(string[] args)
        {
            SequencedStack<int> num = new SequencedStack<int>();
            int decimal_num = default(int), length;
            StringBuilder Hex_num = new StringBuilder();
            Console.Write("Please input a num in decimal:");
            try
            {
                decimal_num = int.Parse(Console.ReadLine());
            }
            catch (FormatException e)
            {
                Console.WriteLine("Please input a num in decimal!!! " + e.GetType());
            }
            while (decimal_num > 0)
            {
                num.Push(decimal_num % 16);
                decimal_num /= 16;
            }
            //由于栈的长度会随着Pop()的调用而变化,所以需要一个变量保存
            length = num.Count;
            for (int i = 0; i < length; i++)
            {
                Hex_num.Append(Num2Str(num.Pop()));
            }
            Console.WriteLine(Hex_num);
        }

        public static string Num2Str(int num)
        {
            string s = "";
            if (num < 10)
            {
                s = num.ToString();
            }
            else if (num == 10)
            {
                s = "A";
            }
            else if (num == 11)
            {
                s = "B";
            }
            else if (num == 12)
            {
                s = "C";
            }
            else if (num == 13)
            {
                s = "D";
            }
            else if (num == 14)
            {
                s = "E";
            }
            else if (num == 15)
            {
                s = "F";
            }
            return s;
        }
    }
}
