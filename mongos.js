use atp;
db.games.aggregate([
  {
    $match: {
      Born: {$not:/,/}
    }
  },
  {
    $group:{
      _id:"$Born"
    }
  },{
    $sample:{size:5}
  }
]);
db.games.distinct("Ground");
db.games.distinct("Hand");
db.games.distinct("WL");
db.games.updateMany(
  {Location: {$in: ["TBA", "TBC", "TBD"]}},
  {$set: {Location: null}}
);
db.games.aggregate([
  {
    $group: {
      _id:{
        hand: {$split: ["$Hand", ","]},
        born: {$split: ["$Born", ","]},
        height: "$Height",
        linkPlayer: "$LinkPlayer",
        playerName: "$PlayerName"
      }
    }
  },{
    $project:{
      _id:0,
      playerName: "$_id.playerName",
      country: {$arrayElemAt: ["$_id.born", -1]},
      height: "$_id.height",
      linkPlayer: {$split: ["$_id.linkPlayer", "/"]},
      domHand: {$arrayElemAt: ["$_id.hand", 0]},
      backhand: {$arrayElemAt: ["$_id.hand", 1]}
    }
  },{
    $set: {
      backhand: {$cond: [
        {$eq: ["$backhand", "Unknown Backhand"]},
        null,
        {$trim: {input: "$backhand"}}
      ]},
      domHand: {$cond: [
        {$eq: ["$domHand", "null"]},
        null,
        {$trim: {input: "$domHand"}}
      ]},
      height: {$cond: [{$eq: ["$height", "NA"]}, 0, "$height"]},
      country: {$cond: [{$eq: ["$country", ""]}, null, {$trim: {input: "$country"}}]},
      linkId: {$arrayElemAt: ["$linkPlayer", 6]}
    }
  },{
    $out: "players"
  }
]);
db.players.find({}, {_id:0, linkPlayer: 0}).limit(5);
db.games.aggregate([
  {
    $group: {
      _id: {
        tournament: "$Tournament",
        location: {$split: ["$Location", ", "]},
        date: "$Date", //TODO tratar
        ground: "$Ground"
      },
      prize: { $first: "$Prize" }
    }
  },{
    $project: {
      _id: 0,
      tournament: "$_id.tournament",
      country: {$arrayElemAt: ["$_id.location", -1]},
      date: "$_id.date",
      ground: {$cond: [{$eq: ["$_id.ground", ""]}, null, "$_id.ground"]},
      prize: "$_id.prize"
    }
  },{
    $out: "tournaments"
  }
]);
db.tournaments.find({}, {_id:0}).limit(5);
db.games.aggregate([
  {
    $match: {
      Oponent: {$ne: "bye"}
    }
  },
  {
    $set: {
      winner: {$cond: [{$eq: ["$WL", "W"]}, "$PlayerName", "$Oponent"]},
      loser: {$cond: [{$eq: ["$WL", "W"]}, "$Oponent", "$PlayerName"]},
      winnerLink: {$cond: [
        {$eq: ["$WL", "W"]},
        {$split: ["$LinkPlayer", "/"]},
        null
      ]},
      looserLink: {$cond: [
        {$eq: ["$WL", "W"]},
        null,
        {$split: ["$LinkPlayer", "/"]}
      ]}
    }
  },
  {
    $group: {
      _id:["$Tournament", "$GameRound", "$Date", "$winner", "$loser", {$arrayElemAt: ["$winnerLink", 6]}, {$arrayElemAt: ["$looserLink", 6]}],
      count: {$sum: 1},
      sets: {$push:"$Score"}
    }
  },{
    $project: {
      _id: false,
      tournament: {$arrayElemAt: ["$_id", 0]},
      gameRound: {$arrayElemAt: ["$_id", 1]},
      date: {$arrayElemAt: ["$_id", 2]},
      winner: {$arrayElemAt: ["$_id", 3]},
      loser: {$arrayElemAt: ["$_id", 4]},
      winnerLinkId: {$arrayElemAt: ["$_id", 5]},
      loserLinkId: {$arrayElemAt: ["$_id", 6]},
      count: true,
      sets: true
    }
  }, {
    $out: "matches"
  }
]);
db.matches.find({}, {_id:0}).limit(5);
db.matches.aggregate([
  {
    $match: {
      winnerLinkId: null
    }
  },
  {
    $lookup:{
      from: "players",
      localField: "winner",
      foreignField: "playerName",
      as: "winnerInfo"
    }
  },{
    $set:{
      winnerLinkId: {$arrayElemAt: ["$winnerInfo.linkId", 0]}
    }
  },{
    $project: {
      winnerInfo: false
    }
  },{
    $merge: {
      into: "matches",
      on: "_id",
      whenMatched: "replace",
      whenNotMatched: "fail"
    }
  }
]);
db.matches.aggregate([
  {
    $match: {
      loserLinkId: null
    }
  },
  {
    $lookup:{
      from: "players",
      localField: "loser",
      foreignField: "playerName",
      as: "loserInfo"
    }
  },{
    $set:{
      loserLinkId: {$arrayElemAt: ["$loserInfo.linkId", 0]}
    }
  },{
    $project: {
      loserInfo: false
    }
  },{
    $merge: {
      into: "matches",
      on: "_id",
      whenMatched: "replace",
      whenNotMatched: "fail"
    }
  }
]);
db.countryCodes.aggregate([
  {
    $lookup: {
      from: "countryAliases",
      localField: "Code",
      foreignField: "code",
      as: "aliases"
    }
  },
  {
    $match: {
      aliases: {$size: 0}
    }
  },{
    $project:{
      _id: 0,
      alias: "$Name",
      code: "$Code",
      country: "$Name",
    }
  },{
    $unionWith: {
      coll: "countryAliases",
      pipeline: [
        {
          $project: {
            _id: 0,
          }
        }
      ]
    }
  },
  {
    $out: "countryAliases"
  }
]);
db.players.aggregate([
  {
    $lookup:{
      from: "countryAliases",
      localField: "country",
      foreignField: "alias",
      as: "alias"
    }
   },{
   $set: {
    countryCode: {$arrayElemAt: ["$alias.code", 0]},
    alias: {$arrayElemAt: ["$alias.alias", 0]},
    country: {$arrayElemAt: ["$alias.country", 0]},
   }
  },
  {$out: "players"}
]);
db.players.find({}, {_id:0}).limit(5);
db.tournaments.aggregate([
  {
    $lookup:{
      from: "countryAliases",
      localField: "country",
      foreignField: "alias",
      as: "alias"
    }
   },{
   $set: {
    countryCode: {$arrayElemAt: ["$alias.code", 0]},
    alias: {$arrayElemAt: ["$alias.alias", 0]},
    country: {$arrayElemAt: ["$alias.country", 0]},
   }
  },
  {$out: "tournaments"}
]);
db.tournaments.find({}, {_id:0}).limit(5);

