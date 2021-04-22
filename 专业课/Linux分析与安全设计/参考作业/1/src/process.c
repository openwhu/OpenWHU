volatile long state;

//进程要么正在执行，要么准备执行
#define TASK_RUNNING        0
//可中断的睡眠，可以通过一个信号唤醒
#define TASK_INTERRUPTIBLE  1 
//不可中断睡眠，不可以通过信号进行唤醒
#define TASK_UNINTERRUPTIBLE    2 
//进程停止执行
#define __TASK_STOPPED      4 
//进程被追踪
#define __TASK_TRACED       8 
//僵尸状态的进程，表示进程被终止，但是父进程还没有获取它的终止信息，比如进程有没有执行完等信息。
#define EXIT_ZOMBIE     16 
//进程的最终状态，进程死亡                     
#define EXIT_DEAD       32 
//死亡
#define TASK_DEAD       64 
//唤醒并杀死的进程
#define TASK_WAKEKILL       128 
//唤醒进程
#define TASK_WAKING     256 


//进程的唯一标识
pid_t pid;
// 线程组的领头线程的pid成员的值
pid_t tgid;


// 指向其父进程，如果创建它的父进程不再存在，则指向 PID 为 1 的 init 进程
struct task_struct __rcu *real_parent; 
// 指向其父进程，当它终止时，必须向它的父进程发送信号。它的值通常与 real_parent 相同
struct task_struct __rcu *parent; 
// 表示链表的头部，链表中的所有元素都是它的子进程(进程的子进程链表)
struct list_head children;	
// 用于把当前进程插入到兄弟链表中(进程的兄弟链表)
struct list_head sibling;
// 指向其所在进程组的领头进程
struct task_struct *group_leader;


// 进程的动态优先级
int prio, 
// 进程的静态优先级，可以用 nice 系统调用来修改
int static_prio, 
// 取决于静态优先级和调度策略，例如：
// 先来先服务、短作业有限、时间片轮转
int normal_prio;
// 进程的调度策略
unsigned int policy;
unsigned int rt_priority;
const struct sched_class *sched_class;
struct sched_entity se;
struct sched_rt_entity rt;


// 用于普通进程的调度，使用 CFS 调度器实现
#define SCHED_NORMAL		0
// 先进先出调度算法
#define SCHED_FIFO		1
// 时间片轮转调度算法
#define SCHED_RR		2
// 用于非交互的处理器消耗性进程
#define SCHED_BATCH		3
// 在系统负载很低时使用，在此版本为保留字段，尚未实现
#define SCHED_IDLE		5
/* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
#define SCHED_RESET_ON_FORK     0x40000000


// 标识是否被跟踪
unsigned int ptrace;
/*
* ptraced is the list of tasks this task is using ptrace on.
* This includes both natural children and PTRACE_ATTACH targets.
* p->ptrace_entry is p's link on the p->parent->ptraced list.
*/
struct list_head ptraced;
struct list_head ptrace_entry;


// 指向进程的信号描述符
struct signal_struct *signal;
// 指向进程信号处理程序描述符
struct sighand_struct *sighand;
// 阻塞信号的掩码
sigset_t blocked, real_blocked;
sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
// 进程上还需要处理的信号
struct sigpending pending;
// 信号处理程序备用堆栈的地址
unsigned long sas_ss_sp;
// 信号处理程序堆栈的地址
size_t sas_ss_size;


// 文件系统信息的指针
struct fs_struct *fs;
// 打开文件的信息的指针
struct files_struct *files;


// 进程的标志，在调用 do_fork 时给出
unsigned int flags;

