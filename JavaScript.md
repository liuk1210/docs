---
### 🔄 数组获取元素'id_1','id_2'拼接字符串
~~~
list.map(item => `'${String(item.id_).replace(/'/g, "''")}'`).join(',');
~~~
