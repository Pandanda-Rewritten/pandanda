eval(_server.readFile("utils/underscore.js"));
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
    if (Date.parse(qRes.get(0).getItem("ubdate")) > Date.now())
      return sendLoginError(chan, "banned", "banned by name", {
        expiration: qRes.get(0).getItem("ubdate"),
      });
    if (qRes.get(0).getItem("ubdate") == "PERMABANNED")
      return sendLoginError(chan, "banned", "banned by name", {
        expiration: "Permanent",
      });
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
      crumbs = {
        lastPlayed: "1/1/1,383",
        xp: 0,
        xpLevel: 300,
        closet: "P001,C301c,C415a,C601a",
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
        isZing: 1,
        mounts: "",
        qItems: "",
        coins: 2000,
        email: qRes.get(0).getItem("email"),
        isEligible: "1",
        isMember: 1,
        lastGame: "undefined",
        isSafe: "0",
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
        qAvailable: processQAvailable(
          String(
            dbase
              .executeQuery(
                "SELECT `value` FROM config WHERE `key`='qAvailable';"
              )
              .get(0)
              .getItem("value")
          )
        ),
        mood: "Hello! I'm playing Pandanda!",
      };
    }
    user = _server.getUserByChannel(chan);

    user.properties.put("id", qRes.get(0).getItem("id"));
    _server.setUserVariables(user, {
      pw: crumbs.wearing || null,
      pc: Number(crumbs.color) || 0,
      px: 530,
      py: 400,
      bc: crumbs.bc,
      ng: crumbs.ng,
      btc: crumbs.btc,
      nc: crumbs.nc,
      bh: crumbs.bh,
    });
    if (crumbs.isMod == 1) {
      user.setAsModerator(true);
    }
    var clo = _.uniq(crumbs["closet"].split(","), false);
    crumbs["closet"] = clo.join(",");
    var tempets = [];
    dbase.executeCommand(
      "UPDATE users SET ip='" +
        _server.escapeQuotes(_server.md5(String(user.getIpAddress()))) +
        "' WHERE id='" +
        _server.escapeQuotes(qRes.get(0).getItem("id")) +
        "';"
    );
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
    crumbs["ip"] = _server.md5(String(user.getIpAddress()) || "127.0.0.1");
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
    crumbs["festivalCollection"] = 0;
    crumbs["id"] = String(user.getUserId());
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
