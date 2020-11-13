/* plain.c 	XL分析器*/
/* Basic parser, shows the structure but there's no code generation */

#include <stdio.h>
#include <stdlib.h>
#include "lex.h"

char    *factor     ( void );
char    *term       ( void );
char    *expression ( void );
char    *term_prime      ( char *);
char    *expr_prime( char *);


statements()
{
  /*  statements -> expression SEMI
   *             |  expression SEMI statements
   */
  
  printf("affix is : %s\n", expression());
  
  if( match( SEMI ) )
    advance();
  else
    fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );
  
  if( !match(EOI) )
    statements();			/* 处理下个语句 */
}

char *expression()
{
  /* expression -> term expression' */
  char *t;
  t = term();
  return expr_prime(t);
}

char *expr_prime(char *exp)
{
  /* expression' -> PLUS term expression'
   *              | epsilon
   */
  char *t = exp;
  if( match( PLUS ) || match (MINUS) ) {
    char * t1, *t2 ;
    char op = yytext[0];
    advance();
    t1 = term();
    t2 = (char *) malloc((strlen (t1) + strlen(t)+5)*sizeof(char));
    sprintf(t2, "%c %s %s", op, t, t1);
    
    t=expr_prime(t2);
  } 
  return t;
}

char *term()
{
  /* term -> factor term' */
  char *t;
  t = factor();
  return term_prime(t);
}

char *term_prime(char * tp)
{
  /* term' -> TIMES factor term'
   *       |   epsilon
   */
  if( match( TIMES ) || match (DIVISION) ) {
    char * t1,*t2 ;
    char op = yytext[0];
    advance();
    t1 = factor();
    t2 = (char *) malloc((strlen (t1) + strlen(tp)+5)*sizeof(char));
    sprintf(t2, "%c %s %s", op, tp, t1);
    tp = term_prime(t2);
    }
  return tp;
}

char *factor()
{
  /* factor   ->    NUM_OR_ID
   *          |     LP expression RP
   */
  char * fp;
  if( match(NUM_OR_ID) )  {
    fp = (char *) malloc ((yyleng+1)*sizeof(char));
    sprintf(fp,"%0.*s", yyleng, yytext );
    advance();
  }
  else if( match(LP)) {
    advance();
    fp = expression();
    if( match(RP) )
      advance();
    else
      fprintf( stderr, "%d: Mismatched parenthesis\n", yylineno);
    }
  else {
    fp = (char *) malloc(4);
    advance();    
    sprintf(fp, "err");
    fprintf( stderr, "line %d %0.*s is not Number or identifier\n", 
	     yylineno, yyleng, yytext );
  }
  return fp;
}
