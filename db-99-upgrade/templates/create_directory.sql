declare
  v_sql varchar2(200);
  v_cnt number;
begin
  select count(*) into v_cnt from dba_directories where directory_name = '{{ orcl_directory }}';
  if v_cnt = 0 then
    v_sql:= 'create directory {{ orcl_directory }} as ''{{ script_dir }}''';
    dbms_output.put_line(v_sql);
--    if '{{ dry_run }}' = 'False' then
      execute immediate v_sql;
--    end if;
  end if;
end;
/
