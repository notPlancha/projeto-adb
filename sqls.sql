drop database if exists aluno_105289_atpp;
create database aluno_105289_atpp;
use aluno_105289_atpp;
CREATE TABLE `Games`(
    `winnerName` VARCHAR(255) NOT NULL,
    `winnerLinkId` CHAR(4) NOT NULL,
    `looserName` VARCHAR(255) NOT NULL,
    `looserLinkId` CHAR(4) NOT NULL,
    `start_date` date NOT NULL,
    `end_date` date NOT NULL
    `tournamentName` VARCHAR(255) NOT NULL,
    `round` VARCHAR(255) NOT NULL,
    `score` VARCHAR(255) NOT NULL,

    primary key (`winnerName`,`winnerLinkId`,`looserName`,`looserLinkId`,`tournamentDate`,`tournamentName`, `round`)
);
CREATE TABLE `Grounds`(`name` VARCHAR(255) NOT NULL primary key );
CREATE TABLE `Tournaments`(
    `name` VARCHAR(255) NOT NULL,
    `countryId` CHAR(2) NOT NULL,
    `ground` VARCHAR(255) NULL,
    `prize` VARCHAR(255) NULL,
    `start_date` date NOT NULL,
    `end_date` date NOT NULL,
    primary key (`name`,`start_date`,`end_date`)
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

-- 1
select C.name, count(t.id) Tournaments, count(g.id) as Games, count(p.id) as Players from Countries C
    right join Players P on C.id = P.bornCountry
    right join Tournaments T on C.id = T.country
    right join Games G on T.id = G.tournamentId
group by C.id;

-- 2
select P.name, count(GW.id) as wins, count(GW.id)*100/count(*) as winPer from Players P
    right join Games GW on GW.winnerId = P.id
    right join Games GL on GL.looserId = P.id
group by P.id
order by winPer
limit 10;

-- 3
select P.name, count(GW.id) as wins, count(GW.id)*100/count(*) as winPer from Players P
    right join Games GW on GW.winnerId = P.id
    right join Games GL on GL.looserId = P.id
where
    P.domHand = (select dh.id from DomHand dh where lower(dh.name) like '%left%' limit 1)
    and GL.tournamentId in
        (select * from Tournaments T where lower(T.name) REGEXP 'us open|australian open|roland garros|wimbledon')
group by P.id
order by winPer
limit 10;

-- 4
select P.name, count(G.id) as GamesWon from Games G
    left join Players P on G.winnerId = P.id
    left join Tournaments T on G.tournamentId = T.id
where T.ground = (select Gr.id from Grounds Gr where lower(Gr.name) like '%hard%' limit 1)
group by P.id
order by GamesWon
limit 5