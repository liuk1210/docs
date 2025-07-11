---
### 🛠 安装
~~~
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# 启动并设置开机启动
sudo systemctl start docker
sudo systemctl enable docker
~~~
### 🖼 常用镜像运行命令
~~~
docker run --name mysql -p 3306:3306 --restart=always -e MYSQL_ROOT_PASSWORD=mysql -d mysql
docker run --name redis -p 6379:6379 -d --restart=always redis --requirepass redis
docker run -d -p 3921:1521 --hostname centos-oracle --name oracle --restart always liuk1210/oracle11g
~~~
### ↔ 镜像导入导出
~~~
sudo docker save -o 文件名.tar 镜像名称:版本号
sudo docker load -i 文件名.tar
~~~
### 📦 容器打包成镜像
~~~
sudo docker commit -a "作者" -m "说明" 容器id 镜像名称:版本号
~~~
### 📋 取最近一段时间的日志
~~~
docker logs --since 60m hrshare >>logs.txt
~~~
### 🔓 开放远程连接
+ 修改docker配置
~~~
vi /lib/systemd/system/docker.service
~~~
找到ExecStart并修改`ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock`
+ 重启docker
~~~
systemctl daemon-reload
service docker restart
curl http://localhost:2375/version
~~~
### 🏃‍♂️ 制作并运行oracle19c
1. 文件下载
+ 下载oracle/docker-images源码  
https://codeload.github.com/oracle/docker-images/zip/refs/heads/main  
下载后的文件：docker-images-main.zip  
+ 下载oracle 19c linux.x64 zip安装包  
https://www.oracle.com/database/technologies/oracle-database-software-downloads.html  
下载后的文件：LINUX.X64_193000_db_home.zip

2. 上传至服务器
通过scp命令或者其他ftp工具上传至centos7服务器/data/目录  
~~~
scp docker-images-main.zip root@ip:/data/  
scp LINUX.X64_193000_db_home.zip root@ip:/data/  
~~~
3. 安装docker，如已安装请忽略此步骤
按照官网指引进行安装  
https://docs.docker.com/engine/install/centos/

4. 解压并移动文件所在位置
~~~
cd /data
#未安装unzip请通过yum -y install unzip命令安装
unzip docker-images-main.zip
mv LINUX.X64_193000_db_home.zip /data/docker-images-main/OracleDatabase/SingleInstance/dockerfiles/19.3.0/
~~~
5. 进入dockerfiles目录制作镜像
~~~
cd /data/docker-images-main/OracleDatabase/SingleInstance/dockerfiles
#查看帮助
./buildContainerImage.sh -h
#制作oracle19.3.0版本的镜像命令
./buildContainerImage.sh -v 19.3.0 -t oracle19c -e
~~~
6. 运行oracle19c镜像
~~~
docker run -d --name oracle19c \
-p 1521:1521 -p 5500:5500 -p 2484:2484 \
-e ORACLE_SID=orcl \
-e ORACLE_PDB=ORCLPDB1 \
-e ORACLE_PWD=ORACLE_password \
-e ORACLE_EDITION=enterprise \
-e ORACLE_CHARACTERSET=AL32UTF8 \
-e ENABLE_ARCHIVELOG=true \
-e ENABLE_TCPS=true \
oracle19c
~~~
~~~
#查看日志
docker logs -f --tail 10000 oracle19c
~~~
7. docker官网镜像地址
https://hub.docker.com/r/liuk1210/oracle19c
