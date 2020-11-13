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
using MySqlX.XDevAPI.Common;
using System.Web;
using System.IO;
using System.Net;
using System.Text;
using ocrfreamwork;
//using EmojiOCR;
//这里.net freamwork 的东西好像不能引用.net core的

namespace EmojiForm
{
    public partial class AddForm : Form
    {
        public AddForm()
        {
            DragDrop += AddForm_DragDrop;
            DragEnter += AddForm_DragEnter;
            InitializeComponent();
        }

        //获取表情包的文字信息，path为表情包路径
        //private string GetOCR(string path)
        //{
            //string exepath = @"./EmojiOCR.exe";//路径可能有问题，还没调试

            //这里需要调用EmojiOCR类生成的exe,并传入参数path
            //System(exepath.data())
            //System.Diagnostics.Process.Start(@"EmojiOCR.exe", "path");
            //string result = EmojiOCR.generalBasic(path);
            //return result;

            //返回值格式是string，可以考虑转换成json后再操作，示例如↓：
            //{"log_id": 3371547277663409633, "words_result_num": 1, "words_result": [{"words": "阿瓦达索命"}]}
            //如果words_result_num=0，返回空字符串
            //否则，需要获取第一个words_result的words值，并返回
        //}

        private void AddForm_DragDrop(object sender, DragEventArgs e)
        {
            string path = ((System.Array)e.Data.GetData(DataFormats.FileDrop)).GetValue(0).ToString();

            //这里调用OCR
            try
            {
                string a = Getkeybyocr(path);
                keywordTextBox.Text = a;
            }
            catch (IOException ex)
            {
                MessageBox.Show("ocr错误！传入地址：" + path + ex.Message);
            }


            this.pictureBox1.Image = Image.FromFile(path);
            pathTextBox.Text = path;



            string picPath = path;//这里记得传入图片的路径,通过可视化操作选中图片传参，参数记得改一下奥席诺同学
            string filename = Path.GetFileName(picPath);
            //string str = System.Environment.CurrentDirectory;
            string str3 = Directory.GetCurrentDirectory();


            
        }
        public static string generalBasic(string path)
        {
            Console.WriteLine("run");
            string token = "24.3640467825457b4ca62361858bc7e091.2592000.1593512782.282335-20158843";
            string host = "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token=" + token;
            Encoding encoding = Encoding.Default;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(host);
            request.Method = "post";
            request.KeepAlive = true;
            // 图片的base64编码
            Console.WriteLine("run2" + path);
            string base64 = getFileBase64(path);
            Console.WriteLine(base64);
            String str = "image=" + HttpUtility.UrlEncode(base64);
            Console.WriteLine("run3");
            byte[] buffer = encoding.GetBytes(str);
            request.ContentLength = buffer.Length;
            request.GetRequestStream().Write(buffer, 0, buffer.Length);
            Console.WriteLine("run4");
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            Console.WriteLine("run5");
            StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.Default);
            string result = reader.ReadToEnd();
            //Console.WriteLine("通用文字识别:");
            //Console.WriteLine(result);
            return result;
        }

        public static String getFileBase64(String fileName)
        {
            FileStream filestream = new FileStream(fileName, FileMode.Open);
            byte[] arr = new byte[filestream.Length];
            filestream.Read(arr, 0, (int)filestream.Length);
            string baser64 = Convert.ToBase64String(arr);
            filestream.Close();
            return baser64;
        }
        public static string Getkeybyocr(string s)
        {
            string Path = s;
            string a = generalBasic(Path);
            Console.WriteLine(a);
            byte[] byteArray = System.Text.Encoding.Default.GetBytes(a);
            string str = System.Text.Encoding.Default.GetString(byteArray);
            Console.WriteLine(str);
            byte[] re = UTF32Encoding.Convert(UTF8Encoding.UTF8, UTF32Encoding.Default, byteArray);
            str = System.Text.Encoding.Default.GetString(re);
            Console.WriteLine(str);
            string[] key = str.Split('"');
            Console.WriteLine(key[9]);
            return key[9];
        }
        private void AddForm_DragEnter(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
                e.Effect = DragDropEffects.Link;
            else e.Effect = DragDropEffects.None;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Emoji newemoji = new Emoji(pathTextBox.Text, keywordTextBox.Text, cmbSeries.Text, cmbTarget.Text, 0, false);
            try
            {
                EmojiService.AddEmoji(newemoji);
                MessageBox.Show("添加成功");
                pictureBox1.Image = null;
                pathTextBox.Text = "";
                keywordTextBox.Text = "";
            }catch(Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            //MainForm mm = new MainForm();
            // mm.ShowEmojis(MainForm.emojiList);
            //((MainForm)this.Owner).Refresh();
                this.Close();
        }
    }
}
