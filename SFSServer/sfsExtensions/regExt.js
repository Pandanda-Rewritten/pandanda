eval(_server.readFile("utils/eventListener.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/json.js"));
eval(_server.readFile("badwords.js"));

// Global variables
var dbase;
var handlers = {};

function handlePandandaPacket(cmd, params, user, fromRoom) {
  trace("regExt: HandlePandandaPacket called with cmd: " + cmd);
  
  // Only handle if not already processed
  if (handlers[cmd] == null) {
    trace("regExt: Command " + cmd + " not found in handlers");
  }
}

// Check if username contains bad words
function containsBadWordsInUsername(username) {
  try {
    // Use the new database-direct function
    if (containsBadWord(username)) {
      var triggeredWord = getTriggeredBadWord(username);
      trace("regExt: Bad word found in username: " + triggeredWord);
      return true;
    }
    return false;
  } catch (e) {
    trace("regExt: Error checking bad words in username: " + e);
    return false; // Allow registration if we can't check bad words (failsafe)
  }
}

function handleRegister(evtObj, user) {
  trace("regExt: Registration request received from user " + user.getName());
  
  var username = evtObj.name;
  var password = evtObj.pass;
  var email = evtObj.email;
  
  // Collect additional fields
  var colorIndex = evtObj.colorIndex || 0;
  var isSafe = evtObj.isSafe === true ? 1 : 0;
  var chatMode = isSafe ? "safe" : "standard";
  
  var chan = [user];

  // Simple input validation
  if (!username || username.length < 4) {
    trace("regExt: ERROR - Username too short: " + username);
    return sendRegError(chan, "invalid", "Username too short");
  }
  
  if (!password || password.length < 5) {
    trace("regExt: ERROR - Password too short");
    return sendRegError(chan, "invalid", "Password too short");
  }
  
  // Check for bad words in username
  if (containsBadWordsInUsername(username)) {
    trace("regExt: ERROR - Username contains prohibited words: " + username);
    return sendRegError(chan, "taken", "Username already taken");
  }
  
  // Check if username already exists
  var userExists = dbase.executeQuery(
    "SELECT * FROM users WHERE username='" + 
    _server.escapeQuotes(username) + 
    "' LIMIT 1;"
  );
  
  if (userExists != null && userExists.size() > 0) {
    trace("regExt: ERROR - Username already taken: " + username);
    return sendRegError(chan, "taken", "Username already taken");
  }
  
  // Check if email is already registered
  var emailExists = dbase.executeQuery(
    "SELECT * FROM users WHERE email='" + 
    _server.escapeQuotes(email) + 
    "' LIMIT 1;"
  );
  
  if (emailExists != null && emailExists.size() > 0) {
    trace("regExt: ERROR - Email already registered: " + email);
    return sendRegError(chan, "emailFull", "Email already registered");
  }
  
  // Insert new user with color
  var insertQuery = "INSERT INTO users (username, password, email, color, safeChat) VALUES ('" + 
    _server.escapeQuotes(username) + "', '" + 
    _server.md5(password) + "', '" + 
    _server.escapeQuotes(email) + "', " + 
    colorIndex + ", " + 
    isSafe + ")";
  
  trace("regExt: Executing SQL: " + insertQuery);
  var result = dbase.executeCommand(insertQuery);
  
  if (result) {
    trace("regExt: User successfully inserted: " + username);
    
    // Return success
    _server.sendResponse(
      { _cmd: "regOK" },
      -1,
      null,
      chan,
      "xml"
    );
  } else {
    trace("regExt: ERROR - Database error while inserting user");
    sendRegError(chan, "dbError", "Database error");
  }
}

function handlePing(evtObj, user) {
  trace("regExt: Ping received from user " + user.getName());
  // Just return a simple response to keep connection alive
  _server.sendResponse(
    { _cmd: "pong" },
    -1,
    null,
    [user],
    "xml"
  );
  trace("regExt: Pong sent to user " + user.getName());
}

function sendRegError(recipients, errorType, errorMsg) {
  trace("regExt: Sending registration error: " + errorType + " - " + errorMsg);
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
  trace("regExt: Initializing Registration Extension");
  
  // Register handlers
  handlers["register"] = handleRegister;
  handlers["ping"] = handlePing;
  
  // Initialize database connection
  dbase = _server.getDatabaseManager();
  
  // Initialize bad words database
  try {
    initializeBadWordsDB();
    var wordCount = getAllBadWords().length;
    trace("regExt: Bad words database initialized successfully (" + wordCount + " words)");
  } catch (e) {
    trace("regExt: Error initializing bad words database: " + e);
  }
  
  trace("regExt: Registration Extension initialized successfully");
  trace("regExt: Available handlers: register, ping");
}

function destroy() {
  trace("regExt: Registration Extension being destroyed");
  // Clean up code here
}

function handleInternalEvent(evtObj) {
  if (evtObj.name == "user_join_room") {
    trace("regExt: User joined room: " + evtObj.user.getName());
    // Handle user joining room if needed
  }
} 