# SQL语句特性:

```mysql
## SQL语句以 " ; '" 结尾
## 不区分大小写和空格
## 建议关键词全大写方便阅读
```

## 1. 登录相关

```mysql
## 登录MySQL
mysql -u kuang -p (-h hostserver -P 3306)

## 退出
exit;
```

## 2. 使用MySQL相关

```MYSQL
## 显示所有数据库
SHOW DATABASES;

## 选择数据库
USE sql_test;

## 显示某个数据库内的表
SHOW TABLES;

## 显示某个表具体列信息
SHOW COLUMNS FROM customers;
```

## 3. 简单检索数据

```MYSQL
## 从products中检索名为prod_name的列
SELECT prod_name FROM products;

## 检索多个列, 每个列用 ; 隔开
## 检索所有列就用 * 来表示列
SELECT prod_id, prod_name, prod_price FROM products;
SELECT * FROM products;

## 检索返回不同的值, 使用DISTINCE表示该列相同的值只取一次
SELECT DISTINCT vend_id FROM products;

## 检索限制结果: limit s. n; s 表示开始行, n表示最多显示数目
SELECT * FROM products limit 5,5;
## 也可以换一种: limit n offset 3
SELECT * FROM products limit 4 OFFSET 3;
```

## 4. 更多检索操作

```MYSQL
## 使用ORDER BY 排序, 默认升序
SELECT * FROM products ORDER BY vend_id;

## 找出最昂贵的物品, 列出他的记录, 使用DESC表示降序, 将输出限制到1个
SELECT * FROM products ORDER BY prod_price DESC limit 1;

----------------------过 滤 数 据---------------------------------------

## 使用WHERE过滤数据, 找出价格为2.50的记录
SELECT * FROM products WHERE prod_price = 2.50;

## where后可加操作符: > ; < ; != ; BETWEEN(两个值之间), IN(里面写值, 逗号隔开)
SELECT * FROM products WHERE prod_price > 2.50;
SELECT * FROM products WHERE prod_price BETWEEN 2.50 AND 5;

## 找出价格为14.99和8.99的记录
SELECT * FROM products WHERE prod_price IN(14.99, 8.99);

----------------------更 高 级 过 滤------------------------------------

## 使用AND / OR 连接或改变WHERE字句条件, 与和或的关系
## 检索出1022制造的 并且 价格在10以下的记录
SELECT * FROM products WHERE prod_price < 10.00 and vend_id = 1002;

## 检索出1022制造的 或者 价格在10以下的记录
SELECT * FROM products WHERE prod_price <= 10.00 or vend_id = 1002;

## 注意一个计算次序: and和or一起使用的时候记得加括号
## 检索出1002, 1003制造的价格小于等于 10的
SELECT * FROM products WHERE prod_price <= 10.00 and (vend_id = 1002 or vend_id = 1003);

## not: 用来否定后面的关键字, 表示一个非, 常与IN连接
## 检索出非1002, 1003制造的商品记录
SELECT * FROM products WHERE vend_id NOT IN(1002, 1003);

----------------------模 糊 查 询--------------------------------

## 使用LIKE关键字, 字符用单引号括起来, % 表示任意次数的任意字符, _ 表示一次任意字符
## 检索出jet开头的产品
SELECT prod_id, prod_name FROM products WHERE prod_name LIKE 'jet%';

## 不建议过渡使用通配符, 注意通配符的位置
```

## 5. 计算字段, 函数, 分组

```MYSQL
---------------------计算字段-------------------------

## 拼接字段: Concat() + 别名
## Concat可以把多个指定的串拼接成一个较长的串
SELECT Concat( vend_name, '(', vend_country, ')') 
AS vend_title 
FROM vendors 
ORDER BY vend_name;

----------------------处理函数-------------------------

## https://blog.csdn.net/sinat_38899493/article/details/78710482

----------------------汇总数据-------------------------
## 聚集函数: 运行在行组上, 计算和返回单个值的函数
## 1. AVG(): 返回平均值
SELECT AVG(prod_price) AS '平均值' 
FROM products;

## 2. COUNT(): 确定符合条件的行的数目
## 用法1: COUNT(*): 对表中行的数目进行统计, 包含NULL值行
SELECT COUNT(*)  
FROM products; ## 统计表中记录总数
## 用法2: COUNT(column): 对特定表进行统计行数
SELECT COUNT(prod_price)  
FROM products; ## 统计prod_price的记录数 

## 3. MAX(): 求最大值; MIN(): 求最小值; SUM(): 求总和

---------------------分组数据---------------------------

## 使用GROUP BY 和 HAVING进行数据分组
## 1. 根据vend_id分组, 查询出每个制造商的商品数, with rollup表示最后再加个总记录数
SELECT vend_id, COUNT(*) AS num_prod 
FROM products 
GROUP BY vend_id 
WITH ROLLUP;

## 2. 查询出订单数>=2的客户, HAVING过滤条件
SELECT cust_id, COUNT(*) AS orders FROM orders GROUP BY cust_id HAVING COUNT(*)>1;

## 3. 检索出商品数 >= 2, 价格>= 10 De 商品信息, HAVING + WHERE的组合过滤
SELECT vend_id, prod_price, COUNT(*) AS num_prods 
FROM products 
WHERE prod_price>=10 
GROUP BY vend_id 
HAVING COUNT(*) >= 2;
```

