CREATE DATABASE IF NOT EXISTS `test_db`;
USE `test_db`;

CREATE TABLE IF NOT EXISTS `test_db` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增索引',
  `update_version` varchar(255) NOT NULL COMMENT '更新数据库版本号，按数字自增规则， 初始为1',
  `update_log` varchar(255) NOT NULL COMMENT '更新日志',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `update_version` (`update_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据库更新记录表，每次更新插入一条记录';

-- 更新日志 --
INSERT INTO `update_version`(`update_version`, `update_log`)
  SELECT '1', 'just test init'
  FROM DUAL
  WHERE NOT EXISTS(
      SELECT `update_version`
      FROM `update_version`
      WHERE `update_version` = '1');