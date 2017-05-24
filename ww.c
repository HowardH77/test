/**/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include "trace.h"

#define MAX_BUF_LEN 1024

void
ww(FILE *fp, int wrap_col)
{
        char buf[MAX_BUF_LEN];
        int rem = 0, rem2, sl;

        memset(buf, 0, sizeof(buf));
        while (fgets(buf, wrap_col - rem + 1, fp) != 0) {
                sl = strlen(buf);
                TRACE2(sl, "%3d", buf, "%s");
                rem2 = wrap_col - rem;
                if (sl < wrap_col - rem && !isspace(buf[rem2])) {
                        fputs(buf, stdout);
                        rem = 0;
                } else if (isspace(buf[rem2 - 1])) {
                        puts(buf);
                        rem = 0;
                } else {
                        int col, wrap_at = wrap_col;
                        rem2 = rem; rem = 0;
                        while (wrap_at > 1 && !isspace(buf[wrap_at - rem2])) {
                                --wrap_at; ++rem;
                        }
                        --rem;
                        TRACE2(wrap_at - rem, "%d", &buf[wrap_at - rem], "'%s' -- wrapbreak");
                        while (wrap_at > 1 && isspace(buf[wrap_at])) { --wrap_at; }
                        for (col = 0; col <= wrap_at - rem2; ++col) {
                                putchar(buf[col]);
                        }
                        putchar('\n');
                        TRACE2(rem, "%d", &buf[wrap_col - rem2 - rem], "'%s' -- break");
                        for (col = wrap_col - rem2 - rem; col < wrap_col - rem2; ++col) {
                                putchar(buf[col]);
                        }
                }
        }
}


main(int argc, char *argv[])
{
        int opt;
        extern char *optarg;
        extern int optind;
        int indx;
        int wrap_col = 80;
        FILE *fp;

        while ((opt = getopt(argc, argv, "w:")) != -1) {
                switch(opt) {
                case 'w':
                        wrap_col = atoi(optarg);
                        if (wrap_col < 0) { wrap_col = -wrap_col; }
                        break;
                case '?':
                        exit(1);
                }
        }
        if (wrap_col > MAX_BUF_LEN) {
                fprintf(stderr, "%s - Error: wrap_column (%d) is too large (Max-wrap-column=%d).\n",
                        argv[0], wrap_col, MAX_BUF_LEN);
                exit(1);
        }

        if (optind < argc) {
                for (indx = optind; indx < argc; ++indx) {
                        if ((fp = fopen(argv[indx], "r")) != (FILE *)0) {
                                ww(fp, wrap_col);
                                fclose(fp);
                        } else {
                                fprintf(stderr, "%s - Error: cannot open %d\n", argv[0], argv[indx]);
                        }
                }
        } else {
                ww(stdin, wrap_col);
        }
        exit(0);
}
/*
:!cc -g -DDTRACE -I. %
:!( Col 80; a.out tstfile 2>$HOME/.tmp/ww.stderr; ) | vip $HOME/.tmp/ww.stderr
*/
