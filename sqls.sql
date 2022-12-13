drop database if exists aluno_105289_atp;
create database aluno_105289_atp;
use aluno_105289_atp;
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
    `countryId` CHAR(2) NULL,
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
-- 1 For each country (only one select): a) Number of players; b) Number of tournaments; c) Number of rounds
select
    c.name as country,
    count(distinct t.name) as tournaments,
    count(distinct g.winnerName, g.winnerLinkId, g.looserName, g.looserLinkId) as games,
    count(distinct p.name, p.linkId) as players
from Countries c
    left join Tournaments t on c.id = t.countryId
    left join Games g on t.name = g.tournamentName and t.date = g.tournamentDate
    left join Players P on P.bornCountryId = c.id
group by
    c.name
order by c.name;

-- 2 List of top 10 players name with their % of winning games, order by %
select p.name, WG.winCount as WinCount, LG.looseCount as LooseCount, WG.winCount*100/(WG.winCount+ LG.looseCount) as winRate from players p
    left join
        (select p.name, P.linkId, count(*) as winCount from players p right join games g on p.name = g.winnerName and p.linkId = g.winnerLinkId group by p.name, p.linkId) WG on WG.name = p.name and WG.linkId = p.linkId
    left join
        (select p.name, P.linkId, count(*) as looseCount from players p right join games g on p.name = g.looserName and p.linkId = g.looserLinkId group by p.name, p.linkId) LG on LG.name = p.name and LG.linkId = p.linkId
order by WG.winCount*100/(WG.winCount+ LG.looseCount) desc limit 10;

-- 3
select p.name, WG.winCount as WinCount, LG.looseCount as LooseCount, WG.winCount*100/(WG.winCount+ LG.looseCount) as winRate from players p
    left join
        (select p.name, P.linkId, count(*) as winCount from players p right join games g on p.name = g.winnerName and p.linkId = g.winnerLinkId where g.tournamentName REGEXP 'us open|australian open|roland garros|wimbledon' and p.domHand = 'Left-Handed' group by p.name, p.linkId) WG on WG.name = p.name and WG.linkId = p.linkId
    left join
        (select p.name, P.linkId, count(*) as looseCount from players p right join games g on p.name = g.looserName and p.linkId = g.looserLinkId where g.tournamentName REGEXP 'us open|australian open|roland garros|wimbledon' and p.domHand = 'Left-Handed' group by p.name, p.linkId) LG on LG.name = p.name and LG.linkId = p.linkId
order by WG.winCount*100/(WG.winCount+ LG.looseCount) desc limit 10;

-- 4 List of top 5 players name with their winning games in Hard Ground
select g.winnerName, count(*) as wins from games g
    left join players p on g.winnerName = p.name and g.winnerLinkId = p.linkId
    left join tournaments t on g.tournamentName = t.name and g.tournamentDate = t.date
where t.ground = 'Hard'
group by g.winnerName, g.winnerLinkId
order by count(*) desc limit 5;
