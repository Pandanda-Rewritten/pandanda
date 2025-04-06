function purchasePetEgg(user, params, dbase) {
  try {
    var decodedData = Decoder.decodeData(params["e"], 11);
    var parts = decodedData.split(":");

    if (parts.length < 2) {
      return {
        _cmd: "purchaseItem",
        isSuccess: false,
        msg: "Invalid data format!",
      };
    }

    var itemId = parts[0];
    var petName = parts[1];

    if (typeof petName === "string") {
      petName = petName.replace(/^\s+|\s+$/g, "");
    }

    if (!petName || petName === "") {
      return {
        _cmd: "purchaseItem",
        isSuccess: false,
        msg: "Pet name cannot be empty!",
      };
    }

    var priceList = user.properties.get("priceList") || "";
    var itemPrice = getItemPrice(itemId, priceList);

    if (itemPrice === 50 && priceList.indexOf(itemId) === -1) {
      return {
        _cmd: "purchaseItem",
        isSuccess: false,
        msg: "Invalid pet egg item!",
      };
    }

    var currentCoins = Number(user.properties.get("coins"));
    if (currentCoins < itemPrice) {
      return {
        _cmd: "purchaseItem",
        isSuccess: false,
        msg: "Not enough coins to purchase the pet egg!",
      };
    }

    var color = 0;
    var lastChar = itemId.charAt(itemId.length - 1).toUpperCase();
    if (lastChar >= "A" && lastChar <= "Z") {
      color = lastChar.charCodeAt(0) - "A".charCodeAt(0);
    }

    var currentDate = new Date();
    var month = currentDate.getMonth() + 1;
    var day = currentDate.getDate();
    month = month < 10 ? "0" + month : month;
    day = day < 10 ? "0" + day : day;
    var birthday = currentDate.getFullYear() + "-" + month + "-" + day;

    var ownerId = user.properties.get("id");
    var query =
      "INSERT INTO pets (name, color, owner, birthday, rest, power, happy) " +
      "VALUES ('" +
      _server.escapeQuotes(petName) +
      "', " +
      color +
      ", '" +
      _server.escapeQuotes(ownerId) +
      "', '" +
      birthday +
      "', 100, 100, 100)";

    if (!dbase.executeCommand(query)) {
      user.properties.put("coins", currentCoins);
      Users.UpdateCrumb(user.properties.get("id"), "coins", currentCoins);
      return {
        _cmd: "purchaseItem",
        isSuccess: false,
        msg: "Failed to adopt pet. Please try again.",
      };
    }

    var newCoinBalance = currentCoins - itemPrice;
    user.properties.put("coins", newCoinBalance);
    Users.UpdateCrumb(ownerId, "coins", newCoinBalance);

    var room = user.properties.get("room");
    if (room) {
      var currentPets = room.getVariable("pets") || "";
      var bParts = birthday.split("-");
      var formattedBirthday = bParts[1] + "/" + bParts[2] + "/" + bParts[0];
      var daysold = "0";

      var newPetEntry = [
        user.getName(),
        petName,
        color,
        formattedBirthday,
        daysold,
        "100:100:100",
        "0",
        "0",
      ].join(",");

      var updatedPets =
        currentPets.length > 0 ? currentPets + ";" + newPetEntry : newPetEntry;
      _server.setRoomVariables(room, null, [
        { name: "pets", val: updatedPets, priv: false },
      ]);
    }

    Users.SendJSON(user, {
      _cmd: "coinUpdate",
      coins: newCoinBalance,
      success: true,
    });

    return {
      _cmd: "purchaseItem",
      isSuccess: true,
      coins: newCoinBalance,
      pet: {
        name: petName,
        color: color,
        birthday: birthday,
        rest: 100,
        power: 100,
        happy: 100,
      },
    };
  } catch (e) {
    return {
      _cmd: "purchaseItem",
      isSuccess: false,
      msg: "An error occurred. Please try again.",
    };
  }
}

function getPetList(user) {
  try {
    var room = user.properties.get("room");
    if (!room) {
      return { _cmd: "petReturn", pets: "", error: "No room found." };
    }

    var petsStr = String(room.getVariable("pets"));
    if (!petsStr) {
      return { _cmd: "petReturn", pets: "", error: "No pets in room." };
    }
    trace(petsStr);

    var petEntries = petsStr.split(";").filter(function (entry) {
      return entry.trim().length > 0;
    });

    if (petEntries.length === 0) {
      return { _cmd: "petReturn", pets: "", error: "No pets in room." };
    }

    var petList = [];

    for (var i = 0; i < petEntries.length; i++) {
      var parts = petEntries[i].split(",");
      if (parts.length >= 5) {
        petList.push(i + "," + parts[1] + "," + parts[2] + "," + parts[4]);
      }
    }

    return {
      _cmd: "petReturn",
      pets: petList.join(";"),
    };
  } catch (e) {
    return {
      _cmd: "petReturn",
      pets: "",
      error: "Failed to retrieve pet list.",
    };
  }
}

function sellPet(user, params, dbase) {
  try {
    var petName = params["petName"];
    var userId = user.properties.get("id");
    var room = user.properties.get("room");

    var qRes = dbase.executeQuery(
      "SELECT * FROM pets WHERE owner='" +
        _server.escapeQuotes(userId) +
        "' " +
        "AND name='" +
        _server.escapeQuotes(petName) +
        "';"
    );

    if (qRes.size() === 0) {
      return { _cmd: "sellPet", isSuccess: false, msg: "Pet not found in DB." };
    }

    var petsStr = String(room.getVariable("pets"));
    if (!petsStr) {
      return { _cmd: "sellPet", isSuccess: false, msg: "No pets in room." };
    }

    var petEntries = petsStr.split(";");
    var updatedPetEntries = [];
    var petFound = false;

    for (var i = 0; i < petEntries.length; i++) {
      if (petEntries[i].split(",")[1] !== petName) {
        updatedPetEntries.push(petEntries[i]);
      } else {
        petFound = true;
      }
    }

    if (!petFound) {
      return { _cmd: "sellPet", isSuccess: false, msg: "Pet not in room." };
    }

    var updatedPetArray = updatedPetEntries.join(";");
    _server.setRoomVariables(room, null, [
      { name: "pets", val: updatedPetArray, priv: false },
    ]);

    var deleteQuery =
      "DELETE FROM pets WHERE owner='" +
      _server.escapeQuotes(userId) +
      "' " +
      "AND name='" +
      _server.escapeQuotes(petName) +
      "';";
    if (!dbase.executeCommand(deleteQuery)) {
      return { _cmd: "sellPet", isSuccess: false, msg: "DB delete failed." };
    }

    var refundAmount = 1000;
    var newCoinBalance = Number(user.properties.get("coins")) + refundAmount;
    user.properties.put("coins", newCoinBalance);
    Users.UpdateCrumb(userId, "coins", newCoinBalance);

    Users.SendJSON(user, {
      _cmd: "coinUpdate",
      coins: newCoinBalance,
      success: true,
    });

    return {
      petName: petName,
      _cmd: "sellPet",
      isSuccess: true,
      coins: newCoinBalance,
    };
  } catch (e) {
    return { _cmd: "sellPet", isSuccess: false, msg: "Server error." };
  }
}
