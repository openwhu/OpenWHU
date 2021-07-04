/*
 * Trivial malloc() implementation
 *
 * Inspired by K&R2 malloc() and Doug Lea malloc().
 */

#include <string.h>

#ifdef NULL /* these days, defined in string.h */
#undef NULL
#endif

#define NULL 0

/*
 * the chunk header
 */
typedef double ALIGN;

typedef union CHUNK_TAG
{
    struct
    {
        union CHUNK_TAG *l; /* leftward chunk */
        union CHUNK_TAG *r; /* rightward chunk + free bit (see below) */
    } s;
    ALIGN x;
} CHUNK;

/*
 * we store the freebit -- 1 if the chunk is free, 0 if it is busy --
 * in the low-order bit of the chunk's r pointer.
 */

/* *& indirection because a cast isn't an lvalue and gcc 4 complains */
//* 末位置 1 表示 free
#define SET_FREEBIT(chunk) (*(unsigned *)&(chunk)->s.r |= 0x1)
//* 末位置 0 表示 busy
#define CLR_FREEBIT(chunk) (*(unsigned *)&(chunk)->s.r &= ~0x1)
#define GET_FREEBIT(chunk) ((unsigned)(chunk)->s.r & 0x1)

/* it's only safe to operate on chunk->s.r if we know freebit
 * is unset; otherwise, we use ... */
//* 右指针不包括末位的 1
#define RIGHT(chunk) ((CHUNK *)(~0x1 & (unsigned)(chunk)->s.r))

/*
 * chunk size is implicit from l-r
 */
//! 右指针 - 当前? 咋算的
#define CHUNKSIZE(chunk) ((unsigned)RIGHT((chunk)) - (unsigned)(chunk))

/*
 * back or forward chunk header
 */
#define TOCHUNK(vp) (-1 + (CHUNK *)(vp))
#define FROMCHUNK(chunk) ((void *)(1 + (chunk)))

/* for demo purposes, a static arena is good enough. */
#define ARENA_CHUNKS (65536 / sizeof(CHUNK))
static CHUNK arena[ARENA_CHUNKS];

static CHUNK *bot = NULL; /* all free space, initially */
static CHUNK *top = NULL; /* delimiter chunk for top of arena */

static void init(void)
{
    bot = &arena[0];
    top = &arena[ARENA_CHUNKS - 1];
    bot->s.l = NULL;
    bot->s.r = top;
    top->s.l = bot;
    top->s.r = NULL;
    SET_FREEBIT(bot);
    CLR_FREEBIT(top);
}

void *tmalloc(unsigned nbytes)
{
    CHUNK *p;
    unsigned size;

    if (bot == NULL)
        init();

    size = sizeof(CHUNK) * ((nbytes + sizeof(CHUNK) - 1) / sizeof(CHUNK) + 1);

    for (p = bot; p != NULL; p = RIGHT(p))
        if (GET_FREEBIT(p) && CHUNKSIZE(p) >= size)
            break;
    if (p == NULL)
        return NULL;

    CLR_FREEBIT(p);
    if (CHUNKSIZE(p) > size) /* create a remainder chunk */
    {
        CHUNK *q, *pr;
        q = (CHUNK *)(size + (char *)p);
        pr = p->s.r;
        q->s.l = p;
        q->s.r = pr;
        p->s.r = q;
        pr->s.l = q;
        SET_FREEBIT(q);
    }
    return FROMCHUNK(p);
}

void tfree(void *vp)
{
    CHUNK *p, *q;

    if (vp == NULL)
        return;

    p = TOCHUNK(vp);
    CLR_FREEBIT(p);
    q = p->s.l;
    if (q != NULL && GET_FREEBIT(q)) /* try to consolidate leftward */
    {
        CLR_FREEBIT(q);
        q->s.r = p->s.r;
        p->s.r->s.l = q;
        SET_FREEBIT(q);
        p = q;
    }
    q = RIGHT(p);
    if (q != NULL && GET_FREEBIT(q)) /* try to consolidate rightward */
    {
        CLR_FREEBIT(q);
        p->s.r = q->s.r;
        q->s.r->s.l = p;
        SET_FREEBIT(q);
    }
    SET_FREEBIT(p);
}

void *trealloc(void *vp, unsigned newbytes)
{
    void *newp = NULL;

    /* behavior on corner cases conforms to SUSv2 */
    if (vp == NULL)
        return tmalloc(newbytes);

    if (newbytes != 0)
    {
        CHUNK *oldchunk;
        unsigned bytes;

        if ((newp = tmalloc(newbytes)) == NULL)
            return NULL;
        oldchunk = TOCHUNK(vp);
        bytes = CHUNKSIZE(oldchunk) - sizeof(CHUNK);
        if (bytes > newbytes)
            bytes = newbytes;
        memcpy(newp, vp, bytes);
    }

    tfree(vp);
    return newp;
}

void *tcalloc(unsigned nelem, unsigned elsize)
{
    void *vp;
    unsigned nbytes;

    nbytes = nelem * elsize;
    if ((vp = tmalloc(nbytes)) == NULL)
        return NULL;
    memset(vp, '\0', nbytes);
    return vp;
}
