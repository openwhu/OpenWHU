static __init int selinux_init(void)
{
	...
		// 初始化 selinux 状态结构体
		selinux_ss_init(&selinux_state.ss);
	selinux_avc_init(&selinux_state.avc);
	mutex_init(&selinux_state.status_lock);

	// 设置当前进程的安全状态
	cred_init_security();
	// 初始化向量缓存
	avc_init();
	// 初始化访问控制向量表
	// 该表也采用 hash 表的结构
	avtab_cache_init();

	ebitmap_cache_init();
	// 初始化 hash 表
	hashtab_cache_init();
	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks), "selinux");

	...
}

struct selinux_state
{
	...
		// 是否初始化
		bool initialized;
	bool policycap[__POLICYDB_CAPABILITY_MAX];

	struct page *status_page;
	// 锁
	struct mutex status_lock;
	// 安全缓存向量结构体
	struct selinux_avc *avc;
	// 存储有一些关键的数据结构
	// 例如 sidtab 以及 policydb 等
	struct selinux_ss *ss;
} __randomize_layout;

struct selinux_ss
{
	// sid 表
	struct sidtab *sidtab;
	// 策略数据库
	struct policydb policydb;
	struct selinux_map map;
} __randomize_layout;

struct sidtab
{
	...
		/* index == SID - 1 (no entry for SECSID_NULL) */
		struct sidtab_isid_entry isids[SECINITSID_NUM];
	...
};

struct sidtab_isid_entry
{
	int set;
	struct sidtab_entry entry;
};

struct sidtab_entry
{
	// sid
	u32 sid;
	u32 hash;
	// sid 对应的安全上下文
	struct context context;
	struct hlist_node list;
};

/*
 * A security context consists of an authenticated user
 * identity, a role, a type and a MLS range.
 */
struct context
{
	u32 user;
	u32 role;
	u32 type;
	u32 len; /* length of string in bytes */
	struct mls_range range;
	char *str; /* string representation if context cannot be mapped. */
};

struct policydb
{
	...
		// 符号表
		struct symtab symtab[SYM_NUM];
	// 类型裁决访问向量和转换
	struct avtab te_avtab;
	// 角色转换, hashtable
	struct hashtab role_tr;
	// 类型强制条件访问向量和转换
	struct avtab te_cond_avtab;
	// 角色允许
	struct role_allow *role_allow;
	// 初始SID，未标记文件系统，TCP或UDP端口号，网络接口和节点
	struct ocontext *ocontexts[OCON_NUM];
	// 范围转换表, hashtable
	struct hashtab range_tr;
	...
} __randomize_layout;

/* Mapping for a single class */
struct selinux_mapping
{
	u16 value;					/* policy value for class */
	unsigned int num_perms;		/* number of permissions in class */
	u32 perms[sizeof(u32) * 8]; /* policy values for permissions */
};

struct selinux_avc
{
	unsigned int avc_cache_threshold;
	struct avc_cache avc_cache;
};

struct avc_cache
{
	// 指向 avc_node->list 的头节点
	struct hlist_head slots[AVC_CACHE_SLOTS]; /* head for avc_node->list */
	...
};

struct avc_node
{
	// 安全缓存向量实体
	struct avc_entry ae;
	struct hlist_node list;
	struct rcu_head rhead;
};

struct avc_entry
{
	u32 ssid;
	u32 tsid;
	u16 tclass;
	struct av_decision avd;
	struct avc_xperms_node *xp_node;
};

static void cred_init_security(void)
{
	struct cred *cred = (struct cred *)current->real_cred;
	struct task_security_struct *tsec;

	tsec = selinux_cred(cred);
	tsec->osid = tsec->sid = SECINITSID_KERNEL;
}

struct task_security_struct
{
	// 最后一次 execve 之前的 sid
	u32 osid;
	// 当前 sid
	u32 sid;
	// exec 的 sid
	u32 exec_sid;
	// 创建文件系统的 sid
	u32 create_sid;
	// 创建密钥的 sid
	u32 keycreate_sid;
	// 创建套接字的 sid
	u32 sockcreate_sid;
} __randomize_layout;

struct cred
{
	...
		// 进程的真实 uid
		kuid_t uid;
	// 进程的真实 gid
	kgid_t gid;
	// 进程的保留 uid
	kuid_t suid;
	// 进程的保留 gid
	kgid_t sgid;
	// 进程的有效 uid
	kuid_t euid;
	// 进程的有效 gid
	kgid_t egid;
	... struct user_struct *user;	/* real user ID subscription */
	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
	...
} __randomize_layout;

