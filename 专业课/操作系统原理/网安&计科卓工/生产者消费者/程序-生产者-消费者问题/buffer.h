/*buffer.h*/
/*缓冲区内的固定大小数组,元素类型声明*/
typedef int buffer_item;
/*数组大小定义*/
#define BUFFER_SIZE 5

/*缓冲区内的操作,分别用于生产者和消费者线程*/
int insert_item(buffer_item item);
int remove_item(buffer_item *item);

