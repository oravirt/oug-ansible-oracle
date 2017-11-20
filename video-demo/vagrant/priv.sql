--
undef USER
--
set feedback off
set verify off
set lines 2000
set pages 80
col grantee format a40
col "OWNER.OBJECTNAME" format a60
col privilege format a30
col granted_role format a30
col admin_option format a10
col default_role format a10
--
accept USER char prompt 'Enter username/role:'

PROMPT
PROMPT TABLE PRIVILEGES

SELECT owner||'.'||table_name "OWNER.OBJECTNAME", privilege
FROM sys.dba_tab_privs
WHERE grantee = upper('&USER')
ORDER BY 1,2;

PROMPT
PROMPT SYSTEM PRIVILEGES

SELECT grantee, privilege
FROM sys.dba_sys_privs
WHERE grantee = upper('&USER')
ORDER BY 2;

PROMPT
PROMPT ROLE PRIVILEGES

SELECT grantee, granted_role, admin_option,default_role
FROM sys.dba_role_privs
WHERE grantee = upper('&USER')
ORDER BY 2;


PROMPT
PROMPT TABLESPACE QUOTAS
set lines 2000
set numf 999999999999999999999
select tablespace_name, bytes/1024/1024/1024 "CURRENT (GB)", max_bytes/1024/1024/1024 "MAX (GB)", dropped "TS DROPPED?"
from dba_ts_quotas
where username = upper('&USER');

PROMPT
PROMPT MISC
set lines 2000
SELECT to_char(created, 'YYYY-MM-DD HH24:MI:SS') "Created",
profile "Profile",
default_tablespace "Default Tbs",
temporary_tablespace "Temp Tbs"
FROM dba_users
WHERE username = upper('&USER');

set lines 80
set verify on
set feed on
PROMPT
