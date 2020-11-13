using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSAGL;

namespace exp3app
{
    class EvalExp
    {
        private string expstr = " ";                       //前缀表达式
        private StringBuilder pstr = new StringBuilder("");//后缀表达式

        public EvalExp(string str)
        {
            expstr = str;
        }

        public string EXPSTR
        {
            get
            {
                return expstr;
            }
            set
            {
                expstr = value;
            }
        }

        public string Transform()
        {
            pstr.Clear();
            SequencedStack<char> stack = new SequencedStack<char>();
            int i = 0;
            char ch, temp;
            while (i < expstr.Length)
            {
                ch = expstr[i];
                switch (ch)
                {
                    case '+':
                    case '-':
                        while((!stack.Empty) && (stack.Peek() != '('))
                        {
                            temp = stack.Pop();
                            pstr.Append(temp);
                        }
                        pstr.Append(' ');
                        stack.Push(ch);
                        i++;
                        break;
                    case '*':
                    case '/':
                        while ((!stack.Empty) && ((stack.Peek() == '*') || (stack.Peek() == '/')))
                        {
                            temp = stack.Pop();
                            pstr.Append(temp);
                        }
                        pstr.Append(' ');
                        stack.Push(ch);
                        i++;
                        break;
                    case '(':
                        stack.Push(ch);
                        i++;
                        break;
                    case ')':
                        while ((!stack.Empty) && (stack.Peek() != '('))
                        {
                            temp = stack.Pop();
                            pstr.Append(temp);
                        }
                        stack.Pop();
                        i++;
                        break;
                    case '0'://数字
                    case '1':
                    case '2':
                    case '3':
                    case '4':
                    case '5':
                    case '6':
                    case '7':
                    case '8':
                    case '9':
                        while ((ch >= '0') && (ch <= '9'))
                        {
                            pstr.Append(ch);
                            i++;
                            if (i < expstr.Length)
                            {
                                ch = expstr[i];
                            }
                            else
                            {
                                ch = '=';
                            }
                        }
                        pstr.Append(' ');
                        break;
                    default:
                        i++;
                        break;
                }
            }
            while (!stack.Empty)
            {
                pstr.Append(stack.Pop());
                //pstr.Append(' ');
            }
            return pstr.ToString();
        }

        public int Eval()
        {
            SequencedStack<int> stack = new SequencedStack<int>();
            int i = 0;
            char ch;
            string num = "";
            while(i < pstr.Length)
            {
                ch = pstr[i];
                if((ch >= '0') && (ch <= '9'))//遇到数字就入栈
                {
                    num = "";
                    while(ch != ' ')
                    {
                        num += ch;
                        i++;
                        if(i < pstr.Length)
                        {
                            ch = pstr[i];
                        }
                    }
                    stack.Push(int.Parse(num));
                    i++;
                }
                else if((ch == '+') || (ch == '-') || (ch == '*') || (ch == '/'))//遇到运算符，出栈两个数字进行运算
                {
                    int a, b;//注意两个元素的先后顺序
                    a = stack.Pop();
                    b = stack.Pop();
                    switch (ch)
                    {
                        case '+':
                            stack.Push(b + a);
                            break;
                        case '-':
                            stack.Push(b - a);
                            break;
                        case '*':
                            stack.Push(b * a);
                            break;
                        case '/':
                            stack.Push(b / a);
                            break;
                        default:
                            break;
                    }
                    i++;
                }
                else
                {
                    i++;
                }
            }
            return stack.Pop();
        }

        public bool isValid()
        {
            bool valid = false;
            int i = 0, oper = 0, num = 0;
            char ch;
            while(i < expstr.Length)
            {
                ch = expstr[i];
                if((ch == '+') || (ch == '-') || (ch == '*') || (ch == '/'))
                {
                    oper++;
                    i++;
                }
                else if((ch >= '0') && (ch <= '9'))
                {
                    while((ch >= '0') && (ch <= '9'))//连在一起的数字当做一个运算数
                    {
                        i++;
                        if(i < expstr.Length)
                        {
                            ch = expstr[i];
                        }
                        else
                        {
                            break;
                        }
                        
                    }
                    num++;
                }
                else
                {
                    i++;
                }
            }
            valid = (num == (oper + 1)) || ((num == 1) && (oper == 0));
            return valid;
        }

        public bool isMatchBacket()
        {
            bool isMatch = false;
            SequencedStack<char> stack = new SequencedStack<char>();
            int i = 0;
            while(i < expstr.Length)
            {
                if(expstr[i] == '(')
                {
                    stack.Push('(');
                }
                else if(expstr[i] == ')')
                {
                    if (stack.Empty)
                    {
                        return false;
                    }
                    else
                    {
                        if (stack.Peek() == '(')
                        {
                            stack.Pop();
                        }
                    }
                }
                i++;
            }
            isMatch = stack.Empty;
            return isMatch;
        }

        public override string ToString()
        {
            return expstr;
        }

        public static void Main(string[] args)
        {
            string str = "((1 + 2) * (4 - 3) - 5 + 6) * 8 / 2";
            EvalExp expstr = new EvalExp(str);
            Console.WriteLine("Expression string: " + expstr);
            Console.WriteLine("Transformed string: " + expstr.Transform());
            Console.WriteLine("Value: " + expstr.Eval());
            while (true)
            {
                Console.WriteLine();
                Console.WriteLine("Please input an expression(-1 for exit):");
                str = Console.ReadLine();
                if(str == "-1")
                {
                    break;
                }
                else
                {
                    expstr.EXPSTR = str;
                    if (!expstr.isMatchBacket())//先检查表达式的括号是否匹配
                    {
                        Console.WriteLine("The bracket do not match!!! ");
                        continue;
                    }
                    else
                    {
                        if (!expstr.isValid())//再检查表达式是否合法
                        {
                            Console.WriteLine("This is not a valid expression!!! ");
                            continue;
                        }
                        else
                        {
                            Console.WriteLine("Expression string: " + expstr);
                            Console.WriteLine("Transformed string: " + expstr.Transform());
                            Console.WriteLine("Value: " + expstr.Eval());
                        }
                    }
                }
            }
        }
    }
}
