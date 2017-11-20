declare
  v_found boolean:= false;
  v_ds number(1);
begin
  for i in 1..60 loop
    select do_switchover into v_ds from tmpggping.ggping_{{ group_name }};
    if v_ds = 1 then
      v_found:= true;
      exit;
    end if;
    dbms_lock.sleep(1);
  end loop;
  if not v_found then
    raise_application_error(-20000, 'Timeout occured.');
  end if;
end;
/
