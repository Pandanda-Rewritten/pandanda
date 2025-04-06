var dbase, zone, _sfs, ghostGameState;

eval(_server.readFile("utils/json.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/xn_name_map.js"));
eval(_server.readFile("utils/eventListener.js"));

var Commands = {};

function handlePandandaPacket(cmd, params, user, fromRoom) {
  var header = cmd.split("##")[1];
  if (header == undefined) header = cmd;
  if (XT_Hash[header] != null && XT_Hash[header] != "") {
    trace("Got a packet: " + XT_Hash[header]);
    try {
      switch (XT_Hash[header]) {
        case "GHOST_GAME_START_CHECK": {
          var startstop = "start";
          if (ghostGameState == false) {
            startstop = "end";
          }

          var ghostroom = zone.getRoomByName("EN_graveyard");
          var usrz = ghostroom.getAllUsers();
          for (var i in usrz) {
            user.properties.put("ghostsCaught", 0);
          }

          Users.SendJSON(user, {
            _cmd: "ghostGame",
            cmd2: startstop,
            inProgress: 1,
            slimeStart: "0,785,10;1,309,13",
          });
          break;
        }
        case "GHOST_GAME_UPDATE_PLAYER_SCORE": {
          var ghostsCaught = Number(user.properties.get("ghostsCaught")) || 0;
          user.properties.put("ghostsCaught", ghostsCaught + 1);

          break;
        }
        case "GHOST_GAME_FINAL_PLAYER_SCORE": {
          try {
            var currentCoins = Number(user.properties.get("coins")) || 0;

            var totalpoints = Number(
              user.properties.get("ghostsCaught").toString()
            );
            var newCoins = currentCoins + totalpoints * 2;

            user.properties.put("coins", newCoins);
            Users.UpdateCrumb(user.properties.get("id"), "coins", newCoins);

            Users.SendJSON(user, {
              _cmd: "coinUpdate",
              success: true,
              coins: newCoins,
            });
          } catch (e) {
            trace("Error in GHOST_GAME_FINAL_PLAYER_SCORE: " + e);
            Users.SendJSON(user, {
              _cmd: "coinUpdate",
              success: false,
              msg: "An error occurred while updating coins.",
            });
          }
          break;
        }
        default: {
          trace("No ghost handler found for: " + XT_Hash[header]);
          break;
        }
      }
    } catch (e) {
      trace("Error while handling " + XT_Hash[header] + ": " + e);
    }
  } else {
    trace("Unknown handler hash: " + header);
  }
}

function ghostGameFunc() {
  if (ghostGameState == true) {
    ghostGameState = false;
  } else if (ghostGameState == false) {
    ghostGameState = true;
  }
  var ghostroom = zone.getRoomByName("EN_graveyard");
  var usrz = ghostroom.getAllUsers();
  var ghostscores = "";
  var ghostList = [];
  if (ghostGameState == false) {
    for (i in usrz) {
      try {
        var totalpoints = Number(usrz[i].properties.get("ghostsCaught")) || 0;

        var currentCoins = Number(usrz[i].properties.get("coins")) || 0;

        var newCoins = currentCoins + totalpoints * 2;

        Users.UpdateCrumb(usrz[i].properties.get("id"), "coins", newCoins);

        ghostList.push({
          username: String(usrz[i].getName()),
          totalpoints: Number(totalpoints),
        });
      } catch (e) {
        trace("Error processing player: " + e);
      }
    }

    var sortedList = sortByKey(ghostList, "totalpoints");
    sortedList = sortedList.reverse();

    var miejsce = 1;
    for (i in sortedList) {
      ghostscores +=
        String(miejsce) +
        "," +
        String(sortedList[i].username) +
        "," +
        String(sortedList[i].totalpoints) +
        ";";
      miejsce = miejsce + 1;
    }
  }

  for (i in usrz) {
    try {
      if (ghostGameState == true) {
        Users.SendJSON(usrz[i], {
          _cmd: "ghostGame",
          cmd2: "start",
          slimeStart: "0,785,10;1,309,13",
        });
      } else if (ghostGameState == false) {
        Users.SendJSON(usrz[i], { _cmd: "ghostGame", cmd2: "end" });
        Users.SendJSON(usrz[i], {
          _cmd: "ghostGame",
          cmd2: "scores",
          scores: ghostscores,
        });
      }
    } catch (e) {
      trace("Error sending data to player: " + e);
    }
  }
}

function init() {
  dbase = _server.getDatabaseManager();
  zone = _server.getCurrentZone();
  _sfs = Packages.it.gotoandplay.smartfoxserver.SmartFoxServer;
  _server.getCurrentZone().setPubMsgInternalEvent(true);
  ghostGameState = true;
  setInterval("ghostGameFunc", 30000);
}

function destroy() {
  trace("Nice knowing you, bye! :)");
}
