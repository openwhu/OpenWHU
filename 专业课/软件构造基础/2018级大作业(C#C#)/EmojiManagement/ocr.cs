using System;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
namespace EmojiManagement
{
    public class EmojiOCR
    {
        // 通用文字识别
        public static string GetOcr(string path)
        {
            Console.WriteLine("run");
            string token = "24.3640467825457b4ca62361858bc7e091.2592000.1593512782.282335-20158843";
            string host = "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token=" + token;
            Encoding encoding = Encoding.Default;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(host);
            request.Method = "post";
            request.KeepAlive = true;
            // 图片的base64编码
            Console.WriteLine("run2:"+path);
            string base64 = getFileBase64(path);
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
            try
            {
                string Path = s;
                string a = GetOcr(Path);
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
            catch(Exception e )
            {
                throw new Exception("cuowu");
            }

        }
    }
}
