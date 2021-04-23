asmlinkage void __init start_kernel(void)
{
    ...

    key_init();
    // 初始化 LSM 模块的关键代码
    security_init();
    dbg_late_init();
    vfs_caches_init(totalram_pages);
    
    ...
}

/**
 * security_init - initializes the security framework
 *
 * This should be called early in the kernel initialization sequence.
 */
int __init security_init(void)
{
    printk(KERN_INFO "Security Framework initialized\n");

    security_fixup_ops(&default_security_ops);
    security_ops = &default_security_ops;
    do_security_initcalls();

    return 0;
}

static struct security_operations *security_ops;
static struct security_operations default_security_ops = {
    .name   = "default",
};


#define set_to_cap_if_null(ops, function)               \
    do {                                \
        if (!ops->function) {                   \
            ops->function = cap_##function;         \
            pr_debug("Had to override the " #function   \
                 " security operation with the default.\n");\
            }                       \
    } while (0)

void __init security_fixup_ops(struct security_operations *ops)
{
    set_to_cap_if_null(ops, ptrace_access_check);
    set_to_cap_if_null(ops, ptrace_traceme);

    ...
}


static void __init do_security_initcalls(void)
{
    initcall_t *call;
    call = __security_initcall_start;
    while (call < __security_initcall_end) {
        (*call) ();
        call++;
    }
}

vfs_open() -> do_dentry_open():

do_dentry_open()
{

    /* (1) LSM框架关于open()的hook函数 */
	error = security_file_open(f, cred);
	if (error)
		goto cleanup_all;    

}


security\security.c:

int security_file_open(struct file *file, const struct cred *cred)
{
	int ret;

    /* (1.1) 逐个调用链表上的所有处理函数 */
	ret = call_int_hook(file_open, 0, file, cred);
	if (ret)
		return ret;

	return fsnotify_perm(file, MAY_OPEN);
}

↓

#define call_int_hook(FUNC, IRC, ...) ({			\
	int RC = IRC;						\
	do {							\
		struct security_hook_list *P;			\
								\
        /* (1.1.1) open()操作对应的链表为security_hook_heads.file_open */
		list_for_each_entry(P, &security_hook_heads.FUNC, list) { \
            /* (1.1.2)节点的P->hook.FUNC为函数指针 */
			RC = P->hook.FUNC(__VA_ARGS__);		\
			if (RC != 0)				\
				break;				\
		}						\
	} while (0);						\
	RC;							\
})


security\selinux\hooks.c:

static struct security_hook_list selinux_hooks[] = {
    ...

	LSM_HOOK_INIT(file_open, selinux_file_open),

    ...
}

#define LSM_HOOK_INIT(HEAD, HOOK) \
	{ .head = &security_hook_heads.HEAD, .hook = { .HEAD = HOOK } }


static __init int selinux_init(void)
{

	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks));

}

↓

static inline void security_add_hooks(struct security_hook_list *hooks,
				      int count)
{
	int i;

    /* (1) 将自定义的selinux_hooks[n]添加进LSM的全局链表security_hook_heads.file_open */
	for (i = 0; i < count; i++)
		list_add_tail_rcu(&hooks[i].list, hooks[i].head);
}




struct security_operations {
	char name[SECURITY_NAME_MAX + 1];

	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
	int (*ptrace_traceme) (struct task_struct *parent);
	int (*capget) (struct task_struct *target,
		       kernel_cap_t *effective,
		       kernel_cap_t *inheritable, kernel_cap_t *permitted);
	int (*capset) (struct cred *new,
		       const struct cred *old,
		       const kernel_cap_t *effective,
		       const kernel_cap_t *inheritable,
		       const kernel_cap_t *permitted);
	int (*capable) (const struct cred *cred, struct user_namespace *ns,
			int cap, int audit);
	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
	int (*quota_on) (struct dentry *dentry);
	int (*syslog) (int type);
	int (*settime) (const struct timespec *ts, const struct timezone *tz);
	int (*vm_enough_memory) (struct mm_struct *mm, long pages);

	int (*bprm_set_creds) (struct linux_binprm *bprm);
	int (*bprm_check_security) (struct linux_binprm *bprm);
	int (*bprm_secureexec) (struct linux_binprm *bprm);
	void (*bprm_committing_creds) (struct linux_binprm *bprm);
	void (*bprm_committed_creds) (struct linux_binprm *bprm);

