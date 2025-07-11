---
### 🔐 获取当前密码
~~~
config get requirepass
~~~

### ✏️ 设置/修改密码
~~~
config set requirepass 123456
~~~

### 🔄 重置密码
~~~
vi /etc/redis/redis.conf	输入/查找到#requirepass 并设置密码
~~~