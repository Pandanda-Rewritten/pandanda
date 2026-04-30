var dbase, zone, _sfs;

eval(_server.readFile("utils/json.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/eventListener.js"));

function init() {
  dbase = _server.getDatabaseManager();
  zone = _server.getCurrentZone();
  _sfs = Packages.it.gotoandplay.smartfoxserver.SmartFoxServer;
}

function destroy() {}

// ---------------------------------------------------------------------------
// Helpers (room vars + broadcasting)
// ---------------------------------------------------------------------------

function getRoomVar(room, name, fallback) {
  try {
    var v = room.getVariable(name);
    if (v == null) return fallback;
    var val = v.getValue();
    return typeof val === "undefined" || val === null ? fallback : String(val);
  } catch (e) {
    return fallback;
  }
}

function setRoomVars(room, vars) {
  var rVars = [];
  for (var k in vars) {
    rVars.push({ name: k, val: String(vars[k]), priv: false });
  }
  _server.setRoomVariables(room, null, rVars);
}

function broadcastJSON(room, packet, exceptUser) {
  var us = room.getAllUsers();
  for (var i in us) {
    try {
      if (exceptUser && us[i].getUserId && exceptUser.getUserId && us[i].getUserId() == exceptUser.getUserId()) continue;
      Users.SendJSON(us[i], packet);
    } catch (e) {}
  }
}

function getPlayersBySeat(room) {
  var p1 = null,
    p2 = null;
  var us = room.getAllUsers();
  for (var i in us) {
    try {
      var u = us[i];
      var idx = u.getPlayerIndex(room);
      if (idx == 1) p1 = u;
      else if (idx == 2) p2 = u;
    } catch (e) {}
  }
  return { p1: p1, p2: p2 };
}

function parseNowTurn(room) {
  var now = getRoomVar(room, "nowTurn", "1;false");
  return now.indexOf("2") === 0 ? 2 : 1;
}

function formatNowTurn(turn, flying) {
  return String(turn) + ";" + (flying ? "true" : "false");
}

function ensurePTPState(room) {
  if (room.getVariable("ptp_board_fences") == null || room.getVariable("ptp_board_pigs") == null) {
    var max = 5;
    var fences = [];
    var pigs = [];
    var owners = [];
    for (var c = 0; c < max; c++) {
      var fCol = [];
      var pCol = [];
      var oCol = [];
      for (var r = 0; r < max; r++) {
        fCol.push(0);
        pCol.push(".");
        oCol.push(0);
      }
      fences.push(fCol);
      pigs.push(pCol);
      owners.push(oCol);
    }
    setRoomVars(room, {
      ptp_board_fences: JSON.stringify(fences),
      ptp_board_pigs: JSON.stringify(pigs),
      ptp_fence_owners: JSON.stringify(owners),
      user1points: getRoomVar(room, "user1points", "0"),
      user2points: getRoomVar(room, "user2points", "0"),
      nowTurn: getRoomVar(room, "nowTurn", "1;false"),
      spectators: getRoomVar(room, "spectators", ""),
    });
  }
}

function computeSpectatorNames(room) {
  var names = [];
  var us = room.getAllUsers();
  for (var i in us) {
    try {
      var u = us[i];
      if (u.getPlayerIndex(room) == -1) names.push(String(u.getName()));
    } catch (e) {}
  }
  return names.join(",");
}

function addCoins(user, amount) {
  var cur = Number(user.properties.get("coins")) || 0;
  var next = cur + Number(amount);
  user.properties.put("coins", next);
  try {
    Users.UpdateCrumb(user.properties.get("id"), "coins", next);
  } catch (e) {}
  Users.SendJSON(user, { _cmd: "coinUpdate", coins: next, coinsEarned: Number(amount), success: true });
  return next;
}

// ---------------------------------------------------------------------------
// Spectator snapshot
// ---------------------------------------------------------------------------

