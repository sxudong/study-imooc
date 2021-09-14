CREATE TABLE `user` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `username` varchar(32) DEFAULT NULL,
    `password` varchar(32) DEFAULT NULL,
    `gender` varchar(2) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

INSERT INTO `user` VALUES (1, 'superbaby', '12345', '男');
INSERT INTO `user` VALUES (2, 'zhangsan', '654789', '男');
INSERT INTO `user` VALUES (3, 'lily', '23518', '女');