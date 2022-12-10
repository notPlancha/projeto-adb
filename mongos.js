db = db.getSiblingDB('attp');

// checkers
// confirm every location has a comma
db.games.find({
  "Location": {
    $not: /.*,*./
  }
}) // confirms that every tournament location has a comma in its name
db.games.distinct("Born", {Born:{$not:/,/}}); // Tem muitos borns sem pais
// also a lot of typos and acronyms in countries


db.games.aggregate([
  {
    $match: {
      Oponent: {$ne: "bye"}
    }
  },
  {
    $set: {
      winner: {$cond: [{$eq: ["$WL", "W"]}, "$PlayerName", "$Oponent"]},
      loser: {$cond: [{$eq: ["$WL", "W"]}, "$Oponent", "$PlayerName"]}
    }
  },
  {
    $group: {
      _id:["$Tournament", "$GameRound", "$Date", "$winner", "$loser", ],
      count: {$sum: 1},
      sets: {$push:"$Score"}
    }
  },
  {
    $match: {
      count: {$gt: 2}
    }
  },
  {
    $project: {
      _id: false,
      tournament: {$arrayElemAt: ["$_id", 0]},
      gameRound: {$arrayElemAt: ["$_id", 1]},
      date: {$arrayElemAt: ["$_id", 2]},
      winner: {$arrayElemAt: ["$_id", 3]},
      loser: {$arrayElemAt: ["$_id", 4]},
      count: true,
      sets: true
    }
  }, {
    $out: "matches"
  }
])

//tables
//tournaments
db.games.aggregate([
  {
    $group: {
      _id: {
        tournament: "$Tournament",
        location: {$split: ["$Location", ", "]},
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
    $out: "tournaments"
  }
])
//players
db.games.aggregate([
  {
    $group: {
      _id:{
        hand: {$split: ["$Hand", ", "]},
        born: {$split: ["$Born", ", "]},
        height: "$Height",
        linkPlayer: "$LinkPlayer",
        playerName: "$PlayerName"
      }
    }
  },{
    $project:{
      playerName: "$_id.playerName",
      country: {$arrayElemAt: ["$_id.born", -1]},
      height: "$_id.height",
      linkPlayer: "$_id.linkPlayer",
      domHand: {$arrayElemAt: ["$_id.hand", 0]},
      backhand: {$arrayElemAt: ["$_id.hand", 1]}
    }
  },{
    $out: "players"
  }
]); //falta os oponent
