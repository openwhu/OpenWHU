#include "glist.cpp"
int atomnum(GLNode *g)	//求广义表g中的原子个数
{
	if (g!=NULL)
	{
		if (g->tag==0)
			return 1+atomnum(g->link);
		else
			return atomnum(g->val.sublist)+atomnum(g->link);
	}
	else
		return 0;
}
void main()
{
	GLNode *g;
	char *s="((#),(a,b),a,(((a),b)))";
	g=CreateGL(s);
	printf("g:");DispGL(g);printf("\n");
	printf("原子个数=%d\n",atomnum(g));
}
