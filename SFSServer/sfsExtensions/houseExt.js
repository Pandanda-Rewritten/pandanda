var dbase, zone, _sfs, bunnyGameState;

eval(_server.readFile("utils/json.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/xn_name_map.js"));
eval(_server.readFile("utils/eventListener.js"));

var Commands = {};

function sendRoom(room, what) {
  var usrz = room.getAllUsers();
  for (i in usrz) {
    try {
      Users.SendJSON(usrz[i], what);
    } catch (e) {}
  }
}
function handlePandandaPacket(cmd, params, user, fromRoom) {
  var header = cmd.split("##")[1];
  if (header == undefined) header = cmd;
  if (XT_Hash[header] != null && XT_Hash[header] != "") {
    trace("Got a packet: " + XT_Hash[header]);
    try {
      switch (XT_Hash[header]) {
        case "PET_ACTION": {
          var action = params["action"];
          var petindex = params["petIndex"];
          trace(action);
          switch (action) {
            case "sleep": {
              sendRoom(fromRoom, {
                _cmd: "petsUpdate",
                isSuccess: true,
                pets: petindex + ",anim:sleep",
              });
              break;
            }
            case "love": {
              sendRoom(fromRoom, {
                _cmd: "petsUpdate",
                isSuccess: true,
                pets: petindex + ",anim:love",
              });
              break;
            }
            case "treat": {
              sendRoom(fromRoom, {
                _cmd: "petsUpdate",
                isSuccess: true,
                pets: petindex + ",anim:treat",
              });
              break;
            }
            case "feed": {
              sendRoom(fromRoom, {
                _cmd: "petsUpdate",
                isSuccess: true,
                pets: petindex + ",anim:feed",
              });
              break;
            }
            case "dance": {
              sendRoom(fromRoom, {
                _cmd: "petsUpdate",
                isSuccess: true,
                pets: petindex + ",anim:dance",
              });
              break;
            }
            case "fly": {
              sendRoom(fromRoom, {
                _cmd: "petsUpdate",
                isSuccess: true,
                pets: petindex + ",anim:fly",
              });
              break;
            }
            case "nofly": {
              sendRoom(fromRoom, {
                _cmd: "petsUpdate",
                isSuccess: true,
                pets: petindex + ",anim:nofly",
              });
              break;
            }
            case "fire": {
              sendRoom(fromRoom, {
                _cmd: "petsUpdate",
                isSuccess: true,
                pets: petindex + ",anim:fire",
              });
              break;
            }
            case "walk": {
              try {
                var room = user.properties.get("room");
                if (!room) {
                  trace("Walk error: No room found");
                  break;
                }

                var petsStr = String(room.getVariable("pets") || "");
                if (!petsStr) {
                  trace("Walk error: No pets in room");
                  break;
                }

                var petEntries = petsStr.split(";");
                var petIndex = Number(petindex);

                if (
                  isNaN(petIndex) ||
                  petIndex < 0 ||
                  petIndex >= petEntries.length
                ) {
                  trace("Walk error: Invalid pet index");
                  break;
                }

                var petData = petEntries[petIndex].split(",");
                if (petData.length < 8) {
                  trace("Walk error: Invalid pet data format");
                  break;
                }

                var petBirthday = petData[3];
                var petex = petBirthday.split("/");
                var eh =
                  petex[2] + "-" + petex[0] + "-" + petex[1] + " 17:29:54";
                var qRes = dbase.executeQuery(
                  "SELECT DATEDIFF(NOW(), '" + eh + "') AS days;"
                );
                if (qRes.size() == 0) break;

                var daysold = String(Number(qRes.get(0).getItem("days")) + 4);

                _server.setUserVariables(user, {
                  pet: [
                    user.getName(),
                    petData[1],
                    petData[2],
                    petBirthday,
                    daysold,
                    "100:100:100",
                    "0",
                    "0",
                  ].join(","),
                });
                Users.SendJSON(user, {
                  _cmd: "petsUpdate",
                  isSuccess: true,
                  pets: String(user.properties.get("hiddenPet")) + ",show",
                });

                user.properties.put("hiddenPet", String(petindex));

                sendRoom(fromRoom, {
                  _cmd: "petsUpdate",
                  isSuccess: true,
                  pets: petindex + ",hide",
                });
              } catch (e) {
                trace("Walk error: " + e);
              }
              break;
            }
            default: {
              trace("Unknown pet action: " + action);
              break;
            }
          }
          break;
        }
        case "GET_PET_INFO": {
          var petid = Number(params["petIndex"]);
          var room = fromRoom;

          if (room) {
            var petsStr = String(room.getVariable("pets"));

            if (petsStr) {
              var petArray = petsStr.split(";");

              if (petid >= 0 && petid < petArray.length) {
                Users.SendJSON(user, {
                  _cmd: "petCard",
                  index: String(petid),
                  info: petArray[petid],
                });
              } else {
                trace("Invalid pet index: " + petid);
              }
            } else {
              trace("No pets variable found in room");
            }
          } else {
            trace("No room provided in GET_PET_INFO");
          }
          break;
        }
        case "BUY_PET_FOOD": {
          var petid = Number(params["petIndex"]);
          var action = String(params["action"]);
          var price = Number(params["price"]);
          sendRoom(fromRoom, {
            _cmd: "petsUpdate",
            isSuccess: true,
            pets: petid + ",anim:" + action,
          });
          break;
        }
        default: {
          trace("No house handler found for: " + XT_Hash[header]);
          break;
        }
      }
    } catch (e) {
      trace("Error while handling " + XT_Hash[header] + ": " + e);
    }
  } else {
    trace("Unknown handler hash: " + header);
  }
}

function init() {
  dbase = _server.getDatabaseManager();
  zone = _server.getCurrentZone();
  _sfs = Packages.it.gotoandplay.smartfoxserver.SmartFoxServer;
  _server.getCurrentZone().setPubMsgInternalEvent(true);
}
function destroy() {
  trace("Nice knowing you, bye! :)");
}
