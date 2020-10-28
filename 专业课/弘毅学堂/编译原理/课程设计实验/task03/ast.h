
/************************************************************/
/*      copyright hanfei.wang@gmail.com                     */
/*             2019.05.04                                  */
/************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <malloc.h>

#define HASHSIZE  997

typedef enum { Or = 1, Diff = 2, Alt = 3, And = 4, Seq = 5,
               Star = 6, Alpha = 7, Epsilon = 8, Empty = 9} Kind;
/* in order of increasing precdence */
typedef struct ast *AST_PTR;

typedef struct lf {
  struct lf * next;
  char symbol;
  AST_PTR exp;
} LF;

typedef LF *LF_PTR;

typedef struct ast {
  Kind op;  
  struct ast *lchild, *rchild;
  int hash;
  int nullable; /* = 1, if E is nullable */
  char *exp_string;  /* mostly simplified exp of E */
  int state;   /* state number. trap state is 0, 
                  the original exp is 1 */
  LF_PTR lf; /* linear form of NFA */
}  AST;


typedef struct exptab {
  struct exptab *next;
  AST_PTR exp;
} *EXPTAB; /* for hash table of expressions */
  
void next_token(void);

void start(void);

AST_PTR mkOpNode(Kind op, AST_PTR tree1, AST_PTR tree2);

AST_PTR mkLeaf(char c);

AST_PTR mkEmpty(void);

AST_PTR mkAltNode(AST_PTR, AST_PTR);
AST_PTR mkDiffNode(AST_PTR, AST_PTR);
AST_PTR mkAndNode(AST_PTR, AST_PTR);

AST_PTR mkOrNode(AST_PTR tree1, AST_PTR tree2);

AST_PTR mkEpsilon(void);

AST_PTR mkSeqNode(AST_PTR tree1, AST_PTR tree2);
AST_PTR arrangeSeqNode(AST_PTR L, AST_PTR C);
AST_PTR mkStarNode(AST_PTR tree);
AST_PTR right_distributive_op(Kind op, AST_PTR L, AST_PTR C);
AST_PTR left_distributive_op(Kind op, AST_PTR C, AST_PTR R);
AST_PTR arrangeOpNode(Kind op, AST_PTR tree1, AST_PTR tree2);

void free_node(AST_PTR tree);
  /* free memory of the tree */

void print_tree(AST_PTR tree);
void print_ast (AST_PTR tree);
void graphviz( AST_PTR tree );

int hash( char *s );

extern EXPTAB exptab[HASHSIZE];
/* defined in dfa.c */
void reg2dfa(AST_PTR exp);
 
void printdfa(void);
void mdfa(void);
void graphviz_dfa(char *filename); 


extern AST_PTR *StateTable;
/* store all state */
extern int next_state;
void addstate(AST_PTR exp);

extern AST_PTR EMPTY;
extern AST_PTR EPSILON;
void *safe_allocate(unsigned Bytes);
void *safe_reallocate(void *X, unsigned Bytes);
void reg2nfa(AST_PTR exp);
void printnfa(char);
void graphviz_nfa(char *filename, char Q_or_D);
void nmdfa(void);
extern int is_diff;
void graphviz_ast( AST_PTR tree );