#define PF_ALIGNWARN    0x00000001    /* Print alignment warning msgs */
#define PF_STARTING    0x00000002    /* being created */
#define PF_EXITING    0x00000004    /* getting shut down */
#define PF_EXITPIDONE    0x00000008    /* pi exit done on shut down */
#define PF_VCPU        0x00000010    /* I'm a virtual CPU */
#define PF_FORKNOEXEC    0x00000040    /* forked but didn't exec */
#define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
#define PF_SUPERPRIV    0x00000100    /* used super-user privileges */
#define PF_DUMPCORE    0x00000200    /* dumped core */
#define PF_SIGNALED    0x00000400    /* killed by a signal */
#define PF_MEMALLOC    0x00000800    /* Allocating memory */
#define PF_FLUSHER    0x00001000    /* responsible for disk writeback */
#define PF_USED_MATH    0x00002000    /* if unset the fpu must be initialized before use */
#define PF_FREEZING    0x00004000    /* freeze in progress. do not account to load */
#define PF_NOFREEZE    0x00008000    /* this thread should not be frozen */
#define PF_FROZEN    0x00010000    /* frozen for system suspend */
#define PF_FSTRANS    0x00020000    /* inside a filesystem transaction */
#define PF_KSWAPD    0x00040000    /* I am kswapd */
#define PF_OOM_ORIGIN    0x00080000    /* Allocating much memory to others */
#define PF_LESS_THROTTLE 0x00100000    /* Throttle me less: I clean memory */
#define PF_KTHREAD    0x00200000    /* I am a kernel thread */
#define PF_RANDOMIZE    0x00400000    /* randomize virtual address space */
#define PF_SWAPWRITE    0x00800000    /* Allowed to write to swap */
#define PF_SPREAD_PAGE    0x01000000    /* Spread page cache over cpuset */
#define PF_SPREAD_SLAB    0x02000000    /* Spread some slab caches over cpuset */
#define PF_THREAD_BOUND    0x04000000    /* Thread bound to specific cpu */
#define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
#define PF_MEMPOLICY    0x10000000    /* Non-default NUMA mempolicy */
#define PF_MUTEX_TESTER    0x20000000    /* Thread belongs to the rt mutex tester */
#define PF_FREEZER_SKIP    0x40000000    /* Freezer should not count it as freezeable */
#define PF_FREEZER_NOSIG 0x80000000    /* Freezer won't send signals to it */



// 记录进程用户态的运行时间
cputime_t utime;
// 记录进程内核态的运行时间
cputime_t stime;
cputime_T utimescaled, stimescaled;
cputime_t gtime;
// 自愿/非自愿上下文切换次数
unsigned long nvcsw, nivcsw; 
// 进程的开始执行时间
struct timespec start_time; 		
// 进程真正的开始执行时间
struct timespec real_start_time;	
// cpu 执行的有效时间
struct task_cputime cputime_expires;
// 用来统计进程或进程组被处理器追踪的时间
struct list_head cpu_timers[3];


struct mm_struct *mm, *active_mm;



struct mm_struct {
    // 指向线性区(vm area)对象的链表头部
    struct vm_area_struct * mmap;		
    // 指向线性区对象的红黑树
    struct rb_root mm_rb;           
    // 指向最近找到的虚拟区间        
    struct vm_area_struct * mmap_cache;	
#ifdef CONFIG_MMU 
    // 在进程地址空间中搜索有效的进程地址空间的函数
    unsigned long (*get_unmapped_area) (struct file *filp,
                unsigned long addr, unsigned long len,
                unsigned long pgoff, unsigned long flags);
    // 释放线性区的调用方法
    void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
#endif
    // 存映射区的基地址
    unsigned long mmap_base;		
    // vm 区域的大小
    unsigned long task_size;		
    // 页表目录指针
    pgd_t * pgd;             
    // 共享进程的个数               
    atomic_t mm_users;		
    // 主使用计数器，采用引用计数，描述有多少指针指向当前的mm_struct	
    atomic_t mm_count;		
    // 所包含线性区的个数	
    int map_count;				
    struct rw_semaphore mmap_sem;
    // 保护页表和引用计数的锁 （使用的自旋锁）
    spinlock_t page_table_lock;		
    // 进程拥有的最大页表数目
    unsigned long hiwater_rss;	
    // 进程线性区的最大页表数目
    unsigned long hiwater_vm;	
    unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
    // 维护代码区和数据区的字段
    unsigned long start_brk, brk, start_stack;       
    // 命令行参数的起始地址和尾地址，环境变量的起始地址和尾地址
    unsigned long arg_start, arg_end, env_start, env_end;  
};


