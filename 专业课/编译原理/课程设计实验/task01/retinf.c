/***********************************************/
/*      File: retinf.c                         */
/*      Author: Li  Yunzhe                     */
/*      Contact: liyunzhe@whu.edu.cn           */
/*      License: Copyright (c) 2019 Li Yunzhe  */
/***********************************************/

/* retinf.c   	AXL分析器 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "lex.h"

char err_id[] = "error";
char * midexp;
extern char * yytext;

struct YYLVAL {
  char * val;  /* 记录表达式中间临时变量 */
  char * expr; /* 记录表达式后缀式 */
  int last_op;  /* last operation of expression 
		   for elimination of redundant parentheses */
};

typedef struct YYLVAL Yylval;

Yylval * expression ( void );

char *newname( void ); /* 在name.c中定义 */

extern void freename( char *name );

void statements ( void )
{
  /*  statements -> expression SEMI  |  expression SEMI statements  */
  printf("Please enter a prefix expression and ending with \";\" :\n");
  while (!match(EOI))
  {
    Yylval *sent = expression();
    printf("The infix expression is %s\n", sent->expr);
    freename(sent->val);
    if (match(SEMI)) 
    {
      printf("Please enter a prefix expression and ending with \";\" :\n");
      advance();
    }else
    {
      fprintf(stderr, "%d: Inserting miss semicolon\nThe input is not a prefix expression\n", yylineno);
      exit(1);
    }
  }

}

Yylval *expression()
{ 
  /*
    expression -> PLUS expression expression
               |  MINUS expression expression
               |  TIMES expression expression
               |  DIVISION expression expression
	       |  NUM_OR_ID
  */

   Yylval *temp = (Yylval *) malloc(sizeof(Yylval));
   if (match(PLUS) || match(MINUS)) //将中缀表达式理解为用加减连接的几个表达式
   {
     char op = yytext[0];
     advance();
     Yylval *temp1 = expression();
     Yylval *temp2 = expression();
     temp->last_op = 1;
     temp->expr = (char *) malloc(strlen(temp1->expr) + 3 + strlen(temp2->expr));//一个符号加两个空格，刚好是三个
     sprintf(temp->expr, "%s %c %s", temp1->expr, op, temp2->expr);
     char *name1 = temp1->val;
     char *name2 = temp2->val;
     freename(temp1->val);
     freename(temp2->val);
     char *reg_name = newname();
     temp->val = reg_name;
     printf("%s %c= %s\n",reg_name, op, name1);//依次来，有一个递归在里面，先放进去name1，然后处理name2，此时，name2已经变成新函数里面的name1了
   }
   else if (match(TIMES) || match(DIVISION))
   {
     char op = yytext[0];
     advance();
     Yylval *temp1 = expression();
     Yylval *temp2 = expression();
     temp->last_op = 2;//2表示乘除
     if (temp1->last_op==1 || temp2->last_op==1)
     {
       if (temp1->last_op!=1)
       {
         //前面的是乘除，优先级比较高，因此后面要加括号
         temp->expr = (char *) malloc(strlen(temp1->expr) + 9 + strlen(temp2->expr));
         sprintf(temp->expr, "%s %c %c %s %c", temp1->expr, op, '(', temp2->expr, ')');
         char *name1 = temp1->val;
         char *name2 = temp2->val;
         freename(temp1->val);
         freename(temp2->val);
         char *reg_name = newname();
         temp->val = reg_name;
         printf("%s %c= %s\n", reg_name, op, name1);
       }
       else if (temp2->last_op!=1)
       {
         //后面是乘除，优先级较高，因此前面加括号
         temp->expr = (char *) malloc(strlen(temp1->expr) + 9 + strlen(temp2->expr));
         sprintf(temp->expr, "%c %s %c %c %s", '(', temp1->expr, ')', op, temp2->expr);
         char *name1 = temp1->val;
         char *name2 = temp2->val;
         freename(temp1->val);
         freename(temp2->val);
         char *reg_name = newname();
         temp->val = reg_name;
         printf("%s %c= %s\n", reg_name, op, name1);
       }
       else
       {
         //两边都是加减，因为中间是乘除，所以都要加括号
         temp->expr = (char *) malloc(strlen(temp1->expr) + 15 + strlen(temp2->expr));
         sprintf(temp->expr, "%c %s %c %c %c %s %c", '(', temp1->expr, ')', op, '(', temp2->expr, ')');
         char *name1 = temp1->val;
         char *name2 = temp2->val;
         freename(temp1->val);
         freename(temp2->val);
         char *reg_name = newname();
         temp->val = reg_name;
         printf("%s %c= %s\n", reg_name, op, name1);
       }
       
     }
     else
     {
       //两边都是乘除，都不加括号
         temp->expr = (char *) malloc(strlen(temp1->expr) + 3 + strlen(temp2->expr));
         sprintf(temp->expr, "%s %c %s", temp1->expr, op, temp2->expr);
         char *name1 = temp1->val;
         char *name2 = temp2->val;
         freename(temp1->val);
         freename(temp2->val);
         char *reg_name = newname();
         temp->val = reg_name;
         printf("%s %c= %s\n", reg_name, op, name1);
     }
   }
   else if (match(NUM_OR_ID))
   {
     char *name = (char *) malloc(yyleng + 1);//给空格留位置
     strncpy(name, yytext, yyleng);
     char *reg_name = newname();
     printf("%s = %s\n", reg_name, name);
     temp->expr = (char *) malloc(strlen(name));
     sprintf(temp->expr, "%s", name);
     temp->val = reg_name;
     temp->last_op = 2;//对于一个数而言，也类似与乘法，因为a*b*c不需要加括号
     advance();//扫描过了，继续往前
   }
   else
   {
     advance();
   }
   return temp;
   
}

