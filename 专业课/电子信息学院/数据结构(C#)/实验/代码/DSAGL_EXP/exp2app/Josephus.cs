using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp2app
{
    class Josephus
    {
        static void Main(string[] args)
        {
            int n = default(int), s = default(int), d = default(int);
            Console.Write("Please enter the num of person(n):");
            try
            {
                n = int.Parse(Console.ReadLine());
            }
            catch (FormatException)
            {
                Console.WriteLine("Please enter a integer!!!");
            }
            Console.Write("Please enter the start num of person(s):");
            try
            {
                s = int.Parse(Console.ReadLine());
            }
            catch (FormatException)
            {
                Console.WriteLine("Please enter a integer!!!");
            }
            Console.Write("Please enter the exit num of person(d):");
            try
            {
                d = int.Parse(Console.ReadLine());
            }
            catch (FormatException)
            {
                Console.WriteLine("Please enter a integer!!!");
            }
            Stopwatch watch = new Stopwatch();
            watch.Start();
            JosephusStart1(n, s, d);
            watch.Stop();
            Console.WriteLine("Method1 use {0} miliseconds.", watch.ElapsedMilliseconds);
            Console.WriteLine();
            watch.Reset();
            watch.Start();
            JosephusStart2(n, s, d);
            watch.Stop();
            Console.WriteLine("Method2 use {0} miliseconds.", watch.ElapsedMilliseconds);
        }

        //出圈的人直接从链表中去掉
        public static void JosephusStart1(int n,int s,int d)
        {
            //创建包含所有人的一个链表
            CircularLinkedList<int> person = new CircularLinkedList<int>();
            for(int i = 1; i <= n; i++)
            {
                person.Add(i);
            }
            
            //定位到开始的那个人
            SingleLinkedNode<int> start_p = person.Head;
            for (int i = 0; i < s; i++)
            {
                start_p = start_p.Next;
            }

            int cnt = 0;
            StringBuilder out_sequence = new StringBuilder();
            while (person.Count > 1)
            {
                start_p = start_p.Next;
                cnt++;
                if((cnt != 0) && (cnt % d == 0))
                {
                    //利用cnt暂时存放一下出圈人的编号，可以避免新建一个变量
                    cnt = start_p.Item;
                    start_p = start_p.Next;
                    out_sequence.Append(cnt + " -> ");
                    person.Remove(cnt);
                    cnt = 0;
                    person.Show();
                    Console.WriteLine();
                }
            }
            //只剩最后一个人
            out_sequence.Append(person.Head.Next.Item);
            Console.WriteLine("Out sequence:");
            Console.WriteLine(out_sequence.ToString());
        }

        //出圈的人用OutValue表示
        public static void JosephusStart2(int n, int s, int d)
        {
            int OutValue = 0;
            //创建包含所有人的一个链表
            CircularLinkedList<int> person = new CircularLinkedList<int>();
            for (int i = 1; i <= n; i++)
            {
                person.Add(i);
            }

            //定位到开始的那个人
            SingleLinkedNode<int> start_p = person.Head;
            for (int i = 0; i < s; i++)
            {
                start_p = start_p.Next;
            }

            int cnt = 0, total = person.Count;
            StringBuilder out_sequence = new StringBuilder();
            while (total > 1)
            {
                start_p = start_p.Next;
                if (start_p.Item != OutValue)
                {
                    cnt++;
                }
                if ((cnt != 0) && (cnt % d == 0))//有一个人出圈
                {
                    out_sequence.Append(start_p.Item + " -> ");
                    start_p.Item = OutValue;
                    while(start_p.Item == 0)
                    {
                        start_p = start_p.Next;
                    }
                    cnt = 0;
                    total--;
                    person.Show();
                    Console.WriteLine();
                }
            }
            //只剩最后一个人
            while (start_p.Item == 0)
            {
                start_p = start_p.Next;
            }
            out_sequence.Append(start_p.Item);
            Console.WriteLine("Out sequence:");
            Console.WriteLine(out_sequence.ToString());
        }
    }
}
