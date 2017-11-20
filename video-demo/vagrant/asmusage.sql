set lines 2000
clear columns
select name,
round(total_mb/1024,2) "Total GB",
round((free_mb/1024),2) "Free GB",
round((USABLE_FILE_MB/1024),2) "Free Usable GB",
round((total_mb-free_mb)/1024,2) "Used GB",
round((((total_mb-free_mb)/total_mb)*100),2)"% Used",
100-(round((((total_mb-free_mb)/total_mb)*100),2))"% Free",
state
,type
from v$asm_diskgroup;
set lines 80
