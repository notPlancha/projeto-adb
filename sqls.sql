use aluno_105289_atpp;
-- countries
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
    `country` INT NOT NULL,
    `date` VARCHAR(255) NOT NULL,
    `ground` INT NOT NULL
);
ALTER TABLE
    `Tournaments` ADD PRIMARY KEY `tournaments_id_primary`(`id`);
ALTER TABLE
    `Tournaments` ADD UNIQUE `tournaments_name_unique`(`name`);
CREATE TABLE `Players`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` INT NOT NULL,
    `bornCountry` CHAR(2) NOT NULL,
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
CREATE TABLE `Countries`(
    `id` INT NOT NULL,
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Countries` ADD PRIMARY KEY `countries_id_primary`(`id`);
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
    `Players` ADD CONSTRAINT `players_borncountry_foreign` FOREIGN KEY(`bornCountry`) REFERENCES `Countries`(`id`);
ALTER TABLE
    `Players` ADD CONSTRAINT `players_domhand_foreign` FOREIGN KEY(`domHand`) REFERENCES `DomHand`(`id`);
ALTER TABLE
    `Tournaments` ADD CONSTRAINT `tournaments_country_foreign` FOREIGN KEY(`country`) REFERENCES `Countries`(`id`);
-- 1
-- select c.name,
--        count(distinct t.id) as Tournaments,
--        count(g.id) as Games,
--        (select count(p.id) as Players from Players p left join Countries c on p.bornCountry = c.id) as Players
-- from games g
--     left join Tournaments t on g.tournamentId = t.id
--     left join Countries c on t.country = c.id
-- group by t.country

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