using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace exp4xapp
{
    public partial class Form_exp4 : Form
    {
        public Form_exp4()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            TreeNode node1 = new TreeNode("武汉大学");
            TreeNode node2 = new TreeNode("电子信息学院");
            TreeNode node3 = new TreeNode("计算机学院");
            TreeNode node4 = new TreeNode("通信工程系");
            TreeNode node5 = new TreeNode("测控技术与仪器系");
            TreeNode node6 = new TreeNode("空间物理系");
            TreeNode node7 = new TreeNode("电子工程系");
            TreeNode node8 = new TreeNode("光电信息工程系");
            node1.Nodes.Add(node2);
            node1.Nodes.Add(node3);
            node2.Nodes.Add(node4);
            node2.Nodes.Add(node5);
            node2.Nodes.Add(node6);
            node2.Nodes.Add(node7);
            node2.Nodes.Add(node8);
            tv_name.Nodes.Add(node1);
            tv_name.ExpandAll();
        }

        private void 关于ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AboutBox about = new AboutBox();
            about.Show();
        }
    }
}
