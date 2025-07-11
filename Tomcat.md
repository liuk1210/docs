---
### 💻 Win11本地Tomcat运行乱码处理
1. 卸载Win11自带的终端应用
2. 修改注册表：
   ```
   在 HKEY_CURRENT_USER → Console 下新增一个 Tomcat 项
   新建 DWORD 值：CodePage，十进制值：65001
   ```

### 🛠️ 使用本地Tomcat作为IDEA开发运行环境
1. `conf\server.xml` 中的 Host 节点下添加 Context：
   ```xml
   <Context docBase="D:\webapp" path="/path"/>
   ```

2. `bin\catalina.bat` 文件头部添加以下内容：
   ```bat
   set JAVA_HOME=D:\Java\jdk1.8.0_202
   set CATALINA_HOME=D:\tomcat
   SET CATALINA_OPTS=-server -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005
   SET JAVA_OPTS=-server -Xms256m -Xmx512m -Dfile.encoding=UTF-8
   ```

3. 在 IDEA 中新建【远程JVM调试】，使用默认配置即可，并且配置执行前【运行外部工具】，添加 Tomcat 的 `startup.bat` 到外部工具

### 🖼️ 图片上传报 `sun.awt.X11GraphicsEnvironment (initialization failure)`
在 Tomcat 中 `bin` 目录下的 `catalina.sh` 中第 265 行修改成以下配置：
```sh
JAVA_OPTS="$JAVA_OPTS $JSSE_OPTS -Djava.awt.headless=true"
```