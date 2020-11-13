2017级弘毅班编译原理课程设计第2次编程作业

利用flex将HTML(http://www.w3.org/TR/html4/)文件转换文本文件

要求

1/ 删除所有的HTML标记，并将转换后的文件直接输出到屏幕上。

2/ 删除所有的开始标记为<script...>, <style...>和<form...>
   结束标记为</script>，</style>和</form>中间的所有内容
   如： 
   <script language="JavaScript">
<!--
function add2cart(id) {
 window.open('http://sms.sina.com.cn/cgi-bin/sms/add2cart.cgi?do=add&id='+id,'cart','width=310,height=160,resizable=0,scrollbars=0,status=no,toolbar=no,location=no,menu=no');
}
function add2fav(serviceid) {
 window.open('http://sms.sina.com.cn/cgi-bin/sms/myfavor.cgi?do=add&service=0&id='+serviceid,'myfav');
}
//-->
</script>
由于该内容在文本文件中没有了意义，所以要删除掉。

3/ 提出所有的锚中的超链，并将其保存在新建的文本文件hyplink.txt中
   如：
<a href = http://news.sina.com.cn/s/1.shtml class=f14 target=_blank>
<a href = "http://news.sina.com.cn/s/2.shtml" class=f14 target=_blank>
<a href = 'http://news.sina.com.cn/s/3.shtml' class=f14 target=_blank>

提取后保存在hyplink.txt中的内容将是：

http://news.sina.com.cn/s/1.shtml
http://news.sina.com.cn/s/2.shtml
http://news.sina.com.cn/s/3.shtml

4/ 几个简单的实体转换：
&qot; -------> '
&gt; -------> >
&lt; -------> <
&amp; ------> &
&nbsp; -----> ' ' (space)
(see: http://www.w3.org/TR/html4/charset.html#h-5.3.2)

注意：

1. HTML的标记是大小写不敏感的，如，要识别<script>的正规表达式是：
   '<'[Ss][Cc][Rr][Ii][Pp][Tt]'>'

2. 考虑使用flex中的条件模式 (见我的flex.pdf)，如：

%x SCRIPT

script开始标记的正规表达式      { BEGIN(SCRIPT);  
			    /* 开始条件，这是仅<SCRIPT>开始的模式有效 */
			}
<SCRIPT>'<'[Ss][Cc][Rr][Ii][Pp][Tt]'>'   { BEGIN(INITIAL);
                            /* 结束条件 */
			}
<SCRIPT>.|\n        { ;
			    /* 空语句,意味着过滤掉script中的字符 */
		     }

3. 运行样板程序 "./html2txt sina.htm > sina.txt"(Linux) or
                "html2txt.exe sina.htm > sina.txt"(DOS)
   查看运行结果: sina.txt和hyplink.txt两个文件


4. 编译方法：
   (1) flex html2txt.l 
       生成lexyy.c(linux下 lex.yy.c)
   (2) tcc lexyy.c (or gcc -o lexyy.c)
       生成执行文件。

   or 

   make -ftcmake.mak  (DOS) 
   make -f unixmake.mak (Linux)

5. 要求完成html2txt.l使得其编译后的结果与上样板程序一致。


6. 
   mailto: hanfei.wang@gmail.com
   邮件主题: 学号(2)
   邮件附件: html2txt.l
   deadline: 待定


hfwang

2019.9.16

