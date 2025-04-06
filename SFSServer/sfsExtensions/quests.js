function startQuest(user, questid) {
  var qAvailable = user.properties.get("qAvailable") || "";
  var qActive = user.properties.get("qActive") || "";

  var questToMove = null;
  var qAvailableUpdated = "";
  var questFound = false;

  var qAvailableQuests = qAvailable.split(",");
  for (var i = 0; i < qAvailableQuests.length; i++) {
    if (qAvailableQuests[i].indexOf(questid + ":") === 0) {
      questToMove = qAvailableQuests[i];
      questFound = true;
    } else {
      qAvailableUpdated += (qAvailableUpdated ? "," : "") + qAvailableQuests[i];
    }
  }

  if (questFound) {
    var questToMoveWithStatus = questToMove + ":0";

    var qActiveUpdated = qActive
      ? qActive + "," + questToMoveWithStatus
      : questToMoveWithStatus;

    user.properties.put("qAvailable", qAvailableUpdated);
    user.properties.put("qActive", qActiveUpdated);

    Users.UpdateCrumb(
      user.properties.get("id"),
      "qAvailable",
      qAvailableUpdated
    );

    Users.UpdateCrumb(user.properties.get("id"), "qActive", qActiveUpdated);

    return {
      _cmd: "quest",
      cmd2: "start",
      active: qActiveUpdated,
      available: qAvailableUpdated,
      isSuccess: true,
    };
  } else {
    return {
      _cmd: "quest",
      cmd2: "start",
      isSuccess: false,
      msg: "Quest not found in available quests.",
    };
  }
}

function updateQuest(user, itemId) {
  var qActive = user.properties.get("qActive") || "";
  var qItems = user.properties.get("qItems") || "";
  var qActiveQuests = qActive.split(",");
  var filteredQuests = [];
  for (var i = 0; i < qActiveQuests.length; i++) {
    if (qActiveQuests[i].trim() !== "") {
      filteredQuests.push(qActiveQuests[i]);
    }
  }
  qActiveQuests = filteredQuests;

  var questId = null;
  var questItems = null;

  for (var i = 0; i < qActiveQuests.length; i++) {
    var questParts = qActiveQuests[i].split(":");
    if (questParts.length < 2) continue;

    if (questParts[1].indexOf(itemId) !== -1) {
      questId = questParts[0];
      questItems = questParts[1];
      break;
    }
  }

  if (!questId) {
    return {
      _cmd: "quest",
      cmd2: "update",
      isSuccess: false,
      msg: "Item not found in any active quest.",
    };
  }

  var qItemsMap = {};
  var itemsArray = qItems.split(",");
  for (var j = 0; j < itemsArray.length; j++) {
    var item = itemsArray[j];
    var parts = item.split("-");
    if (parts.length === 2) {
      qItemsMap[parts[0]] = parseInt(parts[1]) || 0;
    }
  }

  qItemsMap[itemId] = (qItemsMap[itemId] || 0) + 1;

  var updatedQItems = "";
  for (var key in qItemsMap) {
    if (qItemsMap.hasOwnProperty(key)) {
      if (updatedQItems !== "") updatedQItems += ",";
      updatedQItems += key + "-" + qItemsMap[key];
    }
  }

  user.properties.put("qItems", updatedQItems);
  Users.UpdateCrumb(user.properties.get("id"), "qItems", updatedQItems);

  var isComplete = checkQuestCompletion(questItems, qItemsMap);

  if (isComplete) {
    var updatedQuests = [];
    for (var k = 0; k < qActiveQuests.length; k++) {
      var quest = qActiveQuests[k];
      if (quest.indexOf(questId + ":") === 0) {
        var lastColon = quest.lastIndexOf(":");
        quest = quest.substring(0, lastColon) + ":1";
      }
      updatedQuests.push(quest);
    }
    var updatedQActive = updatedQuests.join(",");

    user.properties.put("qActive", updatedQActive);
    Users.UpdateCrumb(user.properties.get("id"), "qActive", updatedQActive);
  }

  return {
    itemId: String(itemId),
    questId: String(questId),
    cmd2: "update",
    _cmd: "quest",
    items: String(updatedQItems),
    isComplete: isComplete,
    active: isComplete ? updatedQActive : qActive,
  };
}

