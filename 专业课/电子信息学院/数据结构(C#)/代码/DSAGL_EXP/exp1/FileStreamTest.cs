using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp1
{
    class FileStreamTest
    {
        static void Main(string[] args)
        {
            try
            {
                StreamReader infile = File.OpenText("../../FileInputTest.txt");
                StreamWriter outfile = File.CreateText("../../FileOutputTest.txt");
                string read_mes = null;
                Stopwatch timer = new Stopwatch();

                timer.Start();
                Console.WriteLine("Original File:");
                while ((read_mes = infile.ReadLine()) != null)
                {
                    outfile.WriteLine(read_mes);
                    Console.WriteLine(read_mes);
                }
                timer.Stop();
                infile.Close();
                outfile.Close();

                Console.WriteLine();
                Console.WriteLine("Copyed File:");
                Console.WriteLine(File.ReadAllText("../../FileOutputTest.txt"));
                Console.WriteLine("It takes {0} milliseconds to copy the file.", timer.ElapsedMilliseconds);
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.WriteLine("Fail to copy the file.");
            }
        }
    }
}
