eval(_server.readFile("utils/underscore.js"));
eval(_server.readFile("utils/crypto.js"));
function handleLogin(username, password, chan) {
  try {
    loginFunction(username, password, chan);
  } catch (e) {
    trace("Login.js error: " + e);
  }
}
function loginFunction(username, password, chan) {
  var qRes = dbase.executeQuery(
    "SELECT * FROM users WHERE username='" +
      _server.escapeQuotes(username) +
      "';"
  );

  if (qRes != null) {
    if (qRes.size() == 0)
      return sendLoginError(chan, "user", "user not found", {});
    if (qRes.get(0).getItem("password") != _server.md5(password))
      return sendLoginError(chan, "password", "wrong password", {});
    if (qRes.get(0).getItem("active") != "1")
      return sendLoginError(chan, "activation", "not activated", {});
    // Check for ban (ubdate) and clear if expired
    var ubdate = qRes.get(0).getItem("ubdate");
    if (ubdate && ubdate !== "" && ubdate !== "null") {
      if (ubdate == "PERMABANNED") {
        return sendLoginError(chan, "banned", "banned by name", {
          expiration: "Permanent",
        });
      } else if (Date.parse(ubdate) > Date.now()) {
        return sendLoginError(chan, "banned", "banned by name", {
          expiration: ubdate,
        });
      } else {
        // Ban has expired, clear it
        trace("Ban expired for user " + username + ", clearing ubdate");
        dbase.executeCommand(
          "UPDATE users SET ubdate=NULL WHERE username='" +
            _server.escapeQuotes(username) +
            "';"
        );
      }
    }
    
    // Check for timed mute (umdate) - similar to ubdate check
    var umdate = qRes.get(0).getItem("umdate");
    var isMuteExpired = false;
    var shouldClearSafeChat = false;
    
    if (umdate && umdate !== "" && umdate !== "null") {
      if (Date.parse(umdate) <= Date.now()) {
        // Mute has expired, clear it
        isMuteExpired = true;
        shouldClearSafeChat = true;
        dbase.executeCommand(
          "UPDATE users SET umdate=NULL WHERE username='" +
            _server.escapeQuotes(username) +
            "';"
        );
      }
    } else {
      // No active mute (umdate is null/empty), should clear SafeChat if it's still active
      shouldClearSafeChat = true;
    }
    if (
      _server.loginUser(qRes.get(0).getItem("username"), password, chan, true)
        .success != true
    )
      return sendLoginError(chan, "kicked", "already logged in");
    var crumbs = null;
    try {
      crumbs = JSON.parse(qRes.get(0).getItem("crumbs"));
    } catch (e) {
      crumbs = null;
    }
    if (crumbs == null) {
      // Get color from database
      var userColor = qRes.get(0).getItem("color");
      if (!userColor) {
          userColor = "P001";
      }
      var processedData = processUserColorAndCloset(userColor, "C301c,C415a,C601a");
      
      crumbs = {
        lastPlayed: "1/1/1,383",
        xp: 0,
        xpLevel: 300,
        closet: processedData.processedCloset,
        memberOnly: "",
        bankCount: "",
        qActive: "",
        bday: "0/0/0,382",
        level: 1,
        allowFriends: 1,
        isMod: 0,
        qCount: 0,
        backpack: "",
        bank: "",
        gold: 0,
        tickets: 0,
        festivalCollection: 0,
        games: "MG001,MG002,MG003",
        cardColor: 8,
        isEmailValidated: 1,
        isZing: 0,
        mounts: "",
        qItems: "",
        coins: 2000,
        email: qRes.get(0).getItem("email"),
        isEligible: "1",
        isMember: 1,
        lastGame: "undefined",
        isSafe: qRes.get(0).getItem("safeChat"),
        storage: "F206",
        furniture: "",
        wearing: "",
        nc: "undefined",
        ng: "undefined",
        bc: "undefined",
        btc: "undefined",
        bh: true,
        isVIP: 0,
        heart: "None",
        bff: "None",
        color: "0",
        cardBG: "BG001",
        qAvailable: "Q001a:QI001-1:50:90:," + processQAvailable(
          String(
            dbase
              .executeQuery(
                "SELECT `value` FROM config WHERE `key`='qAvailable';"
              )
              .get(0)
              .getItem("value")
          )
        ),
        questHash: getQuestHashConfig(),
        mood: "Hello! I'm playing Pandanda Rewritten!",
      };
    }

    // Check and update questHash and qAvailable if necessary for existing crumbs
    if (crumbs != null) {
        try {
            var currentQuestHash = getQuestHashConfig();
            if (crumbs.questHash !== currentQuestHash) {
                trace("QuestHash mismatch for user " + username + ". Updating quests.");
                
                // Fetch and process current qAvailable
                var qAvailableValue = "";
                var qAvailableConfig = dbase.executeQuery("SELECT `value` FROM config WHERE `key`='qAvailable';");
                if (qAvailableConfig != null && qAvailableConfig.size() > 0) {
                    qAvailableValue = qAvailableConfig.get(0).getItem("value");
                } else {
                    trace("Warning: Could not fetch qAvailable config while updating quests for user " + username);
                }
                var processedQAvailable = processQAvailable(String(qAvailableValue));

                // Update crumbs and clear related quest data
                crumbs.qAvailable = processedQAvailable;
                crumbs.questHash = currentQuestHash;
                crumbs.qItems = "";  // Clear quest items
                crumbs.qActive = ""; // Clear active quests
            }
        } catch (e) {
            trace("Error checking/updating questHash for user " + username + ": " + e);
        }
        
        // Check if mute has expired or no active mute and update isSafe accordingly
        if (shouldClearSafeChat && crumbs.isSafe == 1) {
            trace("Clearing SafeChat mode for user " + username + " (mute expired or no active mute)");
            crumbs.isSafe = 0;
            // Update the database crumb as well
            Users.UpdateCrumb(qRes.get(0).getItem("id"), "isSafe", 0);
        }
    }

    user = _server.getUserByChannel(chan);

    user.properties.put("id", qRes.get(0).getItem("id"));
    
    // Set isMuted status if it exists in the database
    var isMuted = crumbs.isMuted === 1 ? "1" : "0";
    user.properties.put("isMuted", isMuted);
    
    _server.setUserVariables(user, {
      pw: crumbs.wearing || null,
      pc: Number(crumbs.color) || 0,
      px: 530,
      py: 400,
      bc: crumbs.bc,
      ng: "undefined",
      nc: "undefined",
      btc: crumbs.btc,
      bh: crumbs.bh,
    });
    if (crumbs.isMod == 1) {
      user.setAsModerator(true);
    }
    var clo = _.uniq(crumbs["closet"].split(","), false);
    crumbs["closet"] = clo.join(",");
    var tempets = [];
    // Encrypt and store IP in existing ip column (reversible), widening column if required
    try {
      var __ipStr = String(user.getIpAddress());
      var __ipEnc = CryptoUtil.encryptIp(__ipStr);
      dbase.executeCommand(
        "UPDATE users SET ip='" +
          _server.escapeQuotes(String(__ipEnc || "")) +
          "' WHERE id='" +
          _server.escapeQuotes(qRes.get(0).getItem("id")) +
          "';"
      );
    } catch (e) {
      try {
        dbase.executeCommand("ALTER TABLE users MODIFY COLUMN ip TEXT NULL;");
        var __ipStr2 = String(user.getIpAddress());
        var __ipEnc2 = CryptoUtil.encryptIp(__ipStr2);
        dbase.executeCommand(
          "UPDATE users SET ip='" +
            _server.escapeQuotes(String(__ipEnc2 || "")) +
            "' WHERE id='" +
            _server.escapeQuotes(qRes.get(0).getItem("id")) +
            "';"
        );
      } catch (e2) {
        trace("login.js: failed to store encrypted IP in users.ip: " + e2);
      }
    }
    var queryRes = dbase.executeQuery(
      'SELECT *, DATE_FORMAT(birthday, "%m/%d/%Y") AS datey FROM pets WHERE owner=\'' +
        _server.escapeQuotes(qRes.get(0).getItem("id")) +
        "';"
    );

    if (queryRes != null) {
      for (var i = 0; i < queryRes.size(); i++) {
        var tempRow = queryRes.get(i);
        var newpet = {
          name: tempRow.getItem("name"),
          color: tempRow.getItem("color"),
          birthday: tempRow.getItem("datey"),
        };
        tempets.push(JSON.stringify(newpet));
      }
    }
    user.properties.put("petarray", tempets);
    var date = new Date();
    crumbs["_cmd"] = "loginSuccess";
    // Provide encrypted IP blob in crumbs
    try {
      crumbs["ip"] = String(CryptoUtil.encryptIp(String(user.getIpAddress())) || "");
    } catch (e) {
      crumbs["ip"] = "";
    }
    crumbs["isBday"] = 0;
    crumbs["sTime"] = String(
      dbase
        .executeQuery("SELECT UNIX_TIMESTAMP(NOW()) AS test;")
        .get(0)
        .getItem("test") || null
    );
    // Check event toggles to determine which price list to use
    var priceListKey = "priceList"; // Default price list
    
    try {
      // Check for active events in eventconfig table
      var eventQuery = dbase.executeQuery("SELECT `event`, active FROM eventconfig WHERE active = 1;");
      
      if (eventQuery != null && eventQuery.size() > 0) {
        var doubleGemsActive = false;
        var doubleFruitVegActive = false;
        var doubleFruitVegGemsActive = false;
        var doubleRecycleActive = false;
        var doubleFishActive = false;
        var doubleAllSellingActive = false;
        
        for (var i = 0; i < eventQuery.size(); i++) {
          var eventName = eventQuery.get(i).getItem("event");
          var isActive = eventQuery.get(i).getItem("active");
          
          if ((isActive == "1" || isActive == 1) && eventName == "doubleGems") {
            doubleGemsActive = true;
          } else if ((isActive == "1" || isActive == 1) && eventName == "doubleFruitVeg") {
            doubleFruitVegActive = true;
          } else if ((isActive == "1" || isActive == 1) && eventName == "doubleFruitVegGems") {
            doubleFruitVegGemsActive = true;
          } else if ((isActive == "1" || isActive == 1) && eventName == "doubleRecycle") {
            doubleRecycleActive = true;
          } else if ((isActive == "1" || isActive == 1) && eventName == "doubleFish") {
            doubleFishActive = true;
          } else if ((isActive == "1" || isActive == 1) && eventName == "doubleAllSelling") {
            doubleAllSellingActive = true;
          }
        }
        
        if (doubleGemsActive) {
          priceListKey = "doubleGemsPriceList";
        } else if (doubleFruitVegActive) {
          priceListKey = "doubleFVPriceList";
        } else if (doubleFruitVegGemsActive) {
          priceListKey = "doubleFVGPPriceList";
        } else if (doubleRecycleActive) {
          priceListKey = "doubleTrashPriceList";
        } else if (doubleFishActive) {
          priceListKey = "doubleFishPriceList";
        } else if (doubleAllSellingActive) {
          priceListKey = "doubleAllPriceList";
        }
      }
    } catch (e) {
      trace("Error checking eventconfig, using default price list: " + e);
    }
    
    crumbs["priceList"] = String(
      dbase
        .executeQuery("SELECT `value` FROM config WHERE `key`='" + priceListKey + "';")
        .get(0)
        .getItem("value")
    );
    crumbs["catalogs"] = String(
      dbase
        .executeQuery("SELECT `value` FROM config WHERE `key`='catalogs';")
        .get(0)
        .getItem("value")
    );
    crumbs["qRand"] = String(
      (date.getDay() + date.getDate()) * date.getMonth() * 2
    );
    crumbs["isMember"] = 1;
    
    // Check eventconfig for isZing value
    var isZingValue = 0; // Default value
    
    try {
      // Check for isZing event in eventconfig table
      var zingQuery = dbase.executeQuery("SELECT active FROM eventconfig WHERE event = 'zingActive';");
      if (zingQuery != null && zingQuery.size() > 0) {
        var zingActive = zingQuery.get(0).getItem("active");
        isZingValue = (zingActive == "1" || zingActive == 1) ? 1 : 0;
      }
    } catch (e) {
      trace("Error checking eventconfig for isZing using default value: " + e);
    }
    
    crumbs["isZing"] = isZingValue;

    // Check eventconfig for isBunnyDay value
    var isBunnyDayValue = 0; // Default value
    
    try {
      // Check for isBunnyDay event in eventconfig table
      var bunnyDayQuery = dbase.executeQuery("SELECT active FROM eventconfig WHERE event = 'doubleBunnyGame';");
      if (bunnyDayQuery != null && bunnyDayQuery.size() > 0) {
        var isBunnyDay = bunnyDayQuery.get(0).getItem("active");
        isBunnyDayValue = (isBunnyDay == "1" || isBunnyDay == 1) ? 1 : 0;
      }
    } catch (e) {
      trace("Error checking eventconfig for bunnyDay, using default value: " + e);
    }
    crumbs["bunnyDay"] = isBunnyDayValue;

    // Check eventconfig for isGhostDay value
    var isGhostDayValue = 0; // Default value
    
    try {
      // Check for isGhostDay event in eventconfig table
      var ghostDayQuery = dbase.executeQuery("SELECT active FROM eventconfig WHERE event = 'doubleGhostGame';");
      if (ghostDayQuery != null && ghostDayQuery.size() > 0) {
        var isGhostDay = ghostDayQuery.get(0).getItem("active");
        isGhostDayValue = (isGhostDay == "1" || isGhostDay == 1) ? 1 : 0;
      }
    } catch (e) {
      trace("Error checking eventconfig for bunnyDay, using default value: " + e);
    }
    crumbs["ghostDay"] = isGhostDayValue;
    
    crumbs["isChristmas"] = 0;
    // crumbs["festivalCollection"] = 0;
    crumbs["id"] = String(user.getUserId());
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1; // Months are 0-indexed
    const day = now.getDate();
    const hours = now.getHours();
    const minutes = now.getMinutes();
    const seconds = now.getSeconds();
    crumbs["lastPlayed"] = year + "-" +
                        (month < 10 ? '0' : '') + month + "-" +
                        (day < 10 ? '0' : '') + day + " " +
                        (hours < 10 ? '0' : '') + hours + ":" +
                        (minutes < 10 ? '0' : '') + minutes + ":" +
                        (seconds < 10 ? '0' : '') + seconds; // Manually pad with leading zeros
    Users.PopulateObject(user, crumbs);
    user.properties.put("id", qRes.get(0).getItem("id"));
    Users.UpdateCrumbs(qRes.get(0).getItem("id"), crumbs);

    _server.sendResponse(crumbs, -1, null, [user], "json");

    var newroomObj = {};
    newroomObj.name = "TH_" + user.getName();
    newroomObj.maxU = 50;
    newroomObj.isTemp = true;
    newroomObj.isLimbo = false;
    newroomObj.isPrivate = false;

    var newRoom = _server.createRoom(newroomObj, user, true, true);

    if (newRoom) {
      var rpetVars = [];
      var petz = [];
      var rawpets = tempets;
      var roomOwnerName = newroomObj.name.substring(3).toString();

      for (var i in rawpets) {
        var newpet = eval("(" + rawpets[i] + ")");
        var petex = String(newpet.birthday).split("/");
        var eh = petex[2] + "-" + petex[0] + "-" + petex[1] + " 17:29:54";

        var qRes = dbase.executeQuery(
          "SELECT DATEDIFF(NOW(), '" + eh + "') AS days;"
        );
        if (qRes.size() > 0) {
          var daysold = String(Number(qRes.get(0).getItem("days")) + 4);
          petz.push(
            roomOwnerName +
              "," +
              newpet.name +
              "," +
              newpet.color +
              "," +
              newpet.birthday +
              "," +
              daysold +
              ",100:100:100,0,0"
          );
        }
      }

      var ayyy = petz.join(";");

      rpetVars.push({ name: "pets", val: ayyy, priv: false });

      _server.setRoomVariables(newRoom, null, rpetVars);

      user.properties.put("room", newRoom);
    } else {
      trace("Failed to create the room.");
    }
  } else {
    sendLoginError();
  }
}
