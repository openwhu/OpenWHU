#include "listring.cpp"
void Repl(LiString *&s)
{
	LiString *p=s->next,*q;
	int find=0;
	while (p->next!=NULL && find==0)	//查找'ab'子串
	{
		if (p->data=='a' && p->next->data=='b')   	//找到了ab子串
		{	
			p->data='x';p->next->data='z';			//替换为xyz
			q=(LiString *)malloc(sizeof(LiString));
			q->data='y';q->next=p->next;p->next=q;
			find=1;
		}
		else p=p->next; 
	}
}
void main()
{
	LiString *s;
	StrAssign(s,"aabcabcd");
	printf("s:");DispStr(s);
	printf("ab->xyz\n");
	Repl(s);
	printf("s:");DispStr(s);
}