void __init avc_init(void)
{
	// 给 avc_node 结构体分配空间
	avc_node_cachep = kmem_cache_create(
		"avc_node",
		sizeof(struct avc_node),
		0, SLAB_PANIC, NULL);
	// 给 avc_xperms_node 结构体分配空间
	avc_xperms_cachep = kmem_cache_create(
		"avc_xperms_node",
		sizeof(struct avc_xperms_node),
		0, SLAB_PANIC, NULL);
	// 给 avc_xperms_decision_node 结构体分配空间
	avc_xperms_decision_cachep = kmem_cache_create(
		"avc_xperms_decision_node",
		sizeof(struct avc_xperms_decision_node),
		0, SLAB_PANIC, NULL);
	// 给 extended_perms_data 结构体分配空间
	avc_xperms_data_cachep = kmem_cache_create(
		"avc_xperms_data",
		sizeof(struct extended_perms_data),
		0, SLAB_PANIC, NULL);
}

void __init avtab_cache_init(void)
{
	avtab_node_cachep = kmem_cache_create(
		"avtab_node",
		sizeof(struct avtab_node),
		0, SLAB_PANIC, NULL);
	avtab_xperms_cachep = kmem_cache_create(
		"avtab_extended_perms",
		sizeof(struct avtab_extended_perms),
		0, SLAB_PANIC, NULL);
}

void __init hashtab_cache_init(void)
{
	hashtab_node_cachep = kmem_cache_create(
		"hashtab_node",
		sizeof(struct hashtab_node),
		0, SLAB_PANIC, NULL);
}

void __init security_add_hooks(struct security_hook_list *hooks,
							   int count, char *lsm)
{
	int i;

	// 注册到 lsm 中
	for (i = 0; i < count; i++)
	{
		hooks[i].lsm = lsm;
		hlist_add_tail_rcu(&hooks[i].list, hooks[i].head);
	}

	if (slab_is_available())
	{
		if (lsm_append(lsm, &lsm_names) < 0)
			panic("%s - Cannot get early memory.\n", __func__);
	}
}

static struct task_struct *copy_process(...)
{
	...
		// 使用 security_task_create 进行权限检查
		retval = security_task_create(clone_flags);
	if (retval)
		goto fork_out;
	...
}

int security_task_create(unsigned long clone_flags)
{
	return security_ops->task_create(clone_flags);
}

static int selinux_task_create(unsigned long clone_flags)
{
	return current_has_perm(current, PROCESS__FORK);
}

static int current_has_perm(const struct task_struct *tsk,
							u32 perms)
{
	u32 sid, tsid;

	sid = current_sid();
	tsid = task_sid(tsk);
	return avc_has_perm(sid, tsid, SECCLASS_PROCESS, perms, NULL);
}

int avc_has_perm(u32 ssid, u32 tsid, u16 tclass,
				 u32 requested, struct common_audit_data *auditdata)
{
	struct av_decision avd;
	int rc, rc2;

	rc = avc_has_perm_noaudit(ssid, tsid, tclass, requested, 0, &avd);

	rc2 = avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata);
	if (rc2)
		return rc2;
	return rc;
}

inline int avc_has_perm_noaudit(u32 ssid, u32 tsid,
								u16 tclass, u32 requested,
								unsigned flags,
								struct av_decision *avd)
{
	// 查询 AVC entry
	node = avc_lookup(ssid, tsid, tclass);
	if (unlikely(!node))
	{
		node = avc_compute_av(ssid, tsid, tclass, avd);
	}
	else
	{
		memcpy(avd, &node->ae.avd, sizeof(*avd));
		avd = &node->ae.avd;
	}
	...
}

static noinline struct avc_node *avc_compute_av(u32 ssid, u32 tsid,
												u16 tclass, struct av_decision *avd)
{
	... security_compute_av(ssid, tsid, tclass, avd);
	...
}

void security_compute_av(...)
{
	...
		// 初始化 avc
		avd_init(avd);
	// 根据源 sid 在 sid表中进行查找
	scontext = sidtab_search(&sidtab, ssid);
	// 根据目标 sid 在 sid表中进行查找
	tcontext = sidtab_search(&sidtab, tsid);

	context_struct_compute_av(scontext, tcontext, tclass, avd);
	...
}

/*
 * Compute access vectors based on a context structure pair for
 * the permissions in a particular class.
 */
