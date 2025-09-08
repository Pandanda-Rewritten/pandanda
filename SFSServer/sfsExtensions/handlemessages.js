var Commands = {};

// Helper function to pad numbers with leading zeros
function padZero(num) {
  return (num < 10 ? '0' : '') + num;
}

function handlePublicMessage(user, message, fromRoom) {
  // Debug check for mute status
  trace("Message from " + user.getName() + ", muted status: " + user.properties.get("muted"));
  
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

          if (queryResult) {
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
    } else if (thecmd == "!festivalexchange") {
      hide = true;
      // Usage: !festivalExchange <amount>
      // Exchanges (deducts) an amount of festival tickets from user's balance.
      // Allowed range: 15 - 50 inclusive.
      if (msgex.length < 2) {
        Users.SendAdmin(user, "Usage: !festivalExchange amount (15-50)", fromRoom);
      } else {
        var amount = parseInt(msgex[1]);
        if (isNaN(amount)) {
          Users.SendAdmin(user, "Please enter a valid number between 15 and 50", fromRoom);
          return;
        }
        if (amount < 15 || amount > 50) {
          Users.SendAdmin(user, "Amount must be between 15 and 50", fromRoom);
          return;
        }

        var currentTickets = Number(user.properties.get("festivalCollection")) || 0;
        if (currentTickets < amount) {
          Users.SendAdmin(user, "You do not have enough festival tickets (You currently have " + currentTickets + ")", fromRoom);
          return;
        }

        var newBalance = currentTickets - amount;
        user.properties.put("festivalCollection", newBalance);
        Users.UpdateCrumb(user.properties.get("id"), "festivalCollection", newBalance);

        // Grant 5 coins per exchanged ticket
        var currentCoins = Number(user.properties.get("coins")) || 0;
        var coinsToAdd = amount * 5;
        var newCoins = currentCoins + coinsToAdd;
        user.properties.put("coins", newCoins);
        Users.UpdateCrumb(user.properties.get("id"), "coins", newCoins);

        // Notify user in chat and via JSON updates used elsewhere in the client
        Users.SendAdmin(user, "Exchanged " + amount + " festival tickets for " + coinsToAdd + " coins. New tickets: " + newBalance + ", coins: " + newCoins, fromRoom);
        Users.SendJSON(user, {
          _cmd: "festivalCollection",
          count: newBalance,
          success: true,
        });
        Users.SendJSON(user, {
          _cmd: "coinUpdate",
          coins: newCoins,
          success: true,
        });
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
        } else {
          var targetz = Users.GetUserByName(
            String(message).replace("!ban ", "")
          );
          if (targetz != null) {
            var date = new Date();
            var permanentDate = new Date(
              date.getTime() + 1000 * 60 * 60 * 24 * 365 * 1000
            );
            var dateString = formatDate(permanentDate) + " 12:00";

            dbase.executeCommand(
              "UPDATE users SET ubdate='" +
                _server.escapeQuotes(dateString) +
                "' WHERE username='" +
                _server.escapeQuotes(String(message).replace("!ban ", "")) +
                "';"
            );
            _server.kickUser(
              targetz,
              10,
              "You have been banned! Please behave better next time..."
            );
          }
        }
      }
    } // else if (thecmd == "!quest_status") {
    //   hide = true;
    //   if (user.isModerator() || user.properties.get("isSMod") == 1) {
    //     try {
    //       var statusResult = dbase.executeQuery(
    //         "SELECT " +
    //         "(SELECT config_value FROM questConfig WHERE config_key = 'currentQListDay') AS currentDay, " +
    //         "(SELECT config_value FROM questConfig WHERE config_key = 'totalQListDays') AS totalDays, " +
    //         "(SELECT config_value FROM questConfig WHERE config_key = 'lastRotationDate') AS lastRotation, " +
    //         "(SELECT config_value FROM questConfig WHERE config_key = 'rotationHour') AS rotationHour, " +
    //         "(SELECT value FROM config WHERE `key` = 'qAvailable') AS currentQuests"
    //       );
          
    //       if (statusResult && statusResult.size() > 0) {
    //         var currentDay = statusResult.get(0).getItem("currentDay");
    //         var totalDays = statusResult.get(0).getItem("totalDays");
    //         var lastRotation = statusResult.get(0).getItem("lastRotation") || "Never";
    //         var rotationHour = statusResult.get(0).getItem("rotationHour");
            
    //         var statusMessage = "Quest Rotation Status: " +
    //           "Current Day: " + currentDay + " of " + totalDays + ", " +
    //           "Last Rotation: " + lastRotation + ", " +
    //           "Rotation Hour: " + rotationHour + " UTC";
            
    //         Users.SendAdmin(user, statusMessage, fromRoom);
    //       } else {
    //         Users.SendAdmin(user, "Could not retrieve quest configuration", fromRoom);
    //       }
    //     } catch (e) {
    //       Users.SendAdmin(user, "Error retrieving quest status: " + e, fromRoom);
    //     }
    //   }
    //}  else if (thecmd == "!quest_rotate") {
    //   hide = true;
    //   if (user.isModerator() || user.properties.get("isSMod") == 1) {
    //     try {
    //       // Get current configuration
    //       var configResult = dbase.executeQuery(
    //         "SELECT " +
    //         "(SELECT config_value FROM questConfig WHERE config_key = 'currentQListDay') AS currentQListDay, " +
    //         "(SELECT config_value FROM questConfig WHERE config_key = 'totalQListDays') AS totalQListDays"
    //       );
          
    //       if (configResult && configResult.size() > 0) {
    //         var currentQListDay = parseInt(configResult.get(0).getItem("currentQListDay")) || 1;
    //         var totalQListDays = parseInt(configResult.get(0).getItem("totalQListDays")) || 7;
            
    //         // Increment the day, looping back to 1 after reaching the total
    //         var nextQListDay = (currentQListDay % totalQListDays) + 1;
            
    //         // Get the quest list for the next day
    //         var qListKey = "qListDay" + nextQListDay;
    //         var qListResult = dbase.executeQuery(
    //           "SELECT config_value " +
    //           "FROM questConfig " +
    //           "WHERE config_key = '" + qListKey + "'"
    //         );
            
    //         if (qListResult && qListResult.size() > 0 && qListResult.get(0).getItem("config_value")) {
    //           var newQuestList = qListResult.get(0).getItem("config_value");
              
    //           // Update the currentQListDay
    //           dbase.executeCommand(
    //             "UPDATE questConfig " +
    //             "SET config_value = '" + nextQListDay + "' " +
    //             "WHERE config_key = 'currentQListDay'"
    //           );
              
    //           // Update the qAvailable in the main config table
    //           dbase.executeCommand(
    //             "UPDATE config " +
    //             "SET value = '" + _server.escapeQuotes(newQuestList) + "' " +
    //             "WHERE `key` = 'qAvailable'"
    //           );
              
    //           // Also update the questHash to trigger quest updates for users when they log in
    //           var newQuestHash = "quest_" + new Date().getTime();
    //           dbase.executeCommand(
    //             "UPDATE config " +
    //             "SET value = '" + _server.escapeQuotes(newQuestHash) + "' " +
    //             "WHERE `key` = 'questHash'"
    //           );
              
    //           // Update last rotation date
    //           var now = new Date();
    //           var formattedDate = formatDate(now);
    //           dbase.executeCommand(
    //             "UPDATE questConfig " +
    //             "SET config_value = '" + formattedDate + "' " +
    //             "WHERE config_key = 'lastRotationDate'"
    //           );
              
    //           Users.SendAdmin(
    //             user, 
    //             "Quest rotation successful. Moved from Day " + currentQListDay + 
    //             " to Day " + nextQListDay + " with hash " + newQuestHash,
    //             fromRoom
    //           );
    //         } else {
    //           // If next day doesn't exist, cycle back to day 1
    //           nextQListDay = 1;
              
    //           dbase.executeCommand(
    //             "UPDATE questConfig " +
    //             "SET config_value = '" + nextQListDay + "' " +
    //             "WHERE config_key = 'currentQListDay'"
    //           );
              
    //           // Get the quest list for day 1
    //           qListResult = dbase.executeQuery(
    //             "SELECT config_value " +
    //             "FROM questConfig " +
    //             "WHERE config_key = 'qListDay1'"
    //           );
              
    //           if (qListResult && qListResult.size() > 0 && qListResult.get(0).getItem("config_value")) {
    //             var newQuestList = qListResult.get(0).getItem("config_value");
                
    //             // Update the qAvailable in the main config table
    //             dbase.executeCommand(
    //               "UPDATE config " +
    //               "SET value = '" + _server.escapeQuotes(newQuestList) + "' " +
    //               "WHERE `key` = 'qAvailable'"
    //             );
                
    //             // Also update the questHash to trigger quest updates for users when they log in
    //             var newQuestHash = "quest_" + new Date().getTime();
    //             dbase.executeCommand(
    //               "UPDATE config " +
    //               "SET value = '" + _server.escapeQuotes(newQuestHash) + "' " +
    //               "WHERE `key` = 'questHash'"
    //             );
                
    //             // Update last rotation date
    //             var now = new Date();
    //             var formattedDate = formatDate(now);
    //             dbase.executeCommand(
    //               "UPDATE questConfig " +
    //               "SET config_value = '" + formattedDate + "' " +
    //               "WHERE config_key = 'lastRotationDate'"
    //             );
                
    //             Users.SendAdmin(
    //               user, 
    //               "Next day not found. Cycled back to Day 1 with hash " + newQuestHash,
    //               fromRoom
    //             );
    //           } else {
    //             Users.SendAdmin(user, "Error: Could not find quest list for day 1", fromRoom);
    //           }
    //         }
    //       } else {
    //         Users.SendAdmin(user, "Error: Could not retrieve quest configuration", fromRoom);
    //       }
    //     } catch (e) {
    //       Users.SendAdmin(user, "Error rotating quest list: " + e, fromRoom);
    //     }
    //   }
    // }
  }
  if (!user.properties.get("muted") && !hide)
    _server.dispatchPublicMessage(message, fromRoom, user);
}