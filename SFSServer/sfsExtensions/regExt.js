eval(_server.readFile("utils/eventListener.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/json.js"));

var dbase;
var handlers = {};

function handlePandandaPacket(cmd, params, user, fromRoom) {
  
  if (handlers[cmd] == null) {
  }
}

function handleRegister(evtObj, user) {
  
  var username = evtObj.name;
  var password = evtObj.pass;
  var email = evtObj.email;
  
  var colorIndex = evtObj.colorIndex || 0;
  var isSafe = evtObj.isSafe || true;
  var chatMode = isSafe ? "safe" : "standard";
  
  var chan = [user];

  if (!username || username.length < 4) {
    return sendRegError(chan, "invalid", "Username too short");
  }
  
  if (!password || password.length < 5) {
    return sendRegError(chan, "invalid", "Password too short");
  }
  
  var userExists = dbase.executeQuery(
    "SELECT * FROM users WHERE username='" + 
    _server.escapeQuotes(username) + 
    "' LIMIT 1;"
  );
  
  if (userExists != null && userExists.size() > 0) {
    return sendRegError(chan, "taken", "Username already taken");
  }
  
  var emailExists = dbase.executeQuery(
    "SELECT * FROM users WHERE email='" + 
    _server.escapeQuotes(email) + 
    "' LIMIT 1;"
  );
  
  if (emailExists != null && emailExists.size() > 0) {
    return sendRegError(chan, "emailFull", "Email already registered");
  }
  
  var insertQuery = "INSERT INTO users (username, password, email, color) VALUES ('" + 
    _server.escapeQuotes(username) + "', '" + 
    _server.md5(password) + "', '" + 
    _server.escapeQuotes(email) + "', " + 
    colorIndex + ")";
  
  var result = dbase.executeCommand(insertQuery);
  
  if (result) {
    
    _server.sendResponse(
      { _cmd: "regOK" },
      -1,
      null,
      chan,
      "xml"
    );
  } else {
    sendRegError(chan, "dbError", "Database error");
  }
}

function handlePing(evtObj, user) {
  _server.sendResponse(
    { _cmd: "pong" },
    -1,
    null,
    [user],
    "xml"
  );
}

function sendRegError(recipients, errorType, errorMsg) {
  _server.sendResponse(
    {
      _cmd: "regFail",
      error: errorType,
      message: errorMsg
    },
    -1,
    null,
    recipients,
    "xml"
  );
}

function init() {
  
  handlers["register"] = handleRegister;
  handlers["ping"] = handlePing;
  
  dbase = _server.getDatabaseManager();
  
}

function destroy() {
}

function handleInternalEvent(evtObj) {
  if (evtObj.name == "user_join_room") {
  }
} 