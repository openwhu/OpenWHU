struct file {
    union {
        struct llist_node   fu_llist;
        struct rcu_head     fu_rcuhead;
	} f_u;
	// 文件的路径
	struct path     f_path;
	// 对应的目录项
	#define f_dentry    f_path.dentry
	// 指向文件的 inode，每个文件对应的 inode 是唯一的
	struct inode        *f_inode;   /* cached value */
	// 定义了文件相关的操作，如读、写
	const struct file_operations    *f_op;

	// 自旋锁
	spinlock_t      f_lock;
	// 文件的引用计数
	atomic_long_t       f_count;
	// 进程打开文件时候的标志，例如以只读、只写等方式打开文件
	unsigned int        f_flags;
	// 文件的访问权限
	fmode_t         f_mode;
	// 当前该文件的偏移量，文件的读写操作均由偏移量开始
	loff_t          f_pos;
	// 文件的属主
    struct fown_struct  f_owner;
    const struct cred   *f_cred;
    struct file_ra_state    f_ra;
};


struct inode_operations {
    // 查找对应的目录项
    struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
    // 文件的权限
    int (*permission) (struct inode *, int);
    // 文件的创建
    int (*create) (struct inode *,struct dentry *, umode_t, bool);
	// 链接 dentry 和 inode
    int (*link) (struct dentry *,struct inode *,struct dentry *);
    int (*unlink) (struct inode *,struct dentry *);
    int (*symlink) (struct inode *,struct dentry *,const char *);
    // 创建目录
    int (*mkdir) (struct inode *,struct dentry *,umode_t);
    // 删除目录
    int (*rmdir) (struct inode *,struct dentry *);
    // 文件重命名
    int (*rename) (struct inode *, struct dentry *,
            struct inode *, struct dentry *);
    // 文件属性设置
    int (*setattr) (struct dentry *, struct iattr *);
	// 更新时间
    int (*update_time)(struct inode *, struct timespec *, int);
};

struct inode {
    // 区分文件类型，如块设备、字符设备、目录等
    umode_t         i_mode;
    // inode 所属文件的所有者 id
    kuid_t          i_uid;
    // inode 所属文件的所在组 id
    kgid_t          i_gid;
    // 定义了 inode 的操作，如建立链接、创建等
    const struct inode_operations   *i_op;
	// 指向了索引所对应的超级块
    struct super_block  *i_sb;
    // 索引节点号
    unsigned long       i_ino;
    // 硬链接的个数，当 inode 描述一个目录时，至少为2
    union {
        const unsigned int i_nlink;
        unsigned int __i_nlink;
    };
    // 如果 inode 描述一个设备文件，那么此为设备号
    dev_t           i_rdev;
    // 文件最近一次被访问的时间
    struct timespec     i_atime;
    // 文件最近一次被修改(内容)的时间
    struct timespec     i_mtime;
    // 文件最近一次被修改(内容和属性)的时间
    struct timespec     i_ctime;
    spinlock_t      i_lock; /* i_blocks, i_bytes, maybe i_size */
    // 所占字节数
    unsigned short          i_bytes;
    // 文件使用的块数
    blkcnt_t        i_blocks;
    // inode 对应的 hash 值，为了提高查找 inode 的效率
    struct hlist_node   i_hash;
    union {
        struct hlist_head   i_dentry;
        struct rcu_head     i_rcu;
    };
    // 引用计数
    atomic_t        i_count;
    // 指向文件操作
    const struct file_operations    *i_fop; /* former ->i_op->default_file_ops */
    struct file_lock    *i_flock;
    struct address_space    i_data;

    // 文件类型所对应的结构
    // 如管道、设备等
    union {
        struct pipe_inode_info  *i_pipe;
        struct block_device *i_bdev;
        struct cdev     *i_cdev;
    };
};


struct inode_operations {
    // 查找对应的目录项
    struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
    void * (*follow_link) (struct dentry *, struct nameidata *);
    // 权限信息
    int (*permission) (struct inode *, int);

