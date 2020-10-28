
#include "ast.h"

LF_PTR mk_lf(char c, AST_PTR exp)
{
  LF_PTR lf = safe_allocate(sizeof(LF));
  lf->exp = exp;
  lf->symbol = c;
  lf->next = NULL;
  return lf;
}

LF_PTR lf_clone(LF_PTR source)
{
  LF_PTR target, tmp;
  if (source == NULL) return NULL;
  tmp = target = mk_lf(source->symbol, source->exp);
  //依次递推下去，直到整个式子计算完
  while(source->next != NULL) {
    source = source->next;
    tmp->next = mk_lf(source->symbol, source->exp);
    tmp = tmp->next;
  }
  return  target;
}


LF_PTR lf_union(LF_PTR lf1, LF_PTR lf2)
{
  //需要tmp暂存一下
  LF_PTR tmp;
  tmp = lf1 = lf_clone(lf1);
  lf2 = lf_clone(lf2);

  if (lf1 == NULL) return lf2;
  while (tmp != NULL) {
    if (tmp->next == NULL) {
      tmp->next = lf2;
      //直接放到最后即可
      break;
    }
    //依次找到tmp的最后一个元素
    tmp = tmp -> next;
  }
  return lf1;
}

LF_PTR lf_union_plus(LF_PTR lf1, LF_PTR lf2)
{
  LF_PTR head, tmp, new, lf;
  head = lf = lf_clone(lf1);

  if (lf1 == NULL) return lf2;

  while (lf2 != NULL) {
    tmp = lf;
    while (tmp != NULL) {
      if (tmp->symbol == lf2->symbol) {
        tmp->exp = arrangeOpNode(Or, tmp->exp, lf2->exp);
 	      goto NEXT;
      }
      tmp = tmp->next;
    }
    new = mk_lf(lf2->symbol, lf2->exp);
    new->next = head;
    head = new;
  NEXT:
    lf2 = lf2 -> next;
  }
  return head;
}



void lf_alphabet(AST_PTR exp)
{
  exp->lf = mk_lf(exp->exp_string[0], EPSILON);
  //对于x，只要取第一个就可以了
}

LF_PTR lf_concate(LF_PTR lf, AST_PTR exp)
{
  LF_PTR tmp;
  tmp = lf = lf_clone(lf);
  if (tmp == NULL) return NULL;
  while (tmp != NULL) {
    tmp->exp = mkOpNode(Seq, tmp->exp, exp);
    tmp = tmp->next;
  }
  return lf;
}


LF_PTR lf_concate_plus(LF_PTR lf, AST_PTR exp)
{
  LF_PTR tmp;
  tmp = lf = lf_clone(lf);
  if (tmp == NULL) return NULL;
  while (tmp != NULL) {
    tmp->exp = arrangeSeqNode(tmp->exp, exp);
    tmp = tmp->next;
  }
  return lf;
}


int lf_length(LF_PTR lf)
{
  int len = 0;
  while (lf != NULL) {
    len++;
    lf = lf->next;
  }
  return len;
}

int is_minus(AST_PTR exp)
{
  if (exp == NULL) return 0;
  switch (exp->op) {
  case Diff: return 1;
  case Empty: case Epsilon:
  case Alpha:
    return 0;
  case Star:   return is_minus(exp->lchild);
  default: return is_minus(exp->lchild) || is_minus(exp->rchild);
  }
}

#define TABLEMAX 256
AST_PTR *StateTable = NULL; /* store all state */
int next_state = 0;


void addstate(AST_PTR exp)
{
  if (exp->state >= 0) return;
  if (next_state % TABLEMAX == 0)
  //此时恰好溢出，处理完毕
    StateTable =safe_reallocate(StateTable,
			    sizeof(exp) * (next_state + TABLEMAX));
  exp->state = next_state;
  StateTable[next_state++] = exp;
  return;
}

LF_PTR lf_alt_plus(LF_PTR lf, AST_PTR exp)
{
    LF_PTR tmp;

    tmp = lf = lf_clone(lf);
    if(tmp == NULL)
      return NULL;
    while (tmp != NULL) {
      tmp->exp = arrangeOpNode(Alt, tmp->exp, exp);
      tmp = tmp->next;
    }
    return lf;
}