	int (*sb_alloc_security) (struct super_block *sb);
	void (*sb_free_security) (struct super_block *sb);
	int (*sb_copy_data) (char *orig, char *copy);
	int (*sb_remount) (struct super_block *sb, void *data);
	int (*sb_kern_mount) (struct super_block *sb, int flags, void *data);
	int (*sb_show_options) (struct seq_file *m, struct super_block *sb);
	int (*sb_statfs) (struct dentry *dentry);
	int (*sb_mount) (const char *dev_name, struct path *path,
			 const char *type, unsigned long flags, void *data);
	int (*sb_umount) (struct vfsmount *mnt, int flags);
	int (*sb_pivotroot) (struct path *old_path,
			     struct path *new_path);
	int (*sb_set_mnt_opts) (struct super_block *sb,
				struct security_mnt_opts *opts,
				unsigned long kern_flags,
				unsigned long *set_kern_flags);
	int (*sb_clone_mnt_opts) (const struct super_block *oldsb,
				   struct super_block *newsb);
	int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
	int (*dentry_init_security) (struct dentry *dentry, int mode,
					struct qstr *name, void **ctx,
					u32 *ctxlen);


#ifdef CONFIG_SECURITY_PATH
	int (*path_unlink) (struct path *dir, struct dentry *dentry);
	int (*path_mkdir) (struct path *dir, struct dentry *dentry, umode_t mode);
	int (*path_rmdir) (struct path *dir, struct dentry *dentry);
	int (*path_mknod) (struct path *dir, struct dentry *dentry, umode_t mode,
			   unsigned int dev);
	int (*path_truncate) (struct path *path);
	int (*path_symlink) (struct path *dir, struct dentry *dentry,
			     const char *old_name);
	int (*path_link) (struct dentry *old_dentry, struct path *new_dir,
			  struct dentry *new_dentry);
	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
			    struct path *new_dir, struct dentry *new_dentry);
	int (*path_chmod) (struct path *path, umode_t mode);
	int (*path_chown) (struct path *path, kuid_t uid, kgid_t gid);
	int (*path_chroot) (struct path *path);
