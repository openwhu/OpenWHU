using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp2app
{
    class GenericList
    {
        static void Main(string[] args)
        {
            //整型的线性表
            //使用系统默认的List
            /*
            List<int> array_int = new List<int>();
            array_int.Add(100);
            array_int.Insert(1, 150);
            Console.WriteLine("This is an int list:");
            foreach (int item in array_int)
            {
                Console.Write(item + "  ");
            }
            Console.WriteLine();
             */
            //使用自己写的List
            SingleLinkedList1<int> list_int = new SingleLinkedList1<int>();

            list_int.Add(100);
            list_int.Add(150);
            list_int.Add(200);
            int[] test_array1 = { 1, 2, 3 };
            list_int.AddRange(test_array1);

            list_int.Insert(1, 120);
            int[] test_array2 = { 4, 5, 6 };
            list_int.InsertRange(2, test_array2);

            list_int.Remove(150);
            list_int.RemoveAt(3);
            list_int.RemoveRange(2, 2);

            int[] array_int = list_int.ToArray();

            Console.WriteLine("This is an my list({0} items):",list_int.Count);
            foreach(var item in list_int)
            {
                Console.Write(item + "  ");
            }
            Console.WriteLine();

            Console.WriteLine("This is an my list to array:");
            foreach(var item in array_int)
            {
                Console.Write(item + "  ");
            }
            Console.WriteLine();

            if (list_int.Contain(110))
            {
                Console.WriteLine("The list contains 110!!!");
            }
            else
            {
                Console.WriteLine("The list doesn't contain 110!!!");
            }
            Console.WriteLine("Clear the whole list......");
            list_int.Clear();
            if (list_int.Empty)
            {
                Console.WriteLine("The list is empty!!!");
            }
            else
            {
                Console.WriteLine("The list is not empty!!!");
            }
            Console.WriteLine();
            Console.WriteLine();

            //自定义类型的线性表
            //使用系统默认的List
            /*
            List<Student> array_student = new List<Student>();
            array_student.Add(new Student("student_A", "2015301200001", 4.4));
            array_student.Insert(1, new Student("student_B", "2015301200002", 3.3));
            Console.WriteLine("This is a student list:");
            foreach (Student item in array_student)
            {
                Console.WriteLine(item);
            }
            */
            //使用自己写的List
            SingleLinkedList<Student> list_student = new SingleLinkedList<Student>();
            list_student.Add(new Student("student_A", "2015301200001", 4.4));
            list_student.Add(new Student("student_B", "2015301200002", 3.3));
            list_student.Insert(1, new Student("student_C", "2015301200003", 2.2));
            Console.WriteLine("This is a my student list:");
            foreach(var item in list_student)
            {
                Console.WriteLine(item);
            }
        }
    }
}