//和之前的差不多，加了个符号，以适应拓展的要求
LF_PTR lf_ext_plus(Kind op, LF_PTR lf1, LF_PTR lf2)
{
  LF_PTR head, tmp, lf;
  head = lf = lf_clone(lf1);
  if(lf1 == NULL)
    return NULL;

  while (lf2 != NULL) {
    tmp = lf;
    while(tmp != NULL)
    {
      if(tmp->symbol == lf2->symbol)
      {
        tmp->exp = arrangeOpNode(op, tmp->exp, lf2->exp);
        goto NEXT;
      }
      tmp =tmp->next;
    }
NEXT:
    lf2 = lf2->next;
  }
  return head;
}

AST_PTR EMPTY;
AST_PTR EPSILON;

static LF_PTR (*union_method)() = lf_union;
static LF_PTR (*seq_method)() = lf_concate;
static LF_PTR (*alt_method)() = lf_alt_plus;
static LF_PTR (*ext_method)() = lf_ext_plus;


void linear_form(AST_PTR exp, int stated)
{
  LF_PTR tmp;
  //和前面的做法一样，用tmp去遍历
  int origin_nstate;

  switch (exp->op) {

    case Epsilon:
    exp->nullable = 1;
    exp->lf = NULL;
    break;

    case Empty:
    exp->nullable = 0;
    exp->lf = NULL;
    break;

    case Alpha:
    exp->nullable = 0;
    exp->lf = mk_lf(exp->exp_string[0], EPSILON);
    //add state
    if (stated) {
      origin_nstate = next_state;
      addstate(exp->lf->exp);
      if (origin_nstate != next_state)
      {
        linear_form(exp->lf->exp, stated);
        //递归调用，直到收敛
      }
    }
    break;

    case Or:
    //分成左右两个儿子重新做
    linear_form(exp->lchild, 0);
    linear_form(exp->rchild, 0);
    exp->nullable = exp->lchild->nullable | exp->rchild->nullable;
    exp->lf = union_method(exp->lchild->lf, exp->rchild->lf);
    if(stated)
    {
      tmp = exp->lf;
      while (tmp != NULL) {
        origin_nstate = next_state;
        addstate(tmp->exp);
        if(origin_nstate != next_state)
        {
          linear_form(tmp->exp, stated);
        }
        //遍历，直到最后
        tmp = tmp->next;
      }
    }
    break;

    case Seq:
    if (exp->lchild->nullable == 0)
    {
      linear_form(exp->lchild, 0);
      exp->nullable = 0;
      exp->lf = seq_method(exp->lchild->lf, exp->rchild);
    }
    else
    {
      linear_form(exp->lchild, 0);
      linear_form(exp->rchild, 0);
      exp->nullable = exp->rchild->nullable;
      exp->lf = union_method(seq_method(exp->lchild->lf, exp->rchild), exp->rchild->lf);
    }
    if(stated)
    {
      tmp = exp->lf;
      while(tmp != NULL)
      {
        origin_nstate = next_state;
        addstate(tmp->exp);
        if (origin_nstate != next_state)
        {
          linear_form(tmp->exp, stated);
        }
        tmp = tmp->next;
      }
    }
    break;

    case Star:
    linear_form(exp->lchild, 0);
    exp->nullable = 1;
    exp->lf = seq_method(exp->lchild->lf, exp);
    if(stated)
    {
      tmp = exp->lf;
      while(tmp != NULL)
      {
        origin_nstate = next_state;
        addstate(tmp->exp);
        if(origin_nstate != next_state)
        {
          linear_form(tmp->exp, stated);
        }
        tmp = tmp->next;
      }
    }
    break;

    case Alt:
    linear_form(exp->lchild, 0);
    linear_form(exp->rchild, 0);
    exp->nullable = exp->lchild->nullable & exp->rchild->nullable;
    exp->lf = union_method(alt_method(Alt, exp->lchild->lf, exp->rchild), alt_method(Alt, exp->rchild->lf, exp->lchild));
    if(stated)
    {
      tmp = exp->lf;
      while(tmp != NULL)
      {
        origin_nstate = next_state;
        addstate(tmp->exp);
        if(origin_nstate != next_state)
        {
          linear_form(tmp->exp, stated);
        }
        tmp = tmp->next;
      }
    }
    break;

    case And:
    linear_form(exp->lchild, 0);
    linear_form(exp->rchild, 0);
    exp->nullable = exp->lchild->nullable & exp->rchild->nullable;
    exp->lf = ext_method(And, exp->lchild->lf, exp->rchild->lf);
    if(stated)
    {
      tmp = exp->lf;
      while(tmp != NULL)
      {
        origin_nstate = next_state;
        addstate(tmp->exp);
        if(origin_nstate != next_state)
        {
          linear_form(tmp->exp, stated);
        }
        tmp = tmp->next;
      }
    }
    break;

    case Diff:
    linear_form(exp->lchild, 0);
    linear_form(exp->rchild, 0);
    exp->nullable = exp->lchild->nullable & !(exp->rchild->nullable);
    exp->lf = ext_method(Diff, exp->lchild->lf, exp->rchild->lf);
    if(stated)
    {
      tmp = exp->lf;
      while(tmp != NULL)
      {
        origin_nstate = next_state;
        addstate(tmp->exp);
        if(origin_nstate != next_state)
        {
          linear_form(tmp->exp, stated);
        }
        tmp = tmp->next;
      }
      break;
    }
  }
}