#endif

	int (*inode_alloc_security) (struct inode *inode);
	void (*inode_free_security) (struct inode *inode);
	int (*inode_init_security) (struct inode *inode, struct inode *dir,
				    const struct qstr *qstr, const char **name,
				    void **value, size_t *len);
	int (*inode_create) (struct inode *dir,
			     struct dentry *dentry, umode_t mode);
	int (*inode_link) (struct dentry *old_dentry,
			   struct inode *dir, struct dentry *new_dentry);
	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
	int (*inode_symlink) (struct inode *dir,
			      struct dentry *dentry, const char *old_name);
	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, umode_t mode);
	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
			    umode_t mode, dev_t dev);
	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
			     struct inode *new_dir, struct dentry *new_dentry);
	int (*inode_readlink) (struct dentry *dentry);
	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
	int (*inode_permission) (struct inode *inode, int mask);
	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
	int (*inode_setxattr) (struct dentry *dentry, const char *name,
			       const void *value, size_t size, int flags);
	void (*inode_post_setxattr) (struct dentry *dentry, const char *name,
				     const void *value, size_t size, int flags);
	int (*inode_getxattr) (struct dentry *dentry, const char *name);
	int (*inode_listxattr) (struct dentry *dentry);
	int (*inode_removexattr) (struct dentry *dentry, const char *name);
	int (*inode_need_killpriv) (struct dentry *dentry);
	int (*inode_killpriv) (struct dentry *dentry);
	int (*inode_getsecurity) (const struct inode *inode, const char *name, void **buffer, bool alloc);
	int (*inode_setsecurity) (struct inode *inode, const char *name, const void *value, size_t size, int flags);
	int (*inode_listsecurity) (struct inode *inode, char *buffer, size_t buffer_size);
	void (*inode_getsecid) (const struct inode *inode, u32 *secid);

	int (*file_permission) (struct file *file, int mask);
	int (*file_alloc_security) (struct file *file);
	void (*file_free_security) (struct file *file);
	int (*file_ioctl) (struct file *file, unsigned int cmd,
			   unsigned long arg);
	int (*mmap_addr) (unsigned long addr);
	int (*mmap_file) (struct file *file,
			  unsigned long reqprot, unsigned long prot,
			  unsigned long flags);
	int (*file_mprotect) (struct vm_area_struct *vma,
			      unsigned long reqprot,
			      unsigned long prot);
	int (*file_lock) (struct file *file, unsigned int cmd);
	int (*file_fcntl) (struct file *file, unsigned int cmd,
			   unsigned long arg);
	void (*file_set_fowner) (struct file *file);
	int (*file_send_sigiotask) (struct task_struct *tsk,
				    struct fown_struct *fown, int sig);
	int (*file_receive) (struct file *file);
	int (*file_open) (struct file *file, const struct cred *cred);

	int (*task_create) (unsigned long clone_flags);
	void (*task_free) (struct task_struct *task);
	int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
	void (*cred_free) (struct cred *cred);
	int (*cred_prepare)(struct cred *new, const struct cred *old,
			    gfp_t gfp);
	void (*cred_transfer)(struct cred *new, const struct cred *old);
	int (*kernel_act_as)(struct cred *new, u32 secid);
	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
	int (*kernel_fw_from_file)(struct file *file, char *buf, size_t size);
	int (*kernel_module_request)(char *kmod_name);
	int (*kernel_module_from_file)(struct file *file);
	int (*task_fix_setuid) (struct cred *new, const struct cred *old,
				int flags);
	int (*task_setpgid) (struct task_struct *p, pid_t pgid);
	int (*task_getpgid) (struct task_struct *p);
	int (*task_getsid) (struct task_struct *p);
	void (*task_getsecid) (struct task_struct *p, u32 *secid);
	int (*task_setnice) (struct task_struct *p, int nice);
	int (*task_setioprio) (struct task_struct *p, int ioprio);
	int (*task_getioprio) (struct task_struct *p);
	int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
			struct rlimit *new_rlim);
	int (*task_setscheduler) (struct task_struct *p);
	int (*task_getscheduler) (struct task_struct *p);
	int (*task_movememory) (struct task_struct *p);
	int (*task_kill) (struct task_struct *p,
			  struct siginfo *info, int sig, u32 secid);
	int (*task_wait) (struct task_struct *p);
	int (*task_prctl) (int option, unsigned long arg2,
			   unsigned long arg3, unsigned long arg4,
			   unsigned long arg5);
	void (*task_to_inode) (struct task_struct *p, struct inode *inode);

	int (*ipc_permission) (struct kern_ipc_perm *ipcp, short flag);
	void (*ipc_getsecid) (struct kern_ipc_perm *ipcp, u32 *secid);

	int (*msg_msg_alloc_security) (struct msg_msg *msg);
	void (*msg_msg_free_security) (struct msg_msg *msg);

	int (*msg_queue_alloc_security) (struct msg_queue *msq);
	void (*msg_queue_free_security) (struct msg_queue *msq);
	int (*msg_queue_associate) (struct msg_queue *msq, int msqflg);
	int (*msg_queue_msgctl) (struct msg_queue *msq, int cmd);
	int (*msg_queue_msgsnd) (struct msg_queue *msq,
				 struct msg_msg *msg, int msqflg);
	int (*msg_queue_msgrcv) (struct msg_queue *msq,
				 struct msg_msg *msg,
				 struct task_struct *target,
				 long type, int mode);

	int (*shm_alloc_security) (struct shmid_kernel *shp);
	void (*shm_free_security) (struct shmid_kernel *shp);
	int (*shm_associate) (struct shmid_kernel *shp, int shmflg);
	int (*shm_shmctl) (struct shmid_kernel *shp, int cmd);
	int (*shm_shmat) (struct shmid_kernel *shp,
			  char __user *shmaddr, int shmflg);

	int (*sem_alloc_security) (struct sem_array *sma);
	void (*sem_free_security) (struct sem_array *sma);
	int (*sem_associate) (struct sem_array *sma, int semflg);
	int (*sem_semctl) (struct sem_array *sma, int cmd);
	int (*sem_semop) (struct sem_array *sma,
			  struct sembuf *sops, unsigned nsops, int alter);

	int (*netlink_send) (struct sock *sk, struct sk_buff *skb);

	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);

	int (*getprocattr) (struct task_struct *p, char *name, char **value);
	int (*setprocattr) (struct task_struct *p, char *name, void *value, size_t size);
	int (*ismaclabel) (const char *name);
	int (*secid_to_secctx) (u32 secid, char **secdata, u32 *seclen);
	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
	void (*release_secctx) (char *secdata, u32 seclen);

	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);

