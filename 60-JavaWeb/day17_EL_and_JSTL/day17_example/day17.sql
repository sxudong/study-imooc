CREATE TABLE `user` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `username` varchar(10) DEFAULT NULL,
    `password` varchar(20) DEFAULT NULL,
    `gender` varchar(2) DEFAULT NULL,
    `age` int(3) DEFAULT NULL,
    `address` varchar(30) DEFAULT NULL,
    `qq` varchar(15) DEFAULT NULL,
    `email` varchar(30) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

INSERT INTO `user` VALUES (1, 'superbaby', '男', 30, '深圳', '12345', '12345@qq.com');
INSERT INTO `user` VALUES (2, 'zhangsan', '男', 20, '广州', '654789', '654789@qq.com');
INSERT INTO `user` VALUES (3, 'lily', '女', 18, '中山', '23518', '23518@qq.com');