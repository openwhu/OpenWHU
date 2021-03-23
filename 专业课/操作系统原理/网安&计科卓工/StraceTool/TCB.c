/* Trace Control Block */
struct tcb {
    int flags;    /* See below for TCB_ values */
    int pid;      /* Process Id of this entry */
    int qual_flg; /* qual_flags[scno] or DEFAULT_QUAL_FLAGS + RAW*/
    int u_error;  /* Error code */
    long scno;    /* System call number */
    long u_arg[MAX_ARGS];    /* System call arguments */
    long u_rval;      /* Return value */
    int curcol;       /* Output column for this process */
    FILE *outf;       /* Output file for this process */
    const char *auxstr;/*Auxiliary info from syscall (see RVAL_STR) */
    const struct_sysent *s_ent;/* sysent[scno] or dummy struct for bad scno */
    struct timeval stime;/*System time usage as of last process wait */
    struct timeval dtime;    /* Delta for system time usage */
    struct timeval etime;    /* Syscall entry time */
              /* Support fortracing forked processes: */
    long inst[2];     /* Saved clone args (badly named) */
};