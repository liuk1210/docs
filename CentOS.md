## CentOS 7修改安装源
~~~
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum clean all
RUN yum makecache
~~~

## 修改密码
~~~
passwd 
~~~

## 允许root密码登录
1. 修改ssh配置
~~~
vi /etc/ssh/sshd_config
~~~

    #允许使用密码登录
    PasswordAuthentication yes
    #允许root认证登录
    PermitRootLogin yes
2、重启sshd   
~~~
systemctl restart sshd
~~~
## 压缩解压
~~~
#以tar.gz方式打包并gz方式压缩
tar -zcvf xxx.tar.gz  source_file (tar -czvf 包名.tar.gz  源文件)        
#解压缩包
tar -zxvf xxx.tar.gz -C path (tar -xzvf xxx.tar.gz -C 目标路径)          
~~~
## 文件上传下载
~~~
#文件上传下载
scp /local/file.txt root@ip:/remote/path/
scp root@ip:/remote/path/file.txt /local/
#文件夹上传下载
scp -r /local/file/path/ root@ip:/remote/path/
scp -r root@ip:/remote/path/ /local/file/path/
~~~
## rpm包下载
~~~
yumdownloader 包名
yum install --downloadonly --downloaddir=/opt/ 包名
~~~
## 修改IP地址
1. 打开网卡配置文件
~~~
vi /etc/sysconfig/network-scripts/ifcfg-ens33
~~~
    #修改相关配置
    BOOTPROTO=static   #dhcp：自动分配ip ，static：静态ip
    ONBOOT=yes #开启启动必须是yes
    IPADDR=192.168.0.2         #ip地址
    NETMASK=255.255.255.0    #掩码
    GATEWAY=192.168.0.1         #网关
    DNS1=192.168.0.1                 #域名服务器1
    DNS2=8.8.8.8                          #域名服务器1
2. 重启服务
~~~
systemctl restart network
~~~
## 虚拟内存配置
1. 在root目录下创建swap文件（每块1M，总共8192块，共计：8192M）
~~~
dd if=/dev/zero of=/root/swapfile bs=1M count=8192
~~~
2. 构建swap格式到swapfile
~~~
mkswap /root/swapfile
~~~
3. 激活swap
~~~
swapon /root/swapfile
~~~
4. 永久生效
~~~
vi /etc/fstab
~~~
    #将 /swap none swap sw 0 0 这行注释掉，新增一行
    /root/swapfile swap swap defaults 0 0
## 常用命令
+ tree
~~~
#查看文档目录结构
tree	
tree -f > tree.txt
tree -d
~~~
+ netstat -tunlp
~~~
netstat -tunlp 用于显示 tcp，udp 的端口和进程等相关情况。
netstat -tunlp | grep 端口号
-t (tcp) 仅显示tcp相关选项
-u (udp)仅显示udp相关选项
-n 拒绝显示别名，能显示数字的全部转化为数字
-l 仅列出在Listen(监听)的服务状态
-p 显示建立相关链接的程序名
~~~
+ free -h
+ df -h
+ ps ef|grep java
## 防火墙开放端口
### 1.查看防火墙状态
~~~
systemctl status firewalld
~~~
### 2.查看已开放端口
~~~
firewall-cmd --list-all
~~~
### 3.防火墙开放端口
~~~
firewall-cmd --zone=public --add-port=2375/tcp --permanent
firewall-cmd --reload
~~~
    参数说明：
    –zone #作用域
    –add-port=80/tcp #添加端口，格式为：端口/通讯协议
    –permanent #永久生效，没有此参数重启后失效
### 4.防火墙关闭端口
~~~
firewall-cmd --permanent --zone=public --remove-port=8080/tcp
firewall-cmd --reload
~~~
### 5.firewalld的基本使用
~~~
启动： systemctl start firewalld
关闭： systemctl stop firewalld
查看状态： systemctl status firewalld
开机禁用 ： systemctl disable firewalld
开机启用 ： systemctl enable firewalld
启动一个服务：systemctl start firewalld.service
关闭一个服务：systemctl stop firewalld.service
重启一个服务：systemctl restart firewalld.service
显示一个服务的状态：systemctl status firewalld.service
在开机时启用一个服务：systemctl enable firewalld.service
在开机时禁用一个服务：systemctl disable firewalld.service
查看服务是否开机启动：systemctl is-enabled firewalld.service
查看已启动的服务列表：systemctl list-unit-files|grep enabled
查看启动失败的服务列表：systemctl --failed
查看版本： firewall-cmd --version
查看帮助： firewall-cmd --help
显示状态： firewall-cmd --state
查看所有打开的端口： firewall-cmd --zone=public --list-ports
更新防火墙规则： firewall-cmd --reload
查看区域信息: firewall-cmd --get-active-zones
查看指定接口所属区域： firewall-cmd --get-zone-of-interface=eth0
拒绝所有包：firewall-cmd --panic-on
取消拒绝状态： firewall-cmd --panic-off
查看是否拒绝： firewall-cmd --query-panic
~~~

