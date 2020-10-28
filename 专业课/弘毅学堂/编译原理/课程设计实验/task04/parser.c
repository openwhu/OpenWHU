
/************************************************************/
/*      copyright hanfei.wang@gmail.com                     */
/*             2019.09.04                                   */
/************************************************************/

#include <ctype.h>
#include <stdlib.h>
#include "ast.h"

/* extended regular expression: 3 binary operators added
   1/ Difference: e1 - e2, L(e1 - e2) = L(e1) - L(e2)
 
   2/ Interleave product: e1 ^ e2
      a ^ b = a b | b a
      ab ^ ba = (a ^ b) (a ^ b) 
      a ^ b ^ c = a b c | a c b | b a c | b c a | c a b | c b a
   
   3/ Intersection: e1 & e2, L(e1 & e2) = L(e1) \cap L(e2)

   the order of precedences from low to high: |, -, ^, &, concat, *

   so the grammar:

   reg -> term_or reg'
   reg' -> '|' term_or reg' | epsilon

   term_or -> term_diff term_or'
   term_or' -> '-' term_alt term_or' | epsilon

   term_alt -> term_and term_alt'
   term_alt' -> '^' term_and term_alt'

   term_and -> term term_and'
   term_and' -> '&' term term_and' | epsilon
  
   term -> kleene term'
   term' -> kleene term' | epsilon
  
   kleene -> fac kleene' 
   kleene' -> * kleene' | epsilon
  
   fac -> alpha | '(' reg ')'
*/

#define BUFFER_SIZE 1024
static char input_buffer[BUFFER_SIZE] = "\0";
static char * current = input_buffer;


AST_PTR lookup(AST_PTR);

AST_PTR insert(AST_PTR);

void next_token(void)
{
  if ( !*current ) {
    current = input_buffer;
    if ( !fgets(input_buffer, BUFFER_SIZE - 1, stdin) ) {
      *current = '\0';
      return; 
    }
  } else current ++;

  while ( isspace (*current) ) 
    current ++;
}

AST_PTR term ();
AST_PTR term1(AST_PTR kleene_left);
AST_PTR kleene();
AST_PTR kleene1( AST_PTR fac_left);
AST_PTR fac();

AST_PTR expr(Kind op);
AST_PTR expr1(Kind op, AST_PTR left);

void start()
{
  AST_PTR root = expr (Or);

  if ( *current != '\0' ) 
    printf("the parser finished at %c, before the end of RE\n", *current);
 
  printf("the simplified exp is %s\n", root->exp_string);
  printf("\n");
  graphviz_ast(root);
  reg2nfa(root);
}

/* 
  expr(op1) -> expr(op2) expr1(op1)
  expr1(op1) -> op2 expr(op2) expr1(op1)
             | epsilon 
  where op1 = |, op2 = -;
        op1 = -, op2 = ^;
        op1 = ^, op2 = &;
        op1 = &, op2 = Seq; 
*/

AST_PTR expr(Kind op)
{
  AST_PTR left;
  switch (op) {
  case Or: left = expr(Diff);
      return expr1(Or, left);
  case Diff: left = expr(Alt);
      return expr1(Diff, left);
    
  case Alt: left = expr(And);
      return expr1(Alt, left);
    
  default:  left = term();
      return expr1(And, left);
  }
}

AST_PTR expr1(Kind op, AST_PTR left)
{
  AST_PTR right, tmp;
  char op_ch;
  switch (op) {
  case Or: op_ch = '|'; break;
  case Diff: op_ch = '-'; break;
  case Alt: op_ch = '^'; break;
  default: op_ch = '&'; 
  }  
  if (*current == op_ch ) {
    next_token ();
    right = expr(op);
    /* tmp = mkOpNode(op, left, right); */
    tmp = arrangeOpNode(op, left, right);
    return expr1(op, tmp);
  } else
    return left;
}


/*  term -> kleene term' */
AST_PTR term ()
{
  AST_PTR kleene_left = kleene ();
  return term1(kleene_left);
}

/*  term' -> kleene term' | epsilon */
AST_PTR term1(AST_PTR kleene_left)
{
  if ( isalnum(*current) || *current == '(' || *current == '!' ) { 
    /* no advance! */
    AST_PTR kleene_right = kleene (),
      /* kleene_tmp = mkOpNode(Seq, kleene_left, kleene_right); */
      kleene_tmp = arrangeSeqNode(kleene_left, kleene_right);
    return term1(kleene_tmp);
  } else
    return kleene_left;
}

/*  kleene -> fac kleene' */
AST_PTR kleene()
{
  AST_PTR fac_left = fac(); 
  return kleene1 (fac_left);
}

/*   kleene' -> * kleene' | epsilon */
AST_PTR kleene1( AST_PTR fac_left)
{
  if (*current == '*') {
    AST_PTR fac_right = mkStarNode(fac_left);
    next_token();
    return kleene1(fac_right);
  } else
    return fac_left;
}

/*   fac -> alpha | '(' reg ')' */
AST_PTR fac()
{ 
  if ( !*current ) {
    printf ("missing an operant!\n");
    exit(1);
  }
 
  if ( isalnum(*current) ) {
    char c = * current;
    next_token();
    return mkLeaf(c);
  } 

  if ( *current == '!' ) {
    next_token();
    return mkEpsilon ();
  }

  if ( *current == '(' ) {
    AST_PTR re; 
    next_token ();
    re = expr(Or);
    if ( *current != ')' ) 
      printf("Syntax error: missing ')'\n");
    next_token ();
    return re;
  }

  printf("Illegal character %c is skip\n", *current);
  next_token();
  return fac();
}