function handleAskPTPSpec(user, room) {
  ensurePTPState(room);
  var players = getPlayersBySeat(room);
  if (!players.p1 || !players.p2) return;

  var t = parseNowTurn(room);
  var p1Points = Number(getRoomVar(room, "user1points", "0")) || 0;
  var p2Points = Number(getRoomVar(room, "user2points", "0")) || 0;

  var fences = JSON.parse(getRoomVar(room, "ptp_board_fences", "[]") || "[]");
  var pigs = JSON.parse(getRoomVar(room, "ptp_board_pigs", "[]") || "[]");
  var owners = JSON.parse(getRoomVar(room, "ptp_fence_owners", "[]") || "[]");

  Users.SendJSON(user, {
    _cmd: "mg##specStatus",
    t: t,
    p1i: 1,
    p2i: 2,
    p1n: String(players.p1.getName()),
    p2n: String(players.p2.getName()),
    boardFences: fences,
    boardPigs: pigs,
    fenceOwners: owners,
    penPigs1: p1Points,
    penPigs2: p2Points,
  });
}

// ---------------------------------------------------------------------------
// Gameplay commands
// ---------------------------------------------------------------------------

function handleMove(user, room, params) {
  ensurePTPState(room);

  // Spectator guard
  var seat = user.getPlayerIndex(room);
  if (seat == -1) return;

  var colRaw = params && typeof params.c !== "undefined" ? params.c : null;
  var rowRaw = params && typeof params.r !== "undefined" ? params.r : null;
  var isHorizontal = Boolean(params && params.h);
  if (colRaw === null || rowRaw === null) return;

  var col = Number(colRaw);
  var row = Number(rowRaw);
  if (isNaN(col) || isNaN(row)) return;
  if (col < 0 || col > 5 || row < 0 || row > 5) return;

  var actorTurn = seat == 1 ? 1 : 2;
  var currentTurn = parseNowTurn(room);
  if (actorTurn !== currentTurn) {
    // Re-affirm nowTurn
    setRoomVars(room, { nowTurn: formatNowTurn(currentTurn, false) });
    return;
  }

  var MAX = 5; // squares grid

  // Fence bits (TS parity)
  var FENCE_N = 1;
  var FENCE_E = 2;
  var FENCE_S = 4;
  var FENCE_W = 8;
  var FENCE_COMPLETE = 15;

  var fences = JSON.parse(getRoomVar(room, "ptp_board_fences", "[]") || "[]");
  var pigs = JSON.parse(getRoomVar(room, "ptp_board_pigs", "[]") || "[]");
  var owners = JSON.parse(getRoomVar(room, "ptp_fence_owners", "[]") || "[]");

  if (!fences || fences.length !== MAX) {
    fences = [];
    pigs = [];
    owners = [];
    for (var c = 0; c < MAX; c++) {
      var fCol = [];
      var pCol = [];
      var oCol = [];
      for (var r = 0; r < MAX; r++) {
        fCol.push(0);
        pCol.push(".");
        oCol.push(0);
      }
      fences.push(fCol);
      pigs.push(pCol);
      owners.push(oCol);
    }
  }

  // Apply fence (TS parity to ActionScript-era rules)
  if (isHorizontal) {
    if (row < MAX) {
      fences[col][row] = (fences[col][row] | FENCE_N) & 15;
      if (!owners[col][row]) owners[col][row] = actorTurn;
    }
    if (row - 1 >= 0) {
      fences[col][row - 1] = (fences[col][row - 1] | FENCE_S) & 15;
      if (!owners[col][row - 1]) owners[col][row - 1] = actorTurn;
    }
  } else {
    if (col < MAX) {
      fences[col][row] = (fences[col][row] | FENCE_W) & 15;
      if (!owners[col][row]) owners[col][row] = actorTurn;
    }
    if (col - 1 >= 0) {
      fences[col - 1][row] = (fences[col - 1][row] | FENCE_E) & 15;
      if (!owners[col - 1][row]) owners[col - 1][row] = actorTurn;
    }
  }

  // Detect newly completed squares and assign pigs
  var pigsAdded = 0;
  for (var c2 = 0; c2 < MAX; c2++) {
    for (var r2 = 0; r2 < MAX; r2++) {
      if (fences[c2][r2] === FENCE_COMPLETE && pigs[c2][r2] === ".") {
        pigs[c2][r2] = String(actorTurn);
        pigsAdded++;
      }
    }
  }

  // Persist state
  setRoomVars(room, {
    ptp_board_fences: JSON.stringify(fences),
    ptp_board_pigs: JSON.stringify(pigs),
    ptp_fence_owners: JSON.stringify(owners),
  });

  // Update points
  var p1 = Number(getRoomVar(room, "user1points", "0")) || 0;
  var p2 = Number(getRoomVar(room, "user2points", "0")) || 0;
  if (pigsAdded > 0) {
    if (actorTurn === 1) p1 += pigsAdded;
    else p2 += pigsAdded;
  }

  var scoreIncreased = pigsAdded > 0;
  var shouldSwap = !scoreIncreased;

  // Broadcast mg##move
  broadcastJSON(room, { _cmd: "mg##move", r: row, c: col, t: actorTurn, swap: shouldSwap, h: isHorizontal });

  // Spectator score update packet (TS parity)
  if (scoreIncreased) {
    broadcastJSON(room, { _cmd: "mg##spectatorUpdateScore", penPig1: p1, penPig2: p2 });
  }

  // Win conditions (TS parity)
  var winner = null;
  var WIN_POINTS = 19;

  // Count completed squares
  var completed = 0;
  for (var c3 = 0; c3 < MAX; c3++) {
    for (var r3 = 0; r3 < MAX; r3++) {
      if (fences[c3][r3] === FENCE_COMPLETE) completed++;
    }
  }

  if (p1 >= WIN_POINTS || p2 >= WIN_POINTS) {
    winner = p1 > p2 ? 1 : 2;
  } else if (completed >= 25) {
    winner = p1 === p2 ? 0 : p1 > p2 ? 1 : 2;
  }

  if (winner !== null) {
    handleWin(room, actorTurn, winner, row, col, isHorizontal, shouldSwap);
    return;
  }

  // Persist points + nowTurn behavior (swap rules)
  setRoomVars(room, { user1points: p1, user2points: p2 });

  if (shouldSwap) {
    var nextTurn = actorTurn === 1 ? 2 : 1;
    setRoomVars(room, { nowTurn: formatNowTurn(nextTurn, true) });
  } else {
    // Keep same turn; set flying=false
    setRoomVars(room, { nowTurn: formatNowTurn(actorTurn, false) });
  }
}

