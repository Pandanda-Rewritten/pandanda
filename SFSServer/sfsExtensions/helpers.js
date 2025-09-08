function getItemPrice(itemId, priceListStr) {
  if (typeof priceListStr !== "string") {
    priceListStr = String(priceListStr || "");
  }

  itemId = itemId.trim();

  var entries = priceListStr.split(",");

  var bestMatch = null;
  var bestMatchLength = 0;

  for (var i = 0; i < entries.length; i++) {
    var parts = entries[i].split(":");
    if (parts.length < 2) continue;

    var prefix = parts[0].trim();
    var price = parts.slice(1).join(":").trim();

    if (itemId.indexOf(prefix) === 0) {
      if (prefix.length > bestMatchLength) {
        bestMatch = price;
        bestMatchLength = prefix.length;
      }
    }
  }

  if (bestMatch !== null) {
    var price = parseInt(bestMatch, 10);
    return isNaN(price) ? 50 : price;
  }

  return 50;
}

function purchaseItem(user, itemID, checkOnly) {
  if (itemID == null) throw new Exception("No valid item? WHY?");

  if (checkOnly) return 50;
  itemArray = ToJSArray(user.properties.get("closet").split(","));
  if (hasItem(user, itemID)) {
    return 50;
  }
  itemArray.push(itemID);
  user.properties.put("closet", itemArray.join(","));

  Users.UpdateCrumb(user.properties.get("id"), "closet", itemArray.join(","));
  return 50;
}

function purchaseFurniture(user, itemID, checkOnly) {
  if (itemID == null) throw new Exception("No valid item? WHY?");

  if (checkOnly) return 50;
  itemArray = ToJSArray(user.properties.get("storage").split(","));
  itemArray.push(itemID);
  user.properties.put("storage", itemArray.join(","));
  Users.UpdateCrumb(user.properties.get("id"), "storage", itemArray.join(","));
  return 50;
}
function purchaseBackpack(user, itemID, checkOnly) {
  if (itemID == null) throw new Exception("No valid item? WHY?");

  if (checkOnly) return 50;
  itemArray = ToJSArray(user.properties.get("backpack").split(","));
  itemArray.push(itemID);
  user.properties.put("backpack", itemArray.join(","));
  Users.UpdateCrumb(user.properties.get("id"), "backpack", itemArray.join(","));
  return 50;
}

function purchaseMount(user, itemID, checkOnly) {
  if (itemID == null) throw new Exception("No valid item? WHY?");

  if (checkOnly) return 50;
  itemArray = ToJSArray(user.properties.get("mounts").split(","));
  if (hasItem(user, itemID)) {
    return 50;
  }

  itemArray.push(itemID);
  user.properties.put("mounts", itemArray.join(","));
  Users.UpdateCrumb(user.properties.get("id"), "mounts", itemArray.join(","));
  return 50;
}
function addBackpack(user, itemID) {
  var itemArray = ToJSArray(user.properties.get("backpack").split(","));
  itemArray.push(itemID);
  user.properties.put("backpack", itemArray.join(","));
  Users.UpdateCrumb(user.properties.get("id"), "backpack", itemArray.join(","));
  var backpack = String(user.properties.get("backpack"));
  var storage = String(user.properties.get("storage"));
  var clothes = String(user.properties.get("closet"));
  var mounts = String(user.properties.get("mounts"));
  var coins = String(user.properties.get("coins"));

  Users.SendJSON(user, {
    _cmd: "sellItems",
    isSuccess: true,
    coins: coins,
    backpack: backpack,
    clothes: clothes,
    storage: storage,
    mounts: mounts,
  });
}
function removeBackpackItem(user, itemID) {
  backpackarr = ToJSArray(user.properties.get("backpack").split(","));
  storagearr = ToJSArray(user.properties.get("storage").split(","));
  clothesarr = ToJSArray(user.properties.get("closet").split(","));
  mountsarr = ToJSArray(user.properties.get("mounts").split(","));

  for (i in backpackarr) {
    if (backpackarr[i] == itemID) {
      backpackarr.splice(i, 1);
      break;
    }
  }
  for (i in storagearr) {
    if (storagearr[i] == itemID) {
      storagearr.splice(i, 1);
      break;
    }
  }
  for (i in clothesarr) {
    if (clothesarr[i] == itemID) {
      clothesarr.splice(i, 1);
      break;
    }
  }
  for (i in mountsarr) {
    if (mountsarr[i] == itemID) {
      mountsarr.splice(i, 1);
      break;
    }
  }

  user.properties.put("backpack", backpackarr.join(","));
  Users.UpdateCrumb(
    user.properties.get("id"),
    "backpack",
    backpackarr.join(",")
  );
  user.properties.put("storage", storagearr.join(","));
  Users.UpdateCrumb(user.properties.get("id"), "storage", storagearr.join(","));
  user.properties.put("closet", clothesarr.join(","));
  Users.UpdateCrumb(user.properties.get("id"), "closet", clothesarr.join(","));
  user.properties.put("mounts", mountsarr.join(","));
  Users.UpdateCrumb(user.properties.get("id"), "mounts", mountsarr.join(","));
}
function hasItem(user, itemID) {
  var closetString = String(user.properties.get("closet") || "");
  var backpackString = String(user.properties.get("backpack") || "");
  var mountsString = String(user.properties.get("mounts") || "");

  var closetArray = closetString ? closetString.split(",") : [];
  var backpackArray = backpackString ? backpackString.split(",") : [];
  var mountsArray = mountsString ? mountsString.split(",") : [];

  for (var i = 0; i < closetArray.length; i++) {
    if (String(closetArray[i]) === String(itemID)) {
      return true;
    }
  }

  for (var j = 0; j < backpackArray.length; j++) {
    if (String(backpackArray[j]) === String(itemID)) {
      return true;
    }
  }

  for (var k = 0; k < mountsArray.length; k++) {
    if (String(mountsArray[k]) === String(itemID)) {
      return true;
    }
  }
  return false;
}
function receiveItem(user, itemID, checkOnly) {
  if (itemID == null) throw new Exception("No valid item? WHY?");
  if (checkOnly) return 50;

  try {
    if (itemID[0] == "C") {
      return purchaseItem(user, itemID, checkOnly);
    } else if (itemID[0] == "M") {
      return purchaseMount(user, itemID, checkOnly);
    } else if (itemID.indexOf("F") == 0) {
      return purchaseFurniture(user, itemID, checkOnly);
    } else if (itemID.indexOf("GI") == 0) {
      return purchaseBackpack(user, itemID, checkOnly);
    } else {
      return purchaseItem(user, itemID, checkOnly);
    }
  } catch (e) {
    throw new Exception("Failed to receive item: " + e.message);
  }
}