struct vm_area_struct {
    // 线性区表示的虚存空间范围为 [vm_start, vm_end)
    // 线性区的首地址
    unsigned long vm_start;		
    // 线性区的结束地址的第一个字节
    unsigned long vm_end;		
    // 每个任务的VM区域的链接列表，按地址排序
    struct vm_area_struct *vm_next, *vm_prev;
    // 此VMA左侧最大的可用内存间隙（以字节为单位）。 
    // 在此VMA和vma-> vm_prev之间，
    // 或者在VMA rbtree中我们下面的一个VMA与其->vm_prev之间。 
    // 这有助于get_unmapped_area找到合适大小的空闲区域。
    unsigned long rb_subtree_gap;
    // 所属的address space
    struct mm_struct *vm_mm;	
    // 此VMA的访问权限 
    pgprot_t vm_page_prot;		
    // 当 vm_area_struct 的数量较少时采用链表管理
    // 当数量增加到一定程度后采用红黑树股那里
    union {
        struct {
            struct rb_node rb;
            unsigned long rb_subtree_last;
        } linear;
        struct list_head nonlinear;
    } shared;
    
    
    // 在其中一个文件页面的COW之后，文件的MAP_PRIVATE vma可以在i_mmap树和anon_vma列表中。
    // AP_SHARED vma只能位于i_mmap树中。 
    // 匿名MAP_PRIVATE，堆栈或brk vma（带有NULL文件）只能位于anon_vma列表中。
    struct list_head anon_vma_chain; 
    struct anon_vma *anon_vma;	
    // 用于处理 vm_area_struct 的函数指针
    const struct vm_operations_struct *vm_ops;
    // 后备存储（backing store）的信息
    // 以PAGE_SIZE为单位的偏移量（在vm_file中），不是 PAGE_CACHE_SIZE
    unsigned long vm_pgoff;		
    // 映射到文件（可以为NULL）
    struct file * vm_file;		
    // vm_pte（共享内存）
    void * vm_private_data;		

#ifndef CONFIG_MMU
    // NOMMU映射区域
    struct vm_region *vm_region;	
#endif
#ifdef CONFIG_NUMA  
    // 针对VMA的NUMA调度策略
    struct mempolicy *vm_policy;
#endif
};



long do_fork(unsigned long clone_flags,
	      unsigned long stack_start,
	      unsigned long stack_size,
	      int __user *parent_tidptr,
	      int __user *child_tidptr)
{
    p = copy_process(clone_flags, stack_start, stack_size,
            child_tidptr, NULL, trace);
}


static struct task_struct *copy_process(unsigned long clone_flags,
					unsigned long stack_start,
					unsigned long stack_size,
					int __user *child_tidptr,
					struct pid *pid,
					int trace)
{
    // 为新进程创建新的内核堆栈
    p = dup_task_struct(current);
    // 对子进程的内存描述符进行初始化
    retval = copy_mm(clone_flags, p);
}


static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
{
	struct mm_struct *mm, *oldmm;
	int retval;
    ...
	oldmm = current->mm;
	if (!oldmm)
		return 0;

	if (clone_flags & CLONE_VM) {
		atomic_inc(&oldmm->mm_users);
		mm = oldmm;
		goto good_mm;
	}

	retval = -ENOMEM;
    // 主要起作用的函数
	mm = dup_mm(tsk);
	...
}


static struct task_struct *dup_task_struct(struct task_struct *orig)
{
    ...
    // 为子进程创建进程描述符分配空间
	tsk = alloc_task_struct_node(node);
    // 为 thread_info 和内核堆栈分配空间
	ti = alloc_thread_info_node(tsk, node);
    // 复制父进程 task_struct 信息
	err = arch_dup_task_struct(tsk, orig);
    // 将栈底的值赋给新节点的 stack
	tsk->stack = ti;
    // thread_info 进行初始化
	setup_thread_stack(tsk, orig);
    ...
	return tsk;
}


struct mm_struct *dup_mm(struct task_struct *tsk)
{
	struct mm_struct *mm, *oldmm = current->mm;

    // 为 mm_struct 分配内存空间
	mm = allocate_mm();
	if (!mm)
		goto fail_nomem;

	memcpy(mm, oldmm, sizeof(*mm));
	mm_init_cpumask(mm);

    // 初始化 mm_struct
	if (!mm_init(mm, tsk))
		goto fail_nomem;

	if (init_new_context(tsk, mm))
		goto fail_nocontext;
}

static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
{
    // 拷贝 page table
	if (likely(!mm_alloc_pgd(mm))) {
		mm->def_flags = 0;
		mmu_notifier_mm_init(mm);
		return mm;
	}

	free_mm(mm);
	return NULL;
}