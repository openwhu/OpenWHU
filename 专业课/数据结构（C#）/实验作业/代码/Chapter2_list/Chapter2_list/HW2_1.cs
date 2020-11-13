using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL_lib;

namespace Chapter2_list
{
    class HW2_1
    {
        public static void Main(string[] args)
        {
            SingleLinkedList<int> list1 = new SingleLinkedList<int>();
            for(int i = 0;i < 10; i++)
            {
                list1.Add(i + 1);
            }
            SingleLinkedList<int> list2 = new SingleLinkedList<int>(list1);
            list1.AddRange(list2);
            list1.Show();
            Console.WriteLine();
            list2.Show();
            Console.WriteLine();
            Console.WriteLine(Sum(list1));

            int[] test = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
            String s = toString(test);
            Console.WriteLine(s);

            DoubleLinkedList<int> list3 = new DoubleLinkedList<int>();
            for (int i = 10; i < 20; i++)
            {
                list3.Add(i + 1);
            }
            list3.Remove(15);
            list3.Show();
            Console.WriteLine();
            Console.WriteLine(list3.IndexOf(12));
            DoubleLinkedList<int> list4 = new DoubleLinkedList<int>(list3);
            list4.Show();
            Console.WriteLine();

            int[] aa = { 10, 15, 20, 12, 13, 19 };
            for(int i = 0; i < aa.Length; i++)
            {
                for(int j = i; j < aa.Length; j++)
                {
                    if(aa[j] < aa[i])
                    {
                        int temp = aa[i];
                        aa[i] = aa[j];
                        aa[j] = temp;
                    }
                }
            }
            for(int i = 0;i < aa.Length; i++)
            {
                Console.Write(aa[i].ToString() + ' ');
            }
            Console.WriteLine();
            Console.WriteLine();

            DoubleLinkedList<int> list5 = new DoubleLinkedList<int>();
            list5.Add(10);
            list5.Add(20);
            list5.Add(15);
            list5.Add(11);
            list5.Add(30);
            list5.Show();
            Console.WriteLine();
            //InsertSort(list5, 14);
            Sort(list5);
            list5.Show();
            Console.WriteLine();
            
            //list5.Show();
            //Console.WriteLine();
        }

        public static int Sum(SingleLinkedList<int> list1)
        {
            int sum = 0;
            SingleLinkedNode<int> p = list1.Head;
            while(p.Next != null)
            {
                sum += p.Next.Item;
                p = p.Next;
            }
            return sum;
        }

        public static string toString<T>(T[] items)
        {
            StringBuilder s = new StringBuilder();
            for (int i = 0; i < items.Length; i++)
            {
                s.Append(items[i]);
            }
            return s.ToString();
        }

        public static void Sort(DoubleLinkedList<int> list)
        {
            //可以用CompareTo函数，那样就可以使用泛型了
            for (int i = 0; i < list.Count; i++)
            {
                for (int j = i; j < list.Count; j++)
                {
                    if (list[j] < list[i])
                    {
                        Exchange(list, j, i);
                    }
                }
            }
        }

        public static void Exchange(DoubleLinkedList<int> list, int small, int big)
        {
            int cnt = 0;
            int num_small = list[small], num_big = list[big];
            DoubleLinkedNode<int> p = list.Head;
            while (p.Next != null)
            {
                p = p.Next;
                if (cnt == big)
                {
                    p.Item = num_small;
                }
                else if (cnt == small)
                {
                    p.Item = num_big;
                    break;
                }
                cnt++;
            }
        }

        public static void InsertSort(DoubleLinkedList<int> list,int num)
        {
            Sort(list);
            DoubleLinkedNode<int> p = list.Head.Next;
            DoubleLinkedNode<int> item = new DoubleLinkedNode<int>(num);
            while (p != null)
            {
                if((p.Item < num) && (p.Next.Item > num))
                {
                    item.Front = p;
                    item.Next = p.Next;
                    p.Next.Front = item;
                    p.Next = item;
                }
                p = p.Next;
            }
        }
    }
}