static void context_struct_compute_av(struct context *scontext,
									  struct context *tcontext,
									  u16 tclass,
									  struct av_decision *avd)
{
	// 初始化 avc
	avd->allowed = 0;
	avd->auditallow = 0;
	avd->auditdeny = 0xffffffff;
	// 检查 class 和权限是否正确
	if (unlikely(!tclass || tclass > policydb.p_classes.nprim))
	{
		...
	}
	// 检查 type 权限
	avkey.target_class = tclass;
	avkey.specified = AVTAB_AV;
	ebitmap_for_each_positive_bit(sattr, snode, i)
	{
		ebitmap_for_each_positive_bit(tattr, tnode, j)
		{
			...
				// 检查 conditional statements
				cond_compute_av(&policydb.te_cond_avtab, &avkey, avd);
		}
	}
	// 检查 MLS 约束以及移除 constraint_expr_eval() 定义的权限
	constraint = tclass_datum->constraints;
	while (constraint)
	{
		...
	}
	// 检查权限转移是否被请求
	if (tclass == policydb.process_class &&
		(avd->allowed & policydb.process_trans_perms) &&
		scontext->role != tcontext->role)
	{
		...
	}
	// 检查 typebounds
	type_attribute_bounds_av(scontext, tcontext,
							 tclass, avd);
}

retval = security_task_alloc(p, clone_flags);
if (retval)
	goto bad_fork_cleanup_audit;

int security_task_alloc(struct task_struct *task,
						unsigned long clone_flags)
{
	int rc = lsm_task_alloc(task);

	if (rc)
		return rc;
	rc = call_int_hook(task_alloc, 0, task, clone_flags);
	if (unlikely(rc))
		security_task_free(task);
	return rc;
}

#define call_int_hook(FUNC, IRC, ...) ({                         \
	int RC = IRC;                                                \
	do                                                           \
	{                                                            \
		struct security_hook_list *P;                            \
                                                                 \
		hlist_for_each_entry(P, &security_hook_heads.FUNC, list) \
		{                                                        \
			RC = P->hook.FUNC(__VA_ARGS__);                      \
			if (RC != 0)                                         \
				break;                                           \
		}                                                        \
	} while (0);                                                 \
	RC;                                                          \
})

static int selinux_task_alloc(struct task_struct *task,
							  unsigned long clone_flags)
{
	u32 sid = current_sid();

	return avc_has_perm(&selinux_state,
						sid, sid, SECCLASS_PROCESS, PROCESS__FORK, NULL);
}

int __init register_security(struct security_operations *ops)
{
	if (verify(ops))
	{
		printk(KERN_DEBUG "%s could not verify "
						  "security_operations structure.\n",
			   __func__);
		return -EINVAL;
	}

	if (security_ops != &default_security_ops)
		return -EAGAIN;

	security_ops = ops;

	return 0;
}

static struct security_operations selinux_ops = {
	.name = "selinux",

	.ptrace_access_check = selinux_ptrace_access_check,
	.ptrace_traceme = selinux_ptrace_traceme,
	.capget = selinux_capget,
	.capset = selinux_capset,
	.capable = selinux_capable,
	.quotactl = selinux_quotactl,
	...}

#define LSM_HOOK_INIT(HEAD, HOOK)                                  \
	{                                                              \
		.head = &security_hook_heads.HEAD, .hook = {.HEAD = HOOK } \
	}

/**
 * security_transition_sid - Compute the SID for a new subject/object.
 * @ssid: source security identifier
 * @tsid: target security identifier
 * @tclass: target security class
 * @out_sid: security identifier for new subject/object
 *
 * Compute a SID to use for labeling a new subject or object in the
 * class @tclass based on a SID pair (@ssid, @tsid).
 * Return -%EINVAL if any of the parameters are invalid, -%ENOMEM
 * if insufficient memory is available, or %0 if the new SID was
 * computed successfully.
 */
int
security_transition_sid(struct selinux_state * state, u32 ssid, u32 tsid, u16 tclass, const struct qstr *qstr, u32 *out_sid)
{
	return security_compute_sid(state, ssid, tsid, tclass,
								AVTAB_TRANSITION,
								qstr ? qstr->name : NULL, out_sid, true);
}

