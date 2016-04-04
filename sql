#! /bin/ksh
#  Synopsis:    sql [-S dbserver] [-U user] [-P passwd] [-D database] \
#                   [-w width] [-s colseparator] [-e] [-b] [-n] [-c] sql_command ...
#               sp_HELP [-S dbserver] [-U user] [-P passwd] [-D database] objname ...
#               sp_help [-S dbserver] [-U user] [-P passwd] [-D database] objname ...
#               sp_helprotect [-S dbserver] [-U user] [-P passwd] [-D database] objname ...
#               showplan [-S dbserver] [-U user] [-P passwd] [-D database] [-n] sql_command ...
#  Description: Execute Sybase SQL statements, sp_help objname
#               Options:  -S Specify Server
#                         -U Specify user
#                         -P Specify passsword
#                         -D Specify database
#                         -s Set the column separator character
#                         -e Include each command issued to isql in the output
#                         -b Suppress table headers
#                         -n Don't execute sql_command
#                         -c set nocount on
#               Note: All scripts are hard-link'ed to sql ($0 is used to set default values)

set_defaults()
{
        local arg0=$1
        case $arg0 in
          sbyb|sbyb2|sbyb4|sbyb5)
                if [ -z "$dbsvr" ]; then dbsvr=PRODUCTION_TEST; fi
                if [ -z "$dbuser" ]; then dbuser=sbid; fi
                if [ -z "$dbpass" ]; then dbpass=`perl -MMIME::Base64 -e 'print decode_base64("eWxkYm9vaw==")'`; fi
                if [ -z "$database" ]; then database="$arg0"; fi
                ;;
          pyrs[12])
                if [ -z "$dbsvr" ]; then dbsvr=ybgdc10:13110; fi
                if [ -z "$dbuser" ]; then dbuser=yb_overnight; fi
                if [ -z "$dbpass" ]; then dbpass=`perl -MMIME::Base64 -e 'print decode_base64("eWxkYm9vaw==")'`; fi
                if [ -z "$database" ]; then database="$arg0"; fi
                ;;
          mktdata)
                if [ -z "$dbsvr" ]; then dbsvr=PRODUCTION_TEST; fi
                if [ -z "$dbuser" ]; then dbuser=yb_datagen_t; fi
                if [ -z "$dbpass" ]; then dbpass=`perl -MMIME::Base64 -e 'print decode_base64("QnVteTIwMTM=")'`; fi
                if [ -z "$database" ]; then database="$arg0"; fi
                ;;
          timeseries)
                if [ -z "$dbsvr" ]; then dbsvr=YBRDC16; fi
                if [ -z "$dbuser" ]; then dbuser=yb_ovncalc_t; fi
                if [ -z "$dbpass" ]; then dbpass=`perl -MMIME::Base64 -e 'print decode_base64("QnVteTIwMTM=")'`; fi
                if [ -z "$database" ]; then database="$arg0"; fi
                ;;
          issuedb)
                if [ -z "$dbsvr" ]; then dbsvr=YBGDIT01; fi  # YBGDI04
                if [ -z "$dbuser" ]; then dbuser=issuedbid; fi
                if [ -z "$dbpass" ]; then dbpass=`perl -MMIME::Base64 -e 'print decode_base64("eWxkYm9vaw==")'`; fi
                ;;
          ybgdc10)
                dbsvr=ybgdc10:13110
                dbuser=hhong_sa
                database=pyrs2
                ;;
          YBRDC16_pyrs)
                dbsvr=YBRDC16
                dbuser=yb_gensvc_t
                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("UmFlZDIwMTM=")'`
                database=pyrs
                ;;
          sql)
                if [ -n "$database" ]; then set_defaults "$database"; fi
                if [ -z "$dbsvr" ]; then dbsvr=PRODUCTION_TEST; fi
                if [ -z "$dbuser" ]; then
                        case $dbsvr in
                          PRODUCTION_TEST|YBRDC16|YBRDC17)
                                dbuser=yb_ovncalc_t;
                                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("QnVteTIwMTM=")'`
                                ;;
                          PRODUCTION|YBGDC04|YBRDC14|YBGDC03|YBRDC13|YBGDC01|YBGDC02|YBRDC11|YBRDC12)
                                dbuser=yb_ovncalc_p;
                                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("eWIwdm5jQGxjMTM=")'`
                                ;;
                        esac
                fi
                ;;
          sp_help|sp_helprotect|sp_HELP)
                sp_help=$arg0
                isql_opts="-e $isql_opts"
                if [ -z "$dbsvr" ]; then dbsvr=PRODUCTION_TEST; fi
                if [ -z "$dbuser" ]; then
                        case $dbsvr in
                          YBGDC06|YBGDC07)
                                dbuser=yb_ovncalc_d;
                                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("RGV2MjAxMw==")'`
                                ;;
                          PRODUCTION_TEST|YBRDC16|YBRDC17)
                                dbuser=yb_ovncalc_t;
                                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("QnVteTIwMTM=")'`
                                ;;
                          PRODUCTION|YBGDC04|YBRDC14|YBGDC03|YBRDC13|YBGDC01|YBGDC02|YBRDC11|YBRDC12)
                                dbuser=yb_ovncalc_p;
                                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("eWIwdm5jQGxjMTM=")'`
                                ;;
                        esac
                fi
                ;;
          showplan)
                set_showplan=1
                ;;
          *) # vendorlvls|pyrs|pspace[0-9]|iboxx*|ra_tsy|ra_swp|lehman|lehman*|var*|tba*
                if [ -z "$dbsvr" ]; then dbsvr=PRODUCTION_TEST; fi
                if [ -z "$dbuser" ]; then
                        case $dbsvr in
                          PRODUCTION_TEST|YBRDC16|YBRDC17)
                                dbuser=yb_ovncalc_t ;;
                          PRODUCTION|\
                          YBGDC03|YBRDC13|YBGDC01|YBGDC02|YBGDC04|\
                          YBGDC05|YBRDC11|YBRDC12|YBRDC14|YBRDC15)
                                dbuser=yb_ovncalc_p ;;
                          YBGDC06|YBGDC07)
                                dbuser=yb_ovncalc_d ;;
                        esac
                fi
                if [ -z "$dbpass" ]; then
                        case "$dbuser" in
                          yb_ovncalc_p)
                                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("eWIwdm5jQGxjMTM=")'` ;;
                          yb_ovncalc_t)
                                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("QnVteTIwMTM=")'` ;;
                          yb_ovncalc_d)
                                dbpass=`perl -MMIME::Base64 -e 'print decode_base64("RGV2MjAxMw==")'` ;;
                        esac
                fi
                if [ -z "$database" ]; then database="$arg0"; fi
                ;;
        esac
}