function checkQuestCompletion(questItems, qItemsMap) {
  var requirementsStr = String(questItems);

  var requirements = requirementsStr.split("^");

  for (var i = 0; i < requirements.length; i++) {
    var parts = requirements[i].split("-");
    if (parts.length !== 2) {
      continue;
    }

    var item = parts[0];
    var needed = parseInt(parts[1]);
    var has = parseInt(qItemsMap[item]) || 0;

    if (has < needed) {
      return false;
    }
  }
  return true;
}
function questDrop(user, questid) {
  var qActive = user.properties.get("qActive") + "";
  var qAvailable = user.properties.get("qAvailable") + "";
  var qItems = user.properties.get("qItems") + "";

  var activeQuests = qActive.split(",");
  var newActiveQuests = [];
  var questToMove = null;
  var itemsToRemove = {};

  for (var i = 0; i < activeQuests.length; i++) {
    var quest = activeQuests[i];
    if (!quest) continue;

    if (quest.indexOf(questid + ":") === 0) {
      var lastColon = quest.lastIndexOf(":");
      questToMove = quest.substring(0, lastColon);

      var itemsPart = quest.split(":")[1];
      if (itemsPart) {
        var itemPairs = itemsPart.split("^");
        for (var j = 0; j < itemPairs.length; j++) {
          var pair = itemPairs[j].split("-");
          if (pair.length === 2) {
            itemsToRemove[pair[0]] = parseInt(pair[1]) || 0;
          }
        }
      }
    } else {
      newActiveQuests.push(quest);
    }
  }

  if (!questToMove) {
    return {
      _cmd: "quest",
      cmd2: "drop",
      isSuccess: false,
      msg: "Quest not found in active quests.",
    };
  }

  var currentItems = qItems.split(",");
  var itemMap = {};

  for (var k = 0; k < currentItems.length; k++) {
    if (!currentItems[k]) continue;
    var parts = currentItems[k].split("-");
    if (parts.length === 2) {
      itemMap[parts[0]] = parseInt(parts[1]) || 0;
    }
  }
  for (var itemId in itemsToRemove) {
    if (itemsToRemove.hasOwnProperty(itemId)) {
      if (itemMap[itemId]) {
        itemMap[itemId] -= itemsToRemove[itemId];
        if (itemMap[itemId] <= 0) {
          delete itemMap[itemId];
        }
      }
    }
  }

  var newItems = [];
  for (var id in itemMap) {
    if (itemMap.hasOwnProperty(id)) {
      newItems.push(id + "-" + itemMap[id]);
    }
  }
  var newQItems = newItems.join(",");

  var newQAvailable = qAvailable;
  if (newQAvailable) {
    newQAvailable += "," + questToMove;
  } else {
    newQAvailable = questToMove;
  }

  user.properties.put("qActive", newActiveQuests.join(","));
  user.properties.put("qAvailable", newQAvailable);
  user.properties.put("qItems", newQItems);

  Users.UpdateCrumb(
    user.properties.get("id"),
    "qActive",
    newActiveQuests.join(",")
  );
  Users.UpdateCrumb(user.properties.get("id"), "qAvailable", newQAvailable);
  Users.UpdateCrumb(user.properties.get("id"), "qItems", newQItems);

  return {
    _cmd: "quest",
    cmd2: "drop",
    active: newActiveQuests.join(","),
    available: newQAvailable,
    items: newQItems,
    isSuccess: true,
  };
}

