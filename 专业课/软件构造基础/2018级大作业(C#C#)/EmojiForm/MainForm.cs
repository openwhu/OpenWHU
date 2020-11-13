using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using EmojiManagement;
using Ubiety.Dns.Core;

namespace EmojiForm
{
    public partial class MainForm : Form
    {
        //展示多少单元格
        private int row = 6;
        private int col = 7;

        //搜索条件 默认0(按标签)，1(按对象)，2(按系列)
        private int queryCondi = 0;

        /// <summary>
        /// 定义静态变量emojiList，便于在不同界面对数据库内容进行操作
        /// 赵文山
        /// /// 蒋沁月说只需要一个存储当前展示的表情列表就行了
        /// </summary>
        public static List<Emoji> emojiList = new List<Emoji>();
        public static List<String> pathList = new List<String>();
        //当前选中的表情
        Emoji emojiSelected=null;

        public MainForm()
        {

            InitializeComponent();
            //增加列
            for(int c = 0;c < col; c++)
            {
                DataGridViewImageColumn ic = new DataGridViewImageColumn();
                this.dataGridViewImage.Columns.Add(ic);
                this.dataGridViewImage.Columns[c].Width = 100;//限定列宽
                this.dataGridViewImage.Columns[c].DefaultCellStyle.NullValue = null;//当没有数据时，不会显示红叉，cell.Value 必须是null，对于空串这句无效
            }
            //增加行
            for (int r = 0; r < row; r++)
            {
                this.dataGridViewImage.Rows.Add();//增加行
                this.dataGridViewImage.Rows[r].Height = 100;//限定行宽
            }
            try
            {
                EmojiService.DeleteNull();
                emojiList = EmojiService.SortbyFrequency();
                ShowEmojis(EmojiService.SortbyFrequency());
            }
            catch
            {
                EmojiService.DeleteNull();
                emojiList = EmojiService.SortbyFrequency();
                ShowEmojis(EmojiService.SortbyFrequency());
            }



        }
        private void showFilePicture(/*List<string> imagePathList*/)//需要传入路径的list
        {
            //显示所有本地图片
            imageList.Images.Clear();
            DirectoryInfo dir = new DirectoryInfo("..\\Resources");//获取目录
            FileInfo[] fileinfo = dir.GetFiles("*.JPG");//获取文件夹中的图片文件

            //防止图片失真
            //this.imageList.ColorDepth = ColorDepth.Depth32Bit;
            foreach (FileInfo file in fileinfo)
            {
                pathList.Add(file.FullName);//图片路径
                this.imageList.Images.Add(System.Drawing.Image.FromFile(file.FullName));
            }
            for (int c = 0; c < col; c++)
            {
                DataGridViewImageColumn ic = new DataGridViewImageColumn();
                this.dataGridViewImage.Columns.Add(ic);
                this.dataGridViewImage.Columns[c].Width = 100;//限定列宽
                this.dataGridViewImage.Columns[c].DefaultCellStyle.NullValue = null;//当没有数据时，不会显示红叉，cell.Value 必须是null，对于空串这句无效
            }
            //增加行
            for (int r = 0; r < row; r++)
            {
                this.dataGridViewImage.Rows.Add();//增加行
                this.dataGridViewImage.Rows[r].Height = 100;//限定行宽
            }
            //展示imageList中的表情
            int count = 0;
            for (int i = 0; i < row; i++)
            {
                for (int j = 0; j < col; j++)
                {
                    if (count < pathList.Count)
                    {
                        this.dataGridViewImage[j, i].Value = imageList.Images[count++];

                    }
                    else
                    {
                        return;
                    }
                }
            }
        }
        public void ShowEmojis(List<Emoji> emojis)
        {
            //清空图片数据
            imageList.Images.Clear();
            for (int r = 0; r < row; r++)
            {
                for (int c = 0; c < col; c++)
                {
                    this.dataGridViewImage[c, r].Value = null;
                }
            }
            //防止图片失真
            this.imageList.ColorDepth = ColorDepth.Depth32Bit;
            //当数据库图片不为空时，将图片加入imageList

            if (emojis.Count != 0)
            {
                foreach (Emoji e in emojis)
                {
                    if (e.Path != "")
                    {
                        try
                        {
                            this.imageList.Images.Add(System.Drawing.Image.FromFile(e.Path));
                        }
                        catch (System.IO.FileNotFoundException) { }
                    }
                }
                //Console.WriteLine("real:" + realcount+"emojicount:"+emojis.Count);
                
                //展示图片
                int count = 0;
                for (int r = 0; r < row; r++)
                {
                    for (int c = 0; c < col; c++)
                    {
                        if (count < imageList.Images.Count)
                        {
                            this.dataGridViewImage[c, r].Value = imageList.Images[count++];

                        }
                        else return;
                    }
                }
            }
            this.Refresh();
        }

        private void import_Click(object sender, EventArgs e)
        {
            AddForm add = new AddForm();
            add.ShowDialog();
        }

        private void recommend_Click(object sender, EventArgs e)
        {
            showFilePicture(/*recommendList*/);
        }

        //按关键词查找
        private void search_Click(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchByKeyword(textBox1.Text);
            ShowEmojis(emojiList);
        }


        //选中一个单元格中的表情
        private void dataGridViewImage_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int r=dataGridViewImage.CurrentCell.RowIndex;
            int c= dataGridViewImage.CurrentCell.ColumnIndex;
            int location = r * col + c;
            if (location < emojiList.Count)
            {
                emojiSelected = emojiList[location];
                //selectedText.Text = emojiSelected.ToString();
                Clipboard.SetDataObject(new Bitmap(emojiSelected.Path));
            }
        }

        private void likes_Click(object sender, EventArgs e)
        {
            FavoriteForm favoriteForm = new FavoriteForm();
            favoriteForm.ShowDialog();
        }

        private void addlike_Click(object sender, EventArgs e)
        {
            EmojiService.FrequencyPlus(emojiSelected);
            EmojiService.ModifyIsFavorite(emojiSelected,0);
            MessageBox.Show("加入收藏夹成功");
        }


        private void bytarget_CheckedChanged(object sender, EventArgs e)
        {
            queryCondi = 1;
        }
        private void byseries_CheckedChanged(object sender, EventArgs e)
        {
            queryCondi = 2;
        }
        private void bylabel_CheckedChanged(object sender, EventArgs e)
        {
            queryCondi = 0;
        }

        private void export_Click(object sender, EventArgs e)
        {
            EmojiService.ExportEmoji(emojiList);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            EmojiService.DeleteNull();
            emojiList = EmojiService.SortbyFrequency();
            ShowEmojis(EmojiService.SortbyFrequency());
            this.Refresh();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            emojiList.Clear();
            EmojiService.DeleteEmoji(emojiSelected);
            MessageBox.Show("删除成功");
            emojiList = EmojiService.SortbyFrequency();
            ShowEmojis(emojiList);

        }

        private void dataGridViewImage_CellMouseEnter(object sender, DataGridViewCellEventArgs e)
        {
            ToolTip toolTip1 = new ToolTip();
            toolTip1.AutoPopDelay = 5000;//提示信息的可见时间
            toolTip1.InitialDelay = 500;//事件触发多久后出现提示
            toolTip1.ReshowDelay = 500;//指针从一个控件移向另一个控件时，经过多久才会显示下一个提示框
            toolTip1.ShowAlways = true;//是否显示提示框
            Emoji emojiHovered;
            int r = dataGridViewImage.CurrentCell.RowIndex;
            int c = dataGridViewImage.CurrentCell.ColumnIndex;
            int location = r * col + c;
            if (location < emojiList.Count)
            {
                emojiHovered = emojiList[location];
                //toolTip1.SetToolTip(dataGridViewImage, emojiSelected.ToString());
            }
        }

        private void toolTipCell_Popup(object sender, PopupEventArgs e)
        {

        }

        private void dataGridViewImage_MouseHover(object sender, EventArgs e)
        {
            dataGridViewImage.ShowCellToolTips = true;
            ToolTip toolTip1 = new ToolTip();
            toolTip1.AutoPopDelay = 5000;//提示信息的可见时间
            toolTip1.InitialDelay = 500;//事件触发多久后出现提示
            toolTip1.ReshowDelay = 500;//指针从一个控件移向另一个控件时，经过多久才会显示下一个提示框
            toolTip1.ShowAlways = true;//是否显示提示框
            //toolTip1.Show("tooptip1", dataGridViewImage,MousePosition.X,MousePosition.Y);
            Emoji emojiHovered;
            int r = dataGridViewImage.CurrentCell.RowIndex;
            int c = dataGridViewImage.CurrentCell.ColumnIndex;
            int location = r * col + c;
            if (location < emojiList.Count)
            {
                emojiHovered = emojiList[location];
                toolTip1.SetToolTip(dataGridViewImage, emojiHovered.ToString());
            }
        }

        private void dataGridViewImage_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            //鼠标右键显示菜单
            if (e.Button == MouseButtons.Right)
            {
                int r = dataGridViewImage.CurrentCell.RowIndex;
                int c = dataGridViewImage.CurrentCell.ColumnIndex;
                int location = r * col + c;
                if (location < emojiList.Count)
                {
                    emojiSelected = emojiList[location];
                    cmsRightClick.Show(MousePosition);
                }
            }
        }

        private void 加入收藏ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            EmojiService.FrequencyPlus(emojiSelected);
            EmojiService.ModifyIsFavorite(emojiSelected, 0);
            MessageBox.Show("加入收藏夹成功");
        }

        private void 删除表情ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            emojiList.Clear();
            EmojiService.DeleteEmoji(emojiSelected);
            MessageBox.Show("删除成功");
            emojiList = EmojiService.SortbyFrequency();
            ShowEmojis(emojiList);
        }

        private void 查看属性ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show(emojiSelected.ToString());
        }

        private void rbTargetAll_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchByTargetPeople(rbTargetAll.Text);
            ShowEmojis(emojiList);
        }

        private void 刷新ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            emojiList.Clear();
            EmojiService.DeleteNull();
            emojiList = EmojiService.SortbyFrequency();
            ShowEmojis(EmojiService.SortbyFrequency());
            this.Refresh();
        }

        private void rbTargetParents_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchByTargetPeople(rbTargetParents.Text);
            ShowEmojis(emojiList);
        }

        private void rbTargetLover_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchByTargetPeople(rbTargetLover.Text);
            ShowEmojis(emojiList);
        }

        private void rbTargetProgrammer_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchByTargetPeople(rbTargetProgrammer.Text);
            ShowEmojis(emojiList);
        }

        private void rbSeriesAll_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchBySeries(rbSeriesAll.Text);
            ShowEmojis(emojiList);
        }

        private void rbSeriesTom_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchBySeries(rbSeriesTom.Text);
            ShowEmojis(emojiList);
        }

        private void rbSeriesPanda_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchBySeries(rbSeriesPanda.Text);
            ShowEmojis(emojiList);
        }

        private void rbSeriesPets_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchBySeries(rbSeriesPets.Text);
            ShowEmojis(emojiList);
        }

        private void rbSeriesBaby_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchBySeries(rbSeriesBaby.Text);
            ShowEmojis(emojiList);
        }

        private void rbSeriesOthers_CheckedChanged(object sender, EventArgs e)
        {
            emojiList.Clear();
            emojiList = EmojiService.SearchBySeries(rbSeriesOthers.Text);
            ShowEmojis(emojiList);
        }

        private void btnAddEmoji_Click(object sender, EventArgs e)
        {
            AddForm add = new AddForm();
            add.ShowDialog();
        }

        private void 返回首页ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            emojiList.Clear();
            EmojiService.DeleteNull();
            emojiList = EmojiService.SortbyFrequency();
            ShowEmojis(EmojiService.SortbyFrequency());
            this.Refresh();
        }

        private void btnMain_Click(object sender, EventArgs e)
        {
            emojiList.Clear();
            EmojiService.DeleteNull();
            emojiList = EmojiService.SortbyFrequency();
            ShowEmojis(EmojiService.SortbyFrequency());
            this.Refresh();
        }

        private void 修改属性ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ModifyForm modiForm = new ModifyForm(emojiSelected);
            modiForm.ShowDialog();
        }
    }
}
