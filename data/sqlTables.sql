CREATE TABLE `Games`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `winnerId` INT NOT NULL,
    `looserId` INT NOT NULL,
    `tournamentId` INT NOT NULL,
    `round` VARCHAR(255) NOT NULL,
    `rank` INT NOT NULL,
    `score` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Games` ADD PRIMARY KEY `games_id_primary`(`id`);
CREATE TABLE `Grounds`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Grounds` ADD PRIMARY KEY `grounds_id_primary`(`id`);
CREATE TABLE `Tournaments`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `country` CHAR(2) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `date` VARCHAR(255) NOT NULL,
    `ground` INT NOT NULL
);
ALTER TABLE
    `Tournaments` ADD PRIMARY KEY `tournaments_id_primary`(`id`);
ALTER TABLE
    `Tournaments` ADD UNIQUE `tournaments_name_unique`(`name`);
CREATE TABLE `Countries`(
    `code` CHAR(2) NOT NULL,
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Countries` ADD PRIMARY KEY `countries_code_primary`(`code`);
CREATE TABLE `Cities`(
    `city` VARCHAR(255) NOT NULL,
    `country` CHAR(2) NOT NULL
);
ALTER TABLE
    `Cities` ADD PRIMARY KEY `cities_city_primary`(`city`);
ALTER TABLE
    `Cities` ADD PRIMARY KEY `cities_country_primary`(`country`);
CREATE TABLE `Players`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` INT NOT NULL,
    `bornCountry` CHAR(2) NOT NULL,
    `bornCity` VARCHAR(255) NOT NULL,
    `domHand` TINYINT NOT NULL,
    `backhand` TINYINT NOT NULL,
    `gamesUrl` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Players` ADD PRIMARY KEY `players_id_primary`(`id`);
CREATE TABLE `DomHand`(
    `id` TINYINT UNSIGNED NOT NULL COMMENT '1,2,3',
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `DomHand` ADD PRIMARY KEY `domhand_id_primary`(`id`);
CREATE TABLE `BackHand`(
    `id` TINYINT UNSIGNED NOT NULL COMMENT '0, 1, 2',
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `BackHand` ADD PRIMARY KEY `backhand_id_primary`(`id`);
ALTER TABLE
    `Games` ADD CONSTRAINT `games_tournamentid_foreign` FOREIGN KEY(`tournamentId`) REFERENCES `Tournaments`(`id`);
ALTER TABLE
    `Tournaments` ADD CONSTRAINT `tournaments_ground_foreign` FOREIGN KEY(`ground`) REFERENCES `Grounds`(`id`);
ALTER TABLE
    `Players` ADD CONSTRAINT `players_backhand_foreign` FOREIGN KEY(`backhand`) REFERENCES `BackHand`(`id`);
ALTER TABLE
    `Games` ADD CONSTRAINT `games_looserid_foreign` FOREIGN KEY(`looserId`) REFERENCES `Players`(`id`);
ALTER TABLE
    `Games` ADD CONSTRAINT `games_winnerid_foreign` FOREIGN KEY(`winnerId`) REFERENCES `Players`(`id`);
ALTER TABLE
    `Players` ADD CONSTRAINT `players_domhand_foreign` FOREIGN KEY(`domHand`) REFERENCES `DomHand`(`id`);
ALTER TABLE
    `Tournaments` ADD CONSTRAINT `tournaments_city_foreign` FOREIGN KEY(`city`) REFERENCES `Cities`(`city`);
ALTER TABLE
    `Players` ADD CONSTRAINT `players_borncountry_foreign` FOREIGN KEY(`bornCountry`) REFERENCES `Cities`(`city`);
ALTER TABLE
    `Tournaments` ADD CONSTRAINT `tournaments_country_foreign` FOREIGN KEY(`country`) REFERENCES `Cities`(`country`);
ALTER TABLE
    `Players` ADD CONSTRAINT `players_borncity_foreign` FOREIGN KEY(`bornCity`) REFERENCES `Cities`(`country`);