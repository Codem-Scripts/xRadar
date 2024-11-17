

CREATE TABLE IF NOT EXISTS `codemradar` (
  `citizenname` varchar(50) DEFAULT NULL,
  `officername` varchar(50) DEFAULT NULL,
  `time` varchar(50) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `image` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

