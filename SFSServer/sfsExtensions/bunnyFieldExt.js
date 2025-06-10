var dbase, zone, _sfs, bunnyGameState;

// Dynamic coin multiplier based on user's bunnyDay crumb
function getBunnyGameCoinMultiplier(user) {
  var bunnyDay = user.properties.get("bunnyDay");
  if (bunnyDay == "1" || bunnyDay == 1) {
    return 4; // Double coins day
  }
  return 2; // Normal multiplier
}

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
        case "BUNNY_GAME_START_CHECK": {
          var startstop = "start";
          if (bunnyGameState == false) {
            startstop = "end";
          }

          Users.SendJSON(user, {
            _cmd: "bunnyGame",
            cmd2: startstop,
            inProgress: 1,
          });
          break;
        }
        case "BUNNY_GAME_UPDATE_PLAYER_SCORE": {
          var toadd = Decoder.decodeData(params["e"], 11);
          
          // Calculate the actual coin value with multiplier
          var actualCoinsToAdd = Number(toadd) * getBunnyGameCoinMultiplier(user);
          var cur = Number(user.properties.get("bunnyPoints")) + actualCoinsToAdd;
          
          // Also track base points (before multiplier) for client display calculation
          var baseTotalPoints = Number(user.properties.get("baseBunnyPoints")) || 0;
          baseTotalPoints += Number(toadd);
          user.properties.put("baseBunnyPoints", baseTotalPoints);

          if (toadd == 1) {
            var whiteBunnies = Number(user.properties.get("whiteBunnies")) || 0;
            user.properties.put("whiteBunnies", whiteBunnies + 1);
          } else if (toadd == 2) {
            var brownBunnies = Number(user.properties.get("brownBunnies")) || 0;
            user.properties.put("brownBunnies", brownBunnies + 1);
          } else if (toadd == 6) {
            var blackBunnies = Number(user.properties.get("blackBunnies")) || 0;
            user.properties.put("blackBunnies", blackBunnies + 1);
          }

          user.properties.put("bunnyPoints", cur);
          break;
        }
        case "BUNNY_GAME_FINAL_PLAYER_SCORE": {
          try {
            var currentCoins = Number(user.properties.get("coins")) || 0;
            var totalpoints = Number(user.properties.get("bunnyPoints")) || 0;
            // bunnyPoints now already contains multiplied values, so no need to multiply again
            var newCoins = currentCoins + totalpoints;
            user.properties.put("coins", newCoins);
            Users.UpdateCrumb(user.properties.get("id"), "coins", newCoins);

            Users.SendJSON(user, {
              _cmd: "coinUpdate",
              success: true,
              coins: newCoins,
            });
            user.properties.put("bunnyPoints", 0);
            user.properties.put("whiteBunnies", 0);
            user.properties.put("brownBunnies", 0);
            user.properties.put("blackBunnies", 0);
            user.properties.put("baseBunnyPoints", 0);
          } catch (e) {
            trace("Error in BUNNY_GAME_FINAL_PLAYER_SCORE: " + e);
            Users.SendJSON(user, {
              _cmd: "coinUpdate",
              success: false,
              msg: "An error occurred while updating coins.",
            });
          }
          break;
        }
        default: {
          trace("No bunny handler found for: " + XT_Hash[header]);
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

function bunnyGameFunc() {
  if (bunnyGameState == true) {
    bunnyGameState = false;
  } else if (bunnyGameState == false) {
    bunnyGameState = true;
  }
  var bunnyroom = zone.getRoomByName("EN_bunny_field");
  var usrz = bunnyroom.getAllUsers();
  var bunnyscores = "";
  var bunnyList = [];
  if (bunnyGameState == false) {
    for (i in usrz) {
      try {
        var whiteBunnies = Number(usrz[i].properties.get("whiteBunnies")) || 0;
        var brownBunnies = Number(usrz[i].properties.get("brownBunnies")) || 0;
        var blackBunnies = Number(usrz[i].properties.get("blackBunnies")) || 0;
        var totalpoints = Number(
          usrz[i].properties.get("bunnyPoints").toString()
        );
        
        // Get base points for client display calculation
        var baseTotalPoints = Number(usrz[i].properties.get("baseBunnyPoints")) || 0;
        
        // Calculate final coins earned amount for client display (base points * server multiplier)
        var coinsEarned = baseTotalPoints * getBunnyGameCoinMultiplier(usrz[i]);

        var currentCoins = Number(usrz[i].properties.get("coins")) || 0;

        // bunnyPoints now already contains multiplied values, so no need to multiply again
        var newCoins = currentCoins + totalpoints;

        // Update user properties
        usrz[i].properties.put("coins", newCoins);
        
        // Update database
        Users.UpdateCrumb(usrz[i].properties.get("id"), "coins", newCoins);
        
        // Notify the UI
        Users.SendJSON(usrz[i], {
          _cmd: "coinUpdate",
          coins: newCoins,
          success: true,
        });
        
        // Reset bunny tracking for next game
        usrz[i].properties.put("bunnyPoints", 0);
        usrz[i].properties.put("whiteBunnies", 0);
        usrz[i].properties.put("brownBunnies", 0);
        usrz[i].properties.put("blackBunnies", 0);
        usrz[i].properties.put("baseBunnyPoints", 0);

        bunnyList.push({
          username: String(usrz[i].getName()),
          totalpoints: totalpoints,
          baseTotalPoints: baseTotalPoints,
          coinsEarned: coinsEarned,
          whiteBunnies: whiteBunnies,
          brownBunnies: brownBunnies,
          blackBunnies: blackBunnies,
        });
      } catch (e) {
        trace("Error processing player: " + e);
      }
    }

    var sortedList = sortByKey(bunnyList, "totalpoints");
    sortedList = sortedList.reverse();

    var miejsce = 1;
    for (i in sortedList) {
      bunnyscores +=
        String(miejsce) +
        "," +
        String(sortedList[i].username) +
        "," +
        String(sortedList[i].whiteBunnies) +
        "," +
        String(sortedList[i].brownBunnies) +
        "," +
        String(sortedList[i].blackBunnies) +
        "," +
        String(sortedList[i].baseTotalPoints) +
        "," +
        String(sortedList[i].coinsEarned) +
        ";";
      miejsce = miejsce + 1;
    }
  }

  for (i in usrz) {
    try {
      if (bunnyGameState == true) {
        Users.SendJSON(usrz[i], { _cmd: "bunnyGame", cmd2: "start" });
      } else if (bunnyGameState == false) {
        Users.SendJSON(usrz[i], { _cmd: "bunnyGame", cmd2: "end" });
        Users.SendJSON(usrz[i], {
          _cmd: "bunnyGame",
          cmd2: "scores",
          scores: bunnyscores,
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
  bunnyGameState = true;
  setInterval("bunnyGameFunc", 30000);
}
function destroy() {
  trace("Nice knowing you, bye! :)");
}
