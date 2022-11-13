/*
 Navicat MySQL Data Transfer

 Source Server         : MySQL for localhost
 Source Server Type    : MySQL
 Source Server Version : 50721
 Source Host           : localhost:3306
 Source Schema         : db3

 Target Server Type    : MySQL
 Target Server Version : 50721
 File Encoding         : 65001

 Date: 13/11/2022 15:51:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sales
-- ----------------------------
DROP TABLE IF EXISTS `sales`;
CREATE TABLE `sales`  (
  `id` int(4) NULL DEFAULT NULL,
  `area` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `seller` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sales` int(10) NULL DEFAULT NULL,
  `apple` int(10) NULL DEFAULT NULL,
  `orange` int(10) NULL DEFAULT NULL,
  `milk` int(10) NULL DEFAULT NULL,
  PRIMARY KEY (`seller`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sales
-- ----------------------------
INSERT INTO `sales` VALUES (2, '华北', '和武', 1820, 1000, 800, 20);
INSERT INTO `sales` VALUES (1, '华东', '孙林', 1869, 1000, 800, 69);
INSERT INTO `sales` VALUES (1, '华东', '孙阳', 2122, 2000, 100, 22);

SET FOREIGN_KEY_CHECKS = 1;
