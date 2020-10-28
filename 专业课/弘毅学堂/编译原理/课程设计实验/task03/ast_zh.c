/************************************************************/
/*      copyright hanfei.wang@gmail.com                     */
/*             2019.09.10                                   */
/************************************************************/
#include "ast.h"

/* realloc(void *_ptr, size_t size)
 * If the allocated memory is expanded, there are the following situations:
 *	1) If there is a required memory space behind the current memory segment,
 *	the memory space will be expanded directly, and realloc() will return the
 *	original pointer.
 *	2) If the free bytes behind the current memory segment are insufficient,
 *	the first memory block in the heap that meets this requirement is used to
 *	copy the current data to a new location and release the original data block
 *	to return to the new memory block location.
 *	3) If the application fails, the NULL will be returned. At this time, the
 *	original pointer is still valid.
 */
#define realloc(X, N)		((X) == NULL? malloc(N): realloc((X), (N)))
/* Symbol Table */
EXPTAB exptab[HASHSIZE] = {NULL};

void *safe_allocate(unsigned Bytes)
{
	void *X = malloc(Bytes);

	if (X == NULL) {
		printf("memory exhasuted.\n");
		exit(1);
	}
	return X;
}

void *safe_reallocate(void *X, unsigned Bytes)
{
	X = realloc(X, Bytes);

	if (X == 0) {
		printf("memory exhasuted\n");
		exit(1);
	}
	return X;
}

int hash(char *s)
{
	unsigned int hv = 7, len = strlen(s);
	int i;

	for (i = 0; i < len; i++) {
		hv = hv*31 + s[i];
	}
	return (int) (hv % HASHSIZE) ;  
}
 
/*
 * AST_PTR
 */
AST_PTR insert(AST_PTR exp)
{
	int hv = exp->hash;			/* hash(exp->exp_string) */
  
	EXPTAB new = (EXPTAB) safe_allocate(sizeof(*new));
	new->next = exptab[hv];		/* insert into head */
	new->exp = exp;				/* just hold the AST_PTR */
	exptab[hv] = new;

	return exp;
}

AST_PTR lookup(char *exp_string)
{
	int hv = hash(exp_string);
	EXPTAB t = exptab[hv];

	/* not record */
	if (t == NULL) {
		return NULL;
	}

	while (t != NULL) {
		if (strcmp(exp_string, t -> exp -> exp_string) == 0) {
			break;
		}
		t = t->next;
	}
	/* not record */
	if (t == NULL) {
		return NULL;
	}

	/* already record */
	return t -> exp;
}

AST_PTR mkLeaf(char c)
{
	AST_PTR tree_tmp;
	char exp[2] = "x";		/* 'x''\0', then replace 'x' with c */

	exp[0] = c;
	tree_tmp = lookup(exp);	/* may lead to multi-father */
  
	if (tree_tmp != NULL) {
		return tree_tmp;
	}

	/* haven't decleared it yet */
	tree_tmp = (AST_PTR) safe_allocate(sizeof(*tree_tmp));
	tree_tmp->op = Alpha;
	tree_tmp->exp_string = strdup(exp);		/* not normal func, will malloc and strcpy */
	tree_tmp->hash = hash(exp);
	tree_tmp->nullable=0;
	tree_tmp->lf = NULL;					/* seems always NULL */
	tree_tmp->state = -1;					/* seems always -1 */
	tree_tmp->lchild = NULL;
	tree_tmp->rchild = NULL;
	return insert(tree_tmp);
}

AST_PTR mkEpsilon (void) 
{
	AST_PTR tree_tmp; 

	tree_tmp = lookup ("ε");
  
	if (tree_tmp != NULL) {
		return tree_tmp;
	}

	tree_tmp = (AST_PTR) safe_allocate(sizeof(*tree_tmp));
	tree_tmp->op = Epsilon;
	tree_tmp->exp_string = strdup("ε");
	tree_tmp->hash = hash(tree_tmp->exp_string);
	tree_tmp->nullable = 1;		/* identify nullable */
	tree_tmp->state = -1;
	tree_tmp->lf = NULL;
	tree_tmp->lchild = NULL;
	tree_tmp->rchild = NULL;
	return insert(tree_tmp);
}

AST_PTR mkEmpty (void) 
{
	AST_PTR tree_tmp;

	tree_tmp = lookup ("ϕ");
  
	if (tree_tmp != NULL) {
		return tree_tmp;
	}

	tree_tmp = (AST_PTR ) safe_allocate(sizeof(*tree_tmp));
	tree_tmp->op = Empty;
	tree_tmp->exp_string = strdup("ϕ");
	tree_tmp->hash = hash(tree_tmp->exp_string);
	tree_tmp->nullable = 0;
	tree_tmp->lf = NULL;
	tree_tmp->state = -1;
	tree_tmp->lchild = NULL;
	tree_tmp->rchild = NULL;
	return insert(tree_tmp);
}

