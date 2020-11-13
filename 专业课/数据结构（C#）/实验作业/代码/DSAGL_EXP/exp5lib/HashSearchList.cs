using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    public class HashSearchList<T>
    {
        private HashNode<T>[] baseTable;

        public HashSearchList(int HashSize)
        {
            baseTable = new HashNode<T>[HashSize];
        }

        public HashSearchList() : this(8) { }

        public HashSearchList(IList<T> datas) : this(8)
        {
            foreach(T t in datas)
            {
                Add(t);
            }
        }

        public int HashCode(T item)
        {
            return (item.GetHashCode() % baseTable.Length);
        }

        public void Add(T item)
        {
            HashNode<T> node = new HashNode<T>(item);
            int i = HashCode(item);
            if(baseTable[i] == null)
            {
                baseTable[i] = node;
            }
            else
            {
                node.Next = baseTable[i].Next;
                baseTable[i].Next = node;
            }
        }

        public bool Contain(T item)
        {
            return (Search(item) == null) ? false : true;
        }

        public HashNode<T> Search(T item)
        {
            int i = HashCode(item);
            if(baseTable[i] == null)
            {
                return null;
            }
            else
            {
                if (baseTable[i].Data.Equals(item))
                {
                    return baseTable[i];
                }
                else
                {
                    HashNode<T> p = baseTable[i].Next;
                    while (p != null)
                    {
                        if (p.Data.Equals(item))
                        {
                            return p;
                        }
                        else
                        {
                            p = p.Next;
                        }
                    }
                }
            }
            return null;
        }

        public void Show(bool showHint = true)
        {
            if (showHint)
            {
                Console.WriteLine("HashSearch Test:");
            }
            foreach(HashNode<T> t in baseTable)
            {
                if(t != null)
                {
                    t.Show();
                    Console.WriteLine();
                }
            }
        }
    }

    public class HashNode<T>
    {
        private T data;
        private HashNode<T> next;

        public HashNode(T data)
        {
            this.data = data;
            next = null;
        }

        public HashNode()
        {
            data = default(T);
            next = null;
        }

        public T Data
        {
            get
            {
                return data;
            }
            set
            {
                data = value;
            }
        }

        public HashNode<T> Next
        {
            get
            {
                return next;
            }
            set
            {
                next = value;
            }
        }

        public void Show()
        {
            HashNode<T> p = this;
            while(p != null)
            {
                Console.Write(p.Data + "->");
                p = p.Next;
            }
        }
    }
}