hide_passwd_prompt()
{
        grep -v -e '^Password: $'
}


# Main
arg0=`basename $0`
for arg in "$@"; do
        case $arg in
          *\ *) argv="${argv:+$argv }'$arg'";;
          *) argv="${argv:+$argv }$arg";;
        esac
done
while getopts vS:U:P:D:w:s:ebnc opt; do
        case $opt in
          v) echo "+ $arg0 $argv" ;;
          S) dbsvr=$OPTARG;;
          U) dbuser=$OPTARG;;
          P) dbpass=$OPTARG;;
          D) database=$OPTARG;;
          X) isql_opts="$isql_opts -X";;
          w) width=$OPTARG;;
          s) delimiter="$OPTARG" ;;
          e) isql_opts="-e $isql_opts";;
          b) isql_opts="-b $isql_opts" ;;
          n) noexec=1;;
          c) nocount="set nocount on
go" ;;
          \?) exit 1 ;;
        esac
done
shift `expr $OPTIND - 1`
set_defaults $arg0

if [ ${set_showplan:-0} -eq 1 ]; then
        show_plan="set showplan on
go"
        if [ ${noexec:-0} -eq 1 ]; then
                show_plan="$show_plan
                        set noexec on
go"
        fi
fi
for arg do
        case "$sp_help" in
          sp_HELP)
                sql_cmds="$sql_cmds
                        if (select type from sysobjects where name like '$arg') = 'U'
                                exec sp_help $arg
                        else
                                exec sp_helptext $arg
go"
                ;;
          *)
                sql_cmds="$sql_cmds
${sp_help:+$sp_help }$arg
go"
                ;;
        esac
done

if [ -z "$dbpass" ]; then
        . ~hhong/.bin/hhlib.sh
        get_password dbpass >/dev/tty </dev/tty
fi

if [ -z "$SYBASE" ]; then
        . $HOME/.bin/sybase.env
        # SYBASE=/home/sb/book/sw/sybase.Linux; export SYBASE
        # alias isql=/home/sb/book/sw/bin.Linux/isql
fi

if [ -z "$sql_cmds" ]; then
        isql ${dbsvr:+-S $dbsvr} ${dbuser:+-U $dbuser} ${dbpass:+-P "$dbpass"} ${database:+-D $database} \
                -w ${width:-4096} $isql_opts ${delimiter:+ -s "$delimiter"} -X
else
        { isql ${dbsvr:+-S $dbsvr} ${dbuser:+-U $dbuser} -w 4096 $isql_opts ${delimiter:+ -s "$delimiter"} -X | hide_passwd_prompt; } <<-end_isql
                ${dbpass}
                ${database:+use $database}
                go
                $show_plan
                $nocount
                $sql_cmds
        end_isql
fi
exit $?

:!sh -x % -S PRODUCTION_TEST -D lehman 'sp_helptext sec_lehman_cmbs_1' 'sp_helptext sec_lehman_cmbs_2'
:!% -S PRODUCTION_TEST -D lehman 'sp_helptext sec_lehman_cmbs_1' 'sp_helptext sec_lehman_cmbs_2'

