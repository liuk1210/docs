### 数组转Map
~~~
Map<String,T> map= list.stream().collect(Collectors.toMap(T::getId, Function.identity(), (v1, v2) -> v2));
~~~

### 数组对象转List<String>
~~~
List<String> list= ary.stream().map(a->a.getName()).collect(Collectors.toList());
~~~

### 数组分组转Map
~~~
Map<String,List<T>> map = list.stream().collect(Collectors.groupingBy(T::getId));
~~~