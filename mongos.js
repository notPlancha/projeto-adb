db = db.getSiblingDB('attp');
//confirm every location has a comma
db.games.find({Location:{$not:/,/}}).count(); //n tem brancos mas tem muitos
db.games.find({Born:{$not:/,/}}).count(); // tem brancos e alguns
// also a lot of typos and acronyms

db.games.aggregate([
  {
    $group: {
      _id: {
        tournament: "$Tournament",
        location: {$split: ["$Location", ", "]}, //alguns n tem virgula e USA tem 3, ver isso dps
        date: "$Date",
        ground: "$Ground",
        prize: "$Prize"
      }
    }
  },{
    $addFields: {
      tournament: "$_id.tournament",
      country: {$arrayElemAt: ["$_id.location", -1]},
      date: "$_id.date",
      ground: "$_id.ground",
      prize: "$_id.prize"
    }
  },{
    $project: {
      _id: 0
    }
  },
  {
    $out: "tournaments"
  }
])
//maybe add a trigger to sql to when insrting tour a country is also added one here creates
//actually why wouldn't we do that instead of this
//create a temp table then when adding this add to the other tables too with triggers
//genius
db.tournaments.find({"country": "USA"})
db.tournaments.find({"country": "U.S.A"})
