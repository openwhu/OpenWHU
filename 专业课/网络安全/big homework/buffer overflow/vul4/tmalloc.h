 /*
 * Trivial malloc() implementation
 *
 * Inspired by K&R2 malloc() and Doug Lea malloc().
 */

void *tmalloc(unsigned nbytes);
void tfree(void *vp);
void *trealloc(void *vp, unsigned newbytes);
void *tcalloc(unsigned nelem, unsigned elsize);
