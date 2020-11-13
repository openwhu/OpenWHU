#include <stdio.h>
#include <malloc.h>
#define MAXM 10						//定义B-树的最大的阶数
typedef int KeyType;        		//KeyType为关键字类型
typedef struct node         		//B-树结点类型定义
{	int keynum;                		//结点当前拥有的关键字的个数
    KeyType key[MAXM];		   		//key[1..keynum]存放关键字,key[0]不用
	struct node *parent;			//双亲结点指针
    struct node *ptr[MAXM];			//孩子结点指针数组ptr[0..keynum]
} BTNode;
typedef struct 						//B-树的查找结果类型
{
	BTNode *pt;						//指向找到的结点
    int i;							//1..m,在结点中的关键字序号
    int tag;						//1:查找成功,O:查找失败
}  Result;
int m;								//m阶B-树,为全局变量
int Max;							//m阶B-树中每个结点的至多关键字个数,Max=m-1
int Min;							//m阶B-树中非叶子结点的至少关键字个数,Min=(m-1)/2
int Search(BTNode *p,KeyType k) 
{  //在p->key[1..keynum]中查找i,使得p->key[i]<=k<p->key[i+1]
   for(int i=0;i<p->keynum && p->key[i+1]<=k;i++);
   return i;
}
Result SearchBTree(BTNode *t,KeyType k)
{ /*在m阶t树t上查找关键字k,返回结果(pt,i,tag)。若查找成功,则特征值
   tag=1,指针pt所指结点中第i个关键字等于k；否则特征值tag=0,等于k的
   关键字应插入在指针Pt所指结点中第i和第i+1个关键字之间*/
	BTNode *p=t,*q=NULL;			//初始化,p指向待查结点,q指向p的双亲
	int found=0,i=0;
	Result r;
	while (p!=NULL && found==0)
	{
		i=Search(p,k);				//在p->key[1..keynum]中查找i,使得p->key[i]<=k<p->key[i+1]
		if (i>0 && p->key[i]==k)	//找到待查关键字
			found=1;
		else
		{
			q=p;
			p=p->ptr[i];
		}
	}
	r.i=i;
	if (found==1)					//查找成功
	{
		r.pt=p;r.tag=1;
	}
	else							//查找不成功,返回K的插入位置信息
	{
		r.pt=q;r.tag=0;
	}
	return r;						//返回k的位置(或插入位置)
}
void Insert(BTNode *&q,int i,KeyType x,BTNode *ap)
{ //将x和ap分别插入到q->key[i+1]和q->ptr[i+1]中
	int j;
	for(j=q->keynum;j>i;j--)	//空出一个位置
	{
		q->key[j+1]=q->key[j];
		q->ptr[j+1]=q->ptr[j];
	}
	q->key[i+1]=x;
	q->ptr[i+1]=ap;
	if (ap!=NULL) ap->parent=q;  
	q->keynum++;
}
void Split(BTNode *&q,BTNode *&ap)
{ //将结点q分裂成两个结点,前一半保留,后一半移入新生结点ap
	int i,s=(m+1)/2;
	ap=(BTNode *)malloc(sizeof(BTNode));	//生成新结点*ap
	ap->ptr[0]=q->ptr[s];					//后一半移入ap
	for (i=s+1;i<=m;i++)
	{
		ap->key[i-s]=q->key[i];
		ap->ptr[i-s]=q->ptr[i];
		if (ap->ptr[i-s]!=NULL)
			ap->ptr[i-s]->parent=ap;
	}	
	ap->keynum=q->keynum-s;	
	ap->parent=q->parent;	
	for (i=0;i<=q->keynum-s;i++) //修改指向双亲结点的指针
		if (ap->ptr[i]!=NULL) ap->ptr[i]->parent = ap;
	q->keynum=s-1;						//q的前一半保留,修改keynum
}
void NewRoot(BTNode *&t,BTNode *p,KeyType x,BTNode *ap)
{ //生成含信息(T,x,ap)的新的根结点*t,原t和ap为子树指针
	t=(BTNode *)malloc(sizeof(BTNode));
	t->keynum=1;t->ptr[0]=p;t->ptr[1]=ap;t->key[1]=x;
	if (p!=NULL) p->parent=t;  
	if (ap!=NULL) ap->parent=t;
	t->parent=NULL;
}
void InsertBTree(BTNode *&t, KeyType k, BTNode *q, int i) 
{ /*在m阶t树t上结点*q的key[i]与key[i+1]之间插入关键字k。若引起
   结点过大,则沿双亲链进行必要的结点分裂调整,使t仍是m阶t树。*/
	BTNode *ap;
	int finished,needNewRoot,s;
	KeyType x;
	if (q==NULL)						//t是空树(参数q初值为NULL)
		NewRoot(t,NULL,k,NULL);			//生成仅含关键字k的根结点*t
	else 
	{
		x=k;ap=NULL;finished=needNewRoot=0;     
		while (needNewRoot==0 && finished==0) 
		{
			Insert(q,i,x,ap);				//将x和ap分别插入到q->key[i+1]和q->ptr[i+1]
			if (q->keynum<=Max) finished=1;	//插入完成
			else 
			{  //分裂结点*q,将q->key[s+1..m],q->ptr[s..m]和q->recptr[s+1..m]移入新结点*ap
				s=(m+1)/2;
				Split(q,ap); 
				x=q->key[s];
				if (q->parent)				//在双亲结点*q中查找x的插入位置
				{  
					q=q->parent;i=Search(q, x);  
				} 
				else needNewRoot=1;
			}
		}
		if (needNewRoot==1)					//根结点已分裂为结点*q和*ap
			NewRoot(t,q,x,ap);				//生成新根结点*t,q和ap为子树指针
	}
}
void DispBTree(BTNode *t)	//以括号表示法输出B-树
{
	int i;
	if (t!=NULL)
	{
		printf("[");			//输出当前结点关键字
		for (i=1;i<t->keynum;i++)
			printf("%d ",t->key[i]);
		printf("%d",t->key[i]);
		printf("]");
		if (t->keynum>0)
		{
			if (t->ptr[0]!=0) printf("(");  //至少有一个子树时输出"("号
			for (i=0;i<t->keynum;i++)		//对每个子树进行递归调用
			{
				DispBTree(t->ptr[i]);
				if (t->ptr[i+1]!=NULL) printf(",");
			}
			DispBTree(t->ptr[t->keynum]);
			if (t->ptr[0]!=0) printf(")");	//至少有一个子树时输出")"号
		}
	}
}
void Remove(BTNode *p,int i)
//从*p结点删除key[i]和它的孩子指针ptr[i]
{
	int j;
	for (j=i+1;j<=p->keynum;j++)		//前移删除key[i]和ptr[i]
	{
		p->key[j-1]=p->key[j];
		p->ptr[j-1]=p->ptr[j];
	}
	p->keynum--;
}
void Successor(BTNode *p,int i)
//查找被删关键字p->key[i](在非叶子结点中)的替代叶子结点
{
	BTNode *q;
	for (q=p->ptr[i];q->ptr[0]!=NULL;q=q->ptr[0]);
	p->key[i]=q->key[1];	//复制关键字值
}
void MoveRight(BTNode *p,int i)
//把一个关键字移动到右兄弟中
{
	int c;
	BTNode *t=p->ptr[i];
	for (c=t->keynum;c>0;c--)	//将右兄弟中所有关键字移动一位
	{
		t->key[c+1]=t->key[c];
		t->ptr[c+1]=t->ptr[c];
	}
	t->ptr[1]=t->ptr[0];		//从双亲结点移动关键字到右兄弟中
	t->keynum++;
	t->key[1]=p->key[i];
	t=p->ptr[i-1];				//将左兄弟中最后一个关键字移动到双亲结点中
	p->key[i]=t->key[t->keynum];
	p->ptr[i]->ptr[0]=t->ptr[t->keynum];
	t->keynum--;
}
void MoveLeft(BTNode *p,int i)
//把一个关键字移动到左兄弟中
{
	int c;
	BTNode *t;
	t=p->ptr[i-1];				//把双亲结点中的关键字移动到左兄弟中
	t->keynum++;
	t->key[t->keynum]=p->key[i];
	t->ptr[t->keynum]=p->ptr[i]->ptr[0];

	t=p->ptr[i];				//把右兄弟中的关键字移动到双亲兄弟中
	p->key[i]=t->key[1];
	p->ptr[0]=t->ptr[1];
	t->keynum--;
	for (c=1;c<=t->keynum;c++)	//将右兄弟中所有关键字移动一位
	{
		t->key[c]=t->key[c+1];
		t->ptr[c]=t->ptr[c+1];
	}
}
void Combine(BTNode *p,int i)
//将三个结点合并到一个结点中
{
	int c;
	BTNode *q=p->ptr[i];			//指向右结点,它将被置空和删除
	BTNode *l=p->ptr[i-1];
	l->keynum++;					//l指向左结点
	l->key[l->keynum]=p->key[i];
	l->ptr[l->keynum]=q->ptr[0];
	for (c=1;c<=q->keynum;c++)		//插入右结点中的所有关键字
	{
		l->keynum++;
		l->key[l->keynum]=q->key[c];
		l->ptr[l->keynum]=q->ptr[c];
	}
	for (c=i;c<p->keynum;c++)		//删除父结点所有的关键字
	{
		p->key[c]=p->key[c+1];
		p->ptr[c]=p->ptr[c+1];
	}
	p->keynum--;
	free(q);						//释放空右结点的空间
}
void Restore(BTNode *p,int i)
//关键字删除后,调整B-树,找到一个关键字将其插入到p->ptr[i]中
{
	if (i==0)							//为最左边关键字的情况
		if (p->ptr[1]->keynum>Min)
			MoveLeft(p,1);
		else
			Combine(p,1);
	else if (i==p->keynum)				//为最右边关键字的情况
		if (p->ptr[i-1]->keynum>Min)
			MoveRight(p,i);
		else
			Combine(p,i);
	else if (p->ptr[i-1]->keynum>Min)	//为其他情况
		MoveRight(p,i);
	else if (p->ptr[i+1]->keynum>Min)
		MoveLeft(p,i+1);
	else
		Combine(p,i);
}
int SearchNode(KeyType k,BTNode *p,int &i)
//在结点p中找关键字为k的位置i,成功时返回1,否则返回0
{
	if (k<p->key[1])	//k小于*p结点的最小关键字时返回0
	{
		i=0;
		return 0;
	}
	else				//在*p结点中查找
	{
		i=p->keynum;
		while (k<p->key[i] && i>1)
			i--;
		return(k==p->key[i]);
	}
}
int RecDelete(KeyType k,BTNode *p)
//查找并删除关键字k
{
	int i;
	int found;
	if (p==NULL)
		return 0;
	else
	{
		if ((found=SearchNode(k,p,i))==1)		//查找关键字k
		{
			if (p->ptr[i-1]!=NULL)				//若为非叶子结点
			{
				Successor(p,i);					//由其后继代替它
				RecDelete(p->key[i],p->ptr[i]);	//p->key[i]在叶子结点中
			}
			else
				Remove(p,i);					//从*p结点中位置i处删除关键字
		}
		else
			found=RecDelete(k,p->ptr[i]);		//沿孩子结点递归查找并删除关键字k
		if (p->ptr[i]!=NULL)
			if (p->ptr[i]->keynum<Min)			//删除后关键字个数小于MIN
				Restore(p,i);
		return found;
	}
}
void DeleteBTree(KeyType k,BTNode *&root)
//从B-树root中删除关键字k,若在一个结点中删除指定的关键字,不再有其他关键字,则删除该结点
{
	BTNode *p;				//用于释放一个空的root
	if (RecDelete(k,root)==0)
		printf("   关键字%d不在B-树中\n",k);
	else if (root->keynum==0)
	{
		p=root;
		root=root->ptr[0];
		free(p);
	}
}
void main()
{
	BTNode *t=NULL;
	Result s;
	int j,n=20;
	KeyType a[]={1,2,6,7,11,4,8,13,10,5,17,9,16,20,3,12,14,18,19,15},k;
	m=5;								//例10.7
	Max=m-1;Min=(m-1)/2;
	printf("\n");
	printf(" 创建一棵%d阶B-树:\n",m);
	for (j=0;j<n;j++)					//创建一棵5阶B-树t	
	{
		s=SearchBTree(t,a[j]);
		if (s.tag==0)
			InsertBTree(t,a[j],s.pt,s.i);	
		printf("   第%d步,插入%d: ",j+1,a[j]);DispBTree(t);printf("\n");
	}
	printf(" 删除操作:\n");				//例10.8
	k=8;
	DeleteBTree(k,t);
	printf("   删除%d: ",k);
	DispBTree(t);printf("\n");
	k=16;
	DeleteBTree(k,t);
	printf("   删除%d: ",k);
	DispBTree(t);printf("\n");
	k=15;
	DeleteBTree(k,t);
	printf("   删除%d: ",k);
	DispBTree(t);printf("\n");
	k=4;
	DeleteBTree(k,t);
	printf("   删除%d: ",k);
	DispBTree(t);printf("\n\n");
}