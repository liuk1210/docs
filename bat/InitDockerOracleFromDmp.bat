@echo off
chcp 65001

:: 即将创建的用户
set "oracle_user=c##user"
set "oracle_password=1"
:: dmp文件放在当前bat文件同级目录下
set "dumpfile=xxx.dmp"
:: set "remap=remap_schema=【导出时的用户名】:%oracle_user% remap_tablespace=【导出时使用的表空间名称】:USERS"
set "remap="

:: 以下代码无需修改，仅修改以上配置即可

:: 创建或覆盖 create_oracle_user.sql 文件，并写入 SQL 命令
(
echo CREATE DIRECTORY dic_expdp AS '/home/oracle/dump';
echo create user %oracle_user% identified by %oracle_password%;
echo GRANT dba TO %oracle_user%;
echo exit;
) > create_oracle_user.sql

:: 输出完成消息
echo create_oracle_user.sql 用户、目录初始化文件已创建

:: 搜索是否存在oracle容器
docker ps | findstr /C:"oracle" >nul 2>&1

if %errorlevel% neq 0 (
    echo oracle容器不存在，即将开始创建并初始化oracle容器...
    docker network create oracle_network
    docker run --network=oracle_network --restart=always -d -p 1521:1521 --name oracle container-registry.oracle.com/database/free
    echo 正在等待oracle数据库启动中，如已确认Oracle容器数据库启动成功则直接按Enter继续...
    timeout /t 30
) else (
    echo 已存在oracle容器，直接初始化数据库
)
call :initDB
del /q create_oracle_user.sql
pause
exit /b 0

:initDB
    docker exec oracle mkdir -p /home/oracle/dump
    docker cp create_oracle_user.sql oracle:/home/oracle/create_oracle_user.sql
    echo 正在初始化oracle目录、用户中...
    docker exec oracle bash -c "sqlplus / as sysdba @/home/oracle/create_oracle_user.sql"
    echo 开始复制dmp文件...
    docker cp %dumpfile% oracle:/home/oracle/dump/import.dmp
    echo 开始执行数据泵导入...
    docker exec oracle bash -c "impdp %oracle_user%/%oracle_password% directory=dic_expdp dumpfile=import.dmp %remap% logfile=import.log"
    echo oracle容器数据库初始化完毕
    goto :eof