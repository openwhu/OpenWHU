using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using EmojiManagement;

namespace EmojiForm
{
    public partial class FavoriteForm : Form
    {
        //展示多少单元格
        private int row = 4;
        private int col = 5;

        //当前展示的表情
        public static List<Emoji> emojiList = new List<Emoji>();
        //当前选中的表情
        Emoji emojiSelected = null;

        public FavoriteForm()
        {
            InitializeComponent();
            //增加列
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

            emojiList = EmojiService.FavoriteEmoji();
            ShowEmojis(emojiList);
        }
        private void ShowEmojis(List<Emoji> emojis)
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
            //将图片加入imageList
            foreach (Emoji e in emojis)
            {
                this.imageList.Images.Add(Image.FromFile(e.Path));
            }
            //展示图片
            int count = 0;
            for (int r = 0; r < row; r++)
            {
                for (int c = 0; c < col; c++)
                {
                    if (count < emojis.Count)
                    {
                        this.dataGridViewImage[c, r].Value = imageList.Images[count++];

                    }
                    else return;
                }
            }
        }
        //选中某个单元格
        private void dataGridViewLikeEmoji_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int r = dataGridViewImage.CurrentCell.RowIndex;
            int c = dataGridViewImage.CurrentCell.ColumnIndex;
            int location = r * col + c;
            if (location < emojiList.Count)
            {
                emojiSelected = emojiList[location];
                selectedText.Text = emojiSelected.ToString();
            }
            else
            {
                emojiSelected = null;
                selectedText.Text = " ";
            }
        }

        private void BtnChange_Click(object sender, EventArgs e)
        {
            ModifyForm modiForm = new ModifyForm(emojiSelected);
            modiForm.ShowDialog();
        }

        private void dataGridViewImage_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int r = dataGridViewImage.CurrentCell.RowIndex;
            int c = dataGridViewImage.CurrentCell.ColumnIndex;
            int location = r * col + c;
            if (location < emojiList.Count)
            {
                emojiSelected = emojiList[location];
                selectedText.Text = emojiSelected.ToString();
            }

        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            emojiList.Clear();
            EmojiService.ModifyIsFavorite(emojiSelected, 1);
            MessageBox.Show("删除成功");
            emojiList = EmojiService.FavoriteEmoji();
            ShowEmojis(emojiList);
        }

        private void export_Click(object sender, EventArgs e)
        {
            EmojiService.ExportEmoji(emojiList);
        }
    }
}
