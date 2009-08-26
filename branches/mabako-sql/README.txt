DROP TABLE IF EXISTS `items`;
CREATE TABLE  `items` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL,
  `owner` int(10) unsigned NOT NULL,
  `itemID` int(10) NOT NULL,
  `itemValue` text NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `worlditems` DROP COLUMN `itemname`,
 MODIFY COLUMN `x` FLOAT DEFAULT 0,
 MODIFY COLUMN `y` FLOAT DEFAULT 0,
 MODIFY COLUMN `z` FLOAT DEFAULT 0,
 DROP COLUMN `items`,
 DROP COLUMN `itemvalues`;