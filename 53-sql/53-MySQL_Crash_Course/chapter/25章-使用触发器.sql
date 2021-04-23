-- 第二十五章-使用触发器

-- 创建触发器
-- 创建失败 [Err] 1415 Not allowed to return a result set from a trigger
-- 原因：从MySQL5以后不支持触发器返回结果集
CREATE TRIGGER newproduct AFTER INSERT ON products
FOR EACH ROW SELECT 'Product added';

-- 将结果INTO到变量中去，但不会显示了。
CREATE TRIGGER newproduct AFTER INSERT ON products
FOR EACH ROW SELECT 'Product added' INTO @ee;

-- 删除触发器
DROP TRIGGER newproduct;

-- 使用触发器

-- 创建失败 [Err] 1415 Not allowed to return a result set from a trigger
-- 原因：从MySQL5以后不支持触发器返回结果集
-- INSERT 触发器
CREATE TRIGGER neworder AFTER INSERT ON orders
FOR EACH ROW SELECT NEW.order_num;

INSERT INTO orders(order_date, cust_id)
VALUES(Now(), 10001);

-- DELETE 触发器
CREATE TRIGGER deleteorder BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
	INSERT INTO archive_orders(order_num, order_date, cust_id)
    VALUES(OLD.order_num, OLD.order_date, OLD.cust_id);
END;

-- UPDATE 触发器
-- 测试时需要删除 orders 和 orderitems 表外键
CREATE TRIGGER updatevendor BEFORE UPDATE ON vendors
FOR EACH ROW SET NEW.vend_state = Upper(NEW.vend_state);


-- 创建 befor update 触发器，该触发器在对
-- employees 表中的行记录更改之前被调用：
DELIMITER //
CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    INSERT INTO employees_audit
    SET action = 'update',
        employeeNumber = OLD.employeeNumber,
        lastname = OLD.lastname,
        changedate = NOW(); 
END//
DELIMITER ;

UPDATE employees 
SET lastName = 'Maxsu'
WHERE employeeNumber = 1056;

SELECT * FROM employees_audit;

用到的表
-- 员工表
CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL AUTO_INCREMENT,
  `lastname` varchar(50) DEFAULT NULL,
  `firstName` varchar(50) DEFAULT NULL,
  `extension` varchar(10) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `officeCode` varchar(10) DEFAULT NULL,
  `reportsTo` int(10) DEFAULT NULL,
  `jobTitle` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`employeeNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=1057 DEFAULT CHARSET=utf8;

-- 保存employees表中数据的更改
CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedate DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);
