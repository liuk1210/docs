## 系统驱动文件导出
~~~
dism /online /export-driver /destination:D:\Drivers
~~~
## 物理硬盘-命令行安装Win11
### 1.diskpart创建gpt分区（已分区忽略）
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
## vhdx虚拟硬盘-命令行安装Win11
### 创建vhdx虚拟硬盘
~~~
create vdisk file="V:\vhdx\win11.vhdx" maximum=10240 type=expandable
~~~
### 挂载vhdx文件
~~~
select vdisk file=V:\vhdx\win11.vhdx
attach vdisk
~~~ 
### 查看硬盘列表，选择虚拟硬盘，后续操作和物理硬盘一致
~~~
list disk
~~~
## 普通文件夹备份
~~~
robocopy d:\xxx u:\xxx /MIR
~~~
