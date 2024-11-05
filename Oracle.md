## 需要查询_时
~~~
like '/_%' escape '/' 
~~~
## 创建表空间
~~~
create tablespace TBS logging  datafile '/home/oracle/tbs.db' size 50m  autoextend on  next 50m maxsize 20480m  extent management local;
create temporary tablespace TMP tempfile '/home/oracle/tmp.dbf' size 50m  autoextend on  next 50m maxsize 20480m  extent management local;
~~~
## 创建用户
~~~
create user demo identified by demo default tablespace TBS temporary tablespace TMP;
GRANT dba TO demo;
~~~
## Oracle根据某列字段拆分为多行/列转行
~~~
with tt as (
        查询语句
    )
select
      regexp_substr(tt.需要分割的字段, '[^,]+', 1, level) 分割后字段,
      tt.*
from tt
connect by level <= regexp_count(tt.需要分割的字段, '\,') + 1
and tt.需要分割的字段 = prior tt.需要分割的字段
and prior dbms_random.value > 0
~~~
## listagg 长度超过4000解决方案
~~~
XMLAGG(XMLPARSE(CONTENT 列名||'分隔符') ORDER BY 列名).GETCLOBVAL()
~~~
## 查询表结构
~~~
SELECT A.TABLE_NAME, B.COLUMN_NAME, B.DATA_TYPE, A.COMMENTS
FROM ALL_COL_COMMENTS A,
     ALL_TAB_COLUMNS B
WHERE A.OWNER = B.OWNER
  AND A.TABLE_NAME = B.TABLE_NAME
  AND A.COLUMN_NAME = B.COLUMN_NAME
  AND A.OWNER = 'ORACLE用户名'
ORDER BY A.TABLE_NAME
~~~