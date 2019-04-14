using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    public class Robot : IComparable<Robot>
    {
        private int id;
        private string name;
        private int iq;

        public int ID
        {
            get
            {
                return id;
            }
            set
            {
                id = value;
            }
        }

        public string Name
        {
            get
            {
                return name;
            }
            set
            {
                name = value;
            }
        }

        public int IQ
        {
            get
            {
                return iq;
            }
            set
            {
                iq = value;
            }
        }

        public Robot()
        {

        }

        public Robot(int ID, string Name, int IQ)
        {
            id = ID;
            name = Name;
            iq = IQ;
        }

        public override string ToString()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("ID:" + ID + "   ");
            sb.Append("Name:" + Name + "   ");
            sb.Append("IQ:" + IQ + "   ");
            return sb.ToString();
        }

        public int CompareTo(Robot other)
        {
            return id.CompareTo(other.ID);
        }
    }
}
