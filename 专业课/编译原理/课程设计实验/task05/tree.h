#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#define MAX_ENV 512
#define INIT_POS 6

extern int is_decl; 

typedef enum {CONST=1, VAR=2, COND=3, ABS=4, APP=5} Node_kind;
  
typedef struct Ast {
  Node_kind kind;
  int value; /* for CONST and De Brujin index */
  struct Ast  *lchild, /*  for variable name and
			   abstraction variable  
                           & apply function  body */
    *rchild; /* for abstraction body  and app argument*/
  struct Ast *cond; /* for condition */
} AST;

extern int current;
extern char *name_env[MAX_ENV];

extern AST *ast_env[MAX_ENV];

void * smalloc(size_t size); /* defined in emalloc.c */
 
void * sfree(void *);

AST *make_string(char *);
AST *make_ast(void);
AST *make_var(int deepth);
AST *make_const(int value);
AST *make_abs(char *var, AST *body);
AST *make_app(AST *lchid, AST *rchild);
AST *make_cond(AST *cond, AST *t_branch, AST * f_branch);
void free_ast(AST *);
int find_deepth(char *);

void printtree(AST *t);
extern FILE *texfile;
void print_expression(AST * tree, FILE *out);