## 6. 子查询和联合查询

```MYSQL
------------------------子查询----------------------------------

## 1. 最后一个字句返回产品id = TNT2的订单
##    倒数第二个 返回这两个订单的客户id
##    第一个 返回这个客户id对应的客户信息
SELECT cust_name, cust_contact 
FROM customers 
WHERE cust_id IN
(SELECT cust_id 
FROM orders 
WHERE order_num IN 
(SELECT order_num 
FROM orderitems 
WHERE prod_id = 'TNT2'));

## 2. 计算字段作为子查询
SELECT cust_name, 
cust_state, 
( SELECT COUNT(*) 
FROM orders 
WHERE orders.cust_id = customers.cust_id ) AS orders 
FROM customers
ORDER BY cust_name;

## 3. 使用联结进行查询
## 外键: 是某个表中包含另一个表主键值的一列, 定义了两个表的关系

## 建议使用 INNER JOIN来联结左右两个表, 因为ON确保不会遗忘连接条件 
SELECT vend_name, prod_name, prod_price 
FROM vendors INNER JOIN products
ON vendors.vend_id = products.vend_id;

## 内部联结: INNER JOIN ... ON
## 外部联结: OUTER JOIN ... ON, 外部联结需要 LEFT 或 RIGHT 来制定左联结还是右联结
## LEFT表示选取左边表的所有行, RIGHT表示选取右边表的所有行

## 使用AND联结多个表: 
SELECT cust_name, cust_contact
FROM customers, orders, orderitems
WHERE customers.cust_id = orders.cust_id
AND orderitems.order_num = orders.order_num
AND prod_id = 'TNT2'; 

-----------------------------高级联结----------------------------
## 使用表别名缩短SQL语句
SELECT cust_name, cust_contact
FROM customers AS c, orders AS o, orderitems AS oi
WHERE c.cust_id = o.cust_id
AND oi.order_num = o.order_num
AND prod_id = 'TNT2';

## 不同的连接: 
## COUNT()函数的联结: 检索所有客户以及每个客户的订单数
SELECT c.cust_name, c.cust_id, COUNT(o.order_num) AS num_ord
FROM customers AS c INNER JOIN orders AS o 
ON c.cust_id = o.cust_id
GROUP BY c.cust_id; 
```

## 7. 组合查询

```mysql
## 使用UNION来将多条SELECT组合成一个结果

## 语句1 : 检索出价格小于等于5的记录
SELECT * 
FROM products 
WHERE prod_price <=5;

## 语句2 : 检索出1001和1002生产的商品
SELECT * 
FROM products 
WHERE vend_id IN(1001,1002);

## 使用UNION整合: 
SELECT * 
FROM products 
WHERE prod_price <=5
UNION
SELECT * 
FROM products 
WHERE vend_id IN(1001,1002);

## UNION规则: UNION会自动取消重复记录, 如果需要, 使用UNION ALL来包含所有
```

## 8. 插入删除更改记录

```mysql
 --------------------------数据插入-------------------------

## 1. 不指定列名
INSERT INTO customers 
VALUES (NULL, 'pep', '100qwe', 'ca');

## 2. 指定列名: 
INSERT INTO customers(cust_address, cust_city, cust_state, cust_zip) 
VALUES (NULL, 'pep', '100qwe', 'ca');

--------------------------数据更新----------------------------

UPDATE customers 
SET cust_name = 'the fuds', cust_email = 'email@163.com 
WHERE cust_id = 1005;

--------------------------删除数据------------------------------

## 一定不要忘记WHERE语句!!!, 不然会删除整个表的数据
DELETE FROM customers 
WHERE cust_id = 10006;

## 更新删除的指导原则: 
1. 除非特殊情况, 不然不要使用没有 WHERE 的 UPDATE 和 DELETE
2. 保证每个表都有主键, 方便唯一区分记录
3. UPDATE 和 DELETE 的 WHERE前, 先使用SELECT检验即将操作的记录是正确的
```

