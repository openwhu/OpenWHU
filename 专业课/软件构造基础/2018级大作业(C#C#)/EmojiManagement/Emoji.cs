using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
//注释：这个文件的代码已经基本成型。后面的工作应该改不到这个了
namespace EmojiManagement
{
    //表情类
    public class Emoji : IComparable<Emoji>
    {
        [Key]
        public string Id { set; get; }
        public string Path { set; get; }    //图片路径
        public string Keyword { set; get; }    //关键词
        public string Series { set; get; }      //图片所属系列
        public string TargetPeople { set; get; }    //目标人群
        public int Frequency { get; set; }    //使用频率
        public bool IsFavorite { get; set; }//是否在收藏夹


        public Emoji()
        {
            //本项目理论上不允许有空参数构造
        }

        public Emoji(string path, string keyword, string series, string targetpeople, int frequency, bool isFavorite)
        {
            Id = Guid.NewGuid().ToString();//确保id唯一
            Path = path;
            Keyword = keyword;
            Series = series;
            TargetPeople = targetpeople;
            Frequency = frequency;
            IsFavorite = isFavorite;
        }

        public int CompareTo(Emoji other)
        {
            if (other == null) return 1;
            return this.Frequency.CompareTo(other.Frequency);
        }

        //判断文件类型
        public bool IsImage(string path)
        { // *.BMP;*.JPG;*.GIF;*.jpeg;*.ico
            string ext = System.IO.Path.GetExtension(path).ToUpper();
            if (ext == ".BMP" || ext == ".JPG" || ext == ".GIF"
                 || ext == ".JPEG" || ext == ".ICO")
            {
                return true;//该文件是图像类型
            }
            else
            {
                return false;
            }
        }

        public override string ToString()
        {
            StringBuilder strBuilder = new StringBuilder();
            strBuilder.Append($"关键词:{Keyword},\n系列:{Series},\n适用对象：{TargetPeople},\n使用频率:{Frequency}\t");
            return strBuilder.ToString();
        }
        public override bool Equals(object obj)
        {
            var e = obj as Emoji;
            return e != null && Id == e.Id;
        }
        public override int GetHashCode()
        {
            var hashCode = -5211314;
            hashCode = hashCode * -2020520 + Id.GetHashCode();
            return hashCode;
        }
    }
}
