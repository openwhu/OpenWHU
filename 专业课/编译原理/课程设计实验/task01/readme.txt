
2016级编译原理课程设计第一次编程作业
			
XL语言编译器

XL语言的单词:

EOI : 输入结束
SEMI: 匹配单个字符';'
PLUS: 匹配单个字符'+'
TIMES: 匹配单个字符'*'
LP: 匹配单个字符'('
RP: 匹配单个字符')'
NUM_OR_ID: 匹配十进制整数或标识符

XL语言的递归形式定义:

statments ->  expression SEMI EOI
	| expression SEMI statments

expression -> term expression'

expression' -> PLUS term expression'
	|    epsilon   /* 空串 */

term ->	factor term'

term' -> TIMES factor term'
	|    epsilon	/* 空串 */

factor-> NUM_OR_ID
	| LP expression RP

程序模块

lex.h		词汇宏定义头文件
lex.c		词法分析模块
plain.c		语法分析模块(不含语义分析)
improved.c	plain.c的改进, 提通过legal_lookahead函数将 expresssion 
		和expression'; term和term'合为一个函数处理,简化plain.c
		的分析程序
name.c		临时变量分配函数
affix.c 	语法分析模块(含有语义分析, 转换为前缀表达式)
retval.c	语法分析模块(含有语义分析, 生成中间语言)
retsuff.c	语法分析模块(同时生成中间语言和前缀表达式)
retinf.c        前缀表达式语法分析模块，未完成！
retinf.exe	DOS样本执行文件；
retinf		Linux64位样本执行程序

main.c		主函数

unixmake.mak	linux Makefile file: 用下述命令
                $ make -f unixmake.mak 
		生成所有的执行文件；

tcmake.mak	Turbo C Makefile(请在命令行下操作!):
		1/ C> path=c:\tc;%path%
		   其中c:\tc为turbo C的执行文件路径名；
		2/ cd 本文件集所在的路径；
		3/ 更改 tcmake.mak 中的TCHOME路径为你系统中的tc路径；
		4/ C> make -ftcmake.mak 
		   生成所有的执行文件；


作业:

1) 学习如何制作Makefile(讲义make.pdf)和命令行执行gcc(讲义gcc.pdf).
   认真阅读本软件包的所有程序, 并用make生成plain, improved, affix 
   和retval执行文件(TC或GCC环境)；

2) 完成retinf.c，其中前缀表达式的文法如下：

   statements -> expression SEMI  |  expression SEMI statements
   
   expression -> PLUS expression expression
               |  MINUS expression expression
               |  TIMES expression expression
               |  DIVISION expression expression
	       |  NUM_OR_ID

   定义递归调用函数 expression()的返回值类型为：
  
   struct YYLVAL {
     char * val;  /* 记录表达式中间临时变量 */
     char * expr; /* 记录表达式后缀式 */
   };

   typedef struct YYLVAL Yylval;
 
  试完成retinf.c中的函数
  void    *statements     ( void );
  Yylval    *expression ( void );

  使得语义分析在完成分析前缀表达式并输出中间代码的同时，也能够将前缀
  表达式翻译为中缀表达式, 且要求翻译后的中缀表达式中尽可能少用括号。
  如： 输入"+ a * b c;"时，应输出中缀式为" a + b * c", 而不是"a + (b * c)"或
  "(a) + (b * c)"等(参见样本程序retinf.exe的执行情况)。
  
  注意：由于 expression()等返回的是指针，所指的内容
  一定不能是局部变量，否则函数返回时其运行环境释放，
  指向该函数局部变量的存储空间将做它用，而不是所期望
  的结果(Dangling Reference), 所以是全局变量或malloc()
  动态申请的存储空间。
 
  请测试: "* + a b * c d;"的输出结果.

3) XL语言分析器的结合次序和优先级, 用retsuff.exe对输入表达式: "1 + 2 + 3;", 
   先进行 1 + 2 的运算, 还是先进行 2 + 3 的运算. 
   输入"1+2*3;"，先算"2*3"，还是先算"1+2".

4) 思考： 考虑前缀表达式：
   + a + b + + c d + e f;
   经过retinf.exe编译输出：
    t0 = a
    t1 = b
    t2 = c
    t3 = d
    t2 += t3
    t3 = e
    t4 = f
    t3 += t4
    t2 += t3
    t1 += t2
    t0 += t1
   即需要t0, t2, ..., t4五个寄存器完成表达式的计算。但是如果修改计算次序如下：
    t0 = c
    t1 = d
    t0 += t1
    t1 = e
    t2 = f
    t1 += t2
    t0 += t1
    t1 = b
    t0 += t1
    t1 = a
    t0 += t1
    即只需三个寄存器。试思考如何实现上述算法。
    (请参考: 河流命名算法(https://en.wikipedia.org/wiki/Strahler_number))

    问如何修改你的程序使得所翻译的中间代码使用的寄存器最少。

    而如果修改计算的结合次序为：+ + + + + a b c d e f, 
    则仅需两个寄存器......  
    (hard, 请参考: 寄存器的分配实际上同构与图论的着色问题(NP-complete)
    (https://en.wikipedia.org/wiki/Register_allocation)
    (龙书：P.556))

5) 请将完成后的retinf.c程序(不要其他的文件，也不要打包压缩)
   mailto: hanfei.wang@gmail.com
   邮件主题请标明: 学号(1)
  

hfwang

2019.09.02




	
