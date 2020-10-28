/*lex.c	 XL分析器 */


#include "lex.h"
#include <stdio.h>
#include <ctype.h>

char       *yytext   = "";  /* 当前词形,注意由于是直接指向
			       行缓冲区input_buffer,因此不是以'\0'结尾,
			       因此使用时要小心, 设初值为0, 表示缓冲区为空,
			       需要重新读行 */
int        yyleng    = 0;   /* 词形的长度	 */
int        yylineno  = 0;   /* 输入的行号	*/

lex()
{
  static char input_buffer[128];
  char        *current;
  
  current = yytext + yyleng;  	/* 跳过以读过的词形 */

  while( 1 ) {                  /* 读下一个词形     */
    while( !*current ) {
      /* 如果当前缓冲区已读完,重新从键盘读入新的一行.
	 并且跳过空格 
      */
      
      current = input_buffer;
      /* 如果读行有误,返回 EOI */
      if( !fgets( input_buffer, 127, stdin ) ) {
	*current = '\0' ;
	return EOI;
      }
      
      ++yylineno;
      
      while( isspace(*current) )
	++current;
    }

    for( ; *current ; ++current ) {
      /* Get the next token */
      
      yytext = current;
      yyleng = 1;
      
      /* 返回不同的词汇代码 */
      switch ( *current ) {
        case ';': return SEMI  ;
        case '+': return PLUS  ;
	case '-': return MINUS ;
	case '/': return DIVISION;
        case '*': return TIMES ;
        case '(': return LP    ;
        case ')': return RP    ;

        case '\n':
        case '\t':
        case ' ' : break;

        default:
	  if( !isalnum(*current) )
	    fprintf(stderr, "Ignoring illegal input <%c>\n", *current);
	  else {
	    while( isalnum(*current) )
	      ++current;
	    
	    yyleng = current - yytext;
	    return NUM_OR_ID;
	  }

	  break;
      }
    }
  }
}

static int Lookahead = -1;      /* 向前查看的词汇,设初值为-1
				   表示第一次调用match函数时
				   必须要读取一个词汇 */

int match( int token )
{
  /* 判断token是否和当前向前查看的词汇相同. */
  
  if( Lookahead == -1 )
    Lookahead = lex();
  
  return token == Lookahead;
}

void advance()
{
  /* 向前都一个词汇 */
  Lookahead = lex();
}
