#! /bin/sh

while getopts pg opt; do
        case $opt in
          p) display=print ;;
          g) display=gv ;;
        esac
done
shift `expr $OPTIND - 1`

tmpfile=${TMPDIR:-/usr/tmp}/kk.$$.ps
trap "rm -f $tmpfile" 0
{ cat .kenken.ps "$@"
  echo quit
} > $tmpfile

case "$display" in
  print) lpr -P YBINDEX $tmpfile ;;
  gv) gs $tmpfile ;;
  *) kghostview $tmpfile ;;
esac
