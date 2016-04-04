# Synopsis:     . trace.sh
# Description:  set PS4 prompt to ScriptName:Function:LineNumber

PS4='TRACE[${BASH_SOURCE[0]:-inherited} ${FUNCNAME[0]:-main}:${LINENO}] '
set -o xtrace
