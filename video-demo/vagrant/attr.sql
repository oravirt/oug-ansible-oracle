break on DGNAME
col dgname format a20
col name format a20
col value format a20
select dg.name DGNAME,a.name,a.value from
v$asm_diskgroup dg, v$asm_attribute a
where a.group_number = dg.group_number
and a.name in ('compatible.asm','compatible.rdbms')
/
