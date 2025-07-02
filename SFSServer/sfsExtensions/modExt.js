var dbase;
var zone;
var _sfs;

function handleModCommand(cmd, params, user, fromRoom) {
  try {
    switch(cmd) {
      case "MOD_KICK": {
        if (user.isModerator()) {
          var targetUsername = params.username;
          
          // If username parameter isn't provided, try to get it from other properties
          if (!targetUsername && params.name) {
            targetUsername = params.name;
          } else if (!targetUsername && params.e) {
            targetUsername = Decoder.decodeData(params.e, 11);
          }
          
          if (targetUsername) {
            var targetUser = Users.GetUserByName(targetUsername);
            if (targetUser) {
              _server.kickUser(
                targetUser,
                3,
                "You have been kicked by a moderator."
              );
              Users.SendJSON(user, {
                _cmd: "modKick",
                isSuccess: true,
                username: targetUsername
              });
            } else {
              Users.SendJSON(user, {
                _cmd: "modKick",
                isSuccess: false,
                error: "User not found"
              });
            }
          } else {
            Users.SendJSON(user, {
              _cmd: "modKick",
              isSuccess: false,
              error: "No username provided"
            });
          }
        } else {
          Users.SendJSON(user, {
            _cmd: "modKick",
            isSuccess: false,
            error: "Insufficient permissions"
          });
        }
        break;
      }
      case "MOD_MUTE": {
        if (user.isModerator()) {
          var targetUsername = params.username;
          
          // If username parameter isn't provided, try to get it from other properties
          if (!targetUsername && params.name) {
            targetUsername = params.name;
          } else if (!targetUsername && params.e) {
            targetUsername = Decoder.decodeData(params.e, 11);
          }
          
          if (targetUsername) {
            var targetUser = Users.GetUserByName(targetUsername);
            if (targetUser) {
              // Toggle mute status with explicit check and forced values
              var currentMuted = targetUser.properties.get("muted");
              
              // Handle null or undefined muted status
              if (currentMuted === null || currentMuted === undefined || currentMuted === "") {
                currentMuted = "0"; // Default to unmuted
              }
              
              var isMuted = (currentMuted === "1") ? "0" : "1";
              
              targetUser.properties.put("muted", isMuted);
              
              var muteMessage = isMuted === "1" ? 
                "You have been muted by a moderator." : 
                "You have been unmuted by a moderator.";
              
              // Notify the target user via admin message
              Users.SendAdmin(targetUser, muteMessage, fromRoom);
              
              // Notify the moderator
              Users.SendAdmin(user, 
                (isMuted === "1" ? "Muted " : "Unmuted ") + targetUsername, 
                fromRoom);
              
              // Respond to the moderator with JSON
              Users.SendJSON(user, {
                _cmd: "modMute",
                isSuccess: true,
                username: targetUsername,
                isMuted: isMuted === "1"
              });
            } else {
              Users.SendJSON(user, {
                _cmd: "modMute",
                isSuccess: false,
                error: "User not found"
              });
            }
          } else {
            Users.SendJSON(user, {
              _cmd: "modMute",
              isSuccess: false,
              error: "No username provided"
            });
          }
        } else {
          Users.SendJSON(user, {
            _cmd: "modMute",
            isSuccess: false,
            error: "Insufficient permissions"
          });
        }
        break;
      }

      case "MOD_BAN":
      case "MOD_PERM_BAN": {
        if (user.isModerator()) {
          var targetUsername = params.username;
          
          // If username parameter isn't provided, try to get it from other properties
          if (!targetUsername && params.name) {
            targetUsername = params.name;
          } else if (!targetUsername && params.e) {
            targetUsername = Decoder.decodeData(params.e, 11);
          }
          
          if (targetUsername) {
            var targetUser = Users.GetUserByName(targetUsername);
            if (targetUser) {
              var isPermanent = cmd === "MOD_PERM_BAN";
              
              // Set ban in database
              var banQuery;
              if (isPermanent) {
                banQuery = "UPDATE users SET ubdate='PERMABANNED' WHERE username='" +
                  _server.escapeQuotes(targetUsername) + "';";
              } else {
                var date = new Date();
                var banDate = new Date(date.getTime() + (24 * 60 * 60 * 1000)); // 24 hours from now
                var dateString = formatDate(banDate) + " 12:00";
                banQuery = "UPDATE users SET ubdate='" + _server.escapeQuotes(dateString) + 
                  "' WHERE username='" + _server.escapeQuotes(targetUsername) + "';";
              }
              
              dbase.executeCommand(banQuery);
              
              // Kick the user
              _server.kickUser(
                targetUser,
                1,
                isPermanent ? "You have been permanently banned." : "You have been banned for 24 hours."
              );
              
              // Notify the moderator
              Users.SendAdmin(user, 
                (isPermanent ? "Permanently banned " : "Banned ") + targetUsername + 
                (isPermanent ? "" : " for 24 hours"), 
                fromRoom);
              
              // Respond to the moderator with JSON
              Users.SendJSON(user, {
                _cmd: isPermanent ? "modPermBan" : "modBan",
                isSuccess: true,
                username: targetUsername
              });
            } else {
              Users.SendJSON(user, {
                _cmd: isPermanent ? "modPermBan" : "modBan",
                isSuccess: false,
                error: "User not found"
              });
            }
          } else {
            Users.SendJSON(user, {
              _cmd: isPermanent ? "modPermBan" : "modBan",
              isSuccess: false,
              error: "No username provided"
            });
          }
        } else {
          Users.SendJSON(user, {
            _cmd: isPermanent ? "modPermBan" : "modBan",
            isSuccess: false,
            error: "Insufficient permissions"
          });
        }
        break;
      }
    }
  } catch (e) {
    trace("Error in modExt handler: " + e);
  }
}

function init() {
  dbase = _server.getDatabaseManager();
  zone = _server.getCurrentZone();
  _sfs = Packages.it.gotoandplay.smartfoxserver.SmartFoxServer;
}

function destroy() {
  trace("ModExt extension destroyed");
} 