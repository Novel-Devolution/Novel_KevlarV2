INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('kevlar_s', 'Kevlar small', 1, 0, 1);
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('kevlar_m', 'Kevlar medium', 1, 0, 1);
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('kevlar', 'Kevlar', 1, 0, 1);
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('kevlar_police', 'Police Kevlar', 1, 0, 1);

ALTER TABLE `users`
	ADD COLUMN `kevlar` INT NULL DEFAULT '0',
	ADD INDEX `kevlar` (`kevlar`);

