### mysql8.0以下版本实现从分组数据中选取每组中count_最大的记录
~~~
SELECT b.*, b.count_
FROM (SELECT t.*,
             @row_num := IF(@current = t.字段1, @row_num + 1, 1) AS row_num,
             @current := t.字段1
      FROM (select 字段1, 字段2, count(1) as count_
            from 统计表
            group by 字段1, 字段2
            order by 字段1, count_ desc, 字段2) t,
           (SELECT @row_num := 0, @current := '') AS init) b
where b.row_num = 1
order by b.count_ desc
~~~