#ifdef CONFIG_SECURITY_NETWORK
	int (*unix_stream_connect) (struct sock *sock, struct sock *other, struct sock *newsk);
	int (*unix_may_send) (struct socket *sock, struct socket *other);

	int (*socket_create) (int family, int type, int protocol, int kern);
	int (*socket_post_create) (struct socket *sock, int family,
				   int type, int protocol, int kern);
	int (*socket_bind) (struct socket *sock,
			    struct sockaddr *address, int addrlen);
	int (*socket_connect) (struct socket *sock,
			       struct sockaddr *address, int addrlen);
	int (*socket_listen) (struct socket *sock, int backlog);
	int (*socket_accept) (struct socket *sock, struct socket *newsock);
	int (*socket_sendmsg) (struct socket *sock,
			       struct msghdr *msg, int size);
	int (*socket_recvmsg) (struct socket *sock,
			       struct msghdr *msg, int size, int flags);
	int (*socket_getsockname) (struct socket *sock);
	int (*socket_getpeername) (struct socket *sock);
	int (*socket_getsockopt) (struct socket *sock, int level, int optname);
	int (*socket_setsockopt) (struct socket *sock, int level, int optname);
	int (*socket_shutdown) (struct socket *sock, int how);
	int (*socket_sock_rcv_skb) (struct sock *sk, struct sk_buff *skb);
	int (*socket_getpeersec_stream) (struct socket *sock, char __user *optval, int __user *optlen, unsigned len);
	int (*socket_getpeersec_dgram) (struct socket *sock, struct sk_buff *skb, u32 *secid);
	int (*sk_alloc_security) (struct sock *sk, int family, gfp_t priority);
	void (*sk_free_security) (struct sock *sk);
	void (*sk_clone_security) (const struct sock *sk, struct sock *newsk);
	void (*sk_getsecid) (struct sock *sk, u32 *secid);
	void (*sock_graft) (struct sock *sk, struct socket *parent);
	int (*inet_conn_request) (struct sock *sk, struct sk_buff *skb,
				  struct request_sock *req);
	void (*inet_csk_clone) (struct sock *newsk, const struct request_sock *req);
	void (*inet_conn_established) (struct sock *sk, struct sk_buff *skb);
	int (*secmark_relabel_packet) (u32 secid);
	void (*secmark_refcount_inc) (void);
	void (*secmark_refcount_dec) (void);
	void (*req_classify_flow) (const struct request_sock *req, struct flowi *fl);
	int (*tun_dev_alloc_security) (void **security);
	void (*tun_dev_free_security) (void *security);
	int (*tun_dev_create) (void);
	int (*tun_dev_attach_queue) (void *security);
	int (*tun_dev_attach) (struct sock *sk, void *security);
	int (*tun_dev_open) (void *security);
	void (*skb_owned_by) (struct sk_buff *skb, struct sock *sk);
#endif	/* CONFIG_SECURITY_NETWORK */

#ifdef CONFIG_SECURITY_NETWORK_XFRM
	int (*xfrm_policy_alloc_security) (struct xfrm_sec_ctx **ctxp,
			struct xfrm_user_sec_ctx *sec_ctx, gfp_t gfp);
	int (*xfrm_policy_clone_security) (struct xfrm_sec_ctx *old_ctx, struct xfrm_sec_ctx **new_ctx);
	void (*xfrm_policy_free_security) (struct xfrm_sec_ctx *ctx);
	int (*xfrm_policy_delete_security) (struct xfrm_sec_ctx *ctx);
	int (*xfrm_state_alloc) (struct xfrm_state *x,
				 struct xfrm_user_sec_ctx *sec_ctx);
	int (*xfrm_state_alloc_acquire) (struct xfrm_state *x,
					 struct xfrm_sec_ctx *polsec,
					 u32 secid);
	void (*xfrm_state_free_security) (struct xfrm_state *x);
	int (*xfrm_state_delete_security) (struct xfrm_state *x);
	int (*xfrm_policy_lookup) (struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
	int (*xfrm_state_pol_flow_match) (struct xfrm_state *x,
					  struct xfrm_policy *xp,
					  const struct flowi *fl);
	int (*xfrm_decode_session) (struct sk_buff *skb, u32 *secid, int ckall);
#endif	/* CONFIG_SECURITY_NETWORK_XFRM */

	/* key management security hooks */
#ifdef CONFIG_KEYS
	int (*key_alloc) (struct key *key, const struct cred *cred, unsigned long flags);
	void (*key_free) (struct key *key);
	int (*key_permission) (key_ref_t key_ref,
			       const struct cred *cred,
			       unsigned perm);
	int (*key_getsecurity)(struct key *key, char **_buffer);
#endif	/* CONFIG_KEYS */

#ifdef CONFIG_AUDIT
	int (*audit_rule_init) (u32 field, u32 op, char *rulestr, void **lsmrule);
	int (*audit_rule_known) (struct audit_krule *krule);
	int (*audit_rule_match) (u32 secid, u32 field, u32 op, void *lsmrule,
				 struct audit_context *actx);
	void (*audit_rule_free) (void *lsmrule);
#endif /* CONFIG_AUDIT */
};



