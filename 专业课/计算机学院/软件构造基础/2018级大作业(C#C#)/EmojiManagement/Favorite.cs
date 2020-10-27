using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmojiManagement
{
    public class Favorite
    {
        public string Id { set; get; }
        public List<Emoji> Emojis { set; get; }
        public Favorite() { }
    }
}
