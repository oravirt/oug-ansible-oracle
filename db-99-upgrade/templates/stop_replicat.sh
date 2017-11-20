#!/bin/bash

export ORACLE_HOME={{ new.oraclehome }}
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

# Stop replicat
{{ new.replicat.home }}/ggsci<<EOF
stop replicat {{ replicat_name }} !
shell sleep 5
status replicat {{ replicat_name }}
exit
EOF

# Wait for replicat to stop

SUCCESS=1
for i in `seq 1 60`; do
{{ new.replicat.home }}/ggsci << EOF > {{ script_dir }}/_stop_gg.out
status replicat {{ replicat_name }}
exit
EOF
grep -i STOPPED {{ script_dir }}/_stop_gg.out
if [ $? -eq 0 ]; then
  SUCCESS=0
  break
fi
sleep 1
done

if [ $SUCCESS -ne 0 ]; then
  echo "Replicat did not stop in 60s"
  exit 1
fi