...
// 进程创建
int (*task_create) (unsigned long clone_flags);
// 进程释放
void (*task_free) (struct task_struct *task);
int (*task_fix_setuid) (struct cred *new, const struct cred *old,
            int flags);
// 设置 pid、gid
int (*task_setpgid) (struct task_struct *p, pid_t pgid);
// 获取 pid、gid
int (*task_getpgid) (struct task_struct *p);
int (*task_getsid) (struct task_struct *p);
void (*task_getsecid) (struct task_struct *p, u32 *secid);
int (*task_setnice) (struct task_struct *p, int nice);
int (*task_setioprio) (struct task_struct *p, int ioprio);
int (*task_getioprio) (struct task_struct *p);
...



// 申请安全模块
int (*bprm_alloc_security) (struct linux_binprm * bprm); 
// 释放安全模块
void (*bprm_free_security) (struct linux_binprm * bprm); 
// 应用凭据
void (*bprm_apply_creds) (struct linux_binprm * bprm, int unsafe); 
void (*bprm_post_apply_creds) (struct linux_binprm * bprm); 
int (*bprm_set_security) (struct linux_binprm * bprm);
// 检查安全 
int (*bprm_check_security) (struct linux_binprm * bprm); 
int (*bprm_secureexec) (struct linux_binprm * bprm);


// IPC 允许
int (*ipc_permission) (struct kern_ipc_perm *ipcp, short flag);
// 为了支持单个消息的安全信息, LSM 在 msg_msg 结构中加入了一个安全域
int (*msg_msg_alloc_security) (struct msg_msg *msg);
void (*msg_msg_free_security) (struct msg_msg *msg);
...

...
// 安全初始化
int (*inode_init_security) (struct inode *inode, struct inode *dir,
                const struct qstr *qstr, const char **name,
                void **value, size_t *len);
// 创建 inode 节点
int (*inode_create) (struct inode *dir,
                struct dentry *dentry, umode_t mode);
// 建立 link
int (*inode_link) (struct dentry *old_dentry,
            struct inode *dir, struct dentry *new_dentry);
int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
int (*inode_symlink) (struct inode *dir,
                struct dentry *dentry, const char *old_name);
// 创建文件夹
int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, umode_t mode);
// 删除文件夹
int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
            umode_t mode, dev_t dev);
// 改名
int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
                struct inode *new_dir, struct dentry *new_dentry);
...


// 文件权限
int (*file_permission) (struct file *file, int mask);
// 安全模块
int (*file_alloc_security) (struct file *file);
// 释放
void (*file_free_security) (struct file *file);
int (*file_mprotect) (struct vm_area_struct *vma,
                unsigned long reqprot,
                unsigned long prot);
// 文件锁
int (*file_lock) (struct file *file, unsigned int cmd);
int (*file_fcntl) (struct file *file, unsigned int cmd,
            unsigned long arg);
// 设置文件属主
void (*file_set_fowner) (struct file *file);
int (*file_send_sigiotask) (struct task_struct *tsk,
                struct fown_struct *fown, int sig);
// 文件接受
int (*file_receive) (struct file *file);
// 文件打开
int (*file_open) (struct file *file, const struct cred *cred);


// unix 流连接
int (*unix_stream_connect) (struct sock *sock, struct sock *other, struct sock *newsk);
// 创建 socket
int (*socket_create) (int family, int type, int protocol, int kern);
int (*socket_post_create) (struct socket *sock, int family,
                int type, int protocol, int kern);
// 绑定 socket
int (*socket_bind) (struct socket *sock,
            struct sockaddr *address, int addrlen);
// socket 连接
int (*socket_connect) (struct socket *sock,
                struct sockaddr *address, int addrlen);
// socket 监听
int (*socket_listen) (struct socket *sock, int backlog);
// socket 接受
int (*socket_accept) (struct socket *sock, struct socket *newsock);
// socket 发送消息
int (*socket_sendmsg) (struct socket *sock,
                struct msghdr *msg, int size);
// socket 接收消息
int (*socket_recvmsg) (struct socket *sock,
                struct msghdr *msg, int size, int flags);
// socket 获取 sock 名称
int (*socket_getsockname) (struct socket *sock);
// socket 关闭
int (*socket_shutdown) (struct socket *sock, int how);
...