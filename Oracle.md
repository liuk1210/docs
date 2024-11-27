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

## Docker Oracle初始化并创建用户
~~~
docker run -d -p 1521:1521 --name oracle23c-ai container-registry.oracle.com/database/free
docker exec -it oracle23c-ai bash
mkdir /home/oracle/dump
sqlplus / as sysdba
CREATE DIRECTORY dic_expdp AS '/home/oracle/dump';
create user c##user identified by 1;
GRANT dba TO c##user;
exit
~~~
## 数据泵导入
将本地文件复制到容器
~~~
docker cp xxx.dmp oracle23c-ai:/home/oracle/dump/import.dmp
~~~
执行`docker exec -it oracle23c-ai bash`进入容器后，执行导入命令
~~~
impdp c##user/1 directory=dic_expdp dumpfile=import.dmp remap_schema=原用户名:c##user remap_tablespace=原表空间名:USERS,原临时表空间名:TEMP logfile=import.log
~~~
## 数据泵导出
~~~
expdp c##user/1 directory=dic_expdp dumpfile=export.dmp schemas=c##user logfile=export.log
~~~
