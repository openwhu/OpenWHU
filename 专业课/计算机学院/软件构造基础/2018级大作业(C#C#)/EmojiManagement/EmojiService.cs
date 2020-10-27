using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Serialization;
using EmojiManagement;


//目前只是把主要的函数和类写出来了，如果还需要什么类和函数自己加，写必要的注释

namespace EmojiManagement
{
    public class EmojiService
    {


        public EmojiService() { }

        //从文件中添加图片
        public static void AddEmoji(Emoji emoji)
        {
            //席诺&马草原
            try
            {
                using (var db = new EmojiContext())
                {
                    string src = emoji.Path;
                    string filename = Path.GetFileName(src);
                    string dest = @"..\..\..\test\" + filename;

                    //File.Copy(src, dest);
                    //string pLocalFilePath = "";//要复制的文件路径
                    // string pSaveFilePath = "";//指定存储的路径
                    if (File.Exists(src))//必须判断要复制的文件是否存在
                    {
                        File.Copy(src, dest, true);//三个参数分别是源文件路径，存储路径，若存储路径有相同文件是否替换
                    }

                    emoji.Path = dest;
                    db.Emojis.Add(emoji);
                    db.SaveChanges();
                }
            }
            catch (Exception e) { }
        }
        public static void CopyDirectory(string srcPath, string destPath)
        {
            try
            {
                DirectoryInfo dir = new DirectoryInfo(srcPath);
                FileSystemInfo[] fileinfo = dir.GetFileSystemInfos();  //获取目录下（不包含子目录）的文件和子目录
                foreach (FileSystemInfo i in fileinfo)
                {
                    if (i is DirectoryInfo)     //判断是否文件夹
                    {
                        if (!Directory.Exists(destPath + "\\" + i.Name))
                        {
                            Directory.CreateDirectory(destPath + "\\" + i.Name);   //目标目录下不存在此文件夹即创建子文件夹
                        }
                        CopyDirectory(i.FullName, destPath + "\\" + i.Name);    //递归调用复制子文件夹
                    }
                    else
                    {
                        File.Copy(i.FullName, destPath + "\\" + i.Name, true);      //不是文件夹即复制文件，true表示可以覆盖同名文件
                    }
                }
            }
            catch (Exception e)
            {
                throw;
            }
        }

        /// <summary>
        /// 修改IsFavorite，参数i为0改为true，参数i为1改为false
        /// 蒋沁月
        /// </summary>
        public static void ModifyIsFavorite(Emoji e, int i)
        {
            using (var db = new EmojiContext())
            {
                var query = db.Emojis.Where(o => o.Id == e.Id);
                foreach (Emoji ee in query)
                {
                    if (i == 0)
                    {
                        ee.IsFavorite = true;
                    }
                    else if (i == 1)
                    {
                        ee.IsFavorite = false;
                    }

                }
                db.SaveChanges();
            }
        }

        public static void DeleteNull()
        {
            using (var db = new EmojiContext())
            {

                var query = db.Emojis.Where(o => o.Id == null || o.IsFavorite == null ||
                            o.Path == "" || o.Keyword == null);
                foreach (Emoji e in query)
                {
                    db.Emojis.Remove(e);
                }
                foreach (Emoji e in db.Emojis)
                {
                    Console.WriteLine(e);
                }
                db.SaveChanges();
            }
        }

        //Frequency++ 蒋沁月
        public static void FrequencyPlus(Emoji e)
        {
            using (var db = new EmojiContext())
            {
                var query = db.Emojis.Where(o => o.Id == e.Id);
                foreach (Emoji ee in query)
                {
                    ee.Frequency++;
                }
                db.SaveChanges();
            }

        }


        //通过路径判断数据库中是否存在当前表情。马草原
        public static bool Emojiexist(string path)
        {
            using (var db = new EmojiContext())
            {
                var queary = db.Emojis.Where(o => o.Path == path);
                if (queary == null)
                    return false;//不存在返回false
                else
                    return true;
            }
        }


        public static void DeleteEmoji(Emoji emoji)
        {
            //张智敏&马草原
            try
            {
                using (var db = new EmojiContext())
                {
                    var query = db.Emojis.Where(o => o.Id == emoji.Id);
                    foreach (Emoji ee in query)
                    {
                        db.Emojis.Remove(ee);
                    }
                    db.SaveChanges();
                }
            }
            catch (Exception e)
            {
                //TODO 需要更加错误类型返回不同错误信息
                throw new ApplicationException($"删除订单错误!");
            }
        }

        //因为要用所以我先写了 蒋沁月
        public static void ModifyEmoji(Emoji e, string key, string target, string series)
        {
            using (var db = new EmojiContext())
            {
                var query = db.Emojis.Where(o => o.Id == e.Id);
                foreach (Emoji ee in query)
                {
                    ee.Keyword = key;
                    ee.TargetPeople = target;
                    ee.Series = series;
                }
                db.SaveChanges();
            }

        }
        //返回所有表情 马草原
        public static IQueryable<Emoji> AllEmojis(EmojiContext db)
        {
            return db.Emojis;
        }

        public static List<Emoji> GetAllEmojis()
        {
            using (var db = new EmojiContext())
            {
                var query = AllEmojis(db).ToList();
                return query;
            }
        }
        //返回数据库中为收藏的表情 马草原
        public static List<Emoji> FavoriteEmoji()
        {
            using (var db = new EmojiContext())
            {
                var query = AllEmojis(db).Where(emo => emo.IsFavorite == true);
                return query.ToList();
            }
        }

        //根据表情热度进行排序的结果 马草原
        public static List<Emoji> SortbyFrequency()
        {
            using (var db = new EmojiContext())
            {
                var query = AllEmojis(db).ToList();
                query.Sort();
                return query;
            }
        }


        //这个是一个综合的搜索，先空着
        public static List<Emoji> SearchEmoji(string info)
        {
            //张智敏&马草原
            using (var db = new EmojiContext())
            {
                var query1 = AllEmojis(db)
                  .Where(e => e.Keyword.Contains(info));
                var query2 = AllEmojis(db)
                  .Where(e => e.Series.Contains(info));
                var query3 = AllEmojis(db)
                  .Where(e => e.TargetPeople.Contains(info));
                var query = query1.Concat(query2);
                query = query.Concat(query3);
                return query.ToList();
            }

        }

        //按关键词搜索
        public static List<Emoji> SearchByKeyword(string info)
        {
            //张智敏&马草原
            using (var db = new EmojiContext())
            {
                var query = AllEmojis(db)
                  .Where(e => e.Keyword.Contains(info));
                return query.ToList();
            }

        }

        //按系列搜索
        public static List<Emoji> SearchBySeries(string info)
        {
            //张智敏&马草原
            if (info == "全部")
            {
                using (var db = new EmojiContext())
                {
                    var query = AllEmojis(db);
                    return query.ToList();
                }
            }
            using (var db = new EmojiContext())
            {
                var query = AllEmojis(db)
                  .Where(e => e.Series.Contains(info));
                return query.ToList();
            }
        }

        //按目标人群搜索
        public static List<Emoji> SearchByTargetPeople(string info)
        {
            //张智敏&马草原
            using (var db = new EmojiContext())
            {
                var query = AllEmojis(db)
                  .Where(e => e.TargetPeople.Contains(info));
                return query.ToList();
            }
        }
        internal class DbHelperSQL
        {
            internal DataTable GetDataTable(object targetDBCon, string v)
            {
                throw new NotImplementedException();
            }
        }
        //导出表情
        public static void ExportEmoji(List<Emoji> emojis)
        {
            using (var db = new EmojiContext())
            {
                var queary = db.Emojis;
                foreach (Emoji ee in queary)
                {
                    if (ee.Path != null)
                    {
                        try
                        {
                            string src = ee.Path;
                            string filename = Path.GetFileName(src);
                            string dest = @"..\..\..\Export\" + filename;
                            if (File.Exists(src))//必须判断要复制的文件是否存在
                            {
                                File.Copy(src, dest, true);//三个参数分别是源文件路径，存储路径，若存储路径有相同文件是否替换
                            }
                            ee.Path = dest;
                        }
                        catch (Exception ep) { }
                    }
                }
            }
            using (var db = new EmojiContext())
            {
                try
                {
                    using (System.IO.StringWriter stringWriter = new StringWriter(new StringBuilder()))
                    {
                        XmlSerializer xmlSerializer = new XmlSerializer(typeof(List<Emoji>));
                        xmlSerializer.Serialize(stringWriter, emojis);

                        FileStream fs = new FileStream("export.xml", FileMode.OpenOrCreate);
                        StreamWriter sw = new StreamWriter(fs);
                        sw.Write(stringWriter.ToString());
                        sw.Close();
                        fs.Close();
                        MessageBox.Show("导出文件成功！");
                        string src = @"..\..\..\EmojiForm\bin\Debug\export.xml";
                        string filename = Path.GetFileName(src);
                        string dest = @"..\..\..\Export\" + filename;
                        File.Copy(src, dest, true);
                    }
                }
                catch (System.Exception ex)
                { }
            }
        }
    }
}