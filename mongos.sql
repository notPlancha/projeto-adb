db = db.getSiblingDB('attp');
db.games.find({}).count()