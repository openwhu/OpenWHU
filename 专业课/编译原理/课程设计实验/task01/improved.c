/*improved.c 		XL分析器 */

/* Revised parser  */
int	legal_lookahead(int first_arg, ... );
#include <stdio.h>
#include "lex.h"

void    factor      ( void );
void    term        ( void );
void    expression  ( void );

statements()
{
  /*  statements -> expression SEMI |  expression SEMI statements */

  while( !match(EOI) )
    {
      expression();
      
      if( match( SEMI ) )
	advance();
      else
	fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );
    }
}

void    expression()
{
  /* expression  -> term expression'
   * expression' -> PLUS term expression' |  epsilon
   */

  if ( !legal_lookahead( NUM_OR_ID, LP, 0 ) )
    return;

  term();
  while( match( PLUS ) || match (MINUS) ) {
    advance();
    term();
  }
}

void    term()
{
  if( !legal_lookahead( NUM_OR_ID, LP, 0 ) )
    return;
  
  factor();
  while( match( TIMES ) || match( DIVISION ) ) {
    advance();
    factor();
  }
}

void    factor()
{
  if( !legal_lookahead( NUM_OR_ID, LP, 0 ) )
    return;
  
  if( match(NUM_OR_ID) )
    advance();
  
  else if( match(LP) )
    {
      advance();
      expression();
      if( match(RP) )
	advance();
      else
	fprintf( stderr, "%d: Mismatched parenthesis\n", yylineno );
    }
  else
    fprintf( stderr, "%d: Number or identifier expected\n", yylineno );
}

#include <stdarg.h>

#define MAXFIRST 16
#define SYNCH	 SEMI

int	legal_lookahead(int first_arg, ... )

{
  /* 本函数是一个典型的可变参数的函数,其参数是可能的下一个合法输入的列表
   * 如果列表为空表示匹配文件结束标记, 如果当前输入不是合法的,函数将放弃
   * 当前输入直到有一个合法的为止. 返回非0表示向前查看的字符是合法的,
   * 否则表示不可以恢复的错误.
   */

  va_list  	args;
  int		tok;
  int		lookaheads[MAXFIRST], *p = lookaheads, *current;
  int		error_printed = 0;
  int		rval	      = 0;
  
  va_start( args, first_arg );

  if( !first_arg ) {
    if( match(EOI) )
      rval = 1;
    }
  else {
    *p++ = first_arg;
    while( (tok = va_arg(args, int)) && p < &lookaheads[MAXFIRST] )
      *p++ = tok;
    
    while( !match( SYNCH ) ) {
      for( current = lookaheads; current < p ; ++current )
	if( match( *current ) ) {
	  rval = 1;
	  goto exit;
	}
      
      if( !error_printed ) { /* 避免重复打印错误信息 */
	fprintf( stderr, "Line %d: Syntax error\n", yylineno );
	error_printed = 1;
      }
      
      advance();
    }
  }
  
 exit:
  va_end( args );
  return rval;
}















