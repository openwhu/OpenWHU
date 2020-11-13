/* retval.c  	XL分析器*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "lex.h"

char err_id[] = "error";
char * midexp;

struct YYLVAL {
  char * val;  /* 记录表达式中间临时变量 */
  char * expr; /* 记录表达式前缀式 */
};

typedef struct YYLVAL Yylval;

Yylval    *factor     ( void );
Yylval    *term       ( void );
Yylval    *expression ( void );

char *newname( void ); /* 在name.c中定义 */

extern void freename( char *name );

void statements ( void )
{
  /*  statements -> expression SEMI  |  expression SEMI statements  */
  
  Yylval *temp;
  printf("Please input an infix expression and ending with \";\"\n");
  while( !match(EOI) )    {
    temp = expression();
    printf("the affix expression is %s\n", temp -> expr);
    freename(temp -> val);
    free(temp -> expr);
    free(temp);    
    if( match( SEMI ) ){
      advance();
      printf("Please input an infix expression and ending with \";\"\n");
    }
    else
      fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );
  }
}

Yylval    *expression()
{
  /* expression -> term expression'
     expression' -> PLUS term expression' 
                 |  MINUS term expression'
                 |  epsilon           */
  
  Yylval  *temp, *temp2;
  
  char *tmpmid;  /* 记录前缀表达式 */
  char *tmpmid1;
  
  temp = term();
  tmpmid = temp->expr;
  
  while( match( PLUS )|| match(MINUS) ) {
    char op = yytext[0];
    advance();
    temp2 = term();
    printf("    %s %c= %s\n", temp ->val, op, temp2 ->val );
	/* generate code by side effects */

    freename( temp2 ->val );
      
    /* 对已经是别的句型 term PLUS term2 生成其对应的前缀式
       该前缀式为：  "+" + term->expr + " " + term2->expr  */

    /* 对已经是别的句型 term MINUS term2 生成其对应的前缀式
       该前缀式为：  "-" + term->expr + " " + term2->expr  */
  
  
    tmpmid1 = (char *) malloc(strlen(temp2 -> expr) + strlen(tmpmid) + 4);
    sprintf (tmpmid1, "%c %s %s", op, tmpmid, temp2 -> expr);

    free(tmpmid);  /* 一定要释放 */

    tmpmid = tmpmid1;
    free(temp2->expr);
    free(temp2); 

  }
  temp->expr = tmpmid; /* 借用第一个term()的结构作为新的返回 */
  
  return temp;
}

Yylval    *term( void)
{
  Yylval  *temp, *temp2 ;
  char  *tmpmid, *tmpmid1;
  temp = factor();
  tmpmid = temp->expr;
  while( match( TIMES ) || match( DIVISION ) )    {
    char op = yytext[0];
    advance();
    temp2 = factor();
    printf("    %s %c= %s\n", temp->val, op, temp2->val );
	/* generate code by side effects */

    freename( temp2->val );

    tmpmid1 = (char *) malloc(strlen(temp2->expr) + strlen(tmpmid) + 4);
    sprintf ( tmpmid1, "%c %s %s", op, tmpmid, temp2 -> expr);   
    free(tmpmid);
    tmpmid = tmpmid1;
    free(temp2->expr);
    free(temp2);
  }
  
  temp->expr = tmpmid;
  return temp;
}

Yylval    *factor( void )
{
  Yylval *temp;
  char * tmpvar, *tmpexpr;
  if( match(NUM_OR_ID) )    {
    tmpvar = newname();
    tmpexpr = (char *) malloc(yyleng + 1);

    strncpy(tmpexpr, yytext, yyleng);
    tmpexpr[yyleng] = 0; 

    printf("    %s = %s\n", tmpvar, tmpexpr );
	/* generate code by side effects */
    
    temp = (Yylval *) malloc(sizeof(Yylval)); 
      /* 一定要动态申请
	 指向局部变量的指针绝对不能是返回值 */
    temp->val = tmpvar;
    temp->expr = tmpexpr;
    advance();

  } else
    if( match(LP) ) {
      advance();
      temp = expression();
      if( match(RP) ){
	advance();
      } else
	fprintf(stderr, "%d: Mismatched parenthesis\n", yylineno );
    }
    else {
      char *s ;
      advance();
      s = (char *) malloc(10);
      strcpy(s,"error_id");
      fprintf( stderr, "%d: Number or identifier expected\n", yylineno );
      temp = (Yylval *) malloc( sizeof(Yylval));
      temp->val =  newname();
      temp->expr = s;
    }
  
  return temp;
}
