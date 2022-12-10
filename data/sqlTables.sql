CREATE TABLE `Games`(
    `winnerName` VARCHAR(255) NOT NULL primary key,
    `winnerLinkId` CHAR(4) NOT NULL primary key,
    `looserName` VARCHAR(255) NOT NULL primary key,
    `looserLinkId` CHAR(4) NOT NULL primary key,
    `tournamentDate` VARCHAR(255) NOT NULL primary key,
    `tournamentName` VARCHAR(255) NOT NULL primary key,
    `round` VARCHAR(255) NOT NULL primary key ,
    `sets` VARCHAR(255) NOT NULL
);
CREATE TABLE `Grounds`(`name` VARCHAR(255) NOT NULL primary key );
CREATE TABLE `Tournaments`(
    `name` VARCHAR(255) NOT NULL primary key ,
    `date` VARCHAR(255) NOT NULL primary key ,
    `countryId` CHAR(2) NOT NULL,
    `ground` VARCHAR(255) NULL,
    `prize` VARCHAR(255) NULL
);
CREATE TABLE `Players`(
    `name` VARCHAR(255) NOT NULL primary key ,
    `linkId` CHAR(4) NOT NULL DEFAULT '0000' primary key ,
    `bornCountryId` CHAR(2) NULL,
    `domHand` VARCHAR(255) NULL,
    `backhand` VARCHAR(255) NULL,
    `height` INT NULL
);
CREATE TABLE `DomHand`(`name` VARCHAR(255) NOT NULL);
ALTER TABLE
    `DomHand` ADD PRIMARY KEY `domhand_name_primary`(`name`);
CREATE TABLE `BackHand`(`name` VARCHAR(255) NOT NULL);
ALTER TABLE
    `BackHand` ADD PRIMARY KEY `backhand_name_primary`(`name`);
CREATE TABLE `Countries`(
    `id` CHAR(2) NOT NULL primary key ,
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Players` ADD CONSTRAINT `players_backhand_foreign` FOREIGN KEY(`backhand`) REFERENCES `BackHand`(`name`);
ALTER TABLE
    `Players` ADD CONSTRAINT `players_domhand_foreign` FOREIGN KEY(`domHand`) REFERENCES `DomHand`(`name`);
ALTER TABLE
    `Tournaments` ADD CONSTRAINT `tournaments_ground_foreign` FOREIGN KEY(`ground`) REFERENCES `Grounds`(`name`);
ALTER TABLE
    `Tournaments` ADD CONSTRAINT `tournaments_countryid_foreign` FOREIGN KEY(`countryId`) REFERENCES `Countries`(`id`);
ALTER TABLE
    `Players` ADD CONSTRAINT `players_borncountryid_foreign` FOREIGN KEY(`bornCountryId`) REFERENCES `Countries`(`id`);