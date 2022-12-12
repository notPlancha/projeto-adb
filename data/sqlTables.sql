
CREATE TABLE `Games`(
    `winnerName` VARCHAR(255) NOT NULL,
    `winnerLinkId` CHAR(4) NOT NULL,
    `looserName` VARCHAR(255) NOT NULL,
    `looserLinkId` CHAR(4) NOT NULL,
    `tournamentDate` VARCHAR(255) NOT NULL,
    `tournamentName` VARCHAR(255) NOT NULL,
    `round` VARCHAR(255) NOT NULL,
    `score` VARCHAR(255) NOT NULL,
    primary key (`winnerName`,`winnerLinkId`,`looserName`,`looserLinkId`,`tournamentDate`,`tournamentName`, `round`)
);
CREATE TABLE `Grounds`(`name` VARCHAR(255) NOT NULL primary key );
CREATE TABLE `Tournaments`(
    `name` VARCHAR(255) NOT NULL,
    `date` VARCHAR(255) NOT NULL,
    `countryId` CHAR(2) NOT NULL,
    `ground` VARCHAR(255) NULL,
    `prize` VARCHAR(255) NULL,
    primary key (`name`,`date`)
);
CREATE TABLE `Players`(
    `name` VARCHAR(255) NOT NULL ,
    `linkId` CHAR(4) NOT NULL DEFAULT '0000',
    `bornCountryId` CHAR(2) NULL,
    `domHand` VARCHAR(255) NULL,
    `backhand` VARCHAR(255) NULL,
    `height` INT not null default 0,
    primary key (`name`,`linkId`)
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
alter table `Games` add constraint `games_winnername_winnerlinkid_foreign` foreign key (`winnerName`,`winnerLinkId`) references `Players`(`name`,`linkId`);
alter table `Games` add constraint `games_loosername_looserlinkid_foreign` foreign key (`looserName`,`looserLinkId`) references `Players`(`name`,`linkId`);
alter table `Games` add constraint `games_tournamentdate_tournamentname_foreign` foreign key (`tournamentName`,`tournamentDate`) references `Tournaments`(`name`,`date`);