static int security_compute_sid(struct selinux_state *state,
								u32 ssid,
								u32 tsid,
								u16 orig_tclass,
								u32 specified,
								const char *objname,
								u32 *out_sid,
								bool kern)
{
	struct selinux_policy *policy;
	struct policydb *policydb;
	struct sidtab *sidtab;
	struct class_datum *cladatum = NULL;
	struct context *scontext, *tcontext, newcontext;
	struct sidtab_entry *sentry, *tentry;
	struct avtab_key avkey;
	struct avtab_datum *avdatum;
	struct avtab_node *node;
	u16 tclass;
	int rc = 0;
	bool sock;

	if (!selinux_initialized(state))
	{
		switch (orig_tclass)
		{
		case SECCLASS_PROCESS: /* kernel value */
			*out_sid = ssid;
			break;
		default:
			*out_sid = tsid;
			break;
		}
		goto out;
	}

	context_init(&newcontext);

	rcu_read_lock();

	policy = rcu_dereference(state->policy);

	if (kern)
	{
		tclass = unmap_class(&policy->map, orig_tclass);
		sock = security_is_socket_class(orig_tclass);
	}
	else
	{
		tclass = orig_tclass;
		sock = security_is_socket_class(map_class(&policy->map,
												  tclass));
	}

	policydb = &policy->policydb;
	sidtab = policy->sidtab;

	sentry = sidtab_search_entry(sidtab, ssid);
	if (!sentry)
	{
		pr_err("SELinux: %s:  unrecognized SID %d\n",
			   __func__, ssid);
		rc = -EINVAL;
		goto out_unlock;
	}
	tentry = sidtab_search_entry(sidtab, tsid);
	if (!tentry)
	{
		pr_err("SELinux: %s:  unrecognized SID %d\n",
			   __func__, tsid);
		rc = -EINVAL;
		goto out_unlock;
	}

	scontext = &sentry->context;
	tcontext = &tentry->context;

	if (tclass && tclass <= policydb->p_classes.nprim)
		cladatum = policydb->class_val_to_struct[tclass - 1];

	/* Set the user identity. */
	switch (specified)
	{
	case AVTAB_TRANSITION:
	case AVTAB_CHANGE:
		if (cladatum && cladatum->default_user == DEFAULT_TARGET)
		{
			newcontext.user = tcontext->user;
		}
		else
		{
			/* notice this gets both DEFAULT_SOURCE and unset */
			/* Use the process user identity. */
			newcontext.user = scontext->user;
		}
		break;
	case AVTAB_MEMBER:
		/* Use the related object owner. */
		newcontext.user = tcontext->user;
		break;
	}

	/* Set the role to default values. */
	if (cladatum && cladatum->default_role == DEFAULT_SOURCE)
	{
		newcontext.role = scontext->role;
	}
	else if (cladatum && cladatum->default_role == DEFAULT_TARGET)
	{
		newcontext.role = tcontext->role;
	}
	else
	{
		if ((tclass == policydb->process_class) || sock)
			newcontext.role = scontext->role;
		else
			newcontext.role = OBJECT_R_VAL;
	}

	/* Set the type to default values. */
	if (cladatum && cladatum->default_type == DEFAULT_SOURCE)
	{
		newcontext.type = scontext->type;
	}
	else if (cladatum && cladatum->default_type == DEFAULT_TARGET)
	{
		newcontext.type = tcontext->type;
	}
	else
	{
		if ((tclass == policydb->process_class) || sock)
		{
			/* Use the type of process. */
			newcontext.type = scontext->type;
		}
		else
		{
			/* Use the type of the related object. */
			newcontext.type = tcontext->type;
		}
	}

	/* Look for a type transition/member/change rule. */
	avkey.source_type = scontext->type;
	avkey.target_type = tcontext->type;
	avkey.target_class = tclass;
	avkey.specified = specified;
	avdatum = avtab_search(&policydb->te_avtab, &avkey);

	/* If no permanent rule, also check for enabled conditional rules */
	if (!avdatum)
	{
		node = avtab_search_node(&policydb->te_cond_avtab, &avkey);
		for (; node; node = avtab_search_node_next(node, specified))
		{
			if (node->key.specified & AVTAB_ENABLED)
			{
				avdatum = &node->datum;
				break;
			}
		}
	}

	if (avdatum)
	{
		/* Use the type from the type transition/member/change rule. */
		newcontext.type = avdatum->u.data;
	}

	/* if we have a objname this is a file trans check so check those rules */
	if (objname)
		filename_compute_type(policydb, &newcontext, scontext->type,
							  tcontext->type, tclass, objname);

	/* Check for class-specific changes. */
	if (specified & AVTAB_TRANSITION)
	{
		/* Look for a role transition rule. */
		struct role_trans_datum *rtd;
		struct role_trans_key rtk = {
			.role = scontext->role,
			.type = tcontext->type,
			.tclass = tclass,
		};

		rtd = policydb_roletr_search(policydb, &rtk);
		if (rtd)
			newcontext.role = rtd->new_role;
	}

	/* Set the MLS attributes.
	   This is done last because it may allocate memory. */
	rc = mls_compute_sid(policydb, scontext, tcontext, tclass, specified,
						 &newcontext, sock);
	if (rc)
		goto out_unlock;

	/* Check the validity of the context. */
	if (!policydb_context_isvalid(policydb, &newcontext))
	{
		rc = compute_sid_handle_invalid_context(state, policy, sentry,
												tentry, tclass,
												&newcontext);
		if (rc)
			goto out_unlock;
	}
	/* Obtain the sid for the context. */
	rc = sidtab_context_to_sid(sidtab, &newcontext, out_sid);
out_unlock:
	rcu_read_unlock();
	context_destroy(&newcontext);
out:
	return rc;
}

