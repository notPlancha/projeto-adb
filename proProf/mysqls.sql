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

-- 50.67571420 seconds

-- 2 List of top 10 players name with their % of winning games, order by %

select p.name, WG.winCount as WinCount, LG.looseCount as LooseCount, WG.winCount*100/(WG.winCount+ LG.looseCount) as winRate from players p
    left join
        (select p.name, P.linkId, count(*) as winCount from players p right join games g on p.name = g.winnerName and p.linkId = g.winnerLinkId group by p.name, p.linkId) WG on WG.name = p.name and WG.linkId = p.linkId
    left join
        (select p.name, P.linkId, count(*) as looseCount from players p right join games g on p.name = g.looserName and p.linkId = g.looserLinkId group by p.name, p.linkId) LG on LG.name = p.name and LG.linkId = p.linkId
order by WG.winCount*100/(WG.winCount+ LG.looseCount) desc limit 10;

-- 2.44203040 seconds

-- 3 List of top 10 left-handed players name with their % of winning games in Grand Slam games

select p.name, WG.winCount as WinCount, LG.looseCount as LooseCount, WG.winCount*100/(WG.winCount+ LG.looseCount) as winRate from players p
    left join
        (select p.name, P.linkId, count(*) as winCount from players p right join games g on p.name = g.winnerName and p.linkId = g.winnerLinkId where g.tournamentName REGEXP 'us open|australian open|roland garros|wimbledon' and p.domHand = 'Left-Handed' group by p.name, p.linkId) WG on WG.name = p.name and WG.linkId = p.linkId
    left join
        (select p.name, P.linkId, count(*) as looseCount from players p right join games g on p.name = g.looserName and p.linkId = g.looserLinkId where g.tournamentName REGEXP 'us open|australian open|roland garros|wimbledon' and p.domHand = 'Left-Handed' group by p.name, p.linkId) LG on LG.name = p.name and LG.linkId = p.linkId
order by WG.winCount*100/(WG.winCount+ LG.looseCount) desc limit 10;

-- 1.61569590 seconds

-- 4 List of top 5 players name with their winning games in Hard Ground

select g.winnerName, count(*) as wins from games g
    left join players p on g.winnerName = p.name and g.winnerLinkId = p.linkId
    left join tournaments t on g.tournamentName = t.name and g.tournamentDate = t.date
where t.ground = 'Hard'
group by g.winnerName, g.winnerLinkId
order by count(*) desc limit 5;

-- 1.53979950 seconds