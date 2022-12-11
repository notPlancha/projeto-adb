mongoexport --db=atp --collection=backhand --type=csv --fields=_id --out=.\data\exports\backhand.csv
mongoexport --db=atp --collection=domHand --type=csv --fields=_id --out=.\data\exports\domhand.csv
mongoexport --db=atp --collection=grounds --type=csv --fields=_id --out=.\data\exports\grounds.csv
mongoexport --db=atp --collection=countryCodes --type=csv --fields=code,country --out=.\data\exports\countries.csv
mongoexport --db=atp --collection=matches --type=csv --fields=sets,winner,winnerLinkId,loser,loserLinkId,tournament,date,gameRound --out .\data\exports\games.csv
mongoexport --db=atp --collection=players --type=csv --fields=countryCode, domHand,backhand,height,playerName,linkId --out .\data\exports\players.csv
mongoexport --db=atp --collection=tournaments --type=csv --fields=countryCode,ground,prize,tournament,date --out .\data\exports\tournaments.csv