int sidtab_context_to_sid(struct sidtab *s, struct context *context,
						  u32 *sid)
{
	unsigned long flags;
	u32 count, hash = context_compute_hash(context);
	struct sidtab_convert_params *convert;
	struct sidtab_entry *dst, *dst_convert;
	int rc;

	*sid = context_to_sid(s, context, hash);
	if (*sid)
		return 0;

	/* lock-free search failed: lock, re-search, and insert if not found */
	spin_lock_irqsave(&s->lock, flags);

	rc = 0;
	*sid = context_to_sid(s, context, hash);
	if (*sid)
		goto out_unlock;

	count = s->count;
	convert = s->convert;

	/* bail out if we already reached max entries */
	rc = -EOVERFLOW;
	if (count >= SIDTAB_MAX)
		goto out_unlock;

	/* insert context into new entry */
	rc = -ENOMEM;
	dst = sidtab_do_lookup(s, count, 1);
	if (!dst)
		goto out_unlock;

	dst->sid = index_to_sid(count);
	dst->hash = hash;

	rc = context_cpy(&dst->context, context);
	if (rc)
		goto out_unlock;

	/*
	 * if we are building a new sidtab, we need to convert the context
	 * and insert it there as well
	 */
	if (convert)
	{
		rc = -ENOMEM;
		dst_convert = sidtab_do_lookup(convert->target, count, 1);
		if (!dst_convert)
		{
			context_destroy(&dst->context);
			goto out_unlock;
		}

		rc = convert->func(context, &dst_convert->context,
						   convert->args);
		if (rc)
		{
			context_destroy(&dst->context);
			goto out_unlock;
		}
		dst_convert->sid = index_to_sid(count);
		dst_convert->hash = context_compute_hash(&dst_convert->context);
		convert->target->count = count + 1;

		hash_add_rcu(convert->target->context_to_sid,
					 &dst_convert->list, dst_convert->hash);
	}

	if (context->len)
		pr_info("SELinux:  Context %s is not valid (left unmapped).\n",
				context->str);

	*sid = index_to_sid(count);

	/* write entries before updating count */
	smp_store_release(&s->count, count + 1);
	hash_add_rcu(s->context_to_sid, &dst->list, dst->hash);

	rc = 0;
out_unlock:
	spin_unlock_irqrestore(&s->lock, flags);
	return rc;
}

static u32 context_to_sid(struct sidtab *s, struct context *context, u32 hash)
{
	struct sidtab_entry *entry;
	u32 sid = 0;

	rcu_read_lock();
	hash_for_each_possible_rcu(s->context_to_sid, entry, list, hash)
	{
		if (entry->hash != hash)
			continue;
		if (context_cmp(&entry->context, context))
		{
			sid = entry->sid;
			break;
		}
	}
	rcu_read_unlock();
	return sid;
}

struct security_operations
{
	char name[SECURITY_NAME_MAX + 1];

	int (*ptrace_access_check)(struct task_struct *child, unsigned int mode);
	int (*ptrace_traceme)(struct task_struct *parent);
	int (*capget)(struct task_struct *target,
				  kernel_cap_t *effective,
				  kernel_cap_t *inheritable, kernel_cap_t *permitted);
	int (*capset)(struct cred *new,
				  const struct cred *old,
				  const kernel_cap_t *effective,
				  const kernel_cap_t *inheritable,
				  const kernel_cap_t *permitted);
	int (*capable)(const struct cred *cred, struct user_namespace *ns,
				   int cap, int audit);
	int (*quotactl)(int cmds, int type, int id, struct super_block *sb);
	int (*quota_on)(struct dentry *dentry);
	int (*syslog)(int type);
	int (*settime)(const struct timespec *ts, const struct timezone *tz);
	int (*vm_enough_memory)(struct mm_struct *mm, long pages);

	int (*bprm_set_creds)(struct linux_binprm *bprm);
	int (*bprm_check_security)(struct linux_binprm *bprm);
	int (*bprm_secureexec)(struct linux_binprm *bprm);
	void (*bprm_committing_creds)(struct linux_binprm *bprm);
	void (*bprm_committed_creds)(struct linux_binprm *bprm);

