CREATE TABLE `items` (
  `orderId` int(10) DEFAULT NULL,
  `quantity` int(10) DEFAULT NULL,
  `sku` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `orders` (
  `orderId` int(10) NOT NULL,
  `custId` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `products` (
  `sku` varchar(30) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;