void reset_hash() /* destroy all lf and state flag */
{
  int i;
  for (i = 0; i < HASHSIZE; i++) {
    EXPTAB current = exptab[i];
    while (current != NULL) {
      current->exp->state = -1;
      current->exp->lf = NULL;
      current = current->next;
    }
  }
}


void reg2fa(AST_PTR exp, int is_dfa)
{
  char Q = is_dfa? 'D' : 'Q';
  char *gv_file_name = is_dfa? "dfa.gv" : "nfa.gv";

  if (is_dfa) {
    union_method = lf_union_plus;
    if (!is_minus(exp)) seq_method = lf_concate_plus;
    reset_hash();
    free(StateTable);
    next_state = 0;
    StateTable = NULL;
  }
  addstate(EMPTY);
  addstate(exp);
  linear_form(exp, 1);
  printnfa(Q);
  graphviz_nfa(gv_file_name, Q);
}

void reg2nfa(AST_PTR exp)
{
  EMPTY = mkEmpty();
  EPSILON = mkEpsilon();
  if(!is_minus(exp)) reg2fa(exp, 0);
  reg2fa(exp, 1);
  nmdfa();
  printnfa('M');
  graphviz_nfa("mdfa.gv", 'M');
}


static struct Equiv { AST_PTR left, right; } *EquivTable;

int equiv_next;
int EQUIVTABLEMAX = 0;

static void enqueue_equiv(AST_PTR L, AST_PTR R) {
   AST_PTR Q;
   int i;
   if (L == R) return;
   if (L->state > R->state) {
     Q = L, L = R, R = Q;
     /* the first entry of pair is always has small state number */
   }
   for (i = 0; i < equiv_next; i++)
      if (L == EquivTable[i].left && R == EquivTable[i].right) return;
   if (equiv_next == EQUIVTABLEMAX) {
     EQUIVTABLEMAX += TABLEMAX;
     EquivTable = safe_reallocate(EquivTable,
			     sizeof(*EquivTable) * EQUIVTABLEMAX);
   }
   EquivTable[equiv_next].left = L;
   EquivTable[equiv_next++].right = R;
   return;
}

/* minimization DFA */

