var Commands = {};

function handlePublicMessage(user, message, fromRoom) {
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
    } else if (thecmd == "!fashionshow") {
      hide = true;
      if (user.isModerator()) {
        if (!msgex[1]) {
        } else {
          fashionShowItem = msgex[1];
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
              10,
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
            targetUser.properties.put("isSafe", 0);
            Users.UpdateCrumb(targetUser.properties.get("id"), "isSafe", 0);

            Users.SendAdmin(
              targetUser,
              "You have been unmuted. Please remember to follow the rules!",
              fromRoom
            );
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
    }
  }
  if (!user.properties.get("muted") && !hide)
    _server.dispatchPublicMessage(message, fromRoom, user);
}
