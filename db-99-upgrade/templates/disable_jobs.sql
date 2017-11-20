declare
  v_sql varchar2(200);
begin
  -- Disable jobs
  for rec in (select * from dba_scheduler_jobs where state != 'DISABLED' and owner in (select distinct schema_name from {{ upgrade_metatable }} where group_name = '{{ group_name }}')) loop
    dbms_output.put_line('DISABLING JOB: '||rec.owner||'.'||rec.job_name);
    if '{{ dry_run }}' = 'False' then
      begin
        dbms_scheduler.disable(rec.owner||'.'||rec.job_name);
      exception
        when others then
          dbms_output.put_line(sqlerrm);
      end;
    end if;
  end loop;
  -- Stop jobs
  for rec in (select * from DBA_SCHEDULER_RUNNING_JOBS where owner in (select distinct schema_name from {{ upgrade_metatable }} where group_name = '{{ group_name }}')) loop
    dbms_output.put_line('STOPPING JOB: '||rec.owner||'.'||rec.job_name);
    if '{{ dry_run }}' = 'False' then
      begin
        dbms_scheduler.stop_job(rec.owner||'.'||rec.job_name);
      exception
        when others then
          dbms_scheduler.stop_job(rec.owner||'.'||rec.job_name, force=>true);
      end;
    end if;
  end loop;
end;
/
