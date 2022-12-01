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
      location: "$_id.location",
      date: "$_id.date",
      ground: "$_id.ground",
      prize: "$_id.prize"
    }
  },{
    $project: {
      _id: 0
    }
  },{
    $out: "tournaments"
  }
])
// dps updatear os location pra 2 campos TODO