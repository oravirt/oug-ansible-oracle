#!/bin/bash -l

execscript="$1"

if [[ -z "$execscript" ]]; then
  echo "First argument must be script name to execute"
  exit 1
fi

export ORACLE_HOME={{ templ_oracle_home }}
export ORACLE_SID={{ templ_oracle_sid }}

cd "{{ script_dir }}"
logfile="{{ templ_oracle_sid }}_{{ group_name }}_`date +%Y%m%d-%H%M%S`_${execscript}.log"
echo "LOGFILE: ${logfile}"

if [[ -n "{{ temp_oracle_pdb }}" ]]; then
  container="alter session set container={{ temp_oracle_pdb }};"
else
  container=""
fi

$ORACLE_HOME/bin/sqlplus / as sysdba<<EOF
whenever sqlerror exit failure rollback
whenever oserror exit failure rollback

set echo on
set serverout on
set timing on
spool ${logfile}
${container}
@@${execscript}
spool off
exit
EOF

exitcode=$?
echo "EXIT CODE HERE: ${exitcode}"
exit $exitcode