    // 创建
    int (*create) (struct inode *,struct dentry *, umode_t, bool);
	// 链接
    int (*link) (struct dentry *,struct inode *,struct dentry *);
	// 解除链接
    int (*unlink) (struct inode *,struct dentry *);
    int (*symlink) (struct inode *,struct dentry *,const char *);
    // 创建目录
    int (*mkdir) (struct inode *,struct dentry *,umode_t);
    // 删除目录
    int (*rmdir) (struct inode *,struct dentry *);
    // 创建特殊文件
    int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
    // 重命名
    int (*rename) (struct inode *, struct dentry *,
            struct inode *, struct dentry *);
    // 设置属性
    int (*setattr) (struct dentry *, struct iattr *);
    int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
	// 更新时间戳
    int (*update_time)(struct inode *, struct timespec *, int);
};

struct super_block {
    // 所有的超级块形成一个双向链表
    // 可以通过 s_list.prev 和 s_list.next 获取前一个和后一个元素
    struct list_head    s_list;     /* Keep this first */
    // 超级块所描述文件系统所在设备号
    dev_t           s_dev;      /* search index; _not_ kdev_t */
    // 块比特大小
    unsigned char       s_blocksize_bits;
    // 块字节大小
    unsigned long       s_blocksize;
    // 文件系统中文件的最大长度
    loff_t          s_maxbytes; /* Max file size */
    // 文件系统的类型
    struct file_system_type *s_type;
    // 超级块的基本操作，例如释放超级块、写回 inode 等
    const struct super_operations   *s_op;
    // 文件系统的标志，例如只读、可擦写等
    unsigned long       s_flags;
    unsigned long       s_magic;
    // 文件系统根目录的目录项结构指针
    struct dentry       *s_root;
    struct rw_semaphore s_umount;
    // 引用计数
    int         s_count;
    atomic_t        s_active;

    // 文件系统的所有索引节点形成一个双向链表
    // 该字段存放链表的头节点
    struct list_head    s_inodes;   /* all inodes */

    // 文件系统的名称
    // 例如对于 ext3 来说，该值为 "ext3"
    char s_id[32];              /* Informational name */
    u8 s_uuid[16];              /* UUID */
	// 文件系统私有信息
    void            *s_fs_info;
};

struct super_operations {
    // 为索引申请空间
    struct inode *(*alloc_inode)(struct super_block *sb);
    // 销毁索引
    void (*destroy_inode)(struct inode *);

    // 是否为脏索引
    void (*dirty_inode) (struct inode *, int flags);
    // 索引写回
    int (*write_inode) (struct inode *, struct writeback_control *wbc);
    // 索引丢弃
    int (*drop_inode) (struct inode *);
    void (*evict_inode) (struct inode *);
    // 释放指定的超级块
    void (*put_super) (struct super_block *);
    // 冻结以及解冻文件系统
    int (*freeze_fs) (struct super_block *);
    int (*unfreeze_fs) (struct super_block *);
};


struct dentry {
    /* RCU lookup touched fields */
    unsigned int d_flags;       /* protected by d_lock */
    seqcount_t d_seq;       /* per dentry seqlock */
    // 内核使用 dcache 作为哈希表对所有的目录项进行管理
    // 对应该目录项的 hash 值
    struct hlist_bl_node d_hash;
    // 指向父目录的目录项
    struct dentry *d_parent;
    // 父目录项的名称  
    struct qstr d_name;
    // 该目录项对应的 inode
    struct inode *d_inode;      
    unsigned char d_iname[DNAME_INLINE_LEN];    /* small names */

    /* Ref lookup also touches following */
    struct lockref d_lockref;   /* per-dentry lock and refcount */
    // 指向目录项操作结构体的指针
    const struct dentry_operations *d_op;
    // 该目录项对应的文件系统的超级块
    struct super_block *d_sb;   

