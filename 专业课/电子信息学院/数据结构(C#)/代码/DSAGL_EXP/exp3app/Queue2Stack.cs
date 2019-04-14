using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp3app
{
    class Queue2Stack
    {
        public static void Main(string[] args)
        {
            Queue<int> queue = new Queue<int>();
            Stack<int> stack = new Stack<int>();
            int length = 0;
            queue.Enqueue(10);
            queue.Enqueue(20);
            queue.Enqueue(30);
            queue.Enqueue(50);
            queue.Enqueue(50);
            queue.Enqueue(60);
            Console.WriteLine("The num in original order:");
            length = queue.Count;
            for (int i = 0;i < length; i++)
            {
                int temp = queue.Dequeue();
                Console.Write(temp + "  ");
                stack.Push(temp);
            }
            Console.WriteLine();
            Console.WriteLine("The num in reverse order:");
            length = stack.Count;
            for(int i = 0;i< length; i++)
            {
                Console.Write(stack.Pop() + "  ");
            }
            Console.WriteLine();
        }
    }
}
