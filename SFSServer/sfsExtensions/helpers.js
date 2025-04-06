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