function processQAvailable(qAvailableString) {
  try {
    var items = qAvailableString.split(",");
    var processedItems = [];

    for (var i = 0; i < items.length; i++) {
      var parts = items[i].split(":");
      if (parts && parts.length > 0) {
        var id = parts[0];
        var baseId = id.length >= 4 ? id.substring(0, 4) : id;
        var letter = id.length > 4 ? id.charAt(4) : "";

        var itemObj = {
          id: id,
          fullItem: items[i],
          baseId: baseId,
          letter: letter,
        };
        processedItems.push(itemObj);
      }
    }

    processedItems.sort(function (a, b) {
      var comp = 0;
      if (a.id < b.id) comp = -1;
      if (a.id > b.id) comp = 1;

      return comp;
    });

    var seenBaseIds = {};
    var filteredItems = [];

    for (var j = 0; j < processedItems.length; j++) {
      var currentItem = processedItems[j];
      if (!seenBaseIds[currentItem.baseId]) {
        seenBaseIds[currentItem.baseId] = true;
        filteredItems.push(currentItem.fullItem);
      }
    }

    var result = filteredItems.join(",");
    return result;
  } catch (e) {
    return qAvailableString;
  }
}

// Function to get the current questHash from the config table
function getQuestHashConfig() {
    var questHashValue = ""; // Default value
    try {
        var sql = "SELECT `value` FROM config WHERE `key`='questHash';";
        var configResult = dbase.executeQuery(sql);
        if (configResult != null && configResult.size() > 0) {
            questHashValue = String(configResult.get(0).getItem("value"));
        } else {
            trace("Warning: Could not find 'questHash' key in config table.");
        }
    } catch (e) {
        trace("Error fetching 'questHash' from config table: " + e);
    }
    return questHashValue;
}

function processUserColorAndCloset(color, existingCloset) {
    try {
        // Process color - remove letters and leading zeros
        var processedColor = "0";
        if (color) {
            // Store original color for closet
            var originalColor = color;
            
            // Remove first character if it's a letter
            if (color.length > 0 && color.charAt(0) >= 'A' && color.charAt(0) <= 'Z') {
                color = color.substring(1);
            }
            // Remove leading zeros
            while (color.length > 0 && color.charAt(0) === '0') {
                color = color.substring(1);
            }
            processedColor = color || "0";

            // Process closet - combine color with existing items
            var closetItems = [];
            if (existingCloset) {
                closetItems = existingCloset.split(',');
            }
            
            // Add original color item if it's not already in the closet
            var hasColor = false;
            for (var i = 0; i < closetItems.length; i++) {
                if (closetItems[i] === originalColor) {
                    hasColor = true;
                    break;
                }
            }
            if (!hasColor) {
                closetItems.unshift(originalColor);
            }
            
            return {
                processedColor: processedColor,
                processedCloset: closetItems.join(',')
            };
        }
        
        // Default return if no color provided
        return {
            processedColor: "0",
            processedCloset: existingCloset || ""
        };
    } catch (e) {
        trace("Error processing user color and closet: " + e);
        return {
            processedColor: "0",
            processedCloset: existingCloset || ""
        };
    }
}

function checkAndGiveLoginItem(user) {
  try {
    // Check if free item event is active
    var eventRes = dbase.executeQuery(
      "SELECT active FROM eventconfig WHERE event='loginItemActive' LIMIT 1;"
    );
    
    if (eventRes.size() == 0 || Number(eventRes.get(0).getItem("active")) !== 1) {
      return; // Event not active
    }
    
    // Get the current login item
    var configRes = dbase.executeQuery(
      "SELECT value FROM config WHERE `key`='loginItem' LIMIT 1;"
    );
    
    if (configRes.size() == 0) {
      return; // No login item configured
    }
    
    var loginItem = String(configRes.get(0).getItem("value"));
    if (!loginItem || loginItem === "") {
      return; // No valid login item
    }
    
    // Check if user already has this item
    if (hasItem(user, loginItem)) {
      return; // User already has the item
    }
    
    // Check if user has already received the current login item
    var lastLoginItem = user.properties.get("lastLoginItem") || "";
    if (lastLoginItem === loginItem) {
      return; // User already received this login item
    }
    
    // Give the item to the user
    receiveItem(user, loginItem);
    
    // Mark that they've received this login item
    user.properties.put("lastLoginItem", loginItem);
    Users.UpdateCrumb(user.properties.get("id"), "lastLoginItem", loginItem);
    
    // Send the secret item popup
    Users.SendJSON(user, {
      _cmd: "secretUpdate",
      itemId: loginItem,
      success: true,
    });
    
  } catch (e) {
    trace("Error in checkAndGiveLoginItem: " + e);
  }
}
