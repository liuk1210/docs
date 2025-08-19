### 🛢️ mysql8.0以下版本实现从分组数据中选取每组中count_最大的记录
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
#### 虚拟列的方式解决存在逻辑删除字段的唯一索引问题
~~~
-- 添加生成列
ALTER TABLE table_name
ADD COLUMN uk_table_name VARCHAR(256)
AS (
    CASE 
        WHEN del_flag_ = 0 
        THEN CONCAT(field_01_, '|', field_02_, '|', field_03_) 
        ELSE NULL 
    END
) STORED;

-- 创建唯一索引
CREATE UNIQUE INDEX uk_table_name 
ON user_info (uk_table_name);
~~~
