DROP TABLE IF EXISTS `organizations`;
CREATE TABLE IF NOT EXISTS `organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `bank` int(20) NOT NULL DEFAULT 0,
  `premium` int(20) NOT NULL DEFAULT 0,
  `buff` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `organizations` (`id`, `name`, `bank`, `premium`) VALUES
(1, 'Police', 0, 0),
(2, 'Paramedic', 0, 0),
(3, 'BurgerShot', 0, 0),
(4, 'PizzaThis', 0, 0),
(5, 'UwuCoffee', 0, 0),
(6, 'BeanMachine', 0, 0),
(7, 'Ballas', 0, 0),
(8, 'Families', 0, 0),
(9, 'Vagos', 0, 0),
(10, 'Aztecas', 0, 0),
(11, 'Bloods', 0, 0),
(12, 'Triads', 0, 0),
(13, 'Razors', 0, 0),
(14, 'Mechanic', 0, 0);

DROP TABLE IF EXISTS `org_transactions`;
CREATE TABLE IF NOT EXISTS `org_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `Type` varchar(50) NOT NULL,
  `Value` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- groups.lua
-- ["Buff"] = {
--     ["Parent"] = {
--         ["Buff"] = true
--     },
--     ["Hierarchy"] = { "Chefe" },
--     ["Salary"] = { 2250 },
--     ["Service"] = {}
-- },