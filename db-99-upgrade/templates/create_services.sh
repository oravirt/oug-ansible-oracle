#!/bin/bash

export ORACLE_HOME={{ new.oraclehome }}
db={{ new.dbuniquename }}

exitcode=0

while read p; do
  servicename="${p}{{ new.appendservice }}"
  echo $servicename
  if [[ "{{ dry_run }}" == "False" ]]; then
    ${ORACLE_HOME}/bin/srvctl add service -database "${db}" -service "${servicename}" -pdb {{ new.pdb }} {{ new.appendaddservice }}
    if [ $? -ne 0 ]; then
      exitcode=1
    fi
  else
    echo "${ORACLE_HOME}/bin/srvctl add service -database "${db}" -service "${servicename}" -pdb {{ new.pdb }} {{ new.appendaddservice }}"
  fi
done < {{ script_dir }}/_services.lst

exit $exitcode
