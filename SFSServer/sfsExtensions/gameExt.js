/*
 * If you somehow have this code, I will h̸a̸t̸e̸  love you forever. G̸o̸ ̸d̸i̸e̸  Stay safe.
 * Sincerely, J̸a̸m̸e̸s̸  ???????.
 */

var dbase, zone, _sfs, celebItem;
var popInterval;

eval(_server.readFile("utils/json.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/xn_name_map.js"));
eval(_server.readFile("badwords.js"));
eval(_server.readFile("handlemessages.js"));
eval(_server.readFile("helpers.js"));
eval(_server.readFile("utils/eventListener.js"));
eval(_server.readFile("login.js"));
eval(_server.readFile("quests.js"));
eval(_server.readFile("petHandlers.js"));
eval(_server.readFile("modExt.js"));

var Commands = {};

function checkItemLevelRequirement(user, itemId) {
    // Get user's level from crumbs
    var userLevel = Number(user.properties.get("level")) || 1;

    // Derive base code (remove last char when it is a letter and the item is not a mount)
    var baseCode = itemId;
    if (itemId[0] !== "M" && /[a-zA-Z]$/.test(itemId)) {
        baseCode = itemId.slice(0, -1);
    }

    var requiredLevel = 0;

    // Try exact code first
    var qRes = dbase.executeQuery(
        "SELECT level_required FROM items WHERE item_code='" +
        _server.escapeQuotes(itemId) + "' LIMIT 1;"
    );
    if (qRes != null && qRes.size() > 0) {
        requiredLevel = Number(qRes.get(0).getItem("level_required")) || 0;
    } else if (baseCode !== itemId) {
        // Fallback to base code when no exact row exists
        qRes = dbase.executeQuery(
            "SELECT level_required FROM items WHERE item_code='" +
            _server.escapeQuotes(baseCode) + "' LIMIT 1;"
        );
        if (qRes != null && qRes.size() > 0) {
            requiredLevel = Number(qRes.get(0).getItem("level_required")) || 0;
        }
    }

    if (requiredLevel > 0 && userLevel < requiredLevel) {
        return {
            allowed: false,
            requiredLevel: requiredLevel
        };
    }

    return { allowed: true };
}

