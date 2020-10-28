using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FirstWindowApp
{
    public partial class Form1 : Form
    {
        float myFontSize;
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            label1.Font = new Font(label1.Font.FontFamily, ++myFontSize);
            label1.Left = (this.Width - label1.Width) / 2;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            label1.Font = new Font(label1.Font.FontFamily, --myFontSize);
            label1.Left = (this.Width - label1.Width) / 2;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            myFontSize = label1.Font.Size;
            label1.Left = (this.Width - label1.Width) / 2;
        }
    }
}
