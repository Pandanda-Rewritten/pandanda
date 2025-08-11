// Bad words configuration file
// This list should be customized with the actual words you want to filter
// The words are stored in lowercase for easier comparison

// Use global variable to ensure bad words list is shared across all modules
if (typeof globalBadWords === 'undefined') {
  globalBadWords = []; // Start with empty array - will be populated from database
}

var badWords = globalBadWords; // Reference the global array

// Load bad words from the database
function loadBadWordsFromDB() {
  try {
    if (typeof dbase === 'undefined' || dbase === null) {
      trace("loadBadWordsFromDB: ERROR - Database connection not available");
      return;
    }
    
    var result = dbase.executeQuery("SELECT value FROM config WHERE `key` = 'badWordsList';");
    
    if (result && result.size() > 0) {
      var dbBadWords = result.get(0).getItem("value");
      
      if (dbBadWords && dbBadWords.trim() !== "") {
        // Replace the default list with the database version
        badWords = dbBadWords.split(",");
        trace("loadBadWordsFromDB: Successfully loaded " + badWords.length + " bad words from database");
      } else {
        // If the list is empty in the DB, use empty list
        badWords = [];
      }
    } else {
      // If there's no entry in the database, use empty list
      badWords = [];
    }
  } catch (e) {
    trace("loadBadWordsFromDB: Error loading bad words from database: " + e);
  }
}

// Save bad words to the database
function saveBadWordsToDB() {
  try {
    if (typeof dbase === 'undefined' || dbase === null) {
      trace("saveBadWordsToDB: ERROR - Database connection not available");
      return false;
    }
    
    var badWordsStr = badWords.join(",");
    
    // Check if the config entry exists
    var result = dbase.executeQuery("SELECT 1 FROM config WHERE `key` = 'badWordsList';");
    
    if (result && result.size() > 0) {
      // Update existing entry
      dbase.executeCommand(
        "UPDATE config SET value = '" + _server.escapeQuotes(badWordsStr) + "' " +
        "WHERE `key` = 'badWordsList';"
      );
    } else {
      // Create new entry
      dbase.executeCommand(
        "INSERT INTO config(`key`, value) VALUES('badWordsList', '" + 
        _server.escapeQuotes(badWordsStr) + "');"
      );
    }
    
    return true;
  } catch (e) {
    trace("saveBadWordsToDB: Error saving bad words to database: " + e);
    return false;
  }
}

// Function to check if a message contains bad words
function containsBadWord(message) {
  var messageLower = message.toLowerCase();
  
  for (var i = 0; i < badWords.length; i++) {
    if (isExactWordMatch(messageLower, badWords[i])) {
      return true;
    }
  }
  
  return false;
}

// Function to get the bad word that triggered the filter
function getTriggeredBadWord(message) {
  var messageLower = message.toLowerCase();
  
  for (var i = 0; i < badWords.length; i++) {
    if (isExactWordMatch(messageLower, badWords[i])) {
      return badWords[i];
    }
  }
  
  return null;
}

// Helper function to check for exact word matches (not substrings)
function isExactWordMatch(message, badWord) {
  // Handle phrases with spaces - keep original behavior
  if (badWord.indexOf(" ") !== -1) {
    return message.indexOf(badWord) !== -1;
  }
  
  // Method 1: Check for space/punctuation boundaries (safest)
  var paddedMessage = " " + message + " ";
  var paddedBadWord = " " + badWord + " ";
  
  if (paddedMessage.indexOf(paddedBadWord) !== -1) {
    return true;
  }
  
  // Method 2: For longer bad words (4+ chars), allow compound matching
  // This reduces false positives since very short words are more likely to appear in other words
  if (badWord.length >= 4) {
    var messageLen = message.length;
    var badWordLen = badWord.length;
    var startPos = 0;
    
    while ((startPos = message.indexOf(badWord, startPos)) !== -1) {
      var endPos = startPos + badWordLen;
      
      // Check if it's at the start or end of the message
      var atStart = (startPos === 0);
      var atEnd = (endPos === messageLen);
      
      // Check characters before/after
      var beforeChar = startPos > 0 ? message.charAt(startPos - 1) : " ";
      var afterChar = endPos < messageLen ? message.charAt(endPos) : " ";
      
      var beforeNonLetter = !isLetter(beforeChar);
      var afterNonLetter = !isLetter(afterChar);
      
      // Allow if: complete word, at start/end, or has at least one non-letter boundary
      if ((atStart && atEnd) || (atStart && afterNonLetter) || (atEnd && beforeNonLetter) || (beforeNonLetter && afterNonLetter)) {
        return true;
      }
      
      startPos++;
    }
  }
  
  return false;
}

// Simple helper to check if character is a letter
function isLetter(c) {
  return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}

// Function to add a word to the bad words list
function addBadWord(word) {
  // Convert to lowercase for consistency
  word = word.toLowerCase();
  
  // Check if the word already exists in the list
  if (badWords.indexOf(word) === -1) {
    badWords.push(word);
    // Save the updated list to the database
    saveBadWordsToDB();
    return true; // Word was added
  }
  
  return false; // Word already exists
}

// Function to remove a word from the bad words list
function removeBadWord(word) {
  // Convert to lowercase for consistency
  word = word.toLowerCase();
  
  // Check if the word exists in the list
  var index = badWords.indexOf(word);
  if (index !== -1) {
    badWords.splice(index, 1);
    // Save the updated list to the database
    saveBadWordsToDB();
    return true; // Word was removed
  }
  
  return false; // Word wasn't in the list
}

// Function to get the list of all bad words
function getAllBadWords() {
  return badWords.slice(); // Return a copy of the array
}

// Function to get the current status of bad words loading
function getBadWordsStatus() {
  return {
    totalWords: badWords.length,
    isLoadedFromDB: true, // Always loaded from DB now (no backup list)
    sampleWords: badWords.slice(0, 5) // First 5 words for verification
  };
} 