
#include <assert.h>
#include <string.h>		/* for strlen() */
#include <strings.h>	/* for strcat() */
#include "buf.h"

struct buf * /* Newly allocated buf structure. */
buf_new(void)
{
	struct buf *rc = malloc(sizeof (*rc));

	assert(rc != NULL);

	rc->data = NULL;
	rc->nbytes = 0;

	return rc;
}

size_t /* Size of the newly allocated buffer. */
buf_expand(struct buf *b, size_t extra)
{
	b->nbytes = 2 * (b->nbytes + extra);
	b->data = realloc(b->data, b->nbytes);

	assert(b->data != NULL);

	return b->nbytes;
}

/*
 Initializes a buffer to an empty state preserving the allocated block.
 */
size_t /* Size of existing buffer. */
buf_reset(struct buf *b)
{
	assert(b != NULL);

	if (b->data != NULL && b->nbytes > 0)
		b->data[0] = '\0';

	return b->nbytes;
}


/*
	If necessary, reallocates and appends a string to a buffer.
 */
void
buf_strcat(struct buf *b, const char *data, size_t len)
{
	assert(b != NULL);

	size_t slen = b->data != NULL ? strlen(data) : 0;

	if ((b->nbytes - slen) < (len + 1)) {
		size_t pbytes = b->nbytes;
		buf_expand(b,len+1);

		if (pbytes == 0)
			buf_reset(b);
	}

	strcat(b->data,data);
}