db.countryAliases.aggregate([
  {
    $group:{
      _id: ["$code", "$country"],
      alias: {$push: "$alias"}
    }
    },{
        $project:{
            _id: 0,
            code: {$arrayElemAt: ["$_id", 0]},
            country: {$arrayElemAt: ["$_id", 1]},
            alias: 1
        }
        },{
        $out: "countryCodes"
    }
]);
db.matches.aggregate([
  {
    $lookup:{
      from: "players",
      localField: "winner",
      foreignField: "playerName",
      as: "winnerInfo"
    }
  },{
    $lookup:{
      from: "players",
      localField: "loser",
      foreignField: "playerName",
      as: "loserInfo"
    }
  },{
    $project:{
      _id: 0,
      winner: 1,
      loser: 1,
      countWinner: { $size: "$winnerInfo" },
      countLooser: { $size: "$loserInfo" }
    }
  },{
    $match: {
      $or: [
        {countWinner: 0},
        {countLooser: 0}
      ]
    }
  },{
    $project: {
      player: {$cond: [{$eq: ["$countWinner", 0]}, "$winner", "$loser"]}
    }
  },
  {
    $group: {
      _id: "$player",
      count: {$sum: 1}
    }
  },{
    $out: "missingPlayers"
  }
]);
db.missingPlayers.find().limit(5);
db.missingPlayers.aggregate([
  {
    $project: {
      _id: 0,
      playerName: "$_id",
      linkId: null,
      country: null,
      countryCode: null,
      alias: null
    }
  },
  {
    $unionWith: {
      coll: "players",
      pipeline: [
        {
          $project: {
            _id: 0,
          }
        }
      ]
    },
  },{
    $out: "players"
  }
]);
db.players.aggregate([
  {
    $group: {
      _id: "$domHand"
    }
  },{$match: {_id: {$ne: null}}},{
    $out: "domHands"
  }
]);
db.players.aggregate([
  {
    $group: {
      _id: "$backhand"
    }
  },{$match: {_id: {$ne: null}}},{
    $out: "backhands"
  }
]);
db.tournaments.aggregate([
  {
    $group: {
      _id: "$ground"
    }
  },{$match: {_id: {$ne: null}}},{
    $out: "grounds"
  }
]);