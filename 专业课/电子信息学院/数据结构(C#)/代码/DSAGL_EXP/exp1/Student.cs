using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp1
{
    class Student
    {
        private string mName;
        private string mID;
        private double mScore;
        public Student(string name, string ID, double score)
        {
            mName = name;
            mID = ID;
            mScore = score;
        }

        public Student()
        {
            mName = "student_A";
            mID = "2015301200001";
            mScore = 4.0;
        }

        public string Name
        {
            get
            {
                return mName;
            }
            set
            {
                mName = value;
            }
        }

        public string ID
        {
            get
            {
                return mID;
            }
            set
            {
                mID = value;
            }
        }

        public double Score
        {
            get
            {
                return mScore;
            }
            set
            {
                mScore = value;
            }
        }

        public override string ToString()
        {
            string s;
            s = Name + ",  " + ID + ",  " + Score;
            return s;
        }
    }
}
