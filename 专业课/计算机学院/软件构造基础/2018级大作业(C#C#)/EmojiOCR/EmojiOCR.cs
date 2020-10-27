using System;
using System.IO;
using System.Net;
using System.Text;
using System.Web;

namespace ocr_emoji
{
    class EmojiOCR
    {
        // 通用文字识别
        public static string generalBasic(string path)
        {
            string token = "24.3640467825457b4ca62361858bc7e091.2592000.1593512782.282335-20158843";
            string host = "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token=" + token;
            Encoding encoding = Encoding.Default;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(host);
            request.Method = "post";
            request.KeepAlive = true;
            // 图片的base64编码
            string base64 = getFileBase64(path);
            String str = "image=" + HttpUtility.UrlEncode(base64);
            byte[] buffer = encoding.GetBytes(str);
            request.ContentLength = buffer.Length;
            request.GetRequestStream().Write(buffer, 0, buffer.Length);
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
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

        public static void Main(string[] args)
        {
            //这里要考虑下怎么返回结果。直接返回string的话好像运行不了。
            Console.WriteLine(generalBasic(@"C:\Users\miles\Desktop\把卡.jpg"));
            return;
            //return generalBasic(args[0]);
        }
    }
}
