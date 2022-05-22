CREATE TABLE `user` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(10) DEFAULT NULL,
    `gender` varchar(2) DEFAULT NULL,
    `age` int(3) DEFAULT NULL,
    `address` varchar(30) DEFAULT NULL,
    `qq` varchar(15) DEFAULT NULL,
    `email` varchar(30) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;