## 9. 对于表的操作

```mysql
##  创建表

CREATE TABLE customers
(
列名1    数据类型(长度)    (NOT) NULL    AUTO_INCREMENT , 
列名2    数据类型(长度)    (NOT) NULL    DEFAULT 1 , 
列名3    数据类型(长度)    (NOT) NULL     , 
列名4    数据类型(长度)    (NOT) NULL     , 
.....
PRIMARY KEY (某一列) 
) ENGINE = InnoDB;

## 1. (NOT) NULL: 定义此列是否可以为空
## 2. AUTO_INCREMENT: 定义此列是否自增
## 3. PRIMARY KEY (某一列): 定义主键
## 4. DEFAULT 1: 定义默认值
## 5. ENGINE = InnoDB: 定义引擎类型
    - InnoDB: 可靠地事务处理引擎
    - MEMORY: 功能等同于MyISAM, 但是使用内存存储, 所以速度很快, 适用于临时表
    - MyISAM: 性能极高的引擎, 支持全文本搜索, 不支持事务处理
---------------------------------------------------------------------
## 更新表: 常用于添加外键
ALTER TABLE orderitems 
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_num) REFERENCES orders (order_num)

---------------------------------------------------------------------
## 删除表
DROP TABLE customers2;

## 重命名表
RENAME TABLE customers2 TO customers3;
----------------------------------------------------------------------
```

## 10. 视图和存储过程

```mysql

--------------------------------视图-----------------------------------

## 介绍 : 比如使用SELECT查询出一些数据, 然后为这个查询定义一个别名, 这样就可以用这个别名代指这个查询, 也叫做视图
## 视图算一个虚拟表, 方便进行查询
## 常见应用场景: 
    - 重用SQL语句
    - 简化复杂的SQL操作
    - 使用表的组成部分而非整表
    - 保护数据: 指定特定可访问的数据
    - 更改数据显示格式

## 注意: 视图本质是一个SQL查询, 那么可能会造成性能影响, 应注意使用
    - 视图名唯一, 视图目录没有限制
    - 创建视图需要的权限需要保证
    - 视图中可以有ORDER BY, 但是会被外面的ORDER BY覆盖

## 如何使用视图: 
    - 创建视图 : CREATE VIEW
    - 查看创建视图的语句: SHOW CREATE VIEW viewname; 
    - 删除视图: DROP VIEW viewname;

-------------------------存储过程-------------------------------------
## 介绍: 就是一条或多条SQL语句的集合, 可视为批文件

## 为什么要使用: 简单, 安全, 高性能
    - 简化复杂的操作, 
    - 保证数据完整性, 防止错误
    - 简化对变动的管理
    - 提高性能: 存储过程比单独sql快

## 如何使用: 
## 1. 执行存储过程: 
 CALL productpricing
 (
 @pricelow    #这个是变量名
 @pricehigh
 @priceave
 )

## 2. 创建存储过程
CREATE PROCEDURE 存储名字
(
IN 变量名 变量类型,  # IN表示传入数据
OUT 变量名 变量类型  # OUT表示输出对象
)
BEGIN
    SQL语句
END;
```

## 性能改善出发点:

### Part 1

1. 建议将MySQL运行在自己专用服务器上
2. MySQL的预设值可以调整: 比如内存分配, 缓冲区大小
3. MySQL是一个多线程的DBMS, 经常同时执行多个任务, 可能会被其中一个执行缓慢的任务影响, 使用 SHOW PROCESSLIST 显示活动进程来分析, 使用KILL杀死进程
4. SELECT语句的多种尝试: 联结, 并, 子查询等, 找出最佳方法
5. 使用EXPLAIN让MySQL解释如何执行一个查询
6. 存储过程执行比一条一条的执行个SQL语句快

### Part 2

1. 应该总是使用正确的数据类型
2. 少用SELECT * : 也就是不要检索超出需求的数据
3. 必须索引数据库表以改善数据检索的性能
4. 使用多条SELECT 和连接他们的UNION语句代替OR条件
5. 索引改善检索数据的性能, 但是影响增删改, 如果一个表不经常被检索, 则不要索引他们
6. Like很慢, 最好使用FULLTEXT
7. 数据库是不断变化的, 一组优化良好的表可能一会就面目全非了, 所以理想优化也会改变