using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;

namespace exp5xapp
{
    public partial class Form_exp5 : Form
    {
        public enum searchType{ L2O, L2X, L2D };
        private searchType type;

        public Form_exp5()
        {
            InitializeComponent();
            type = searchType.L2X;
            SSL1.Text = "Linq2XML";
        }

        private void bt_search_Click(object sender, EventArgs e)
        {
            switch (type)
            {
                case searchType.L2O:
                    searchByObject();
                    break;
                case searchType.L2X:
                    searchByXML();
                    break;
                case searchType.L2D:
                    searchByDataSet();
                    break;
                default:
                    searchByXML();
                    break;
            }
        }

        private void l2O_StripMenuItem_Click(object sender, EventArgs e)
        {
            type = searchType.L2O;
            SSL1.Text = "Linq2Object";
        }

        private void l2XML_StripMenuItem_Click(object sender, EventArgs e)
        {
            type = searchType.L2X;
            SSL1.Text = "Linq2XML";
        }

        private void l2D_StripMenuItem_Click(object sender, EventArgs e)
        {
            type = searchType.L2D;
            SSL1.Text = "Linq2DataSet";
        }

        public void searchByXML()
        {
            string name = tb_input.Text;
            List<Robot> robots = importDataFromXML();
            //遍历List查询
            foreach (Robot robot in robots)
            {
                if (robot.Name.Equals(name))
                {
                    showResult(robot);
                    return;
                }
            }
            showResult(null);
        }

        public void searchByObject()
        {
            string name = tb_input.Text;
            List<Robot> robots = importDataFromXML();
            var robot = (from r in robots where r.Name.Equals(name) select r).ToList();
            showResult(robot[0]);
        }

        public void searchByDataSet()
        {
            tb_result.Text = "Not finish yet";
        }

        public void showResult(Robot robot)
        {
            if(robot == null)
            {
                tb_result.Text = "No such Robot, Please chaeck your spelling...";
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("ID:");
                sb.Append(robot.ID);
                sb.Append("    Name:");
                sb.Append(robot.Name);
                sb.Append("    IQ:");
                sb.Append(robot.IQ);
                tb_result.Text = sb.ToString();
            }
        }

        public List<Robot> importDataFromXML()
        {
            XmlDocument document = new XmlDocument();
            XmlReaderSettings setting = new XmlReaderSettings();
            setting.IgnoreComments = true;//忽略XML文档里面的注释
            XmlReader reader = XmlReader.Create(Path, setting);
            //加载XML文件
            document.Load(reader);
            //得到Robots根节点
            XmlNode node = document.SelectSingleNode("Robots");
            //得到所有Robot子节点
            XmlNodeList nodelist = node.ChildNodes;
            List<Robot> robots = new List<Robot>();
            //将XML文件转换为List数据类型便于查询
            foreach (XmlNode node1 in nodelist)
            {
                Robot robot = new Robot();
                XmlNodeList attribute = node1.ChildNodes;
                robot.ID = attribute.Item(0).InnerText;
                robot.Name = attribute.Item(1).InnerText;
                robot.IQ = attribute.Item(2).InnerText;
                robots.Add(robot);
            }
            return robots;
        }

        public static String Path
        {
            get
            {
                String path = String.Format("{0}\\Robots.xml", Environment.CurrentDirectory);
                return path;
            }
        }

        private void tb_input_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.KeyCode == Keys.Enter)
            {
                bt_search.PerformClick();
            }
        }
    }

    public class Robot
    {
        private string id;
        private string name;
        private string iq;

        public string ID
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

        public string IQ
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
    }
}
