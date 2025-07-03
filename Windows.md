## 系统驱动文件导出
~~~
dism /online /export-driver /destination:D:\Drivers
~~~
## 命令行安装Win11
### 1.diskpart创建gpt分区
~~~
list disk     #查看硬盘列表
select disk 1 #选中具体硬盘，进行清除分区后转换成gpt分区
clean         #清除分区
convert gpt
create partition efi size=100
format quick fs=fat32 label="SYSTEM"
assign letter="F"
create partition msr size=128
create partition primary
format quick
assign letter="D"
~~~
### 2.dism安装Win11
~~~
dism /apply-image /imagefile:install.wim /index:1 /applydir:d:\
~~~
### 3.bcdboot创建引导并指定存放位置
~~~
bcdboot d:\windows /s f:
~~~
### 4.跳过联网配置
~~~
Shift+F10 打开命令行
输入以下命令：OOBE\BYPASSNRO
~~~
## 系统修复
### Windows系统问题通用修复命令
~~~
DISM.exe /Online /Cleanup-image /CheckHealth
~~~
~~~
DISM.exe /Online /Cleanup-image /Scanhealth
~~~
~~~
DISM.exe /Online /Cleanup-image /Restorehealth
~~~
~~~
sfc /scannow
~~~
## 系统保留存储关闭
- 以管理员身份打开命令提示符（可以在开始菜单搜索“cmd”，然后右击选择“以管理员身份运行”）。
- 输入以下命令并执行：
~~~
DISM /Online /Set-ReservedStorageState /State:Disabled
~~~
## 文件夹备份
~~~
robocopy d:\xxx u:\xxx /MIR
~~~
