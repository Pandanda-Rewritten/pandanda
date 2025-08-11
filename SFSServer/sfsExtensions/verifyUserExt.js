eval(_server.readFile("utils/eventListener.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/json.js"));

var dbase;
var handlers = {};

function handlePandandaPacket(cmd, params, user, fromRoom) {
  
  if (handlers[cmd] == null) {
  }
}

function handleLoginVerify(evtObj, user) {
  var username = evtObj.name;
  var password = evtObj.pass;
  var chan = [user];
  var qRes = dbase.executeQuery(
    "SELECT * FROM users WHERE username='" +
      _server.escapeQuotes(username) +
      "' LIMIT 1;"
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
    var shouldClearSafeChat = false;
    
    if (umdate && umdate !== "" && umdate !== "null") {
      if (Date.parse(umdate) <= Date.now()) {
        // Mute has expired, clear it
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
    
    // Clear SafeChat mode if no active mute
    if (shouldClearSafeChat) {
      dbase.executeCommand(
        "UPDATE users SET crumbs = JSON_SET(crumbs, '$.isSafe', 0) WHERE username='" +
          _server.escapeQuotes(username) +
          "' AND JSON_EXTRACT(crumbs, '$.isSafe') = 1;"
      );
    }

    var serverStr = new Array(),
      servers = dbase.executeQuery("SELECT * FROM servers;");
    for (var i = 0; i < servers.size(); i++) {
      var popu = servers.get(i).getItem("population");
      serverStr.push(
        servers.get(i).getItem("name") +
          "," +
          servers.get(i).getItem("zone") +
          "," +
          servers.get(i).getItem("host") +
          "," +
          servers.get(i).getItem("port") +
          "," +
          popu +
          "," +
          servers.get(i).getItem("safeChat") +
          "," +
          servers.get(i).getItem("membersOnly") +
          "," +
          servers.get(i).getItem("levelReq") +
          "," +
          servers.get(i).getItem("friendOnline")
          // Old Hardcoded values:
          // false, // Safe Chat
          // false, //Members Only
          // 0, // Level Req
          // false, // Friend Online
      );
    }
    serverStr = serverStr.join(";");
    _server.sendResponse(
      {
        _cmd: "loginSuccess",
        level: qRes.get(0).getItem("level"),
        isMember: qRes.get(0).getItem("memberexpiry") > strtotime("NOW"),
        info: serverStr,
      },
      -1,
      null,
      chan,
      "xml"
    );
  } else {
    sendLoginError(chan, "m_databaseError", "Database Error");
  }
}

function handleLoadClient(params, user) {
  client = dbase
    .executeQuery("SELECT * FROM config WHERE `key`='client';")
    .get(0)
    .getItem("value");
  _server.sendResponse(
    {
      _cmd: "client",
      client: String(client),
    },
    -1,
    null,
    [user],
    "json"
  );
}

function handleChangePassword(evtObj, user) {
  
  var username = evtObj.name;
  var oldPassword = evtObj.oldPW;
  var newPassword = evtObj.newPW;
  var chan = [user];
  
  if (!newPassword || newPassword.length < 5) {
    return sendResponse(chan, "cp", false);
  }
  
  var qRes = dbase.executeQuery(
    "SELECT * FROM users WHERE username='" +
      _server.escapeQuotes(username) +
      "' LIMIT 1;"
  );
  
  if (qRes != null && qRes.size() > 0) {
    var storedHash = qRes.get(0).getItem("password");
    var inputHash = _server.md5(oldPassword);
    
    if (storedHash != inputHash) {
      return sendResponse(chan, "cp", false);
    }
    
    var updateResult = dbase.executeCommand(
      "UPDATE users SET password='" +
      _server.md5(newPassword) +
      "' WHERE username='" +
      _server.escapeQuotes(username) +
      "';"
    );
    
    if (updateResult) {
      sendResponse(chan, "cp", true);
    } else {
      sendResponse(chan, "cp", false);
    }
  } else {
    sendResponse(chan, "cp", false);
  }
}

function sendResponse(recipients, cmd, isSuccess) {
  _server.sendResponse(
    {
      _cmd: cmd,
      isSuccess: isSuccess
    },
    -1,
    null,
    recipients,
    "xml"
  );
}

function sendLoginError(recipients, errorType, errorMsg, additionalData) {
  var resp = {
    _cmd: "loginFail",
    error: errorType,
    message: errorMsg
  };
  
  if (additionalData) {
    for (var key in additionalData) {
      resp[key] = additionalData[key];
    }
  }
  
  _server.sendResponse(
    resp,
    -1,
    null,
    recipients,
    "xml"
  );
}

function init() {
  handlers = {};
  handlers["verify"] = handleLoginVerify;
  handlers["loadClient"] = handleLoadClient;
  handlers["cp"] = handleChangePassword;
  dbase = _server.getDatabaseManager();
}

function destroy() {}