    union {
        // 如果当前目录项是一个目录
        // 那么该目录下所有的子目录加入到父目录的 d_subdirs 链表当中
        struct list_head d_child;
        struct rcu_head d_rcu;
    } d_u;
    // 如果当前的目录项是一个目录，那么该目录下的所有子目录形成一个链表
    // 该字段成为链表的表头
    struct list_head d_subdirs; /* our children */
    // 一个inode可能对应多个目录项，所有的目录项形成一个链表。
    // inode结构中的i_dentry即为这个链表的头结点。
    // 当前目录项以这个字段处于i_dentry链表中。
    // 该字段中的prev和next指针分别指向与该目录项同inode的其他两个（如果有的话）目录项 
    struct hlist_node d_alias;  /* inode alias list */
};

struct dentry_operations {
    // 计算目录项对应的 hash
    int (*d_hash)(const struct dentry *, struct qstr *);
    // 比较两个目录项是否相等
    int (*d_compare)(const struct dentry *, const struct dentry *,
            unsigned int, const char *, const struct qstr *);
    // 删除目录项
    int (*d_delete)(const struct dentry *);
    // 释放目录项
    void (*d_release)(struct dentry *);
    // 目录项剪枝
    void (*d_prune)(struct dentry *);
};


struct dentry_operations {
	int (*d_revalidate)(struct dentry *, unsigned int);
	int (*d_weak_revalidate)(struct dentry *, unsigned int);
	// 计算目录项对应的 hash
	int (*d_hash)(const struct dentry *, struct qstr *);
	// 比较两个目录项是否相等
	int (*d_compare)(const struct dentry *, const struct dentry *,
			unsigned int, const char *, const struct qstr *);
	// 删除目录项
	int (*d_delete)(const struct dentry *);
	// 释放目录项
	void (*d_release)(struct dentry *);
	// 目录项剪枝
	void (*d_prune)(struct dentry *);
	void (*d_iput)(struct dentry *, struct inode *);
	char *(*d_dname)(struct dentry *, char *, int);
	struct vfsmount *(*d_automount)(struct path *);
	int (*d_manage)(struct dentry *, bool);
}


struct inode_operations {
	// 查找对应的目录项
	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
	void * (*follow_link) (struct dentry *, struct nameidata *);
	// 文件的权限
	int (*permission) (struct inode *, int);
	struct posix_acl * (*get_acl)(struct inode *, int);

	int (*readlink) (struct dentry *, char __user *,int);
	void (*put_link) (struct dentry *, struct nameidata *, void *);

	// 文件的创建
	int (*create) (struct inode *,struct dentry *, umode_t, bool);
	int (*link) (struct dentry *,struct inode *,struct dentry *);
	int (*unlink) (struct inode *,struct dentry *);
	int (*symlink) (struct inode *,struct dentry *,const char *);
	// 创建目录
	int (*mkdir) (struct inode *,struct dentry *,umode_t);
	// 删除目录
	int (*rmdir) (struct inode *,struct dentry *);
	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
	// 文件重命名
	int (*rename) (struct inode *, struct dentry *,
			struct inode *, struct dentry *);
	// 文件属性设置
	int (*setattr) (struct dentry *, struct iattr *);
	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
	ssize_t (*listxattr) (struct dentry *, char *, size_t);
	int (*removexattr) (struct dentry *, const char *);
	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
		      u64 len);
	int (*update_time)(struct inode *, struct timespec *, int);
	int (*atomic_open)(struct inode *, struct dentry *,
			   struct file *, unsigned open_flag,
			   umode_t create_mode, int *opened);
	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
}

struct super_operations {
	// 为索引申请空间
   	struct inode *(*alloc_inode)(struct super_block *sb);
	// 销毁索引
	void (*destroy_inode)(struct inode *);

	// 是否为脏索引
   	void (*dirty_inode) (struct inode *, int flags);
	// 索引写回
	int (*write_inode) (struct inode *, struct writeback_control *wbc);
	// 索引丢弃
	int (*drop_inode) (struct inode *);
	void (*evict_inode) (struct inode *);
	// 释放指定的超级块
	void (*put_super) (struct super_block *);
	// 冻结文件系统
	int (*freeze_fs) (struct super_block *);
	int (*unfreeze_fs) (struct super_block *);
};