function handleWin(room, actorTurn, winnerSeat, row, col, hit, swap) {
  var players = getPlayersBySeat(room);
  var winnerUser = winnerSeat === 1 ? players.p1 : winnerSeat === 2 ? players.p2 : null;
  var loserUser = winnerSeat === 1 ? players.p2 : winnerSeat === 2 ? players.p1 : null;

  var winnerReward = 10;
  var loserReward = 5;

  // Broadcast mg##win first (TS parity)
  broadcastJSON(room, {
    _cmd: "mg##win",
    r: row,
    c: col,
    t: actorTurn,
    swap: swap,
    w: winnerSeat,
    h: hit,
    wn: winnerUser ? String(winnerUser.getName()) : "Unknown",
    coinsEarned: winnerReward,
    loserCoinsEarned: loserReward,
  });

  if (winnerUser) addCoins(winnerUser, winnerReward);
  if (loserUser) addCoins(loserUser, loserReward);

  cleanupGame(room);
}

function cleanupGame(room) {
  try {
    setRoomVars(room, {
      spectators: "",
      user1points: 0,
      user2points: 0,
      nowTurn: "1;false",
      ptp_board_fences: "",
      ptp_board_pigs: "",
      ptp_fence_owners: "",
    });

    var us = room.getAllUsers();
    for (var i in us) {
      try {
        _server.leaveRoom(us[i], room.getId());
      } catch (e) {}
    }
  } catch (e) {}
}

function handleExit(user, room) {
  if (user.getPlayerIndex(room) == -1) {
    try {
      _server.leaveRoom(user, room.getId());
    } catch (e) {}
    setRoomVars(room, { spectators: computeSpectatorNames(room) });
    return;
  }

  addCoins(user, 5);
  broadcastJSON(room, { _cmd: "mg##stop" });
  cleanupGame(room);
}

// ---------------------------------------------------------------------------
// Command dispatch
// ---------------------------------------------------------------------------

function handlePandandaPacket(cmd, params, user, fromRoom) {
  if (fromRoom == null) return;

  if (cmd === "move") return handleMove(user, fromRoom, params || {});
  if (cmd === "exit") return handleExit(user, fromRoom);
  if (cmd === "askPTPSpec") return handleAskPTPSpec(user, fromRoom);
}