	int (*sb_alloc_security)(struct super_block *sb);
	void (*sb_free_security)(struct super_block *sb);
	int (*sb_copy_data)(char *orig, char *copy);
	int (*sb_remount)(struct super_block *sb, void *data);
	int (*sb_kern_mount)(struct super_block *sb, int flags, void *data);
	int (*sb_show_options)(struct seq_file *m, struct super_block *sb);
	int (*sb_statfs)(struct dentry *dentry);
	int (*sb_mount)(const char *dev_name, struct path *path,
					const char *type, unsigned long flags, void *data);
	int (*sb_umount)(struct vfsmount *mnt, int flags);
	int (*sb_pivotroot)(struct path *old_path,
						struct path *new_path);
	int (*sb_set_mnt_opts)(struct super_block *sb,
						   struct security_mnt_opts *opts,
						   unsigned long kern_flags,
						   unsigned long *set_kern_flags);
	int (*sb_clone_mnt_opts)(const struct super_block *oldsb,
							 struct super_block *newsb);
	int (*sb_parse_opts_str)(char *options, struct security_mnt_opts *opts);
	int (*dentry_init_security)(struct dentry *dentry, int mode,
								struct qstr *name, void **ctx,
								u32 *ctxlen);

#ifdef CONFIG_SECURITY_PATH
	int (*path_unlink)(struct path *dir, struct dentry *dentry);
	int (*path_mkdir)(struct path *dir, struct dentry *dentry, umode_t mode);
	int (*path_rmdir)(struct path *dir, struct dentry *dentry);
	int (*path_mknod)(struct path *dir, struct dentry *dentry, umode_t mode,
					  unsigned int dev);
	int (*path_truncate)(struct path *path);
	int (*path_symlink)(struct path *dir, struct dentry *dentry,
						const char *old_name);
	int (*path_link)(struct dentry *old_dentry, struct path *new_dir,
					 struct dentry *new_dentry);
	int (*path_rename)(struct path *old_dir, struct dentry *old_dentry,
					   struct path *new_dir, struct dentry *new_dentry);
	int (*path_chmod)(struct path *path, umode_t mode);
	int (*path_chown)(struct path *path, kuid_t uid, kgid_t gid);
	int (*path_chroot)(struct path *path);
#endif

	int (*inode_alloc_security)(struct inode *inode);
	void (*inode_free_security)(struct inode *inode);
	int (*inode_init_security)(struct inode *inode, struct inode *dir,
							   const struct qstr *qstr, const char **name,
							   void **value, size_t *len);
	int (*inode_create)(struct inode *dir,
						struct dentry *dentry, umode_t mode);
	int (*inode_link)(struct dentry *old_dentry,
					  struct inode *dir, struct dentry *new_dentry);
	int (*inode_unlink)(struct inode *dir, struct dentry *dentry);
	int (*inode_symlink)(struct inode *dir,
						 struct dentry *dentry, const char *old_name);
	int (*inode_mkdir)(struct inode *dir, struct dentry *dentry, umode_t mode);
	int (*inode_rmdir)(struct inode *dir, struct dentry *dentry);
	int (*inode_mknod)(struct inode *dir, struct dentry *dentry,
					   umode_t mode, dev_t dev);
	int (*inode_rename)(struct inode *old_dir, struct dentry *old_dentry,
						struct inode *new_dir, struct dentry *new_dentry);
	int (*inode_readlink)(struct dentry *dentry);
	int (*inode_follow_link)(struct dentry *dentry, struct nameidata *nd);
	int (*inode_permission)(struct inode *inode, int mask);
	int (*inode_setattr)(struct dentry *dentry, struct iattr *attr);
	int (*inode_getattr)(struct vfsmount *mnt, struct dentry *dentry);
	int (*inode_setxattr)(struct dentry *dentry, const char *name,
						  const void *value, size_t size, int flags);
	void (*inode_post_setxattr)(struct dentry *dentry, const char *name,
								const void *value, size_t size, int flags);
	int (*inode_getxattr)(struct dentry *dentry, const char *name);
	int (*inode_listxattr)(struct dentry *dentry);
	int (*inode_removexattr)(struct dentry *dentry, const char *name);
	int (*inode_need_killpriv)(struct dentry *dentry);
	int (*inode_killpriv)(struct dentry *dentry);
	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
	void (*inode_getsecid)(const struct inode *inode, u32 *secid);

	int (*file_permission)(struct file *file, int mask);
	int (*file_alloc_security)(struct file *file);
	void (*file_free_security)(struct file *file);
	int (*file_ioctl)(struct file *file, unsigned int cmd,
					  unsigned long arg);
	int (*mmap_addr)(unsigned long addr);
	int (*mmap_file)(struct file *file,
					 unsigned long reqprot, unsigned long prot,
					 unsigned long flags);
	int (*file_mprotect)(struct vm_area_struct *vma,
						 unsigned long reqprot,
						 unsigned long prot);
	int (*file_lock)(struct file *file, unsigned int cmd);
	int (*file_fcntl)(struct file *file, unsigned int cmd,
					  unsigned long arg);
	void (*file_set_fowner)(struct file *file);
	int (*file_send_sigiotask)(struct task_struct *tsk,
							   struct fown_struct *fown, int sig);
	int (*file_receive)(struct file *file);
	int (*file_open)(struct file *file, const struct cred *cred);

