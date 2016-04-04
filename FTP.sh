#! /bin/sh
#  FTP [-v] [-U user] [-P password] rhost get rfile ... ldir
#  FTP [-v] [-U user] [-P password] rhost put rdir lfile ... rdir

argv0=`basename $0`
while getopts vU:P:p opt; do
        case $opt in
          v) verbose=v ;;
          U) user=$OPTARG ;;
          P) passwd=$OPTARG ;;
          p) { echo -n "password? "; stty -echo; read passwd; stty echo; } >/dev/tty </dev/tty
             ;;
        esac
done
shift `expr $OPTIND - 1`
rhost=$1
getput=$2
shift 2
for arg; do dir=$arg; done
case "$getput" in
  get|mget) chdir="lcd $dir"
            chdir2="cd"
            list_dir="!dir"
            ;;
  put|mput) chdir="cd $dir"
            chdir2="lcd"
            list_dir="dir"
            ;;
  *)  echo "Error: $argv0 - Invalid get|put option '$getput'"
      exit 1
      ;;
esac
arg_indx=0
for arg; do
        (( arg_indx = arg_indx + 1 ))
        if [ $arg_indx -lt $# ]; then
                dir=`dirname $arg`
                basename=`basename $arg`
                getput_files="$getput_files
$chdir2 $dir
$getput $basename"
        fi
done

# cat <<-end_ftp
ftp -ni${verbose} <<-end_ftp
        open $rhost
        user $user $passwd
        $chdir
        $getput_files
        $list_dir
        quit
end_ftp
exit

:!sh % -v -U ftpdata -P tr8nsf3r ybgprod1  get /home/sb/production/pricing/data/dates ~/production/pricing/data 
:!sh % -v -U ftpdata -P tr8nsf3r ybrprod16 put ~/production/pricing/data/dates /usr/tmp
