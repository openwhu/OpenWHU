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
    public partial class ModifyForm : Form
    {
        private Emoji thisemoji;
        public ModifyForm(Emoji e)
        {
            thisemoji = e;
            InitializeComponent();
            pictureBoxEmoji.Image= Image.FromFile(e.Path);
            keywordTextBox.Text = e.Keyword;
            targetTextBox.Text = e.TargetPeople;
            seriesTextBox.Text = e.Series;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            EmojiService.ModifyEmoji(thisemoji,keywordTextBox.Text,targetTextBox.Text,seriesTextBox.Text);
            MessageBox.Show("修改成功");
        }
    }
}
