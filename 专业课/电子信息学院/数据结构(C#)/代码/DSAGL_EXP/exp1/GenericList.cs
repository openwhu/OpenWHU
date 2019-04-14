using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp1
{
    class GenericList
    {
        static void Main(string[] agrs)
        {
            //整型的线性表
            List<int> list_int = new List<int>();
            list_int.Add(100);
            list_int.Insert(1, 150);
            Console.WriteLine("This is an int list:");
            foreach(var item in list_int)
            {
                Console.Write(item + "  ");
            }
            Console.WriteLine();

            //自定义类型的线性表
            List<Student> list_student = new List<Student>();
            list_student.Add(new Student("student_A", "2015301200001", 4.4));
            list_student.Insert(1, new Student("student_B", "2015301200002", 3.3));
            Console.WriteLine("This is a student list:");
            foreach(var item in list_student)
            {
                Console.WriteLine(item);
            }
        }
    }
}
