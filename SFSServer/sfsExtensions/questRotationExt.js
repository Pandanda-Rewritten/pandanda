var dbase, zone, _sfs;
var timerRef; // Reference to keep track of timer
var debugMode = false; // Debug mode flag
var debugInterval = 10000; // 2 minutes in milliseconds
var normalInterval = 60000; // 1 minute in milliseconds

// Import utility functions
eval(_server.readFile("utils/functions.js"));

function init() {
  dbase = _server.getDatabaseManager();
  zone = _server.getCurrentZone();
  _sfs = Packages.it.gotoandplay.smartfoxserver.SmartFoxServer;
  
  var interval = debugMode ? debugInterval : normalInterval;
  
  // Schedule the quest rotation check
  timerRef = setInterval("checkAndRotateQuests", interval);
  
  trace("QuestRotation extension initialized - Debug mode: " + debugMode + " - Interval: " + (interval/1000) + " seconds");
}

function destroy() {
  // Clear the interval when the extension is destroyed
  if (timerRef) {
    clearInterval(timerRef);
  }
  trace("QuestRotation extension destroyed");
}

function checkAndRotateQuests() {
  var now = new Date();
  var currentUnixTime = now.getTime();
  
  try {
    // Get rotation configuration
    var configResult = dbase.executeQuery(
      "SELECT " +
      "(SELECT config_value FROM questConfig WHERE config_key = 'rotationHour') AS rotationHour, " +
      "(SELECT config_value FROM questConfig WHERE config_key = 'lastRotationDate') AS lastRotationDate"
    );
    
    if (configResult && configResult.size() > 0) {
      var rotationHour = 18; // Fixed to 12:00 UTC
      var lastRotationUnixTime = parseInt(configResult.get(0).getItem("lastRotationDate")) || 0;
      
      // Check if unix time matches current time (prevent duplicate updates)
      if (lastRotationUnixTime === currentUnixTime) {
        return;
      }
      
      var shouldRotate = false;
      var rotationReason = "";
      
      if (debugMode) {
        // In debug mode, ignore rotation hour and just rotate based on debug interval
        var timeSinceLastRotation = currentUnixTime - lastRotationUnixTime;
        
        if (timeSinceLastRotation >= debugInterval) {
          shouldRotate = true;
          rotationReason = "Debug mode: " + (debugInterval / 1000) + " seconds elapsed since last rotation";
        }
      } else {
        // Normal mode: rotate at 12:00 UTC if haven't rotated today
        var todayRotationTime = new Date();
        todayRotationTime.setUTCHours(rotationHour, 0, 0, 0); // Set to 12:00:00.000 UTC
        
        var todayStart = new Date();
        todayStart.setUTCHours(0, 0, 0, 0); // Start of today in UTC
        
        var lastRotationDate = new Date(lastRotationUnixTime);
        
        // Check if last rotation was today by comparing dates
        var hasRotatedToday = lastRotationUnixTime >= todayStart.getTime();
        
        // Rotate if:
        // 1. Current time is past today's rotation time (12:00 UTC)
        // 2. Haven't rotated today yet (based on Unix timestamp)
        if (now >= todayRotationTime && !hasRotatedToday) {
          shouldRotate = true;
          rotationReason = "Normal mode: Past 12:00 UTC and haven't rotated today";
        }
      }
      
      if (shouldRotate) {
        trace("====== QUESTS ROTATION STARTED ======");
        trace("Quest rotation triggered at " + now.toString() + " - " + rotationReason);
        var rotationResult = rotateQuestList();
        
        if (rotationResult.success) {
          trace("Quest rotation completed successfully");
          trace("====== QUESTS ROTATION ENDED ======");
          if (debugMode) {
            trace("Rotation result: " + JSON.stringify(rotationResult));
          }
        } else {
          trace("Quest rotation FAILED: " + rotationResult.error);
          trace("====== QUESTS ROTATION ENDED ======");
        }
        
        // Update last rotation date with current Unix timestamp
        dbase.executeCommand(
          "UPDATE questConfig " +
          "SET config_value = '" + currentUnixTime + "' " +
          "WHERE config_key = 'lastRotationDate'"
        );
        
        if (debugMode) {
          trace("Updated lastRotationDate to: " + currentUnixTime);
        }
      }
      // No console output when rotation is not needed (already rotated today)
    }
  } catch (e) {
    trace("Error in checkAndRotateQuests: " + e);
    if (debugMode) {
      trace("Full error stack: " + e.stack);
    }
  }
}