AST_PTR mkOpNode(Kind op, AST_PTR tree1, AST_PTR tree2)
{
	char *exp_string = (char *) safe_allocate(strlen(tree1->exp_string) + strlen(tree2->exp_string) + 6);
	char *lp1 = "", *rp1 = "", *lp2 = "", *rp2 = "";
	char *op_string;
	AST_PTR tree_tmp;

	switch (op) {
		case Alt:
			op_string = "^";
			break;
		case Diff:
			op_string = "-";
			break;
		case And:
			op_string = "&";
			break;
		case Or:
			op_string = "|";
			break;
		default:
			op_string = "";
	}

	/*
	 * Seq:
	 *	εx = xε = x, ϕx = xϕ = ϕ
	 * Alt:
	 *	ε ^ x = x ^ ε = x, ϕ ^ x = x ^ ϕ = ϕ
	 */
	if (op == Seq || op == Alt) {
		if (tree1->op == Epsilon) return tree2;
		if (tree1->op == Empty) return tree1;
		if (tree2->op == Epsilon) return tree1;
		if (tree2->op == Empty) return tree2;
	}

	/*
	 * And:
	 *	ε & x = x & ε = ε, ϕ & x = x & ϕ = ϕ
	 */
	if (op == And) {
		if (tree1->op == Epsilon) return tree1;
		if (tree1->op == Empty) return tree1;
		if (tree2->op == Epsilon) return tree2;
		if (tree2->op == Empty) return tree2;
	}

	/*
	 * Diff:
	 *	ϕ - x = ϕ, x - ϕ = x
	 */
	if (op == Diff) {
		if (tree1->op == Empty) return tree1;
		if (tree2->op == Empty) return tree1;
	}

	/*
	 * tree1 == tree2:
	 *	x | x = x & x = x, x - x = ϕ(seems that x ^ x = xx)
	 */
	if (tree1 == tree2){
		if (op == Or || op == And) return tree1;
		if (op == Diff) return mkEmpty();
	}

	/*
	 * Or:
	 *	for Or is the lowest op, no need for ().
	 */
	if (op == Or) {
		sprintf(exp_string,"%s%s%s", tree1->exp_string, op_string, tree2->exp_string);
	} else {
		if (op == Diff && tree2->op == Diff) {
			/* right prior because of (), for Diff doesn't like (| ^ &), Diff not commutative */
			lp2 = "(";
			rp2 = ")"; 
		} else {
			if (tree1->op < op) { 
				lp1 = "(";
				rp1 = ")";
			}
			if (tree2->op < op) {
				lp2 = "(";
				rp2 = ")";
			}
		}
		sprintf(exp_string,"%s%s%s%s%s%s%s", lp1, tree1->exp_string, rp1, op_string, lp2, tree2->exp_string, rp2);
	}
	tree_tmp = lookup (exp_string);

	if (tree_tmp != NULL)  {
		free(exp_string);
		return tree_tmp;
	}

	tree_tmp = (AST_PTR ) safe_allocate(sizeof *tree_tmp);
	tree_tmp->hash = hash(exp_string);
	tree_tmp->op = op;
	tree_tmp->exp_string = exp_string;
	tree_tmp->nullable = 	(op == Or 	?	(tree1->nullable || tree2->nullable) : 
							(op == Diff	?	(tree1->nullable * (tree1->nullable - tree2->nullable)) :
											(tree1->nullable && tree2->nullable)));
	tree_tmp->lf = NULL;
	tree_tmp->state = -1;
	tree_tmp->lchild = tree1;
	tree_tmp->rchild = tree2;
	return insert(tree_tmp); 
}

/* only for op that commutative */
AST_PTR insert_op_node(Kind op, AST_PTR tree1, AST_PTR tree2)
{
	AST_PTR e1 = tree1->lchild, e2 = tree1->rchild;
	/* (e1 || e2) || e1 = (e1 || e2) || e2 = e1 || e2 */ 

	if (tree1->op != op) {
		if (tree1->hash <= tree2->hash)
  			return mkOpNode(op, tree1, tree2);
		else 
			return mkOpNode(op, tree2, tree1);
	}
	// printf("%d\t%d\t%d\n", e1->hash, e2->hash, tree2->hash);
	if (e2->hash <= tree2->hash) 
		return mkOpNode(op, tree1, tree2);
	/* tree2->hash may between e1, e2, or < e1 */
	if (e1->op != op) {
		if (tree2->hash <= e1->hash)
			return mkOpNode(op, mkOpNode(op, tree2, e1), e2);
		else
			return mkOpNode(op, mkOpNode(op, e1, tree2), e2);
	}

	/* much complicated, recurse */
	return mkOpNode(op, insert_op_node(op, e1, tree2), e2); 
}

