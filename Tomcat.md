### win11本地tomcat运行乱码处理
1. 卸载win11自带的终端应用
2. 修改注册表
~~~
    在HKEY_CURRENT_USER → Console下新增一个Tomcat项
    新建DWORD值：CodePage，十进制值：65001
~~~
### 使用本地tomcat作为idea开发运行环境
1. conf\server.xml中的Host节点下添加Context
~~~
    <Context docBase="D:\webapp" path="/path"/>
~~~
2. bin\catalina.bat文件头部添加以下内容
~~~
    set JAVA_HOME=D:\Java\jdk1.8.0_202
    set CATALINA_HOME=D:\tomcat
    SET CATALINA_OPTS=-server -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005
    SET JAVA_OPTS=-server -Xms256m -Xmx512m -Dfile.encoding=UTF-8
~~~
3. 在idea中新建【远程JVM调试】，使用默认配置即可，并且配置执行前【运行外部工具】，添加tomcat的startup.bat到外部工具


### 图片上传报sun.awt.X11GraphicsEnvironment (initialization failure)
~~~
在Tomcat中bin目录下的catalina.sh中第265行修改成以下配置
265行 	JAVA_OPTS="$JAVA_OPTS $JSSE_OPTS -Djava.awt.headless=true"
~~~