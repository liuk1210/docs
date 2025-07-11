---

### 🛠 修改安装源
```bash
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum clean all
RUN yum makecache
```

### 🔒 修改密码
```bash
passwd 
```

### 👤 允许root密码登录
1. 修改ssh配置
```bash
vi /etc/ssh/sshd_config
```
```
#允许使用密码登录
PasswordAuthentication yes
#允许root认证登录
PermitRootLogin yes
```
2. 重启sshd
```bash
systemctl restart sshd
```

### 🗜 压缩解压
```bash
#以tar.gz方式打包并gz方式压缩
tar -zcvf xxx.tar.gz  source_file

#解压缩包
tar -zxvf xxx.tar.gz -C path
```

### ↑↓ 文件上传下载
```bash
#文件上传下载
scp /local/file.txt root@ip:/remote/path/

#文件夹上传下载
scp -r /local/file/path/ root@ip:/remote/path/
```

### 📦 rpm包下载
```bash
yumdownloader 包名
yum install --downloadonly --downloaddir=/opt/ 包名
```

### 💻 修改IP地址
1. 打开网卡配置文件
```bash
vi /etc/sysconfig/network-scripts/ifcfg-ens33
```
```
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.0.2
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
DNS1=192.168.0.1
DNS2=8.8.8.8
```
2. 重启服务
```bash
systemctl restart network
```

### 💾 虚拟内存配置
1. 创建 swap 文件
```bash
dd if=/dev/zero of=/root/swapfile bs=1M count=8192
```
2. 构建 swap 格式
```bash
mkswap /root/swapfile
```
3. 激活 swap
```bash
swapon /root/swapfile
```
4. 永久生效（写入 fstab）
```bash
vi /etc/fstab
```
```
#将/swap none swap sw 0 0 这行注释掉，新增一行
/root/swapfile swap swap defaults 0 0
```

### 📂 常用命令
```bash
tree
tree -f > tree.txt
tree -d
# 用于显示 tcp，udp 的端口和进程等相关情况
netstat -tunlp
netstat -tunlp | grep 端口号
# 内存硬盘使用情况
free -h
df -h
# 进程查询
ps -ef | grep java
```

### 🔥 防火墙开放端口

1. 查看防火墙状态
```bash
systemctl status firewalld
```

2. 查看已开放端口
```bash
firewall-cmd --list-all
```

3. 防火墙开放端口

```bash
firewall-cmd --zone=public --add-port=2375/tcp --permanent
firewall-cmd --reload

参数说明：
–zone #作用域
–add-port=80/tcp #添加端口，格式为：端口/通讯协议
–permanent #永久生效，没有此参数重启后失效
```

4. 防火墙关闭端口
```bash
firewall-cmd --permanent --zone=public --remove-port=8080/tcp
firewall-cmd --reload
```

5. firewalld 的基本使用命令
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