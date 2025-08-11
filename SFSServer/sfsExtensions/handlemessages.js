var Commands = {};

// Helper function to pad numbers with leading zeros
function padZero(num) {
  return (num < 10 ? '0' : '') + num;
}

function handlePublicMessage(user, message, fromRoom) {
  // Debug check for mute status
  trace("Message from " + user.getName() + ", muted status: " + user.properties.get("muted"));
  
  // Ensure bad words are loaded if they haven't been yet
  if (typeof badWords === 'undefined' || badWords.length === 0) {
    trace("handlemessages.js: Bad words not loaded, attempting to load from database");
    try {
      if (typeof dbase !== 'undefined' && dbase !== null) {
        loadBadWordsFromDB();
        trace("handlemessages.js: Bad words loaded from database, count: " + badWords.length);
      }
    } catch (e) {
      trace("handlemessages.js: Error loading bad words: " + e);
    }
  }
  
  // Check if message contains any bad words
  if (containsBadWord(message)) {
    trace("Bad word detected from user " + user.getName() + ": " + message);
    var triggeredWord = getTriggeredBadWord(message);
    
    // Count all previous auto-action offenses (warning, mute, ban, permban)
    var offenseCount = 0;
    try {
      var offenseResult = dbase.executeQuery(
        "SELECT COUNT(*) AS count FROM moderation_logs WHERE username='" +
          _server.escapeQuotes(user.getName()) +
          "' AND action IN ('auto_warning', 'auto_mute', 'auto_ban', 'auto_permban');"
      );
      if (offenseResult && offenseResult.size() > 0) {
        offenseCount = parseInt(offenseResult.get(0).getItem("count"));
      }
    } catch (e) {
      trace("Error counting previous offenses: " + e);
    }
    offenseCount = isNaN(offenseCount) ? 0 : offenseCount;
    
    // Progressive offense system: warnings, mutes, then bans
    var muteHours = 0;
    var actionType = "warning";
    var actionMessage = "";
    
    if (offenseCount < 30) {
      // 0-29 offenses: Warning and block message
      actionType = "warning";
      actionMessage = "Your message contained inappropriate language and was blocked. Please refrain from using inappropriate language. Continued behaviour will result in further action";
    } else if (offenseCount >= 30 && offenseCount < 60) {
      // 30-59 offenses: Safe chat mute for 72 hours
      actionType = "mute";
      muteHours = 72; // 72 hours as requested
      actionMessage = "You have been muted for 72 hours for using prohibited language. You are now in SafeChat mode. (Offense " + (offenseCount + 1) + "/60)";
    } else {
      // 60+ offenses: Permanent ban
      actionType = "permban";
      actionMessage = "You have been permanently banned for repeated use of prohibited language. (Offense " + (offenseCount + 1) + ")";
    }
    
    
    // Log the incident to the database
    var date = new Date();
    var timestamp = formatDate(date) + " " + 
                   padZero(date.getHours()) + ":" + 
                   padZero(date.getMinutes()) + ":" + 
                   padZero(date.getSeconds());
    try {
      dbase.executeCommand(
        "INSERT INTO moderation_logs(username, action, message, bad_word, room, timestamp) VALUES('" +
          _server.escapeQuotes(user.getName()) +
          "', 'auto_" + actionType + "', '" +
          _server.escapeQuotes(message) +
          "', '" +
          _server.escapeQuotes(triggeredWord) +
          "', '" +
          _server.escapeQuotes(fromRoom.getName()) +
          "', '" +
          _server.escapeQuotes(timestamp) +
          "');"
      );
    } catch (e) {
      trace("Error logging bad word detection: " + e);
    }
    
    if (actionType === "warning") {
      // First offense: Warning only - just block the message and notify user with popup
      Users.SendAdmin(
        user,
        actionMessage,
        fromRoom
      );
      
    } else if (actionType === "mute") {
      // Apply timed mute - set umdate and force SafeChat
      var muteMillis = muteHours * 60 * 60 * 1000;
      var muteUntil = new Date(date.getTime() + muteMillis);
      var dateString = formatDate(muteUntil) + " 12:00";
      
      // Set umdate in database
      dbase.executeCommand(
        "UPDATE users SET umdate='" +
          _server.escapeQuotes(dateString) +
          "' WHERE username='" +
          _server.escapeQuotes(user.getName()) +
          "';"
      );
      
      // Force user into SafeChat mode
      user.properties.put("isSafe", 1);
      Users.UpdateCrumb(user.properties.get("id"), "isSafe", 1);
      
      // Kick the user with mute message
      _server.kickUser(
        user,
        5,
        actionMessage
      );
      
    } else if (actionType === "permban") {
      // Apply permanent ban until 31/12/9999
      var dateString = "9999/12/31 12:00";
      dbase.executeCommand(
        "UPDATE users SET ubdate='" +
          _server.escapeQuotes(dateString) +
          "' WHERE username='" +
          _server.escapeQuotes(user.getName()) +
          "';"
      );
      
      // Kick the user with ban message
      _server.kickUser(
        user,
        2,
        actionMessage
      );
    }
    
    return; // Exit early, don't process the message
  }
  
  // Check if user is muted and block the message if so
  if (user.properties.get("muted") === "1") {
    trace("User " + user.getName() + " is muted, blocking message");
    Users.SendJSON(user, {
      _cmd: "moderation",
      action: "muteError",
      message: "You are currently muted and cannot send messages."
    });
    return; // Exit early, don't process the message
  }
  
  // Check if user is in SafeChat mode due to timed mute
  if (user.properties.get("isSafe") === 1 || user.properties.get("isSafe") === "1") {
    trace("User " + user.getName() + " is in SafeChat mode, filtering message");
    // In SafeChat mode, only allow very basic messages
    // This is a simple implementation - you might want to expand this
    var safeChatAllowed = /^[a-zA-Z0-9\s\.\!\?\,]+$/.test(message) && message.length <= 50;
    if (!safeChatAllowed) {
      Users.SendJSON(user, {
        _cmd: "moderation",
        action: "safeChatError",
        message: "You are in SafeChat mode. Only simple messages are allowed."
      });
      return; // Exit early, don't process the message
    }
  }
  
  dbase.executeCommand(
    "INSERT INTO messages(author,message,room) VALUES('" +
      _server.escapeQuotes(String(user.getName())) +
      "','" +
      _server.escapeQuotes(String(message)) +
      "','" +
      _server.escapeQuotes(String(fromRoom.getName())) +
      "');"
  );
  if (
    message.indexOf("!") === 0 &&
    (command = message
      .substr(
        0,
        message.indexOf(" ") == -1 ? message.length : message.indexOf(" ")
      )
      .toUpperCase()) != null
  ) {
    var msgex = message.split(" ");
    var thecmd = String(msgex[0]);
    var hide = false;
    if (thecmd == "!giveaway") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        var usrz = fromRoom.getAllUsers();
        var itid = String(msgex[1]);

        for (var i = 0; i < usrz.length; i++) {
          try {
            var itemz = String(usrz[i].properties.get("closet")).split(",");

            if (itemz.indexOf(itid) == -1) {
              receiveItem(usrz[i], itid);
              Users.SendJSON(usrz[i], {
                _cmd: "secretUpdate",
                success: true,
                itemId: itid,
              });
            }
          } catch (e) {}
        }
      }
    } else if (thecmd == "!give") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (msgex.length < 3) {
          Users.SendAdmin(user, "Usage: !give item username", fromRoom);
        } else {
          var itid = msgex[1];
          var targetUsername = msgex[2];
          var targetUser = Users.GetUserByName(targetUsername);

          if (targetUser != null) {
            try {
              var itemz = String(targetUser.properties.get("closet")).split(
                ","
              );
              if (itemz.indexOf(itid) == -1) {
                receiveItem(targetUser, itid);
                Users.SendJSON(targetUser, {
                  _cmd: "secretUpdate",
                  success: true,
                  itemId: itid,
                });
                Users.SendAdmin(
                  user,
                  "Successfully gave item " + itid + " to " + targetUsername,
                  fromRoom
                );
              } else {
                Users.SendAdmin(
                  user,
                  targetUsername + " already has item " + itid,
                  fromRoom
                );
              }
            } catch (e) {
              Users.SendAdmin(
                user,
                "Error giving item to " + targetUsername,
                fromRoom
              );
            }
          } else {
            Users.SendAdmin(
              user,
              "User " + targetUsername + " not found",
              fromRoom
            );
          }
        }
      }
    } else if (thecmd == "!giveawaym") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (msgex.length < 2) {
          Users.SendAdmin(user, "Usage: !giveawaym amount", fromRoom);
        } else {
          var amount = parseInt(msgex[1]);
          if (isNaN(amount)) {
            Users.SendAdmin(user, "Please enter a valid number", fromRoom);
            return;
          }

          var usrz = fromRoom.getAllUsers();
          for (var i = 0; i < usrz.length; i++) {
            try {
              var currentCoins = parseInt(usrz[i].properties.get("coins")) || 0;
              var newAmount = currentCoins + amount;
              usrz[i].properties.put("coins", newAmount);
              Users.UpdateCrumb(
                usrz[i].properties.get("id"),
                "coins",
                newAmount
              );

              Users.SendJSON(usrz[i], {
                _cmd: "coinUpdate",
                coins: newAmount,
                success: true,
              });
              Users.SendAdmin(
                usrz[i],
                "You received " + amount + " coins!",
                fromRoom
              );
            } catch (e) {}
          }
          Users.SendAdmin(
            user,
            "Successfully gave " + amount + " coins to all users in the room",
            fromRoom
          );
        }
      }
    } else if (thecmd == "!givem") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (msgex.length < 3) {
          Users.SendAdmin(user, "Usage: !givem amount username", fromRoom);
        } else {
          var amount = parseInt(msgex[1]);
          var targetUsername = msgex[2];
          if (isNaN(amount)) {
            Users.SendAdmin(user, "Please enter a valid number", fromRoom);
            return;
          }

          var targetUser = Users.GetUserByName(targetUsername);
          if (targetUser != null) {
            try {
              var currentCoins =
                parseInt(targetUser.properties.get("coins")) || 0;
              var newAmount = currentCoins + amount;
              targetUser.properties.put("coins", newAmount);
              Users.UpdateCrumb(
                targetUser.properties.get("id"),
                "coins",
                newAmount
              );

              Users.SendJSON(targetUser, {
                _cmd: "coinUpdate",
                coins: newAmount,
                success: true,
              });
              Users.SendAdmin(
                targetUser,
                "You received " + amount + " coins!",
                fromRoom
              );
              Users.SendAdmin(
                user,
                "Successfully gave " + amount + " coins to " + targetUsername,
                fromRoom
              );
            } catch (e) {
              Users.SendAdmin(
                user,
                "Error giving coins to " + targetUsername,
                fromRoom
              );
            }
          } else {
            Users.SendAdmin(
              user,
              "User " + targetUsername + " not found",
              fromRoom
            );
          }
        }
      }
    } else if (thecmd == "!kick") {
      if (user.isModerator()) {
        if (!msgex[1]) {
        } else {
          var targetz = Users.GetUserByName(
            String(message).replace("!kick ", "")
          );
          if (targetz != null) {
            _server.kickUser(
              targetz,
              4,
              "You have been kicked! Please behave better next time..."
            );
          }
        }
      }
    } else if (thecmd == "!unban") {
      hide = true;

      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (!msgex[1]) {
        } else {
          var targetUsername = String(message).replace("!unban ", "");

          var queryResult = dbase.executeQuery(
            "SELECT * FROM users WHERE username='" +
              _server.escapeQuotes(targetUsername) +
              "';"
          );

          if (queryResult && queryResult.size() > 0) {
            dbase.executeCommand(
              "UPDATE users SET ubdate=null WHERE username='" +
                _server.escapeQuotes(targetUsername) +
                "';"
            );

            var unbanMessage =
              "You have successfully unbanned " + targetUsername + ".";

            Users.SendAdmin(user, unbanMessage, fromRoom);
          } else {
            var errorMessage =
              "Error: User '" + targetUsername + "' does not exist.";

            Users.SendAdmin(user, errorMessage, fromRoom);
          }
        }
      }
    } else if (thecmd == "!mute") {
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (!msgex[1]) {
        } else {
          var targetName = String(message).replace("!mute ", "");
          var targetUser = Users.GetUserByName(targetName);
          if (targetUser != null) {
            targetUser.properties.put("isSafe", 1);
            Users.UpdateCrumb(targetUser.properties.get("id"), "isSafe", 1);

            Users.SendAdmin(
              targetUser,
              "You have been muted. Please remember to follow the rules!",
              fromRoom
            );

            _server.kickUser(
              targetUser,
              5,
              "You have been muted! Please follow the rules."
            );
          }
        }
      }
    } else if (thecmd == "!m") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        var message = String(message.substring(3)).trim();

        if (message !== "") {
          var users = fromRoom.getAllUsers();

          for (var i = 0; i < users.length; i++) {
            var currentUser = users[i];

            Users.SendAdmin(
              currentUser,
              message + " -" + user.getName(),
              fromRoom
            );
          }
        }
      }
    } else if (thecmd == "!pm") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (msgex.length < 3) {
          Users.SendAdmin(user, "Usage: !pm username message", fromRoom);
        } else {
          var targetUsername = msgex[1];
          var message = message
            .substring(thecmd.length + targetUsername.length + 2)
            .trim();

          var targetUser = Users.GetUserByName(targetUsername);
          if (targetUser != null) {
            Users.SendAdmin(
              targetUser,
              user.getName() + ": " + message,
              fromRoom
            );
            Users.SendAdmin(
              user,
              "PM sent to " + targetUsername + ": " + message,
              fromRoom
            );
          } else {
            Users.SendAdmin(
              user,
              "User " + targetUsername + " not found",
              fromRoom
            );
          }
        }
      }
    } else if (thecmd == "!global") {
      hide = true;

      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        var message = String(message.substring(7)).trim();

        if (message !== "") {
          var rooms = zone.getRooms();

          for (var j = 0; j < rooms.length; j++) {
            var currentRoom = rooms[j];
            var users = currentRoom.getAllUsers();

            for (var i = 0; i < users.length; i++) {
              var currentUser = users[i];

              Users.SendAdmin(currentUser, message, currentRoom);
            }
          }
        }
      }
    } else if (thecmd == "!unmute") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (!msgex[1]) {
        } else {
          var targetName = String(message).replace("!unmute ", "");
          var targetUser = Users.GetUserByName(targetName);
          if (targetUser != null) {
            // Clear both regular mute and timed mute
            targetUser.properties.put("isSafe", 0);
            Users.UpdateCrumb(targetUser.properties.get("id"), "isSafe", 0);
            
            // Clear umdate from database
            dbase.executeCommand(
              "UPDATE users SET umdate=NULL WHERE username='" +
                _server.escapeQuotes(targetName) +
                "';"
            );

            Users.SendAdmin(
              targetUser,
              "You have been unmuted. Please remember to follow the rules!",
              fromRoom
            );
            
            Users.SendAdmin(
              user,
              "Successfully unmuted " + targetName + " and cleared any timed mute.",
              fromRoom
            );
          }
        }
      }
    } else if (thecmd == "!mutestatus") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (!msgex[1]) {
          Users.SendAdmin(user, "Usage: !mutestatus username", fromRoom);
        } else {
          var targetName = String(message).replace("!mutestatus ", "");
          
          // Check database for mute status
          var qRes = dbase.executeQuery(
            "SELECT umdate, crumbs FROM users WHERE username='" +
              _server.escapeQuotes(targetName) +
              "';"
          );
          
          if (qRes && qRes.size() > 0) {
            var umdate = qRes.get(0).getItem("umdate");
            var crumbsData = qRes.get(0).getItem("crumbs");
            var statusMessage = "Mute status for " + targetName + ": ";
            
            try {
              var userCrumbs = JSON.parse(crumbsData);
              var isSafe = userCrumbs.isSafe;
              
              if (umdate && umdate !== "" && umdate !== "null") {
                if (Date.parse(umdate) > Date.now()) {
                  statusMessage += "Timed mute active until " + umdate + " (SafeChat: " + (isSafe ? "ON" : "OFF") + ")";
                } else {
                  statusMessage += "Timed mute expired (should be cleared on next login). SafeChat: " + (isSafe ? "ON" : "OFF");
                }
              } else {
                statusMessage += "No timed mute. SafeChat: " + (isSafe ? "ON" : "OFF");
              }
            } catch (e) {
              statusMessage += "Error reading user data";
            }
            
            Users.SendAdmin(user, statusMessage, fromRoom);
          } else {
            Users.SendAdmin(user, "User " + targetName + " not found", fromRoom);
          }
        }
      }
    } else if (thecmd == "!everyone") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        var rooms = zone.getRooms();
        var totalUserCount = 0;

        for (var j = 0; j < rooms.length; j++) {
          var currentRoom = rooms[j];
          var userCount = currentRoom.getAllUsers().length;
          totalUserCount += userCount;
        }

        Users.SendAdmin(
          user,
          "Total users across all rooms: " + totalUserCount,
          fromRoom
        );
      }
    } else if (thecmd == "!tp") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (!msgex[1]) {
          Users.SendAdmin(user, "Usage: !tp username", fromRoom);
        } else {
          var targetUsername = String(message.substring(4)).trim();

          var rmList = zone.getRooms();
          for (var i in rmList) {
            var musers = rmList[i].getAllUsers();
            for (var x in musers) {
              if (
                String(musers[x].getName().toLowerCase()) ==
                String(targetUsername.toLowerCase())
              ) {
                Users.SendJSON(user, {
                  _cmd: "gotoRoom",
                  isLocked: 0,
                  roomName: String(rmList[i].getName()),
                });
                return;
              }
            }
          }
          Users.SendAdmin(
            user,
            "User " + targetUsername + " not found",
            fromRoom
          );
        }
      }
    } else if (thecmd == "!summon") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        var targetUsername = String(message.substring(8)).trim();

        var rmList = zone.getRooms();
        for (var i in rmList) {
          var musers = rmList[i].getAllUsers();
          for (var x in musers) {
            if (
              String(musers[x].getName().toLowerCase()) ==
              String(targetUsername.toLowerCase())
            ) {
              Users.SendJSON(musers[x], {
                _cmd: "gotoRoom",
                isLocked: 0,
                roomName: String(fromRoom.getName()),
              });
              return;
            }
          }
        }
      }
    } else if (thecmd == "!promote") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (!msgex[1]) {
        } else {
          var targetName = String(message).replace("!promote ", "");
          var targetUser = Users.GetUserByName(targetName);
          if (targetUser != null) {
            targetUser.properties.put("isMod", 1);
            Users.UpdateCrumb(targetUser.properties.get("id"), "isMod", 1);

            _server.kickUser(
              targetUser,
              5,
              "Congratulations! You have been promoted to a moderator"
            );
          }
        }
      }
    } else if (thecmd == "!demote") {
      hide = true;
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (!msgex[1]) {
        } else {
          var targetName = String(message).replace("!demote ", "");
          var targetUser = Users.GetUserByName(targetName);
          if (targetUser != null) {
            targetUser.properties.put("isMod", 0);
            Users.UpdateCrumb(targetUser.properties.get("id"), "isMod", 0);

            _server.kickUser(
              targetUser,
              5,
              "You have been demoted from moderator"
            );
          }
        }
      }
    } else if (thecmd == "!ban") {
      if (user.isModerator() || user.properties.get("isSMod") == 1) {
        if (!msgex[1]) {
          Users.SendAdmin(user, "Usage: !ban [username]", fromRoom);
        } else {
          var targetUsername = String(message).replace("!ban ", "").trim();
          
          // Check if user exists in database
          var queryResult = dbase.executeQuery(
            "SELECT * FROM users WHERE username='" +
              _server.escapeQuotes(targetUsername) +
              "';"
          );
          
          if (queryResult && queryResult.size() > 0) {
            var targetz = Users.GetUserByName(targetUsername);
            var date = new Date();
            var permanentDate = new Date(
              date.getTime() + 1000 * 60 * 60 * 24 * 365 * 1000
            );
            var dateString = formatDate(permanentDate) + " 12:00";

            dbase.executeCommand(
              "UPDATE users SET ubdate='" +
                _server.escapeQuotes(dateString) +
                "' WHERE username='" +
                _server.escapeQuotes(targetUsername) +
                "';"
            );
            
            // Show success message to moderator first
            Users.SendAdmin(user, targetUsername + " has been banned permanently.", fromRoom);
            
            // Then try to kick if user is online
            if (targetz != null) {
              try {
                _server.kickUser(
                  targetz,
                  1,
                  "You have been banned! Please behave better next time..."
                );
              } catch (e) {
                trace("handlemessages.js: Error kicking user " + targetUsername + ": " + e);
                // User was banned in database, kick error doesn't matter
              }
            }
          } else {
            Users.SendAdmin(user, "Error: User '" + targetUsername + "' does not exist.", fromRoom);
          }
        }
      }
    } 
  }
  if (!user.properties.get("muted") && !hide)
    _server.dispatchPublicMessage(message, fromRoom, user);
}

// Ensure bad words are loaded from database when this module is loaded
try {
  if (typeof dbase !== 'undefined' && dbase !== null) {
    loadBadWordsFromDB();
    trace("handlemessages.js: Bad words loaded from database");
  } else {
    trace("handlemessages.js: Database not available yet, bad words will be loaded later");
  }
} catch (e) {
  trace("handlemessages.js: Error loading bad words: " + e);
}

// Function to check bad words status (can be called from other modules)
function checkBadWordsStatus() {
  var status = {
    badWordsLoaded: typeof badWords !== 'undefined',
    badWordsCount: typeof badWords !== 'undefined' ? badWords.length : 0,
    databaseAvailable: typeof dbase !== 'undefined' && dbase !== null
  };
  
  trace("handlemessages.js: Bad words status - " + JSON.stringify(status));
  return status;
}