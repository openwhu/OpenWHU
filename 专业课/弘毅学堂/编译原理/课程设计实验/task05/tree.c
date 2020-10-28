#include "tree.h"


AST *make_ast(void)
{
  AST *t = (AST *)smalloc(sizeof(struct Ast));
  t -> kind = 0;
  t -> value = 0;
  t -> lchild = NULL;
  t -> rchild = NULL;
  t -> cond = NULL;
  return t;
}


AST *make_string(char *name)
{
  AST *t =  make_ast();
  t -> kind = VAR;
  t -> lchild = (AST *) name;
  return t;
}

AST *make_var(int deepth)
{
  AST *t = make_ast();
  t -> kind = VAR;
  t -> value = deepth;
  return t;
}

AST *make_const(int value)
{
  AST *t = make_ast();
  t -> kind = CONST;
  t -> value = value;
  return t;
}

AST *make_abs(char *var, AST *body)
{
  AST *t = make_ast();
  t -> kind = ABS;
  t -> lchild = (AST *) var;
  t -> rchild = body;
  return t;
}

AST *make_app(AST *lchild, AST *rchild)
{
  AST *t = make_ast();
  t -> kind = APP;
  t -> lchild = lchild;
  t -> rchild = rchild;
  return t;
}

AST *make_cond(AST *cond, AST *lchild, AST *rchild)
{
  AST *t = make_ast();
  t -> kind = COND;
  t -> cond = cond;
  t -> lchild = lchild;
  t -> rchild = rchild;
  return t;
}

void free_ast(AST *t)
{
  if (t == NULL) return;
  switch (t -> kind) {
  case CONST: break;
  case VAR: if (t -> lchild) sfree(t->lchild); 
    break;
  case ABS: 
    if (t-> lchild) sfree(t -> lchild); 
    free_ast(t -> rchild);
    break;
  case COND: free_ast(t -> cond);
    /* APP node */
  default:  free_ast(t -> lchild); free_ast(t -> rchild);
  }
  sfree(t);
  return;
}

int find_deepth(char *name)
{
  int i = current - 1;
  while (i + 1) {
    if (strcmp(name, name_env[i]) == 0) return current - i ;
    i--;
  }
  printf("id %s is unbound!\n", name);
  exit (1);
}


void printtree_rec(AST * t)
{
  if (t == NULL) return;
  switch (t -> kind) {
  case CONST: 
    fprintf(texfile,  "[.\\node{\\tt %d};]\n", t -> value);
    return;
  case VAR: 
    fprintf(texfile, "[.\\node{\\tt %d:%s};]\n", 
	    t -> value , t -> lchild ? (char *) t -> lchild : ""); 
    return;
  case ABS: 
      fprintf(texfile, "[.\\node{\\tt ABS}; \n \
      [.\\node{\\tt %s};]\n", t -> lchild ? (char *) t -> lchild : ""); 
    printtree_rec(t-> rchild);
    fprintf(texfile, "]\n");
    return;
  case APP:
    fprintf(texfile, "[.\\node{\\tt APP}; \n");
    printtree_rec(t -> lchild);
    printtree_rec(t -> rchild);
    fprintf (texfile, "]\n");
    return;
  case COND:
    fprintf(texfile, "[.\\node{\\tt IF}; \n");
    printtree_rec(t -> cond);
    printtree_rec(t -> lchild);
    printtree_rec(t -> rchild);
    fprintf (texfile, "]\n");
  }
  return;
}



void print_expression(AST * tree, FILE *out) 
{
  if (tree == NULL) return;
  switch(tree -> kind) {
  case CONST: fprintf(out, "%d", tree -> value); break;
  case VAR: 
    fprintf(out, "(%s:%d)",  tree -> lchild ? (char *) tree -> lchild : "", 
	   tree -> value);
    break;
  case COND: fprintf(out, "if"); print_expression(tree -> cond, out);
    fprintf(out, "then"); print_expression(tree -> lchild, out);
    fprintf(out, "else"); print_expression(tree -> rchild, out);
    break;
  case ABS: fprintf(out, "(@%s.", 
		    tree -> lchild ? (char *) tree -> lchild : "");
    print_expression(tree -> rchild, out);
    fprintf(out, ")"); break;  
  default: /* APP */
    fprintf(out, "("); print_expression(tree -> lchild, out);
    print_expression(tree ->rchild, out);
    fprintf(out, ")");
  }
  return;
}

void printtree(AST * t)
{
  fprintf(texfile, "\\exptree{");
  print_expression(t, texfile);
  fprintf(texfile, "}{\\Tree\n");
  printtree_rec(t);
  fprintf(texfile, "}\n");
}