	int (*task_create)(unsigned long clone_flags);
	void (*task_free)(struct task_struct *task);
	int (*cred_alloc_blank)(struct cred *cred, gfp_t gfp);
	void (*cred_free)(struct cred *cred);
	int (*cred_prepare)(struct cred *new, const struct cred *old,
						gfp_t gfp);
	void (*cred_transfer)(struct cred *new, const struct cred *old);
	int (*kernel_act_as)(struct cred *new, u32 secid);
	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
	int (*kernel_fw_from_file)(struct file *file, char *buf, size_t size);
	int (*kernel_module_request)(char *kmod_name);
	int (*kernel_module_from_file)(struct file *file);
	int (*task_fix_setuid)(struct cred *new, const struct cred *old,
						   int flags);
	int (*task_setpgid)(struct task_struct *p, pid_t pgid);
	int (*task_getpgid)(struct task_struct *p);
	int (*task_getsid)(struct task_struct *p);
	void (*task_getsecid)(struct task_struct *p, u32 *secid);
	int (*task_setnice)(struct task_struct *p, int nice);
	int (*task_setioprio)(struct task_struct *p, int ioprio);
	int (*task_getioprio)(struct task_struct *p);
	int (*task_setrlimit)(struct task_struct *p, unsigned int resource,
						  struct rlimit *new_rlim);
	int (*task_setscheduler)(struct task_struct *p);
	int (*task_getscheduler)(struct task_struct *p);
	int (*task_movememory)(struct task_struct *p);
	int (*task_kill)(struct task_struct *p,
					 struct siginfo *info, int sig, u32 secid);
	int (*task_wait)(struct task_struct *p);
	int (*task_prctl)(int option, unsigned long arg2,
					  unsigned long arg3, unsigned long arg4,
					  unsigned long arg5);
	void (*task_to_inode)(struct task_struct *p, struct inode *inode);

	int (*ipc_permission)(struct kern_ipc_perm *ipcp, short flag);
	void (*ipc_getsecid)(struct kern_ipc_perm *ipcp, u32 *secid);

	int (*msg_msg_alloc_security)(struct msg_msg *msg);
	void (*msg_msg_free_security)(struct msg_msg *msg);

	int (*msg_queue_alloc_security)(struct msg_queue *msq);
	void (*msg_queue_free_security)(struct msg_queue *msq);
	int (*msg_queue_associate)(struct msg_queue *msq, int msqflg);
	int (*msg_queue_msgctl)(struct msg_queue *msq, int cmd);
	int (*msg_queue_msgsnd)(struct msg_queue *msq,
							struct msg_msg *msg, int msqflg);
	int (*msg_queue_msgrcv)(struct msg_queue *msq,
							struct msg_msg *msg,
							struct task_struct *target,
							long type, int mode);

	int (*shm_alloc_security)(struct shmid_kernel *shp);
	void (*shm_free_security)(struct shmid_kernel *shp);
	int (*shm_associate)(struct shmid_kernel *shp, int shmflg);
	int (*shm_shmctl)(struct shmid_kernel *shp, int cmd);
	int (*shm_shmat)(struct shmid_kernel *shp,
					 char __user *shmaddr, int shmflg);

	int (*sem_alloc_security)(struct sem_array *sma);
	void (*sem_free_security)(struct sem_array *sma);
	int (*sem_associate)(struct sem_array *sma, int semflg);
	int (*sem_semctl)(struct sem_array *sma, int cmd);
	int (*sem_semop)(struct sem_array *sma,
					 struct sembuf *sops, unsigned nsops, int alter);

	int (*netlink_send)(struct sock *sk, struct sk_buff *skb);

	void (*d_instantiate)(struct dentry *dentry, struct inode *inode);

	int (*getprocattr)(struct task_struct *p, char *name, char **value);
	int (*setprocattr)(struct task_struct *p, char *name, void *value, size_t size);
	int (*ismaclabel)(const char *name);
	int (*secid_to_secctx)(u32 secid, char **secdata, u32 *seclen);
	int (*secctx_to_secid)(const char *secdata, u32 seclen, u32 *secid);
	void (*release_secctx)(char *secdata, u32 seclen);

	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);