AST_PTR arrangeSeqNode(AST_PTR L, AST_PTR C)
{
	AST_PTR left, right, top;

	if (L->op == Or) {
		left = arrangeSeqNode(L->lchild, C);
		right = arrangeSeqNode(L->rchild, C);
		top = arrangeOpNode(Or, left, right);
	} else if (C->op == Or) {
		left = arrangeSeqNode(L, C->lchild);
		right = arrangeSeqNode(L, C->rchild);
		top = arrangeOpNode(Or, left, right);
	} else {
		top = mkOpNode(Seq, L, C);
	}
	return top;
}

AST_PTR mkStarNode(AST_PTR tree)
{
	char *exp_string = (char *) safe_allocate(strlen(tree->exp_string) + 4);
	char *lp = "", *rp = "";
	AST_PTR tree_tmp;

	if (tree->op == Star || tree->op == Epsilon || tree->op == Empty) {
		/* avoid x**** */
		return tree;
	}

	if (tree->op == Or && tree->lchild->op == Epsilon) {
		/* (!|a)*	->	a*	*/
		return mkStarNode(tree->rchild);
	}
    
	if (tree->op != Alpha) {
		/* else need () as whole */
		lp = "(";
		rp = ")";
	}

	sprintf(exp_string, "%s%s%s%c", lp, tree->exp_string, rp, '*');
	tree_tmp = lookup (exp_string);
  
	if (tree_tmp != NULL) {
		free(exp_string);
		return tree_tmp;
	}
 
	tree_tmp = (AST_PTR) safe_allocate(sizeof(*tree_tmp));

	tree_tmp->hash = hash(exp_string);
	tree_tmp->op = Star;
	tree_tmp->exp_string = exp_string;
	tree_tmp->nullable = 1;
	tree_tmp->state = -1;
	tree_tmp->lf = NULL;
	tree_tmp->lchild = tree;
	tree_tmp->rchild = NULL;
	return insert(tree_tmp); 
}

AST_PTR arrangeOpNode(Kind op, AST_PTR tree1, AST_PTR tree2)
{
	AST_PTR left;

	if (op == Or || op == Alt || op == And) {
		/* for commutative */
		if (op == tree1->op && op == tree2->op) {
			left = arrangeOpNode(op, tree1, tree2->rchild);
			return arrangeOpNode(op, left, tree2->lchild);
		} else if (op == tree1->op) {
			/* tree1's lchild & rchild cannot be NULL */
			if (tree1->rchild->hash > tree2->hash) {
				if (tree1->lchild->op == op) {
					left = arrangeOpNode(op, tree1->lchild, tree2);
					return mkOpNode(op, left, tree1->rchild);
				} else {
					if (tree2->hash > tree1->lchild->hash) {
						left = mkOpNode(op, tree1->lchild, tree2);
						return mkOpNode(op, left, tree1->rchild);
					} else {
						left = mkOpNode(op, tree2, tree1->lchild);
						return mkOpNode(op, left, tree1->rchild);
					}
				}
			} else {
				return mkOpNode(op, tree1, tree2);
			}
		} else if (op == tree2->op) {
			return arrangeOpNode(op, tree2, tree1);
		} else {
			return insert_op_node(op, tree1, tree2);
		}
	} else {
		return insert_op_node(op, tree1, tree2);
	}
}

/*
 * GV
 */
static FILE *gv_file;
static int label_count = 0;

int graphviz_ast_aux(AST_PTR tree)
{
	int count = label_count++, left_count, right_count;
	char op_c;

	switch (tree -> op) {
		case Alpha:
		case Empty:
		case Epsilon:
			fprintf(gv_file, "node_%d[label=\"%s\"]\n", count, tree->exp_string);
			return count;
		case Star: 
			left_count = graphviz_ast_aux(tree -> lchild);
			fprintf(gv_file, "node_%d[label=\"%c\", shape=circle]\n", count, '*');
			fprintf(gv_file, "node_%d  -> node_%d[dir=none];\n", count, left_count);
			return count;
		case Seq:
			op_c = '.';
			break;
		case Or:
			op_c = '|';
			break;
		case Diff:
			op_c = '-';
			break;
		case Alt:
			op_c = '^';
			break;
		case And:
			op_c = '&';
	}

	left_count = graphviz_ast_aux(tree->lchild);
	right_count = graphviz_ast_aux(tree->rchild);
  
	fprintf(gv_file, "node_%d[label=\"%c\", shape=circle]\n", count, op_c);
	fprintf(gv_file, "node_%d  -> node_%d[dir=none];\n", count, left_count);
	fprintf(gv_file, "node_%d  -> node_%d[dir=none];\n", count, right_count);

	return count;
}

void graphviz_ast(AST_PTR tree)
{
	if ((gv_file = fopen("ast.gv", "w")) == NULL) {
		printf("coudn't create output file!\n");
		exit(1);
	}

	if (tree == NULL) {
		printf("attempt output empty tree!\n");
		exit (1);
	}

	fprintf(gv_file, "digraph  G {label =\"%s\";\n", tree->exp_string); 
	graphviz_ast_aux(tree);
	fprintf(gv_file, "}\n");
	fclose (gv_file);
}

