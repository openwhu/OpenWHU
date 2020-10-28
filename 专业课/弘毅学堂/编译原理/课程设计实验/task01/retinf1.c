/***********************************************/
/*      File: retinf.c                         */
/*      Author: Yuan Haobo                     */
/*      Contact: yuanhaobo@whu.edu.cn          */
/*      License: Copyright (c) 2018 Yuan Haobo */
/***********************************************/

/* retinf.c   	AXL分析器 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lex.h"

char err_id[] = "error";
char *midexp;
extern char *yytext;

struct YYLVAL {
  char *val;   /* 记录表达式中间临时变量 */
  char *expr;  /* 记录表达式后缀式 */
  int last_op; /* last operation of expression
for elimination of redundant parentheses */
};

typedef struct YYLVAL Yylval;

Yylval *expression(void);

char *newname(void);

extern void freename(char *name);

void statements(void) {
  /*  statements -> expression SEMI  |  expression SEMI statements  */

  printf("Please enter a prefix expression and ending with \";\" :\n");
  while (!match(EOI)) {
    Yylval *sent = expression();
    printf("The infix expression is %s\n", sent->expr);
    freename(sent->val);
    if (match(SEMI)) {
      printf("Please enter a prefix expression and ending with \";\" :\n");
      advance();
    } else {
      fprintf(stderr, "%d: Inserting missing semicolon\n", yylineno);
    }
  }
}

Yylval *expression() {
  /*
expression -> PLUS expression expression
|  MINUS expression expression
|  TIMES expression expression
|  DIVISION expression expression
|  NUM_OR_ID
*/
  Yylval *temp = (Yylval *) malloc(sizeof(Yylval));
  if (match(PLUS) || match(MINUS)) {
    char op = yytext[0];
    advance();
    Yylval *temp1 = expression();
    Yylval *temp2 = expression();
    temp->last_op = 1;
    temp->expr = (char *) malloc(strlen(temp1->expr) + 3 + strlen(temp2->expr));
    sprintf(temp->expr, "%s %c %s", temp1->expr, op, temp2->expr);
    char *name1 = temp1->val;
    char *name2 = temp2->val;
    freename(temp1->val);
    freename(temp2->val);
    char *reg_name = newname();
    temp->val = reg_name;
    //printf("%s = %s %c %s\n", reg_name, name1, op, name2);
    printf("%s %c= %s\n", reg_name, op, name1);
  } else if (match(TIMES) || match(DIVISION)) {
    char op = yytext[0];
    advance();
    Yylval *temp1 = expression();
    Yylval *temp2 = expression();
    temp->last_op = 2;
    if (temp1->last_op==1 || temp2->last_op==1) {
      if (temp1->last_op!=1) {
        temp->expr =
            (char *) malloc(strlen(temp1->expr) + 9 + strlen(temp2->expr));
        sprintf(temp->expr, "%s %c %c %s %c", temp1->expr, op, '(', temp2->expr,
                ')');
        char *name1 = temp1->val;
        char *name2 = temp2->val;
        freename(temp1->val);
        freename(temp2->val);
        char *reg_name = newname();
        temp->val = reg_name;
        //printf("%s = %s %c %s\n", reg_name, name1, op, name2);
        printf("%s %c= %s\n", reg_name, op, name1);
      } else if (temp2->last_op!=1) {
        temp->expr =
            (char *) malloc(strlen(temp1->expr) + 9 + strlen(temp2->expr));
        sprintf(temp->expr, "%c %s %c %c %s", '(', temp1->expr, ')', op,
                temp2->expr);
        char *name1 = temp1->val;
        char *name2 = temp2->val;
        freename(temp1->val);
        freename(temp2->val);
        char *reg_name = newname();
        temp->val = reg_name;
        //printf("%s = %s %c %s\n", reg_name, name1, op, name2);
        printf("%s %c= %s\n", reg_name, op, name1);
      } else {
        temp->expr =
            (char *) malloc(strlen(temp1->expr) + 15 + strlen(temp2->expr));
        sprintf(temp->expr, "%c %s %c %c %c %s %c", '(', temp1->expr, ')', op,
                '(', temp2->expr, ')');
        char *name1 = temp1->val;
        char *name2 = temp2->val;
        freename(temp1->val);
        freename(temp2->val);
        char *reg_name = newname();
        temp->val = reg_name;
        //printf("%s = %s %c %s\n", reg_name, name1, op, name2);
        printf("%s %c= %s\n", reg_name, op, name1);
      }
    } else {
      temp->expr =
          (char *) malloc(strlen(temp1->expr) + 3 + strlen(temp2->expr));
      sprintf(temp->expr, "%s %c %s", temp1->expr, op, temp2->expr);
      char *name1 = temp1->val;
      char *name2 = temp2->val;
      freename(temp1->val);
      freename(temp2->val);
      char *reg_name = newname();
      temp->val = reg_name;
      //printf("%s = %s %c %s\n", reg_name, name1, op, name2);
      printf("%s %c= %s\n", reg_name, op, name1);
    }
  } else if (match(NUM_OR_ID)) {
    char *name = (char *) malloc(yyleng + 1);
    strncpy(name, yytext, yyleng);
    char *reg_name = newname();
    printf("%s = %s\n", reg_name, name);
    temp->expr = (char *) malloc(strlen(name));
    sprintf(temp->expr, "%s", name);
    temp->last_op = 2;
    temp->val = reg_name;
    advance();
  } else
    advance();
  return temp;
}