#ifdef CONFIG_SECURITY_NETWORK
	int (*unix_stream_connect)(struct sock *sock, struct sock *other, struct sock *newsk);
	int (*unix_may_send)(struct socket *sock, struct socket *other);
	... int (*socket_create)(int family, int type, int protocol, int kern);
	int (*socket_post_create)(struct socket *sock, int family,
							  int type, int protocol, int kern);
	int (*socket_bind)(struct socket *sock,
					   struct sockaddr *address, int addrlen);
	int (*socket_connect)(struct socket *sock,
						  struct sockaddr *address, int addrlen);
	int (*socket_listen)(struct socket *sock, int backlog);
	int (*socket_accept)(struct socket *sock, struct socket *newsock);
	int (*socket_sendmsg)(struct socket *sock,
						  struct msghdr *msg, int size);
	int (*socket_recvmsg)(struct socket *sock,
						  struct msghdr *msg, int size, int flags);
	int (*socket_getsockname)(struct socket *sock);
	int (*socket_getpeername)(struct socket *sock);
	int (*socket_getsockopt)(struct socket *sock, int level, int optname);
	int (*socket_setsockopt)(struct socket *sock, int level, int optname);
	int (*socket_shutdown)(struct socket *sock, int how);
	... int (*socket_sock_rcv_skb)(struct sock *sk, struct sk_buff *skb);
	int (*socket_getpeersec_stream)(struct socket *sock, char __user *optval, int __user *optlen, unsigned len);
	int (*socket_getpeersec_dgram)(struct socket *sock, struct sk_buff *skb, u32 *secid);
	int (*sk_alloc_security)(struct sock *sk, int family, gfp_t priority);
	void (*sk_free_security)(struct sock *sk);
	void (*sk_clone_security)(const struct sock *sk, struct sock *newsk);
	void (*sk_getsecid)(struct sock *sk, u32 *secid);
	void (*sock_graft)(struct sock *sk, struct socket *parent);
	int (*inet_conn_request)(struct sock *sk, struct sk_buff *skb,
							 struct request_sock *req);
	void (*inet_csk_clone)(struct sock *newsk, const struct request_sock *req);
	void (*inet_conn_established)(struct sock *sk, struct sk_buff *skb);
	int (*secmark_relabel_packet)(u32 secid);
	void (*secmark_refcount_inc)(void);
	void (*secmark_refcount_dec)(void);
	void (*req_classify_flow)(const struct request_sock *req, struct flowi *fl);
	int (*tun_dev_alloc_security)(void **security);
	void (*tun_dev_free_security)(void *security);
	int (*tun_dev_create)(void);
	int (*tun_dev_attach_queue)(void *security);
	int (*tun_dev_attach)(struct sock *sk, void *security);
	int (*tun_dev_open)(void *security);
	void (*skb_owned_by)(struct sk_buff *skb, struct sock *sk);

#ifdef CONFIG_SECURITY_NETWORK_XFRM
	int (*xfrm_policy_alloc_security)(struct xfrm_sec_ctx **ctxp,
									  struct xfrm_user_sec_ctx *sec_ctx, gfp_t gfp);
	int (*xfrm_policy_clone_security)(struct xfrm_sec_ctx *old_ctx, struct xfrm_sec_ctx **new_ctx);
	void (*xfrm_policy_free_security)(struct xfrm_sec_ctx *ctx);
	int (*xfrm_policy_delete_security)(struct xfrm_sec_ctx *ctx);
	int (*xfrm_state_alloc)(struct xfrm_state *x,
							struct xfrm_user_sec_ctx *sec_ctx);
	int (*xfrm_state_alloc_acquire)(struct xfrm_state *x,
									struct xfrm_sec_ctx *polsec,
									u32 secid);
	void (*xfrm_state_free_security)(struct xfrm_state *x);
	int (*xfrm_state_delete_security)(struct xfrm_state *x);
	int (*xfrm_policy_lookup)(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
	int (*xfrm_state_pol_flow_match)(struct xfrm_state *x,
									 struct xfrm_policy *xp,
									 const struct flowi *fl);
	int (*xfrm_decode_session)(struct sk_buff *skb, u32 *secid, int ckall);
#endif /* CONFIG_SECURITY_NETWORK_XFRM */

	/* key management security hooks */
#ifdef CONFIG_KEYS
	int (*key_alloc)(struct key *key, const struct cred *cred, unsigned long flags);
	void (*key_free)(struct key *key);
	int (*key_permission)(key_ref_t key_ref,
						  const struct cred *cred,
						  unsigned perm);
	int (*key_getsecurity)(struct key *key, char **_buffer);
#endif /* CONFIG_KEYS */

#ifdef CONFIG_AUDIT
	int (*audit_rule_init)(u32 field, u32 op, char *rulestr, void **lsmrule);
	int (*audit_rule_known)(struct audit_krule *krule);
	int (*audit_rule_match)(u32 secid, u32 field, u32 op, void *lsmrule,
							struct audit_context *actx);
	void (*audit_rule_free)(void *lsmrule);
#endif /* CONFIG_AUDIT */
};

int register_kprobe(struct kprobe *kp);

int pre_handler(struct kprobe *p, struct pt_regs *regs);
void post_handler(struct kprobe *p, struct pt_regs *regs,
				  unsigned long flags);
fault_handler()

struct ftrace_hook {
        const char *name;
		// Hook 函数地址
        void *function;
		// 存储被 Hook 函数地址
        void *original;
		// 被 Hook 函数地址
        unsigned long address;
        struct ftrace_ops ops;
};