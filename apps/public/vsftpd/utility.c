/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */
/*
 * Part of Very Secure FTPd
 * Licence: GPL v2
 * Author: Chris Evans
 * utility.c
 */

#include "utility.h"
#include "sysutil.h"
#include "str.h"
#include "defs.h"
#include <stdarg.h>	// Jiahao
#include <iconv.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
//#include <bcmnvram.h>
#include "tunables.h"

const char* NLS_NVRAM_U2C="asusnlsu2c";	// Jiahao
const char* NLS_NVRAM_C2U="asusnlsc2u";
static char *xfr_buf=NULL;
//static int xfr_buf_init=0;
char tmp[1024];

#define DIE_DEBUG

void
die(const char* p_text)
{
#ifdef DIE_DEBUG
  bug(p_text);
#endif
  vsf_sysutil_exit(1);
}

void
die2(const char* p_text1, const char* p_text2)
{
  struct mystr die_str = INIT_MYSTR;
  str_alloc_text(&die_str, p_text1);
  str_append_text(&die_str, p_text2);
  die(str_getbuf(&die_str));
}

void
bug(const char* p_text)
{
  /* Rats. Try and write the reason to the network for diagnostics */
  vsf_sysutil_activate_noblock(VSFTP_COMMAND_FD);
  (void) vsf_sysutil_write_loop(VSFTP_COMMAND_FD, "500 OOPS: ", 10);
  (void) vsf_sysutil_write_loop(VSFTP_COMMAND_FD, p_text,
                                vsf_sysutil_strlen(p_text));
  (void) vsf_sysutil_write_loop(VSFTP_COMMAND_FD, "\r\n", 2);
  vsf_sysutil_exit(1);
}

void
vsf_exit(const char* p_text)
{
  (void) vsf_sysutil_write_loop(VSFTP_COMMAND_FD, p_text,
                                vsf_sysutil_strlen(p_text));
  vsf_sysutil_exit(0);
}

char * 
local2remote(const char *buf) 
{
	if (tunable_enable_iconv == 0) return NULL;
	char *in_ptr;
	char *out_ptr;
	size_t inbytesleft, outbytesleft;
	char *p;
	iconv_t ic;

	ic = iconv_open(tunable_remote_charset, tunable_local_charset);
	if (ic == (iconv_t)(-1)) return NULL;
	iconv(ic, NULL, NULL, NULL, NULL);

	inbytesleft = strlen(buf);
	outbytesleft = inbytesleft * 6;
	p = vsf_sysutil_malloc(outbytesleft+1);

	in_ptr = buf;
	out_ptr = p;
	while (inbytesleft) {
		if (iconv(ic, &in_ptr, &inbytesleft, &out_ptr, &outbytesleft) == (size_t)(-1)) {
			iconv_close(ic);
			vsf_sysutil_free(p);
			return NULL;
		}
	}

	*out_ptr = 0;

	iconv_close(ic);
	return p;
/*
	xfr_buf = (char *)malloc(2048);
	memset(tmp, 0, 1024);
	sprintf(tmp, "%s%s_%s", NLS_NVRAM_U2C, tunable_remote_charset, buf);
	if((p = (char *)nvram_xfr(tmp)) != NULL){
		strcpy(xfr_buf, p);
		return xfr_buf;
	}
	else
	{
		free(xfr_buf);
		return NULL;
	}*/
}

char * 
remote2local(const char *buf) 
{
	if (tunable_enable_iconv == 0) return NULL;
	char *in_ptr;
	char *out_ptr;
	size_t inbytesleft, outbytesleft;
	char *p;
	iconv_t ic;

	ic = iconv_open(tunable_local_charset, tunable_remote_charset);
	if (ic == (iconv_t)(-1)) return NULL;
	iconv(ic, NULL, NULL, NULL, NULL);

	inbytesleft = strlen(buf);
	outbytesleft = inbytesleft * 6;
	p = vsf_sysutil_malloc(outbytesleft+1);

	in_ptr = buf;
	out_ptr = p;
	while (inbytesleft) {
		if (iconv(ic, &in_ptr, &inbytesleft, &out_ptr, &outbytesleft) == (size_t)(-1)) {
			iconv_close(ic);
			vsf_sysutil_free(p);
			return NULL;
		}
	}

	*out_ptr = 0;

	iconv_close(ic);
	return p;
/*
	xfr_buf = (char *)malloc(2048);
	memset(tmp, 0, 1024);
	sprintf(tmp, "%s%s_%s", NLS_NVRAM_C2U, tunable_remote_charset, buf);
	if((p = (char *)nvram_xfr(tmp)) != NULL){
		strcpy(xfr_buf, p);
		return xfr_buf;
	}
	else
	{
		free(xfr_buf);
		return NULL;
	}*/
}
