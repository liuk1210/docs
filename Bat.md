---
### 📄 文件头UTF8
~~~
@echo off
chcp 65001
~~~
### 💼 使用管理员权限运行
~~~
NET SESSION >nul 2>&1
if errorlevel 1 (
    echo 请使用管理员权限运行本脚本！
    pause
    goto :eof
)
echo 请按enter键开始配置。
pause
~~~
### ➕ 添加Path环境变量
~~~
:addEnvPath
    for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path ^| findstr /i "Path"') do (
        set "currentPath=%%b"
    )
    echo %currentPath% | find /i "%~1" >nul
    if errorlevel 1 (
        setx /M Path "%currentPath%;%~1"
        echo Path环境变量%~1添加成功。
    ) else (
        echo Path环境变量%~1已存在，无需再次添加到环境变量。
    )
    goto :eof
~~~
方法使用demo
~~~
call :addEnvPath D:\Workspaces\Programs\jdk8\bin
~~~
### 🆕 添加环境变量
~~~
:addEnv
    set "varName=%~1"
    set "varValue=%~2"
    reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %varName% >nul 2>&1
    if errorlevel 1 (
        setx /M %varName% "%varValue%"
        echo 环境变量%varName%已成功添加，值为 %varValue%。
    ) else (
        echo 环境变量%varName%已存在，无需再次添加。
    )
    goto :eof
~~~
方法使用demo
~~~
call :addEnv "JAVA_HOME" "D:\Workspaces\Programs\jdk8"
~~~
### 🏷️ 添加host
~~~
set "hostsPath=C:\Windows\System32\drivers\etc\hosts"
:addHosts
    findstr /c:%1 "%hostsPath%" >nul
    if errorlevel 1 (
        echo %~1>> %hostsPath%
        echo 添加%~1到hosts文件成功。
    ) else (
        echo %~1已存在，无需再次添加到hosts文件。
    )
    goto :eof
~~~
方法使用demo
~~~
call :addHosts "127.0.0.1 域名"
~~~