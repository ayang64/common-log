

#ifndef _HAVE_BUF_H
#define _HAVE_BUF_H
#include <stdlib.h>

/* buf.c */
struct buf *buf_new(void);
size_t buf_expand(struct buf *b, size_t extra);
size_t buf_reset(struct buf *b);
void buf_strcat(struct buf *b, const char *data, size_t len);

struct buf {
	char *data;
	size_t nbytes;
};

#endif
