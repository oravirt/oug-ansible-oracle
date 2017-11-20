declare
  f utl_file.file_type;
  sn varchar2(4000);
begin
  f:= utl_file.fopen('{{ orcl_directory }}', '_services.lst', 'W');
  SELECT listagg(service_names,',') WITHIN GROUP (ORDER BY service_names) INTO sn FROM (SELECT DISTINCT service_names FROM {{ upgrade_metatable }} WHERE group_name = '{{ group_name }}' AND service_names IS NOT NULL);
  IF trim(sn) IS NOT NULL THEN
    sn:= '"'||replace(sn,',','","')||'"';
    for rec in (SELECT DISTINCT trim(column_value) cv FROM XMLTABLE(sn)) loop
      utl_file.put_line(f, rec.cv);
    end loop;
  END IF;
  utl_file.fclose(f);
end;
/
