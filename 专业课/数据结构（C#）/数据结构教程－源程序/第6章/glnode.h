typedef char ElemType;
typedef struct lnode
{
	int tag;					//节点类型标识
	union 
	{
		ElemType data;			//原子值
		struct lnode *sublist;	//指向子表的指针
	} val;
	struct lnode *link;			//指向下一个元素
} GLNode;						//广义表节点类型定义