function completeQuest(user, questid) {
  var qActive = user.properties.get("qActive") + "";
  var qAvailable = user.properties.get("qAvailable") + "";
  var qItems = user.properties.get("qItems") + "";
  var qCount = parseInt(user.properties.get("qCount")) || 0;
  var coins = parseInt(user.properties.get("coins")) || 0;
  var xp = parseInt(user.properties.get("xp")) || 0;
  var level = parseInt(user.properties.get("level")) || 1;
  var xpLevel = parseInt(user.properties.get("xpLevel")) || 300;

  var activeQuests = qActive.split(",");
  var newActiveQuests = [];
  var questReward = null;
  var itemsToRemove = {};

  for (var i = 0; i < activeQuests.length; i++) {
    var quest = activeQuests[i];
    if (!quest) continue;

    if (quest.indexOf(questid + ":") === 0) {
      var parts = quest.split(":");
      if (parts.length >= 4) {
        questReward = {
          coins: parseInt(parts[2]) || 0,
          xp: parseInt(parts[3]) || 0,
          items: parts[1] || "",
        };

        var itemPairs = questReward.items.split("^");
        for (var j = 0; j < itemPairs.length; j++) {
          var pair = itemPairs[j].split("-");
          if (pair.length === 2) {
            itemsToRemove[pair[0]] = parseInt(pair[1]) || 0;
          }
        }
      }
    } else {
      newActiveQuests.push(quest);
    }
  }

  if (!questReward) {
    return {
      _cmd: "quest",
      cmd2: "complete",
      isSuccess: false,
      msg: "Quest not found in active quests.",
    };
  }

  var nextQuestEntry = checkForNextQuest(questid, qAvailable);
  if (nextQuestEntry) {
    user.properties.put("qActive", newActiveQuests.join(","));

    var newQAvailable = qAvailable
      ? processQAvailable(String(qAvailable) + "," + String(nextQuestEntry))
      : processQAvailable(String(nextQuestEntry));

    user.properties.put("qAvailable", newQAvailable);

    Users.UpdateCrumb(
      user.properties.get("id"),
      "qActive",
      newActiveQuests.join(",")
    );
    Users.UpdateCrumb(user.properties.get("id"), "qAvailable", newQAvailable);

    var nextQuestId = nextQuestEntry.split(":")[0];
    var startResult = startQuest(user, nextQuestId);
    return Users.SendJSON(user, startResult);
  }

  var currentItems = qItems.split(",");
  var itemMap = {};

  for (var k = 0; k < currentItems.length; k++) {
    if (!currentItems[k]) continue;
    var parts = currentItems[k].split("-");
    if (parts.length === 2) {
      itemMap[parts[0]] = parseInt(parts[1]) || 0;
    }
  }

  for (var itemId in itemsToRemove) {
    if (itemsToRemove.hasOwnProperty(itemId)) {
      if (itemMap[itemId]) {
        itemMap[itemId] -= itemsToRemove[itemId];
        if (itemMap[itemId] <= 0) {
          delete itemMap[itemId];
        }
      }
    }
  }

  var newItems = [];
  for (var id in itemMap) {
    if (itemMap.hasOwnProperty(id)) {
      newItems.push(id + "-" + itemMap[id]);
    }
  }
  var newQItems = newItems.join(",");

  var newCoins = coins + questReward.coins;
  var newXp = xp + questReward.xp;
  var newQCount = qCount + 1;

  var newLevel = level;
  var newXpLevel = xpLevel;
  if (newXp >= xpLevel) {
    newLevel++;
    newXpLevel = newLevel * 300;
    newXp = newXp - xpLevel;
  }

  user.properties.put("qActive", newActiveQuests.join(","));
  user.properties.put("qItems", newQItems);
  user.properties.put("coins", newCoins);
  user.properties.put("xp", newXp);
  user.properties.put("level", newLevel);
  user.properties.put("qCount", newQCount);

  Users.UpdateCrumb(
    user.properties.get("id"),
    "qActive",
    newActiveQuests.join(",")
  );
  Users.UpdateCrumb(user.properties.get("id"), "qItems", newQItems);
  Users.UpdateCrumb(user.properties.get("id"), "coins", newCoins);
  Users.UpdateCrumb(user.properties.get("id"), "xp", newXp);
  Users.UpdateCrumb(user.properties.get("id"), "level", newLevel);
  Users.UpdateCrumb(user.properties.get("id"), "xpLevel", newXpLevel);
  Users.UpdateCrumb(user.properties.get("id"), "qCount", newQCount);

  return {
    questId: questid,
    coins: newCoins,
    xpLevel: newXpLevel,
    level: newLevel,
    cmd2: "complete",
    _cmd: "quest",
    xp: newXp,
    available: qAvailable,
    qCount: newQCount,
    active: newActiveQuests.join(","),
    isSuccess: true,
  };
}

function checkForNextQuest(currentQuestId, qAvailableString) {
  try {
    var baseId = currentQuestId.substring(0, 4);
    var currentLetter = currentQuestId.charAt(4);
    var nextLetter = String.fromCharCode(currentLetter.charCodeAt(0) + 1);
    var nextQuestBaseId = baseId + nextLetter;

    var qAvailable = qAvailableString.split(",");
    for (var i = 0; i < qAvailable.length; i++) {
      var questEntry = qAvailable[i];
      if (questEntry.indexOf(nextQuestBaseId + ":") === 0) {
        return questEntry;
      }
    }

    var qRes = dbase.executeQuery(
      "SELECT CONCAT(quest_id, ':', requirements, ':', reward_coins, ':', reward_xp) AS full_entry " +
        "FROM quests WHERE quest_id='" +
        _server.escapeQuotes(nextQuestBaseId) +
        "';"
    );

    if (qRes && qRes.size() > 0) {
      return qRes.get(0).getItem("full_entry");
    }
  } catch (e) {
    trace("Error in checkForNextQuest: " + e);
  }
  return null;
}

function checkForNextQuest(currentQuestId, userQAvailable) {
  try {
    var baseId = currentQuestId.substring(0, 4);
    var currentLetter = currentQuestId.charAt(4);
    var nextLetter = String.fromCharCode(currentLetter.charCodeAt(0) + 1);
    var nextQuestId = baseId + nextLetter;

    var userAvailable = userQAvailable.split(",");
    for (var i = 0; i < userAvailable.length; i++) {
      if (userAvailable[i].indexOf(nextQuestId + ":") === 0) {
        return userAvailable[i];
      }
    }

    var qRes = dbase.executeQuery(
      "SELECT `value` FROM config WHERE `key`='qAvailable';"
    );

    if (qRes && qRes.size() > 0) {
      var serverQAvailable = qRes.get(0).getItem("value");
      var serverAvailable = serverQAvailable.split(",");

      for (var j = 0; j < serverAvailable.length; j++) {
        if (serverAvailable[j].indexOf(nextQuestId + ":") === 0) {
          return serverAvailable[j];
        }
      }
    }
  } catch (e) {
    trace("Error in checkForNextQuest: " + e);
  }
  return null;
}
