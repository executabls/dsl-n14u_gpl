/* Check if file exists
 *
 * Copyright (c) 2008 Claudio Matsuoka <http://helllabs.org/finit/>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <errno.h>
#include <unistd.h>

/**
 * fexist - Check if a file exists in the file system.
 * @file: File to look for, with full path.
 *
 * Returns:
 * %TRUE(1) if the file exists, otherwise %FALSE(0).
 */
int fexist(char *file)
{
	if (!file) {
		errno = EINVAL;
		return 0;	/* Doesn't exist ... */
	}

	if (-1 == access(file, F_OK))
		return 0;

	return 1;
}

#ifdef UNITTEST
#include "lite.h"

int main(void)
{
	int i = 0;
	struct { char *file; int exist; } arr[] = {
		{ "/etc/passwd", 1 },
		{ "/etc/kalle",  0 },
		{ "/sbin/init",  1 },
		{ "/dev/null",   1 },
		{ NULL,  0 },
	};
	FILE *src, *dst;

	for (i = 0; i < NELEMS(arr); i++) {
		if (fexist(arr[i].file) != arr[i].exist)
			err(1, "Failed fexist(%s)", arr[i].file ?: "NULL");
		else
			printf("File %-11s %-14s => OK!\n", arr[i].file ?: "NULL",
			       arr[i].exist ? "does exist" : "does not exist");
	}

	return 0;
}
#endif /* UNITTEST */

/**
 * Local Variables:
 *  compile-command: "make V=1 -f fexist.mk"
 *  version-control: t
 *  indent-tabs-mode: t
 *  c-file-style: "linux"
 * End:
 */
