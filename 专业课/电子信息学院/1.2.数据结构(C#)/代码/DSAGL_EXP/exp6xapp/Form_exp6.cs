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
using DSAGL;

namespace exp6xapp
{
    public partial class Form_exp6 : Form
    {
        private List<Robot> robots;
        public Form_exp6()
        {
            InitializeComponent();
            robots = importDataFromXML();
            showResult(robots);
            SSL1.Text = "SortByName";
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
                robot.ID = int.Parse(attribute.Item(0).InnerText);
                robot.Name = attribute.Item(1).InnerText;
                robot.IQ = int.Parse(attribute.Item(2).InnerText);
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

        private void showResult(IEnumerable<Robot> robots)
        {
            StringBuilder sb = new StringBuilder();
            foreach (Robot r in robots)
            {
                sb.Append(r);
                sb.Append("\r\n");
            }
            tb_result.Text = sb.ToString();
        }

        private void sortByNameToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var result = from r in robots orderby r.Name select r;
            showResult(result);
            SSL1.Text = "SortByName";
        }

        private void sortByNameDownToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var result = from r in robots orderby r.Name descending select r;
            showResult(result);
            SSL1.Text = "SortByNameDown";
        }

        private void sortByIDToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var result = from r in robots orderby r.ID select r;
            showResult(result);
            SSL1.Text = "SortByID";
        }

        private void sortByIDDownToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var result = from r in robots orderby r.ID descending select r;
            showResult(result);
            SSL1.Text = "SortByIDDown";
        }

        private void sortByIQToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var result = from r in robots orderby r.IQ select r;
            showResult(result);
            SSL1.Text = "SortByIQ";
        }

        private void sortByIQDownToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var result = from r in robots orderby r.IQ descending select r;
            showResult(result);
            SSL1.Text = "SortByIQDown";
        }
    }
}
