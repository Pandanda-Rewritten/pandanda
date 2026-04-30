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

function formatNowTurn(turn) {
  return String(turn) + ";false";
}

function ensureL4State(room) {
  // If state vars are missing, initialize them to a clean board.
  if (room.getVariable("l4_board") == null || room.getVariable("l4_heights") == null) {
    var cols = 7,
      rows = 6;
    var heights = [];
    for (var c = 0; c < cols; c++) heights.push(5);
    var board = [];
    for (var r = 0; r < rows; r++) {
      var row = [];
      for (var cc = 0; cc < cols; cc++) row.push(0);
      board.push(row);
    }
    setRoomVars(room, {
      l4_cols: cols,
      l4_heights: JSON.stringify(heights),
      l4_board: JSON.stringify(board),
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

function handleAskL4Spec(user, room) {
  ensureL4State(room);
  var players = getPlayersBySeat(room);
  if (!players.p1 || !players.p2) return;

  var t = parseNowTurn(room);

  var boardRowColStr = getRoomVar(room, "l4_board", "");
  var boardRowCol = boardRowColStr ? JSON.parse(boardRowColStr) : [];
  if (!boardRowCol || !boardRowCol.length) return;

  // transpose [row][col] -> [col][row]
  var board = [];
  for (var col = 0; col < 7; col++) {
    var colArr = [];
    for (var rowIdx = 0; rowIdx < 6; rowIdx++) {
      colArr.push((boardRowCol[rowIdx] && boardRowCol[rowIdx][col]) || 0);
    }
    board.push(colArr);
  }

  Users.SendJSON(user, {
    _cmd: "mg##specStatus",
    t: t,
    p1i: 1,
    p2i: 2,
    p1n: String(players.p1.getName()),
    p2n: String(players.p2.getName()),
    board: board,
  });
}

// ---------------------------------------------------------------------------
// Win detection (Connect-4)
// ---------------------------------------------------------------------------

function detectL4Win(board, row, col, player) {
  // board is [row][col]
  var dirs = [
    { dx: 1, dy: 0, dir: "e" },
    { dx: 0, dy: 1, dir: "s" },
    { dx: 1, dy: 1, dir: "se" },
    { dx: -1, dy: 1, dir: "sw" },
  ];
  var rows = board.length;
  var cols = (board[0] && board[0].length) || 0;

  for (var i = 0; i < dirs.length; i++) {
    var dx = dirs[i].dx,
      dy = dirs[i].dy,
      dir = dirs[i].dir;

    var forward = 0;
    var x = col + dx,
      y = row + dy;
    while (x >= 0 && x < cols && y >= 0 && y < rows && board[y][x] === player) {
      forward++;
      x += dx;
      y += dy;
    }

    var back = 0;
    x = col - dx;
    y = row - dy;
    while (x >= 0 && x < cols && y >= 0 && y < rows && board[y][x] === player) {
      back++;
      x -= dx;
      y -= dy;
    }

    if (1 + back + forward >= 4) {
      var useBack = Math.min(3, back);
      var needForward = 3 - useBack;
      if (forward < needForward) {
        var deficit = needForward - forward;
        useBack = Math.max(0, useBack - deficit);
      }
      var startCol = col - useBack * dx;
      var startRow = row - useBack * dy;
      var endCol = startCol + 3 * dx;
      var endRow = startRow + 3 * dy;
      if (startCol >= 0 && startCol < cols && startRow >= 0 && startRow < rows && endCol >= 0 && endCol < cols && endRow >= 0 && endRow < rows) {
        return { startRow: startRow, startCol: startCol, dir: dir };
      }
    }
  }
  return null;
}

// ---------------------------------------------------------------------------
// Gameplay commands
// ---------------------------------------------------------------------------

function handleMove(user, room, params) {
  ensureL4State(room);

  // Spectator guard
  var seat = user.getPlayerIndex(room);
  if (seat == -1) return;

  var xRaw = params && typeof params.x !== "undefined" ? params.x : null;
  if (xRaw === null) return;
  var x = Number(xRaw);
  if (isNaN(x)) return;

  var actorTurn = seat == 1 ? 1 : 2;
  var currentTurn = parseNowTurn(room);
  if (actorTurn !== currentTurn) {
    // Re-affirm nowTurn (broadcast is acceptable; client uses it as authority)
    setRoomVars(room, { nowTurn: formatNowTurn(currentTurn) });
    return;
  }

  var cols = Number(getRoomVar(room, "l4_cols", "7")) || 7;
  var heights = JSON.parse(getRoomVar(room, "l4_heights", "[]") || "[]");
  if (!heights || heights.length !== cols) {
    heights = [];
    for (var c = 0; c < cols; c++) heights.push(5);
  }

  var colIdx = Math.max(0, Math.min(cols - 1, Math.floor(x)));
  var nextRow = heights[colIdx];
  if (typeof nextRow !== "number") nextRow = 5;
  if (nextRow < 0) {
    setRoomVars(room, { nowTurn: formatNowTurn(currentTurn) });
    return;
  }
  var y = Math.max(0, Math.min(5, nextRow));
  heights[colIdx] = y - 1;

  var board = JSON.parse(getRoomVar(room, "l4_board", "[]") || "[]");
  if (!board || !board.length) {
    board = [];
    for (var rr = 0; rr < 6; rr++) {
      var row = [];
      for (var cc = 0; cc < cols; cc++) row.push(0);
      board.push(row);
    }
  }

  board[y][colIdx] = actorTurn;
  setRoomVars(room, { l4_heights: JSON.stringify(heights), l4_board: JSON.stringify(board) });

  // Points update (TS parity: increments by 1 per move)
  var p1 = Number(getRoomVar(room, "user1points", "0")) || 0;
  var p2 = Number(getRoomVar(room, "user2points", "0")) || 0;
  if (actorTurn === 1) p1++;
  else p2++;

  // Win check BEFORE mg##move (TS behavior)
  var win = detectL4Win(board, y, colIdx, actorTurn);
  if (win) {
    handleWin(room, actorTurn, colIdx, y, win);
    return;
  }

  // Broadcast mg##move
  broadcastJSON(room, { _cmd: "mg##move", t: actorTurn, x: colIdx, y: y });

  // Toggle turn and broadcast rVars updates
  var nextTurn = actorTurn === 1 ? 2 : 1;
  setRoomVars(room, {
    nowTurn: formatNowTurn(nextTurn),
    user1points: p1,
    user2points: p2,
  });
}

function handleWin(room, actorTurn, colIdx, y, winInfo) {
  var players = getPlayersBySeat(room);
  var winnerSeat = actorTurn; // actor is the winner in TS
  var winnerUser = winnerSeat === 1 ? players.p1 : players.p2;
  var loserUser = winnerSeat === 1 ? players.p2 : players.p1;

  var winnerReward = 10;
  var loserReward = 5;

  // Broadcast mg##win first (TS parity)
  broadcastJSON(room, {
    _cmd: "mg##win",
    wx: String(winInfo.startCol),
    wy: String(winInfo.startRow),
    t: actorTurn,
    w: winnerSeat,
    x: String(colIdx),
    y: String(y),
    wd: winInfo.dir,
    wn: winnerUser ? String(winnerUser.getName()) : "Unknown",
    coinsEarned: winnerReward,
    loserCoinsEarned: loserReward,
  });

  if (winnerUser) addCoins(winnerUser, winnerReward);
  if (loserUser) addCoins(loserUser, loserReward);

  // Reset room vars/state and remove everyone from the minigame room
  cleanupGame(room);
}

function cleanupGame(room) {
  try {
    // Reset observable vars
    setRoomVars(room, {
      spectators: "",
      user1points: 0,
      user2points: 0,
      nowTurn: "1;false",
      l4_board: "",
      l4_heights: "",
    });

    // Remove all users from the game room (players + spectators)
    var us = room.getAllUsers();
    for (var i in us) {
      try {
        _server.leaveRoom(us[i], room.getId());
      } catch (e) {}
    }
  } catch (e) {}
}

function handleExit(user, room) {
  // Spectator just leaves the minigame room
  if (user.getPlayerIndex(room) == -1) {
    try {
      _server.leaveRoom(user, room.getId());
    } catch (e) {}
    setRoomVars(room, { spectators: computeSpectatorNames(room) });
    return;
  }

  // Player quit: award 5 coins, broadcast mg##stop, reset, remove all
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
  if (cmd === "askL4Spec") return handleAskL4Spec(user, fromRoom);
}

