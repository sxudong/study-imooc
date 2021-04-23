```sql
########################################

# MySQL Crash Course

# http://www.forta.com/books/0672327120/

# Example table creation scripts

########################################

########################

# Create customers table

########################
CREATE TABLE customers (
  cust_id      int       NOT NULL AUTO_INCREMENT,
  cust_name    char(50)  NOT NULL ,
  cust_address char(50)  NULL ,
  cust_city    char(50)  NULL ,
  cust_state   char(5)   NULL ,
  cust_zip     char(10)  NULL ,
  cust_country char(50)  NULL ,
  cust_contact char(50)  NULL ,
  cust_email   char(255) NULL ,
  PRIMARY KEY (cust_id)
) ENGINE=InnoDB;

#########################

# Create orderitems table

#########################
CREATE TABLE orderitems (
  order_num  int          NOT NULL ,
  order_item int          NOT NULL ,
  prod_id    char(10)     NOT NULL ,
  quantity   int          NOT NULL ,
  item_price decimal(8,2) NOT NULL ,
  PRIMARY KEY (order_num, order_item)
) ENGINE=InnoDB;

#####################

# Create orders table

#####################
CREATE TABLE orders (
  order_num  int      NOT NULL AUTO_INCREMENT,
  order_date datetime NOT NULL ,
  cust_id    int      NOT NULL ,
  PRIMARY KEY (order_num)
) ENGINE=InnoDB COMMENT='订单信息';

#######################

# Create products table

#######################
CREATE TABLE products (
  prod_id    char(10)      NOT NULL,
  vend_id    int           NOT NULL ,
  prod_name  char(255)     NOT NULL ,
  prod_price decimal(8,2)  NOT NULL ,
  prod_desc  text          NULL ,
  PRIMARY KEY(prod_id)
) ENGINE=InnoDB COMMENT='产品信息';

######################

# Create vendors table

######################
CREATE TABLE vendors (
  vend_id      int      NOT NULL AUTO_INCREMENT,
  vend_name    char(50) NOT NULL ,
  vend_address char(50) NULL ,
  vend_city    char(50) NULL ,
  vend_state   char(5)  NULL ,
  vend_zip     char(10) NULL ,
  vend_country char(50) NULL ,
  PRIMARY KEY (vend_id)
) ENGINE=InnoDB COMMENT='供应商信息';

###########################

# Create productnotes table

###########################
CREATE TABLE productnotes (
  note_id    int           NOT NULL AUTO_INCREMENT,
  prod_id    char(10)      NOT NULL,
  note_date datetime       NOT NULL,
  note_text  text          NULL ,
  PRIMARY KEY(note_id),
  FULLTEXT(note_text)
) ENGINE=MyISAM;

# 班级表

DROP TABLE IF EXISTS t_class;
CREATE TABLE t_class(
    class_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID', 
    class_name VARCHAR(10),
    stu_count INT
)
INSERT INTO t_class (class_name,stu_count) VALUES ('1年1班',1);
INSERT INTO t_class (class_name,stu_count) VALUES ('1年2班',1);
INSERT INTO t_class (class_name,stu_count) VALUES ('1年3班',1);

# 学生表

DROP TABLE IF EXISTS t_student;
CREATE TABLE t_student(
    ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID', 
    stu_id VARCHAR(12),
    class_id INT
)
INSERT INTO t_student (stu_id,class_id) VALUES ('2019010101',1);
INSERT INTO t_student (stu_id,class_id) VALUES ('2019010201',2);
INSERT INTO t_student (stu_id,class_id) VALUES ('2019010301',3);

# 员工表

------

-- Table structure for `employees`

------

DROP TABLE IF EXISTS `employees`;
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

------

-- Records of employees

------

INSERT INTO `employees` VALUES ('1056', 'Maxsu', 'bbb', 'ccc', 'ccc', 'ccc', '1000', 'ccc');

# 保存employees表中数据的更改

CREATE TABLE `employees_audit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeNumber` int(11) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `changedat` datetime DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

#####################

# Define foreign keys

#####################
ALTER TABLE orderitems ADD CONSTRAINT fk_orderitems_orders FOREIGN KEY (order_num) REFERENCES orders (order_num);
ALTER TABLE orderitems ADD CONSTRAINT fk_orderitems_products FOREIGN KEY (prod_id) REFERENCES products (prod_id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_customers FOREIGN KEY (cust_id) REFERENCES customers (cust_id);
ALTER TABLE products ADD CONSTRAINT fk_products_vendors FOREIGN KEY (vend_id) REFERENCES vendors (vend_id);


```

