declare
  cnt number;
begin
  select count(*) into cnt from dba_tables where owner='DBAUSER' and table_name='UPGRADE_SERVICE_LIST#TMP';
  if cnt = 0 then
    execute immediate 'create table dbauser.UPGRADE_SERVICE_LIST#TMP (service_name varchar2(50)) ORGANIZATION EXTERNAL ( TYPE ORACLE_LOADER DEFAULT DIRECTORY {{ orcl_directory }} ACCESS PARAMETERS ( RECORDS DELIMITED BY NEWLINE FIELDS TERMINATED BY '','' MISSING FIELD VALUES ARE NULL ( service_name      CHAR(50) )) LOCATION (''_services.lst'')) REJECT LIMIT UNLIMITED';
  end if;
end;
/

declare
  v_cnt number;
begin
  -- Kill post transactional
  for rec in (select * from gv$session where username in (select distinct schema_name from {{ upgrade_metatable }} where group_name = '{{ group_name }}') or service_name in (select service_name from dbauser.UPGRADE_SERVICE_LIST#TMP) order by username, sid) loop
    dbms_output.put_line('KILL PT: '||rec.username||' '||rec.sid||','||rec.serial#||',@'||rec.inst_id||' ['||rec.osuser||'@'||rec.machine||']');
    begin
      if '{{ dry_run }}' = 'False' then
        execute immediate 'alter system disconnect session '''||rec.sid||','||rec.serial#||',@'||rec.inst_id||''' POST_TRANSACTION';
      end if;
    exception
      when others then null;
    end;
  end loop;
  dbms_lock.sleep(5);
  -- Check if there are still some sessions alive
  select count(*) into v_cnt from gv$session where username in (select distinct schema_name from {{ upgrade_metatable }} where group_name = '{{ group_name }}') or service_name in (select service_name from dbauser.UPGRADE_SERVICE_LIST#TMP);
  if v_cnt > 0 then
    for rec in (select * from gv$session where username in (select distinct schema_name from {{ upgrade_metatable }} where group_name = '{{ group_name }}') or service_name in (select service_name from dbauser.UPGRADE_SERVICE_LIST#TMP) order by username, sid) loop
      dbms_output.put_line('KILL IMMEDIATE: '||rec.username||' '||rec.sid||','||rec.serial#||',@'||rec.inst_id||' ['||rec.osuser||'@'||rec.machine||']');
      begin
        if '{{ dry_run }}' = 'False' then
          execute immediate 'alter system disconnect session '''||rec.sid||','||rec.serial#||',@'||rec.inst_id||''' immediate';
        end if;
      exception
        when others then null;
      end;
    end loop;
    dbms_lock.sleep(5);
  end if;
end;
/