function rotateQuestList() {
  
  try {
    // Get current configuration
    var configResult = dbase.executeQuery(
      "SELECT " +
      "(SELECT config_value FROM questConfig WHERE config_key = 'currentQListDay') AS currentQListDay, " +
      "(SELECT config_value FROM questConfig WHERE config_key = 'totalQListDays') AS totalQListDays"
    );
    
    if (configResult && configResult.size() > 0) {
      var currentQListDay = parseInt(configResult.get(0).getItem("currentQListDay")) || 1;
      var totalQListDays = parseInt(configResult.get(0).getItem("totalQListDays")) || 7;
      
      // Increment the day, looping back to 1 after reaching the total
      var nextQListDay = (currentQListDay % totalQListDays) + 1;
      
      // Get the quest list for the next day
      var qListKey = "qListDay" + nextQListDay;
      
      var qListResult = dbase.executeQuery(
        "SELECT config_value " +
        "FROM questConfig " +
        "WHERE config_key = '" + qListKey + "'"
      );
      
      if (qListResult && qListResult.size() > 0 && qListResult.get(0).getItem("config_value")) {
        // Update the currentQListDay
        dbase.executeCommand(
          "UPDATE questConfig " +
          "SET config_value = '" + nextQListDay + "' " +
          "WHERE config_key = 'currentQListDay'"
        );
      
        var newQuestList = qListResult.get(0).getItem("config_value");
        
        // Update the qAvailable in the main config table
        dbase.executeCommand(
          "UPDATE config " +
          "SET value = '" + _server.escapeQuotes(newQuestList) + "' " +
          "WHERE `key` = 'qAvailable'"
        );
        
        // Also update the questHash to trigger quest updates for users when they log in
        var newQuestHash = generateQuestHash();
        dbase.executeCommand(
          "UPDATE config " +
          "SET value = '" + _server.escapeQuotes(newQuestHash) + "' " +
          "WHERE `key` = 'questHash'"
        );
        
        trace("Quest rotation successful. Moved from qListDay" + currentQListDay + " to " + qListKey + " with hash " + newQuestHash);
        
        if (debugMode) {
          trace("New quest list: " + newQuestList);
        }
        
        return {
          success: true,
          previousDay: currentQListDay,
          newDay: nextQListDay,
          questList: newQuestList
        };
      } else {
        // If next day doesn't exist, cycle back to day 1
        nextQListDay = 1;
        qListKey = "qListDay1";
        
        qListResult = dbase.executeQuery(
          "SELECT config_value " +
          "FROM questConfig " +
          "WHERE config_key = '" + qListKey + "'"
        );
        
        if (qListResult && qListResult.size() > 0 && qListResult.get(0).getItem("config_value")) {
          // Update the currentQListDay to 1
          dbase.executeCommand(
            "UPDATE questConfig " +
            "SET config_value = '1' " +
            "WHERE config_key = 'currentQListDay'"
          );
          
          var newQuestList = qListResult.get(0).getItem("config_value");
          
          // Update the qAvailable in the main config table
          dbase.executeCommand(
            "UPDATE config " +
            "SET value = '" + _server.escapeQuotes(newQuestList) + "' " +
            "WHERE `key` = 'qAvailable'"
          );
          
          // Also update the questHash to trigger quest updates for users when they log in
          var newQuestHash = generateQuestHash();
          dbase.executeCommand(
            "UPDATE config " +
            "SET value = '" + _server.escapeQuotes(newQuestHash) + "' " +
            "WHERE `key` = 'questHash'"
          );
          
          trace("Next day not found. Cycled back to qListDay1 with hash " + newQuestHash);
          
          if (debugMode) {
            trace("Cycled back to day 1 - New quest list: " + newQuestList);
          }
          
          return {
            success: true,
            previousDay: currentQListDay,
            newDay: 1,
            questList: newQuestList,
            message: "Next day not found. Cycled back to Day 1."
          };
        } else {
          trace("Error: Could not find quest list for day 1");
          return {
            success: false,
            error: "Could not find quest list for day 1"
          };
        }
      }
    }
  } catch (e) {
    trace("Error rotating quest list: " + e);
    if (debugMode) {
      trace("Full error stack in rotateQuestList: " + e.stack);
    }
    return {
      success: false,
      error: "Error rotating quest list: " + e
    };
  }
}

function generateQuestHash() {
  // Generate a unique hash for the new quest configuration
  return "quest_" + new Date().getTime();
}

function formatDate(date) {
  var d = date;
  var month = "" + (d.getUTCMonth() + 1);
  var day = "" + d.getUTCDate();
  var year = d.getUTCFullYear();

  if (month.length < 2) month = "0" + month;
  if (day.length < 2) day = "0" + day;

  return [year, month, day].join("-");
}

/**
 * Handle internal events from SmartFoxServer
 *
 * @param {Object} evtObj - Event object containing event information
 */
function handleInternalEvent(evtObj) {
  // Handle specific internal events if needed
  if (evtObj.name == "serverReady") {
    trace("QuestRotation extension: Server ready");
  } else if (evtObj.name == "userLost" || evtObj.name == "logOut") {
    // Handle user disconnection if needed
  } else if (evtObj.name == "user_join_room") {
    // Handle user joining a room if needed
  }
} 