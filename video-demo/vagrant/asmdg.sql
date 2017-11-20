set lines 2000
set pages 20
break on dgname
col dgname format a12
col dnamename format a12
col path format a23
col mount_status format a7
col header_status format a12
col mode_status format a7
col state format a8
SELECT substr(g.name,0,12) "DGNAME"
,substr(D.PATH,0,23)"PATH"
--,D.MOUNT_STATUS
,D.HEADER_STATUS
--,D.MODE_STATUS
,D.STATE
,d.total_mb
, round((((d.total_mb-d.free_mb)/d.total_mb)*100),2)"% Used"
,100-(round((((d.total_mb-d.free_mb)/d.total_mb)*100),2))"% Free"
FROM V$ASM_DISK D, V$ASM_DISKGROUP G
where D.GROUP_NUMBER = G.GROUP_NUMBER
order by dgname;
set lines 80
