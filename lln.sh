#! /bin/sh
#  Synopsis:    lln filename ...
#  Description: list symlink files

awk -v files="$*" '
     function dirname(fname,   indx) {  # The Unix dirname utility
         for (indx = length(fname); indx > 1; --indx) {
             if (substr(fname, indx, 1) == "/")
                 return substr(fname, 1, indx-1)
         }
         return "."
     }

     function basename(fname,   len, indx) {  # The Unix basename utility
         for (indx = length(fname); indx > 1; --indx) {
             if (substr(fname, indx, 1) == "/")
                 return substr(fname, indx)
         }
         return fname
     }

     function pwd_p(dir,  pwd) {  # The "pwd -P" command
         pwd = "{ cd " dir "; pwd; }"
         pwd | getline
         close(pwd)
         TRACE("pwd_p(" dir  " = " ret_dir)
         return $0
     }

     function resolve_symlink(fname, link) {
         TRACE("resolve_symlink(" fname ", " link ")")
         if (link ~ /^\//) {
             return link
         } else {
             return dirname(fname) "/" link
        }
     }

     function ls_symlink(fname,   ls_file) {
         ls_file = "ls -ld " fname
         ls_file | getline
         print $0
         close(ls_file)
         if ($1 ~/^l/) {
             ls_symlink(resolve_symlink($(NF-2), $(NF)))
             return $(NF)
         }
     }

     function listfile(fname,   ifile, ffile) {  # intermediate, final
         i_link = ls_symlink(fname);
         if ((f_link = pwd_p(dirname(i_link)) basename(i_link)) != i_link)
             system("ls -ld " f_link);
     }

     function TRACE(msg) {
         if (TRACE_ON == 1) { print "TRACE: " msg; }
     }


END  { # TRACE_ON = 1
       nfiles = split(files, filename)
       for (indx = 1; indx <= nfiles; ++indx) {
           print "+ ls " filename[indx]
           listfile(filename[indx])
           if (nfiles > 1) print ""
       }
     }
' /dev/null
exit $?

:!% /usr/bin/java /etc/localtime /usr/bin/aclocal
:!% $HOME/infrastructure/modules/rundeck/env/howard/data.tf
:!cd $HOME/infrastructure/modules/rundeck/env/howard && % data.tf
:!mkdir -p /tmp/d1/d2/d3; ln -s l1 /tmp/d1/d2/d3/l0; ln -s ../l2 /tmp/d1/d2/d3/l1; ln -s ../l3 /tmp/d1/d2/l2; echo l3 > /tmp/d1/l3
:!lln /tmp/d1/d2/d3/l0
:!cd /tmp/d1/d2/d3; lln l0
:!cd /tmp/d1/d2; lln d3/l0
:!cd /tmp/d1; lln d2/d3/l0
:!cd /tmp; lln d1/d2/d3/l0

