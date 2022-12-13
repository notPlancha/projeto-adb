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