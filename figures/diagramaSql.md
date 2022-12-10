classDiagram
direction BT
class backhand {
   varchar(255) name
}
class countries {
   varchar(255) name
   char(2) id
}
class domhand {
   varchar(255) name
}
class games {
   varchar(255) sets
   varchar(255) winnerName
   char(4) winnerLinkId
   varchar(255) looserName
   char(4) looserLinkId
   varchar(255) tournamentDate
   varchar(255) tournamentName
   varchar(255) round
}
class grounds {
   varchar(255) name
}
class players {
   char(2) bornCountryId
   varchar(255) domHand
   varchar(255) backhand
   int(11) height
   varchar(255) name
   char(4) linkId
}
class tournaments {
   char(2) countryId
   varchar(255) ground
   varchar(255) prize
   varchar(255) name
   varchar(255) date
}

games  -->  players : winnerName, winnerLinkId:name, linkId
games  -->  players : looserName, looserLinkId:name, linkId
games  -->  tournaments : tournamentName, tournamentDate:name, date
players  -->  backhand : backhand:name
players  -->  countries : bornCountryId:id
players  -->  domhand : domHand:name
tournaments  -->  countries : countryId:id
tournaments  -->  grounds : ground:name
