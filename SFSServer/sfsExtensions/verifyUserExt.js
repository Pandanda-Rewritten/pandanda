eval(_server.readFile("utils/eventListener.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/json.js"));

function handlePandandaPacket(cmd, params, user, fromRoom) {}

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
    if (Date.parse(qRes.get(0).getItem("ubdate")) > Date.now())
      return sendLoginError(chan, "banned", "banned by name", {
        expiration: qRes.get(0).getItem("ubdate"),
      });
    if (qRes.get(0).getItem("ubdate") == "PERMABANNED")
      return sendLoginError(chan, "banned", "banned by name", {
        expiration: "Permanent",
      });

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
          "false,false,0,false"
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

function init() {
  handlers["verify"] = handleLoginVerify;
  handlers["loadClient"] = handleLoadClient;
  dbase = _server.getDatabaseManager();
}

function destroy() {}