void nmdfa(void) {
  int renumber, i, j, current_queue;
  AST_PTR Qi, Qj, L, R;
  LF_PTR Li;

  for (i = 1; i < next_state; i++) {
    Qi = StateTable[i];
    if (Qi->state < i) continue;
    for (j = i + 1; j < next_state; j++) {

      Qj = StateTable[j];
      if (Qj->state < j) continue;
      equiv_next = 0;
      enqueue_equiv(Qi, Qj);
      for (current_queue = 0; current_queue < equiv_next; current_queue++) {
	L = EquivTable[current_queue].left;
	R = EquivTable[current_queue].right;
	if (L->nullable != R->nullable) goto DISTINGUISHED;
	if (L->lf == NULL && R->lf != NULL) goto DISTINGUISHED;
	if (lf_length(L->lf) != lf_length(R->lf)) goto DISTINGUISHED;
	for (Li = L->lf; Li != NULL; Li = Li->next ) {
	  LF_PTR Lj;
	  for (Lj = R->lf; Lj != NULL; Lj = Lj->next )  {
	    if (Li->symbol == Lj->symbol) {
	      enqueue_equiv(Li->exp, Lj->exp);
	      break;
	    }
	  }
	  if (Lj == NULL)
	    goto DISTINGUISHED; /* there is no entry j in i */
	}
      }
      for (current_queue = 0; current_queue < equiv_next; current_queue++) {
	printf("FOUND EQUIV D%d = D%d\n",
	       EquivTable[current_queue].left->state,
	       EquivTable[current_queue].right->state);
	if (EquivTable[current_queue].right->state > EquivTable[current_queue].left->state)
	   EquivTable[current_queue].right->state =
	  EquivTable[current_queue].left->state;
	else
	   EquivTable[current_queue].left->state =
	  EquivTable[current_queue].right->state;

      }
    DISTINGUISHED: continue;
    }
  }
  free(EquivTable);
  renumber = 0;
  for (i = 0; i < next_state; i++) {
    Qi = StateTable[i];
    Qi->state = (Qi->state < i)? StateTable[Qi->state]->state: renumber++;
  }
}


void printnfa(char Q_or_D)
{
  int renumber, i, q;
  AST_PTR Q;
  LF_PTR lf_tmp ;
  renumber = 1;
  for (i = 1; i < next_state; i++) {
    Q = StateTable[i];
    if (Q->state < renumber) continue;
    renumber++;

    printf("%c%d =", Q_or_D, Q->state);
    if (Q->nullable) printf(" 1 |");
    else printf(" 0 |");
    lf_tmp = Q->lf;
    while(lf_tmp != NULL) {
      q = lf_tmp->exp->state;
      if (q) printf("| %c %c%d ", lf_tmp->symbol, Q_or_D, q);
      lf_tmp = lf_tmp->next;
    }
    printf("| %c%d = %s", Q_or_D, Q->state, Q->exp_string);
    printf("\n");
  }
}

void graphviz_nfa(char *filename, char Q_or_D)
  /* generate graphviz dot format of DFA */
{
  FILE *gv_file;
  int renumber, i, q;
  AST_PTR Q;
  LF_PTR lf;

  if (next_state == 1) {
    printf("it's an empty fa!\n");
    return;
  }

  if ((gv_file = fopen(filename, "w")) == NULL) {
    printf("coudn't create output file %s!\n", filename);
    exit(1);
  }
  fprintf(gv_file, "digraph\n  G { label=\"%s of %s\";\n \nrankdir=LR\n\
start[shape =none]\nstart ->node_1\n",
	  Q_or_D == 'Q'? "NFA": (Q_or_D == 'D'? "DFA": "MDFA"),
	  StateTable[1]->exp_string);

  renumber = 1;
  for (i = 1; i < next_state; i++) {
    Q = StateTable[i];
    if (Q->state < renumber) continue;
    renumber++;

    q = Q->state;

    fprintf(gv_file, "node_%d [label=\"%c%d\"", q, Q_or_D, q);

    if (Q->nullable)
	fprintf(gv_file, ", shape = doublecircle]\n");
    else
      fprintf(gv_file, ", shape = circle]\n");
    lf = Q->lf;
    while(lf != NULL){
      if(lf->exp!=EMPTY)
	fprintf(gv_file, "node_%d -> node_%d [label =\"%c\"]\n",
		q, lf->exp->state, lf->symbol);
      lf = lf->next;
    }
  }

  fprintf(gv_file, "}\n");
  fclose (gv_file);
}