function handlePandandaPacket(cmd, params, user, fromRoom) {
  var roomObj = fromRoom;
  var header = cmd.split("##")[1];
  if (header == undefined) header = cmd;
  if (XT_Hash[header] != null && XT_Hash[header] != "") {
    trace("Got a packet: " + XT_Hash[header]);
    try {
      switch (XT_Hash[header]) {
        case "MOD_MSG": {
          handlePublicMessage(user, params.msg, fromRoom);
          break;
        }
        case "MOD_KICK":
        case "MOD_MUTE":
        case "MOD_BAN":
        case "MOD_PERM_BAN":
        case "PERM_BAN": {
          handleModCommand(XT_Hash[header], params, user, fromRoom);
          break;
        }
        case "MG_GET_STATS": {
          break;
        }
        case "GET_USER_INFO":
        case "MOD_GET_USER_INFO": {
          var RequestedName = "";
          if (params["e"] != null && params["e"] != "") {
            RequestedName = Decoder.decodeData(params["e"], 11).split(",");
          } else if (params["name"] != null && params["name"] != "") {
            RequestedName = params["name"].split(",");
          } else {
            return;
          }
          if (
            (qRes = dbase.executeQuery(
              'SELECT *, DATE_FORMAT(regdate, "%m/%d/%Y") AS datey FROM users WHERE username=\'' +
                _server.escapeQuotes(RequestedName) +
                "';"
            )).size() == 0
          )
            return Users.SendJSON(user, { _cmd: "userInfo", isSuccess: false });
          var birthdateString = qRes.get(0).getItem("datey").split(",")[0];
          var birthdate = new Date(birthdateString);
          var ageInMilliseconds = Date.now() - birthdate.getTime();
          var ageInDays = Math.floor(ageInMilliseconds / (1000 * 60 * 60 * 24));
          var userCrumbs = JSON.parse(qRes.get(0).getItem("crumbs"));
          Users.SendJSON(user, {
            isHouse: userCrumbs.bh,
            birthday: qRes.get(0).getItem("datey") + "",
            friendCount: String(
              zone.loadBuddyList(String(RequestedName)).buddies.size()
            ),
            color: Number(userCrumbs.color),
            quests: userCrumbs.qCount,
            isMod: userCrumbs.isMod,
            wearing: userCrumbs.wearing,
            cardColor: userCrumbs.cardColor,
            isMember: userCrumbs.isMember,
            cardBG: userCrumbs.cardBG,
            gold: userCrumbs.gold,
            _cmd: "userInfo",
            xp: userCrumbs.xp,
            level: userCrumbs.level,
            name: String(RequestedName),
            age: ageInDays + " days",
            mood: userCrumbs.mood,
            bff: userCrumbs.bff,
            isVIP: userCrumbs.isVIP,
            heart: userCrumbs.heart,
            isSuccess: true,
          });
          break;
        }
        case "JOIN_ROOM": {
          var Room = Decoder.decodeData(params["e"], 11);
          if ((roomObj = zone.getRoomByName(Room)) == null)
            Users.SendJSON(user, { _cmd: "joinFail" });
          if (
            !_server.joinRoom(
              user,
              fromRoom == null ? -1 : fromRoom.getId(),
              true,
              roomObj.getId()
            )
          )
            Users.SendJSON(user, { _cmd: "joinFail" });
          _server.setUserVariables(user, {
            px: 530,
            py: 400,
          });
          
          // Check for login item when user joins their first room after login
          if (!user.properties.get("loginItemChecked")) {
            // Mark as checked for this session to prevent multiple checks
            user.properties.put("loginItemChecked", true);
            
            // Check and give login item if conditions are met
            if (typeof checkAndGiveLoginItem === "function") {
              checkAndGiveLoginItem(user);
            }
          }
          
          break;
        }
        case "GET_USER_ROOM": {
          var whotojoin = Decoder.decodeData(params["e"], 11);
          var rmList = zone.getRooms();

          for (i in rmList) {
            var musers = rmList[i].getAllUsers();
            for (x in musers) {
              if (
                String(musers[x].getName().toLowerCase()) ==
                String(whotojoin.toLowerCase())
              ) {
                var roomName = String(rmList[i].getName());
                var targetUsername = String(whotojoin.toLowerCase());
                var expectedRoomName = "TH_" + targetUsername;

                var isLocked = 0;
                if (roomName.toLowerCase() === expectedRoomName.toLowerCase()) {
                  var qRes = dbase.executeQuery(
                    "SELECT crumbs FROM users WHERE username='" +
                      _server.escapeQuotes(targetUsername) +
                      "';"
                  );

                  if (qRes.size() > 0) {
                    var targetUserCrumbs = JSON.parse(
                      qRes.get(0).getItem("crumbs")
                    );
                    isLocked = targetUserCrumbs.bh ? 0 : 1;
                  }
                }

                Users.SendJSON(user, {
                  _cmd: "gotoRoom",
                  isLocked: isLocked,
                  roomName: roomName,
                });
                return;
              }
            }
          }
          break;
        }
        case "GET_ROOM_POSITIONS": {
          var UserList = roomObj.getAllUsers();
          var Positions = new Array();

          if (roomObj.getName().indexOf("TH_") == 0) {
            var roomOwnerName = roomObj.getName().substring(3).toString();
            if (roomObj.getVariable("furniture") == null) {
              trace("NULL FURNITURE!");

              try {
                var qRes = dbase.executeQuery(
                  "SELECT * FROM users WHERE username='" +
                    _server.escapeQuotes(roomOwnerName) +
                    "';"
                );

                if (qRes.size() > 0) {
                  var crumbsData = qRes.get(0).getItem("crumbs");
                  if (crumbsData && crumbsData != "") {
                    try {
                      var userCrumbs = JSON.parse(crumbsData);
                      if (userCrumbs.furniture) {
                        var mFurnToSet = userCrumbs.furniture.split("#")[0];
                        trace("Setting vars! " + mFurnToSet);

                        var rfurnVars = [
                          {
                            name: "furniture",
                            val: mFurnToSet,
                            priv: false,
                          },
                        ];
                        _server.setRoomVariables(fromRoom, null, rfurnVars);
                      }
                    } catch (e) {
                      trace("Error parsing crumbs JSON:", e);
                    }
                  }
                }
              } catch (e) {
                trace("Database query error:", e);
              }
            }

            Users.SendJSON(user, {
              _cmd: "petsUpdate",
              isSuccess: true,
              pets: String(user.properties.get("hiddenPet")) + ",hide",
            });
          }

          for (var i in UserList) {
            var px = UserList[i].getVariable("px");
            var py = UserList[i].getVariable("py");
            Positions.push(
              UserList[i].getUserId() +
                "," +
                (px ? px.getValue() : 0) +
                "," +
                (py ? py.getValue() : 0)
            );
          }

          Users.SendJSON(user, {
            _cmd: "roomPositions",
            pos: Positions.join(";"),
          });

          break;
        }
        case "POS": {
          _server.setUserVariables(user, {
            px: parseInt(params.x) || 330,
            py: parseInt(params.y) || 300,
          });
          break;
        }
        case "PET_RETURN_HOME": {
          _server.setUserVariables(user, {
            pet: "",
          });

          Users.SendJSON(user, {
            _cmd: "petsUpdate",
            isSuccess: true,
            pets: String(user.properties.get("hiddenPet")) + ",show",
          });

          user.properties.put("hiddenPet", "");

          break;
        }
        case "ADD_BACKPACK": {
          var Itemel = Decoder.decodeData(params["e"], 11);
          try {
            addBackpack(user, Itemel);
          } catch (e) {
            trace("add backpack error " + e);
          }
          Users.SendJSON(user, {
            _cmd: "addBackpack",
            isSuccess: true,
            item: Itemel,
          });
          break;
        }
        case "GET_PRICES": {
          var Requested = Decoder.decodeData(params["e"], 11).split(",");
          var priceList = user.properties.get("priceList") || "";
          var Costs = [];

          for (var i in Requested) {
            var itemId = Requested[i].split(":")[0];
            Costs.push(getItemPrice(itemId, priceList));
          }
          Users.SendJSON(user, {
            _cmd: "priceList",
            priceList: String(Costs.join(",")),
            gold: 100000,
          });
          break;
        }
        case "PURCHASE_ITEMS": {
          var itype = "error";
          var Items = Decoder.decodeData(params["e"], 11).split(",");
          trace(Decoder.decodeData(params["e"], 11));

          var uniqueItems = [];
          var seenItems = {};

          for (var i = 0; i < Items.length; i++) {
            var item = Items[i].trim();

            if (item.indexOf("F") === 0 || item.indexOf("GI") === 0) {
              uniqueItems.push(item);
            } else {
              if (!seenItems[item] && !hasItem(user, item)) {
                uniqueItems.push(item);
                seenItems[item] = true;
              }
            }
          }

          if (uniqueItems.length === 0) {
            return Users.SendJSON(user, {
              _cmd: "purchaseItem",
              isSuccess: false,
              msg: "Item already owned.",
            });
          }

          // Check level requirements for all items
          for (var i in uniqueItems) {
            var levelCheck = checkItemLevelRequirement(user, uniqueItems[i]);
            if (!levelCheck.allowed) {
              return Users.SendJSON(user, {
                _cmd: "purchaseItem",
                isSuccess: false,
                msg: "You need to be level " + levelCheck.requiredLevel + " or higher to purchase this item.",
              });
            }
          }

          var priceList = user.properties.get("priceList") || "";
          var currentCoins = Number(user.properties.get("coins"));
          var totalCost = 0;

          for (var i in uniqueItems) {
            var item = uniqueItems[i];
            var itemCost = getItemPrice(item, priceList);
            totalCost += itemCost;
          }

          if (currentCoins < totalCost) {
            return Users.SendJSON(user, {
              _cmd: "purchaseItem",
              isSuccess: false,
              msg: "Not enough coins!",
              coins: currentCoins,
            });
          }

          var newCoinBalance = currentCoins - totalCost;
          user.properties.put("coins", newCoinBalance);
          Users.UpdateCrumb(user.properties.get("id"), "coins", newCoinBalance);

          for (var i in uniqueItems) {
            try {
              if (uniqueItems[i][0] == "C") {
                purchaseItem(user, uniqueItems[i]);
                itype = "clothes";
              } else if (uniqueItems[i][0] == "M") {
                purchaseMount(user, uniqueItems[i]);
                itype = "mount";
              } else if (uniqueItems[i].indexOf("F") == 0) {
                purchaseFurniture(user, uniqueItems[i]);
                itype = "storage";
              } else if (uniqueItems[i].indexOf("GI") == 0) {
                purchaseBackpack(user, uniqueItems[i]);
                itype = "backpack";
              } else {
                purchaseItem(user, uniqueItems[i]);
                itype = "clothes";
              }
            } catch (e) {
              return Users.SendJSON(user, {
                _cmd: "purchaseItem",
                isSuccess: false,
                msg: e.message,
              });
            }
          }

          if (itype == "mount") {
            Users.SendJSON(user, {
              _cmd: "purchaseItem",
              isSuccess: true,
              coins: newCoinBalance,
              mount: uniqueItems.join(","),
            });
          } else if (itype == "clothes") {
            Users.SendJSON(user, {
              _cmd: "purchaseItem",
              isSuccess: true,
              coins: newCoinBalance,
              clothes: uniqueItems.join(","),
            });
          } else if (itype == "backpack") {
            Users.SendJSON(user, {
              _cmd: "purchaseItem",
              isSuccess: true,
              coins: newCoinBalance,
              backpack: uniqueItems.join(","),
            });
          } else if (itype == "storage") {
            Users.SendJSON(user, {
              _cmd: "purchaseItem",
              isSuccess: true,
              coins: newCoinBalance,
              furniture: uniqueItems.join(","),
            });
          }
          break;
        }
        case "CHANGE_CLOTHES": {
          var Clothes = Decoder.decodeData(params["e"], 11);
          var Items = Clothes.split(",");
          var newear = [];
          var tehcolor = Number(user.properties.get("color"));
          for (i in Items) {
            if (Items[i].indexOf("BG") == 0) {
              user.properties.put("cardBG", Items[i]);
              Users.UpdateCrumb(user.properties.get("id"), "cardBG", Items[i]);
            }
            if (Items[i].indexOf("P") == 0) {
              tehcolor = Number(String(Items[i]).substr(1)) - 1;
              user.properties.put("color", tehcolor);
              Users.UpdateCrumb(user.properties.get("id"), "color", tehcolor);
            }

            newear.push(String(Items[i]));
          }
          user.properties.put("wearing", newear.join(","));
          Users.UpdateCrumb(
            user.properties.get("id"),
            "wearing",
            newear.join(",")
          );
          _server.setUserVariables(user, {
            pw: newear.join(","),
            pc: tehcolor,
          });
          break;
        }
        case "CHANGE_CARD_COLOR": {
          var decoded = Decoder.decodeData(params["e"], 11);
          user.properties.put("cardColor", decoded);
          Users.UpdateCrumb(user.properties.get("id"), "cardColor", decoded);
          break;
        }
        case "SELL_ITEMS": {
          var Items = Decoder.decodeData(params["e"], 11).split(",");

          var priceList = user.properties.get("priceList") || "";
          var totalSellPrice = 0;

          for (var i in Items) {
            var item = Items[i];
            var itemPrice = getItemPrice(item, priceList);
            totalSellPrice += itemPrice;

            removeBackpackItem(user, item);
          }

          var currentCoins = Number(user.properties.get("coins"));
          var newCoinBalance = currentCoins + totalSellPrice;

          user.properties.put("coins", newCoinBalance);

          Users.UpdateCrumb(user.properties.get("id"), "coins", newCoinBalance);

          var backpack = String(user.properties.get("backpack"));
          var storage = String(user.properties.get("storage"));
          var clothes = String(user.properties.get("closet"));
          var mounts = String(user.properties.get("mounts"));

          Users.SendJSON(user, {
            _cmd: "sellItems",
            isSuccess: true,
            coins: newCoinBalance,
            backpack: backpack,
            clothes: clothes,
            storage: storage,
            mounts: mounts,
          });
          break;
        }
        case "USE_ITEM": {
          var Item = Decoder.decodeData(params["e"], 11).split(",");
          removeBackpackItem(user, Item);
          Users.SendJSON(user, {
            _cmd: "useItem",
            isSuccess: true,
            itemId: Item,
          });
          break;
        }
        case "CREATE_HOUSE": {
          var mName = Decoder.decodeData(params["e"], 11);
          var newroomObj = {};
          newroomObj.name = mName;
          newroomObj.maxU = 50;
          newroomObj.isTemp = true;
          newroomObj.isLimbo = false;
          newroomObj.isPrivate = false;
          var newRoom = _server.createRoom(newroomObj, user, true, true);
          if (newRoom == null) Users.SendJSON(user, { _cmd: "joinFail" });
          if (
            !_server.joinRoom(
              user,
              fromRoom == null ? -1 : fromRoom.getId(),
              true,
              zone.getRoomByName(mName).getId()
            )
          )
            Users.SendJSON(user, { _cmd: "joinFail" });
          _server.setUserVariables(user, {
            px: 530,
            py: 400,
          });          
          break;
        }

        case "TOGGLE_HOUSE": {
          var doOpen = params["doOpen"];
          user.properties.put("bh", doOpen);

          Users.UpdateCrumb(user.properties.get("id"), "bh", doOpen);

          _server.setUserVariables(user, {
            bh: doOpen,
          });

          break;
        }

        case "ADD_TREASURE": {
          var decoded = Decoder.decodeData(params["e"], 11);

          var parts = decoded.split(",");

          if (parts.length < 2) {
            return Users.SendJSON(user, {
              _cmd: "gameMsg",
              msg: "Invalid treasure data",
            });
          }

          var item = parts[0].trim();
          var coinsToAdd = Number(parts[1].trim());

          if (isNaN(coinsToAdd)) {
            return Users.SendJSON(user, {
              _cmd: "gameMsg",
              msg: "Invalid coin amount",
            });
          }

          var backpack = String(user.properties.get("backpack"));
          var backpackItems = backpack.split(",");
          var targetItems = ["GI601", "GI615", "GI617", "GI619"];

          var chestRemoved = false;
          for (var i = 0; i < backpackItems.length && !chestRemoved; i++) {
            var currentItem = backpackItems[i].trim();

            for (var j = 0; j < targetItems.length; j++) {
              if (currentItem.indexOf(targetItems[j]) === 0) {
                removeBackpackItem(user, currentItem);
                Users.SendJSON(user, {
                  itemId: currentItem,
                  isSuccess: true,
                  _cmd: "useItem",
                });
                chestRemoved = true;
                break;
              }
            }
          }
          var currentCoins = Number(user.properties.get("coins")) || 0;
          var newCoins = currentCoins + coinsToAdd;

          user.properties.put("coins", newCoins);
          Users.UpdateCrumb(user.properties.get("id"), "coins", newCoins);
          removeBackpackItem(user, "GI606");

          Users.SendJSON(user, {
            coins: newCoins,
            success: true,
            _cmd: "coinUpdate",
          });

          Users.SendJSON(user, {
            coins: newCoins,
            success: true,
            _cmd: "treasure",
          });

          break;
        }

        case "PURCHASE_PET_EGG": {
          var response = purchasePetEgg(user, params, dbase);
          Users.SendJSON(user, response);
          break;
        }

        case "GET_PET_LIST": {
          var response = getPetList(user, dbase);
          Users.SendJSON(user, response);
          break;
        }

        case "SELL_PET": {
          var response = sellPet(user, params, dbase);
          Users.SendJSON(user, response);
          break;
        }

        case "GET_HOUSE_LIST": {
          var mList = [];
          var rmList = zone.getRooms();

          for (i in rmList) {
            if (rmList[i].getName().indexOf("TH_") == 0) {
              var username = rmList[i].getName().substring(3);

              var qRes = dbase.executeQuery(
                "SELECT crumbs FROM users WHERE username='" +
                  _server.escapeQuotes(username) +
                  "';"
              );

              if (qRes.size() > 0) {
                var userCrumbs = JSON.parse(qRes.get(0).getItem("crumbs"));
                var isOpen = userCrumbs.bh || false;

                if (isOpen) {
                  mList.push(username);
                }
              }
            }
          }

          Users.SendJSON(user, {
            _cmd: "houseList",
            isSuccess: true,
            houseList: mList.join(","),
          });

          break;
        }
        case "PLACE_FURNITURE": {
          if (
            (qRes = dbase.executeQuery(
              "SELECT * FROM users WHERE username='" +
                _server.escapeQuotes(String(user.getName())) +
                "';"
            )).size() == 0
          )
            return;

          var Items = Decoder.decodeData(params["e"], 11);
          var truncatedItems = Items.split("#")[0];
          var rVars = [];
          var toup = truncatedItems;
          rVars.push({ name: "furniture", val: toup, priv: false });
          _server.setRoomVariables(fromRoom, null, rVars);
          user.properties.put("furniture", Items);
          Users.UpdateCrumb(user.properties.get("id"), "furniture", Items);
          break;
        }
        case "REQUEST_FRIEND": {
          var whom = Decoder.decodeData(params["e"], 11);
          if (String(user.getName()) == "Sheriff") {
            var targetz = Users.GetUserByName(String(whom));
            receiveItem(targetz, celebItem);
            Users.SendJSON(targetz, {
              _cmd: "secretUpdate",
              success: true,
              itemId: celebItem,
            });
            return;
          } else {
            // Check if the target user allows friend requests
            var targetUser = Users.GetUserByName(String(whom));
            if (targetUser) {
              var targetId = targetUser.properties.get("id");
              var qRes = dbase.executeQuery(
                "SELECT crumbs FROM users WHERE id='" +
                  _server.escapeQuotes(targetId) +
                  "';"
              );
              
              if (qRes.size() > 0) {
                var targetCrumbs = JSON.parse(qRes.get(0).getItem("crumbs"));
                // If allowFriends is 0, don't allow friend request
                if (targetCrumbs.allowFriends === 0) {
                  Users.SendJSON(user, {
                    _cmd: "friendRequest",
                    success: false,
                    error: "This user is not accepting friend requests."
                  });
                  return;
                }
              }
            }
            
            // Proceed with friend request if allowed
            _server.requestAddBuddyPermission(user, String(whom), null);
          }
          break;
        }
        case "MG_UPDATE": {
          var decoded = Decoder.decodeData(params["e"], 11);

          var parts = decoded.split(",");

          var receivedMoney = Number(parts[1]);

          if (isNaN(receivedMoney)) {
            return Users.SendJSON(user, {
              _cmd: "coinUpdate",
              success: false,
              msg: "Invalid money value!",
            });
          }

          var currentCoins = Number(user.properties.get("coins")) || 0;

          var newCoinsValue = currentCoins + receivedMoney;

          user.properties.put("coins", newCoinsValue);

          Users.UpdateCrumb(user.properties.get("id"), "coins", newCoinsValue);

          Users.SendJSON(user, {
            _cmd: "coinUpdate",
            coins: newCoinsValue,
            success: true,
          });

          break;
        }

        case "REQUEST_RELATION_CHANGE": {
          var decoded = Decoder.decodeData(params["e"], 11);

          var parts = decoded.split(",");
          if (parts.length < 2) {
            return Users.SendJSON(user, {
              _cmd: "gameMsg",
              msg: "Something went wrong",
            });
          }

          var targetUsername = parts[0].trim();
          var relationshipType = parts[1].trim();

          if (relationshipType !== "bff" && relationshipType !== "heart") {
            return Users.SendJSON(user, {
              _cmd: "gameMsg",
              msg: "Something went wrong",
            });
          }

          var activeUsers = zone.getUserList().toArray();

          var activeUsernames = activeUsers.map(function (u) {
            return JSON.stringify(u.getName().trim());
          });

          var targetUser = null;

          for (var i = 0; i < activeUsernames.length; i++) {
            var currentUsername = activeUsernames[i];

            if (currentUsername === JSON.stringify(targetUsername)) {
              targetUser = activeUsers[i];
              break;
            }
          }
          var sender = String(user.getName());

          if (targetUser) {
            Users.SendJSON(targetUser, {
              _cmd: "relationship",
              cmd2: "request",
              success: true,
              data: {
                sender: sender,
                type: relationshipType,
              },
            });

            Users.SendJSON(user, {
              _cmd: "relationship",
              cmd2: "request",
              success: true,
              msg: "Relationship request sent successfully.",
            });
          } else {
            Users.SendJSON(user, {
              _cmd: "gameMsg",
              msg: "No user with this username is online",
            });
          }
          break;
        }
        case "REJECT_RELATION_CHANGE":
        case "ACCEPT_RELATION_CHANGE": {
          var decoded = Decoder.decodeData(params["e"], 11);

          var parts = decoded.split(",");
          if (parts.length < 3) {
            return Users.SendJSON(user, {
              _cmd: "gameMsg",
              msg: "Something went wrong",
            });
          }

          var targetUsername = parts[0].trim();
          var relationshipType = parts[1].trim();
          var isAccepted = parts[2].trim().toLowerCase() === "true";

          if (relationshipType !== "bff" && relationshipType !== "heart") {
            return Users.SendJSON(user, {
              _cmd: "gameMsg",
              msg: "Something went wrong",
            });
          }

          var activeUsers = zone.getUserList().toArray();

          var activeUsernames = activeUsers.map(function (u) {
            return JSON.stringify(u.getName().trim());
          });

          var targetUser = null;

          for (var i = 0; i < activeUsernames.length; i++) {
            var currentUsername = activeUsernames[i];

            if (currentUsername === JSON.stringify(targetUsername)) {
              targetUser = activeUsers[i];
              break;
            }
          }

          var sender = String(user.getName());

          if (targetUser) {
            Users.SendJSON(targetUser, {
              _cmd: "relationship",
              cmd2: isAccepted ? "accepted" : "rejected",
              success: true,
              data: {
                sender: sender,
                type: relationshipType,
              },
            });

            if (isAccepted) {
              if (relationshipType === "bff") {
                Users.UpdateCrumb(
                  user.properties.get("id"),
                  "bff",
                  targetUsername
                );

                Users.UpdateCrumb(
                  targetUser.properties.get("id"),
                  "bff",
                  user.getName()
                );
              } else if (relationshipType === "heart") {
                Users.UpdateCrumb(
                  user.properties.get("id"),
                  "heart",
                  targetUsername
                );

                Users.UpdateCrumb(
                  targetUser.properties.get("id"),
                  "heart",
                  user.getName()
                );
              }
            }
          } else {
            Users.SendJSON(user, {
              _cmd: "gameMsg",
              msg: "The user is no longer online",
            });
          }
          break;
        }
        case "BUY_VIP": {
          try {
            if (!params || typeof params["value"] === "undefined") {
              return Users.SendJSON(user, {
                _cmd: "purchaseVIP",
                success: false,
                error: "missing_cost",
              });
            }
            var cost = Number(params["value"]);
            if (isNaN(cost) || cost <= 0) {
              return Users.SendJSON(user, {
                _cmd: "purchaseVIP",
                success: false,
                error: "invalid_cost",
              });
            }
            var currentCoins = Number(user.properties.get("coins")) || 0;

            if (currentCoins >= cost) {
              var newCoinBalance = currentCoins - cost;

              if (
                !Users.UpdateCrumb(
                  user.properties.get("id"),
                  "coins",
                  newCoinBalance
                )
              ) {
                return Users.SendJSON(user, {
                  _cmd: "purchaseVIP",
                  success: false,
                  error: "database_error",
                });
              }
              user.properties.put("coins", newCoinBalance);

              if (!Users.UpdateCrumb(user.properties.get("id"), "isVIP", 1)) {
                Users.UpdateCrumb(
                  user.properties.get("id"),
                  "coins",
                  currentCoins
                );
                return Users.SendJSON(user, {
                  _cmd: "purchaseVIP",
                  success: false,
                  error: "database_error",
                });
              }
              user.properties.put("isVIP", 1);

              Users.SendJSON(user, {
                _cmd: "purchaseVIP",
                success: true,
                coins: newCoinBalance,
                isVIP: 1,
              });

              Users.SendJSON(user, {
                _cmd: "coinUpdate",
                coins: newCoinBalance,
                success: true,
              });
            } else {
              Users.SendJSON(user, {
                _cmd: "purchaseVIP",
                success: false,
                error: "insufficient_coins",
              });
            }
          } catch (e) {
            trace("ERROR in BUY_VIP: " + e);
            Users.SendJSON(user, {
              _cmd: "purchaseVIP",
              success: false,
              error: "server_error",
            });
          }
          break;
        }
        case "CHANGE_MOOD": {
          var moodValue = params["mood"];
          Users.UpdateCrumb(
            user.properties.get("id"),
            "mood",
            String(moodValue)
          );
          user.properties.put("mood", moodValue);
          Users.SendJSON(user, {
            _cmd: "changeMood",
            mood: moodValue,
          });
          break;
        }
        case "CHANGE_GLOWS": {
          var bodyColor = params["bc"];
          var nameGlow = params["ng"];
          var badgeTextColor = params["btc"];
          var nameColor = params["nc"];

          if (!bodyColor || !nameGlow || !badgeTextColor || !nameColor) {
            return Users.SendJSON(user, {
              _cmd: "changeGlows",
              isSuccess: false,
              msg: "Invalid glow data provided.",
            });
          }

          user.properties.put("bc", bodyColor);
          user.properties.put("ng", nameGlow);
          user.properties.put("btc", badgeTextColor);
          user.properties.put("nc", nameColor);

          Users.UpdateCrumb(user.properties.get("id"), "bc", bodyColor);
          Users.UpdateCrumb(user.properties.get("id"), "ng", nameGlow);
          Users.UpdateCrumb(user.properties.get("id"), "btc", badgeTextColor);
          Users.UpdateCrumb(user.properties.get("id"), "nc", nameColor);

          _server.setUserVariables(user, {
            bc: bodyColor,
            ng: nameGlow,
            btc: badgeTextColor,
            nc: nameColor,
          });
          break;
        }
        case "ACCEPT_FRIEND": {
          var whomaccept = Decoder.decodeData(params["e"], 11);
          _server.addBuddy(String(whomaccept), user);
          _server.addBuddy(
            String(user.getName()),
            Users.GetUserByName(String(whomaccept))
          );
          break;
        }

        case "REMOVE_FRIEND": {
          var whomremove = Decoder.decodeData(params["e"], 11);
          _server.removeBuddy(String(whomremove), user);
          _server.removeBuddy(
            String(user.getName()),
            Users.GetUserByName(String(whomremove))
          );
          break;
        }
        case "IGNORE": {
          break;
        }
        case "BUY_ICECREAM": {
          break;
        }
        case "ALLOW_FRIEND_REQUESTS": {
          // Get current allowFriends value from user crumbs
          var userId = user.properties.get("id");
          var qRes = dbase.executeQuery(
            "SELECT crumbs FROM users WHERE id='" +
              _server.escapeQuotes(userId) +
              "';"
          );
          
          if (qRes.size() > 0) {
            var userCrumbs = JSON.parse(qRes.get(0).getItem("crumbs"));
            // Check if allowFriends is 0, then set to 1
            var currentAllowFriends = userCrumbs.allowFriends;
            var newAllowFriends = 1;
            
            // If allowFriends is already 1 or not set, set it to 0
            if (currentAllowFriends === 1 || currentAllowFriends === undefined) {
              newAllowFriends = 0;
            }
            
            // Update the user crumb
            Users.UpdateCrumb(userId, "allowFriends", newAllowFriends);
            
            // Send response to client
            Users.SendJSON(user, {
              _cmd: "allowFriendsUpdate",
              allowFriends: newAllowFriends,
              success: true
            });
          } else {
            Users.SendJSON(user, {
              _cmd: "allowFriendsUpdate",
              success: false,
              error: "Failed to update settings"
            });
          }
          break;
        }
        case "START_QUEST": {
          var questid = Decoder.decodeData(params["e"], 11);
          var response = startQuest(user, questid);
          return Users.SendJSON(user, response);
        }
        case "UPDATE_QUEST": {
          var itemId = Decoder.decodeData(params["e"], 11);
          var response = updateQuest(user, itemId);
          return Users.SendJSON(user, response);
        }
        case "UPDATE_QUEST_PURCHASE": {
          var itemId = Decoder.decodeData(params["e"], 11);
          var response = updateQuest(user, itemId);

          var priceList = user.properties.get("priceList") || "";
          var itemCost = getItemPrice(itemId, priceList);
          var currentCoins = Number(user.properties.get("coins"));

          if (currentCoins < itemCost) {
            Users.SendJSON(user, {
              _cmd: "purchaseItem",
              isSuccess: false,
              msg: "Not enough coins!",
              coins: currentCoins,
            });
            return Users.SendJSON(user, response);
          }

          var newCoinBalance = currentCoins - itemCost;
          user.properties.put("coins", newCoinBalance);
          Users.UpdateCrumb(user.properties.get("id"), "coins", newCoinBalance);

          Users.SendJSON(user, {
            _cmd: "purchaseItem",
            coins: newCoinBalance,
            success: true,
          });

          Users.SendJSON(user, {
            _cmd: "coinUpdate",
            coins: newCoinBalance,
            success: true,
          });

          return Users.SendJSON(user, response);
          break;
        }
        case "COMPLETE_QUEST": {
          var itemId = Decoder.decodeData(params["e"], 11);
          var response = completeQuest(user, itemId);
          return Users.SendJSON(user, response);
          break;
        }
        case "DROP_QUEST": {
          var questId = Decoder.decodeData(params["e"], 11);
          var response = questDrop(user, questId);
          return Users.SendJSON(user, response);
          break;
        }
        case "TICKET_PRIZE": {
          // Query the database fresh for the current zingItem
          var zingItemResult = dbase.executeQuery("SELECT `value` FROM config WHERE `key`='zingItem';");
          var currentZingItem = "0"; // Default fallback
          if (zingItemResult.size() > 0) {
            currentZingItem = String(zingItemResult.get(0).getItem("value"));
          }
          Users.SendJSON(user, {
            _cmd: "zing",
            cmd2: "ticketPrize",
            isEligible: 1,
            itemId: currentZingItem,
          });
          break;
        }
        case "COLLECT_GOLDEN_TICKET": {
          var ticks = Number(user.properties.get("tickets"));
          if (ticks < 10) {
            ticks = ticks + 1;
          }
          user.properties.put("tickets", ticks);
          Users.UpdateCrumb(user.properties.get("id"), "tickets", ticks);
          Users.SendJSON(user, {
            _cmd: "zing",
            cmd2: "goldenTicket",
            count: ticks,
            success: true,
          });
          break;
        }
        case "REDEEM_GOLDEN_TICKETS": {
          var doPrize = params["doPrize"];

          if (doPrize === false) {
            var currentCoins = Number(user.properties.get("coins"));
            var newCoinBalance = currentCoins + 500;

            user.properties.put("coins", newCoinBalance);
            Users.UpdateCrumb(
              user.properties.get("id"),
              "coins",
              newCoinBalance
            );

            Users.SendJSON(user, {
              _cmd: "zing",
              cmd2: "ticketPurchase",
              coins: newCoinBalance,
              success: true,
            });
          } else {
            // Query the database fresh for the current zingItem
            var zingItemResult = dbase.executeQuery("SELECT `value` FROM config WHERE `key`='zingItem';");
            var currentZingItem = "0"; // Default fallback
            if (zingItemResult.size() > 0) {
              currentZingItem = String(zingItemResult.get(0).getItem("value"));
            }
            
            if (hasItem(user, currentZingItem)) {
              Users.SendJSON(user, {
                _cmd: "purchaseItem",
                isSuccess: false,
                msg: "You already have this item.",
              });
              break;
            }

            receiveItem(user, currentZingItem);
            Users.SendJSON(user, {
              _cmd: "zing",
              cmd2: "ticketPurchase",
              itemId: currentZingItem,
              success: true,
            });
          }
          user.properties.put("tickets", 0);
          Users.UpdateCrumb(user.properties.get("id"), "tickets", 0);
          break;
        }
        case "ADD_SECRET_ITEM": {
          var itemId = Decoder.decodeData(params["e"], 11);

          if (!hasItem(user, itemId)) {
            receiveItem(user, itemId);
            Users.SendJSON(user, {
              _cmd: "secretUpdate",
              itemId: itemId,
              success: true,
            });
          }
          break;
        }

        case "GET_CALENDAR": {
          var decoded = Decoder.decodeData(params["e"], 11);

          if (decoded == "0") {
            var calendarValue = String(
              dbase
                .executeQuery(
                  "SELECT `value` FROM config WHERE `key`='calendar';"
                )
                .get(0)
                .getItem("value")
            );

            if (calendarValue) {
              Users.SendJSON(user, {
                _cmd: "calendar",
                cmd2: "events",
                success: true,
                pandanda: calendarValue,
                player: "",
              });
            } else {
              Users.SendJSON(user, {
                _cmd: "calendar",
                cmd2: "events",
                success: false,
                msg: "Calendar data not found.",
              });
            }
          } else {
            Users.SendJSON(user, {
              _cmd: "calendar",
              cmd2: "events",
              success: false,
              msg: "Invalid request.",
            });
          }
          break;
        }
        case "COLLECT_FESTIVAL_TICKET": {
          var ticks = Number(user.properties.get("festivalCollection"));
          if (ticks < 999 ) {
            ticks = ticks + 1;
          }
          user.properties.put("festivalCollection", ticks);
          Users.UpdateCrumb(
            user.properties.get("id"),
            "festivalCollection",
            ticks
          );
          Users.SendJSON(user, {
            _cmd: "festivalCollection",
            count: ticks,
            success: true,
          });
          break;
        }
        case "PURCHASE_FESTIVAL_PRIZE": {
          handlePurchaseFestivalPrize(user, params);
          break;
        }
        case "EXCHANGE_FESTIVAL_COINS": {
          handleExchangeFestivalCoins(user, params);
          break;
        }
        case "REPORT": {
          handleReport(params, user, fromRoom);
          break;
        }

        default: {
          trace("No handler found for: " + XT_Hash[header]);
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

function handleReport(params, user, fromRoom) {
  try {
    // Debug: Log the raw parameters
    trace("Report params: " + JSON.stringify(params));
    
    var decoded = Decoder.decodeData(params["e"] || "", 11);
    trace("Decoded report data: " + decoded);
    
    // Expected formats seen historically:
    // - "targetName,true,reason text" (we ignore the abuse flag)
    // - "targetName,reason text"
    var parts = decoded.split(",");
    trace("Report parts: " + JSON.stringify(parts));
    
    var targetName = (parts.shift() || "").trim();
    trace("Raw target name: " + targetName);
    
    // If next token is an abuse boolean, drop it (we no longer use it)
    if (parts.length > 1 && /^(true|false|1|0)$/i.test(parts[0].trim())) {
      parts.shift();
    }
    var reason = parts.join(",").trim() || "(no message)";
    
    trace("Final target name: " + targetName);
    trace("Final reason: " + reason);

    // Get reporter and target user info
    var reporterName = user.getName();
    var reporterIp = String(CryptoUtil.encryptIp(String(user.getIpAddress() || "")) || "");
    var targetUser = zone.getUserByName(targetName);
    var targetIp = String(CryptoUtil.encryptIp(String(targetUser ? targetUser.getIpAddress() || "" : "")) || "");

    // Query database for reportHook webhook URL
    var reportHookResult = dbase.executeQuery("SELECT `value` FROM config WHERE `key`='reportHook';");
    var reportHookUrl = "";
    if (reportHookResult.size() > 0) {
      reportHookUrl = String(reportHookResult.get(0).getItem("value"));
    }

    // Build Discord webhook payload
    var now = new Date();
    var year = now.getFullYear();
    var month = (now.getMonth() + 1 < 10 ? "0" : "") + (now.getMonth() + 1);
    var day = (now.getDate() < 10 ? "0" : "") + now.getDate();
    var hours = (now.getHours() < 10 ? "0" : "") + now.getHours();
    var minutes = (now.getMinutes() < 10 ? "0" : "") + now.getMinutes();
    var seconds = (now.getSeconds() < 10 ? "0" : "") + now.getSeconds();
    var milliseconds = now.getMilliseconds();
    if (milliseconds < 10) milliseconds = "00" + milliseconds;
    else if (milliseconds < 100) milliseconds = "0" + milliseconds;
    
    var nowIso = year + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds + "." + milliseconds + "Z";
    
    // Function to create embed
    function createEmbed() {
      return {
        title: "New Player Report",
        description: [
          "A new report was submitted in-game.",
          "\n",
          "Please review and take action if needed.",
          "\n"
        ].join(""),
        color: 0xF1C40F,
        fields: [
          { name: "Target", value: targetName || "(unknown)", inline: true },
          { name: "Reporter", value: reporterName || "(unknown)", inline: true },
          { name: "Reason", value: reason || "(no message)", inline: false },
          { name: "ZONE", value: zone.getName() || 'unknown', inline: true },
          { name: "ROOM", value: fromRoom ? fromRoom.getName() : 'unknown', inline: true },
          { name: "Reporter IP (Encrypted)", value: reporterIp || "(unavailable)", inline: false },
          { name: "Target IP (Encrypted)", value: targetIp || "(unavailable)", inline: false }
        ],
        footer: { text: "Pandanda Rewritten" },
        timestamp: nowIso
      };
    }

     // Send webhook if URL is configured
     if (reportHookUrl && reportHookUrl !== "") {
       try {
         var webhookData = {
           url: reportHookUrl,
           method: "POST",
           headers: {
             "Content-Type": "application/json",
             "User-Agent": "Pandanda-Server/1.0"
           },
           payload: {
             username: "Pandanda Reports",
             embeds: [createEmbed()]
           },
           timestamp: new Date().getTime(),
           reporter: reporterName,
           target: targetName,
           reason: reason
         };
         
         // Call Python script to send webhook
         var pythonScript = "sfsScripts/process_webhooks.py";
         var pythonFile = new java.io.File(pythonScript);
         
         if (pythonFile.exists()) {
           try {
             // Create temporary file with webhook data
             var tempFile = new java.io.File("temp_webhook.json");
             var tempWriter = new java.io.FileWriter(tempFile);
             tempWriter.write(JSON.stringify(webhookData));
             tempWriter.close();
             
             // Call Python script
             var processBuilder = new java.lang.ProcessBuilder("python", pythonScript, tempFile.getAbsolutePath());
             processBuilder.directory(new java.io.File("."));
             processBuilder.redirectErrorStream(true);
             
             var process = processBuilder.start();
             var reader = new java.io.BufferedReader(new java.io.InputStreamReader(process.getInputStream()));
             var line;
             var output = "";
             while ((line = reader.readLine()) != null) {
               output += line + "\n";
             }
             
             var exitCode = process.waitFor();
             reader.close();
             
             if (exitCode === 0) {
               trace("SUCCESS: Webhook sent via Python script: " + output);
               // Clean up temp file
               try {
                 if (tempFile.exists()) {
                   tempFile["delete"]();
                 }
               } catch (cleanupError) {
                 trace("Warning: Could not delete temp file: " + cleanupError);
               }
             } else {
               trace("ERROR: Python script failed with exit code: " + exitCode);
               trace("Output: " + output);
               
               // Fallback: Write to queue file
               var webhookFile = new java.io.File("logs/webhook_queue.json");
               if (!webhookFile.getParentFile().exists()) {
                 webhookFile.getParentFile().mkdirs();
               }
               
               var fileWriter = new java.io.FileWriter(webhookFile, true);
               fileWriter.write(JSON.stringify(webhookData) + "\n");
               fileWriter.close();
               
               trace("INFO: Webhook data written to logs/webhook_queue.json for external processing");
             }
             
             // Clean up temp file
             try {
               if (tempFile.exists()) {
                 tempFile["delete"]();
               }
             } catch (cleanupError) {
               trace("Warning: Could not delete temp file: " + cleanupError);
             }
             
           } catch (pythonError) {
             trace("ERROR: Python script execution failed: " + pythonError);
           }
         } else {
           trace("ERROR: Python script not found: " + pythonScript);
         }
         
       } catch (webhookError) {
         trace("ERROR: Webhook processing failed: " + webhookError);
       }
     } else {
       trace("Report webhook URL not configured. Skipping Discord webhook send.");
     }

    // Log report to console for debugging
    trace("Report submitted - Reporter: " + reporterName + ", Target: " + targetName + ", Reason: " + reason);

    // Send success response to client
    Users.SendJSON(user, { _cmd: "report", isSuccess: true }, fromRoom);
  } catch (e) {
    trace("handleReport error: " + e);
    Users.SendJSON(user, { _cmd: "report", isSuccess: false, msg: "Failed to submit report" }, fromRoom);
  }
}

function handlePurchaseFestivalPrize(user, params) {
    var reqit = String(params["purchase"]);
    var priceList = user.properties.get("priceList") || "";
    var itemCost = getItemPrice(reqit, priceList);
    var currentTickets = Number(user.properties.get("festivalCollection")) || 0;
    
    // Check if we have enough festival tickets
    if (currentTickets >= itemCost) {
        // For non-potion items, check if user already has them
        if (reqit.indexOf("GI") !== 0 && hasItem(user, reqit)) {
            Users.SendJSON(user, {
                _cmd: "purchaseItem",
                isSuccess: false,
                msg: "You already have this item"
            });
            return;
        }

        // Update festival tickets first
        var newTicketBalance = currentTickets - itemCost;
        user.properties.put("festivalCollection", newTicketBalance);
        Users.UpdateCrumb(user.properties.get("id"), "festivalCollection", newTicketBalance);
        
        // Use receiveItem to handle all item types
        receiveItem(user, reqit);
        
        // Determine item type and create appropriate response
        var response = {
            _cmd: "purchaseItem",
            isSuccess: true
        };
        
        // Add the appropriate property based on item type
        if (reqit.indexOf("M") === 0) {
            response.mount = reqit;
        } else if (reqit.indexOf("F") === 0) {
            response.storage = reqit;
        } else if (reqit.indexOf("GI") === 0) {
            response.backpack = reqit;
        } else {
            response.clothes = reqit;
        }
        
        // Send purchase success response
        Users.SendJSON(user, response);
        
        // Send updated festival ticket count
        Users.SendJSON(user, {
            _cmd: "festivalCollection",
            count: newTicketBalance,
            success: true
        });
    } else {
        Users.SendJSON(user, {
            _cmd: "purchaseItem",
            isSuccess: false,
            msg: "Not enough festival tickets"
        });
    }
}

function handleExchangeFestivalCoins(user, params) {
    var REQUIRED_TICKETS = 99;
    var COINS_REWARD = 500; // Fixed amount, matching zing ticket behavior
    var REQUIRE_LEVEL_CHECK = true; // Toggle: Set to false to disable level requirement
    var MINIMUM_LEVEL = 10;
    
    var currentTickets = Number(user.properties.get("festivalCollection")) || 0;
    
    // Check if user has enough festival tickets
    if (currentTickets < REQUIRED_TICKETS) {
        Users.SendJSON(user, {
            _cmd: "festivalCoinExchange",
            success: false
        });
        return;
    }
    
    // Check level requirement (if enabled)
    if (REQUIRE_LEVEL_CHECK) {
        var userLevel = Number(user.properties.get("level")) || 1;
        if (userLevel < MINIMUM_LEVEL) {
            Users.SendJSON(user, {
                _cmd: "festivalCoinExchange",
                success: false,
                msg: "You need to be level " + MINIMUM_LEVEL + " or higher to exchange your festival collectibles for coins."
            });
            return;
        }
    }
    
    // Deduct festival tickets
    var newTicketBalance = currentTickets - REQUIRED_TICKETS;
    user.properties.put("festivalCollection", newTicketBalance);
    Users.UpdateCrumb(user.properties.get("id"), "festivalCollection", newTicketBalance);
    var currentCoins = Number(user.properties.get("coins")) || 0;
    var newCoins = currentCoins + COINS_REWARD;
    user.properties.put("coins", newCoins);
    Users.UpdateCrumb(user.properties.get("id"), "coins", newCoins);
    
    // Send success responses
    Users.SendJSON(user, {
        _cmd: "festivalCollection",
        count: newTicketBalance,
        success: true
    });
    
    Users.SendJSON(user, {
        _cmd: "coinUpdate",
        coins: newCoins,
        success: true
    });
    
    Users.SendJSON(user, {
        _cmd: "festivalCoinExchange",
        success: true,
        ticketsUsed: REQUIRED_TICKETS,
        coinsReceived: COINS_REWARD,
        newTicketBalance: newTicketBalance,
        newCoinBalance: newCoins
    });
}

function init() {
  dbase = _server.getDatabaseManager();
  zone = _server.getCurrentZone();
  _sfs = Packages.it.gotoandplay.smartfoxserver.SmartFoxServer;
  var celebItemResult = dbase.executeQuery("SELECT `value` FROM config WHERE `key`='celebItem';");
  if (celebItemResult.size() > 0) {
    celebItem = String(celebItemResult.get(0).getItem("value"));
  } else {
    celebItem = "0"; // Default fallback value
  }
  popInterval = setInterval("updatePop", 15000);
  _server.getCurrentZone().setPubMsgInternalEvent(true);  
  // Load bad words from database
  loadBadWordsFromDB();
}
function destroy() {
  trace("Nice knowing you, bye! :)");
  clearInterval(popInterval);
}