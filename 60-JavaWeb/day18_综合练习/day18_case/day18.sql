CREATE TABLE `user` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(10) DEFAULT NULL,
    `gender` varchar(2) DEFAULT NULL,
    `age` int(3) DEFAULT NULL,
    `address` varchar(30) DEFAULT NULL,
    `qq` varchar(15) DEFAULT NULL,
    `email` varchar(30) DEFAULT NULL,
    `username` varchar(20) DEFAULT NULL,
    `password` varchar(20) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `user` VALUES (1, 'superbaby', '男', 30, '深圳', '12345', '12345@qq.com', '空不空', 'abcdefg');
INSERT INTO `user` VALUES (2, 'zhangsan', '男', 20, '广州', '654789', '654789@qq.com', '言不言', 'afdfdkfd');
INSERT INTO `user` VALUES (3, 'lily', '女', 18, '中山', '23518', '23518@qq.com', '和不和', 'afda');
