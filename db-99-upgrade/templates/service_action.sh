#!/bin/bash

export ORACLE_HOME=$1
envnum=$3

if [ $envnum -eq 1 ]; then
  db={{ new.dbuniquename }}
else
  db={{ old.dbuniquename }}
fi

exitcode=0

while read p; do
  if [ $envnum -eq 1 ]; then
    servicename="${p}{{ new.appendservice }}"
  else
    servicename="${p}"
  fi
  echo $servicename
  if [[ "{{ dry_run }}" == "False" ]]; then
    ${ORACLE_HOME}/bin/srvctl $2 service -d "${db}" -s "${servicename}"
    if [ $? -ne 0 ]; then
      exitcode=1
    fi
  else
    echo "${ORACLE_HOME}/bin/srvctl $2 service -d ${db} -s ${servicename}"
  fi
done < {{ script_dir }}/_services.lst

exit $exitcode
