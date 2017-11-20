declare
  v_sql varchar2(200);
  f utl_file.file_type;
begin
  f:= utl_file.fopen('{{ orcl_directory }}', '_unlock_accounts.sql', 'W');
  if '{{ dry_run }}' != 'False' then
    utl_file.put_line(f, '/*');
  end if;
  for rec in (select distinct u.username from {{ upgrade_metatable }} s join dba_users u on u.username = upper(s.schema_name) where u.account_status = 'OPEN' and s.group_name = '{{ group_name }}') loop
    utl_file.put_line(f, 'alter user "'||rec.username||'" account unlock;');
    v_sql:= 'alter user "'||rec.username||'" account lock';
    dbms_output.put_line(v_sql);
    if '{{ dry_run }}' = 'False' then
      execute immediate v_sql;
    end if;
  end loop;
  if '{{ dry_run }}' != 'False' then
    utl_file.put_line(f, '*/');
  end if;
  utl_file.fclose(f);
end;
/
