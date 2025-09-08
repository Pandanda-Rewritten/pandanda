// Bad words configuration file
// This module queries the database directly for better performance and consistency
// All functions maintain backward compatibility with existing code
//
// USAGE:
// 1. Call initializeBadWordsDB() once during server startup to ensure database is initialized
// 2. Use containsBadWord(message) to check if a message contains bad words
// 3. Use getTriggeredBadWord(message) to get the specific bad word that was found
// 4. Use addBadWord(word) and removeBadWord(word) to manage the word list
// 5. Use getAllBadWords() to get the complete list of bad words
//
// DATABASE SCHEMA:
// Table: config
// Key: 'badWordsList'
// Value: comma-separated list of bad words (e.g., "word1,word2,word3")

// Default bad words list for initialization if database is empty
var defaultBadWords = [];

// Helper function to get bad words from database (optimized)
function getBadWordsFromDB() {
  try {
    var result = dbase.executeQuery("SELECT value FROM config WHERE `key` = 'badWordsList';");
    
    if (result && result.size() > 0) {
      var badWordsStr = result.get(0).getItem("value");
      if (badWordsStr && badWordsStr.trim() !== "") {
        return badWordsStr.split(",");
      }
    }
    
    return null;
  } catch (e) {
    trace("Error getting bad words from database: " + e);
    return null;
  }
}

// Helper function to save bad words to database (optimized)
function saveBadWordsToDB(badWordsArray) {
  try {
    var badWordsStr = badWordsArray.join(",");
    
    // Use INSERT ... ON DUPLICATE KEY UPDATE for better performance
    // or check if entry exists first for compatibility
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
    trace("Error saving bad words to database: " + e);
    return false;
  }
}

// Initialize database with default words if needed
function initializeBadWordsDB() {
  try {
    var result = dbase.executeQuery("SELECT value FROM config WHERE `key` = 'badWordsList';");
    
    if (!result || result.size() === 0) {
      // No entry exists, create one with default words
      saveBadWordsToDB(defaultBadWords);
      trace("Initialized bad words database with " + defaultBadWords.length + " default words");
    } else {
      var dbValue = result.get(0).getItem("value");
      if (!dbValue || dbValue.trim() === "") {
        // Entry exists but is empty, update with default words
        saveBadWordsToDB(defaultBadWords);
        trace("Updated empty bad words database with " + defaultBadWords.length + " default words");
      }
    }
  } catch (e) {
    trace("Error initializing bad words database: " + e);
  }
}

// Function to check if a message contains bad words
function containsBadWord(message) {
  try {
    var messageLower = message.toLowerCase();
    var badWords = getBadWordsFromDB();
    
    if (badWords) {
      for (var i = 0; i < badWords.length; i++) {
        var word = badWords[i].trim();
        if (word && isExactWordMatch(messageLower, word)) {
          return true;
        }
      }
    }
    
    return false;
  } catch (e) {
    trace("Error checking bad words: " + e);
    return false;
  }
}

// Function to get the bad word that triggered the filter
function getTriggeredBadWord(message) {
  try {
    var messageLower = message.toLowerCase();
    var badWords = getBadWordsFromDB();
    
    if (badWords) {
      for (var i = 0; i < badWords.length; i++) {
        var word = badWords[i].trim();
        if (word && isExactWordMatch(messageLower, word)) {
          return word;
        }
      }
    }
    
    return null;
  } catch (e) {
    trace("Error getting triggered bad word: " + e);
    return null;
  }
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
  try {
    // Convert to lowercase for consistency
    word = word.toLowerCase().trim();
    
    if (!word) {
      return false; // Empty word
    }
    
    // Get current bad words from database
    var badWords = getBadWordsFromDB();
    
    if (badWords) {
      // Check if word already exists
      for (var i = 0; i < badWords.length; i++) {
        if (badWords[i].trim() === word) {
          return false; // Word already exists
        }
      }
      
      // Add the new word
      badWords.push(word);
      
      // Save to database
      if (saveBadWordsToDB(badWords)) {
        trace("Added bad word: " + word);
        return true; // Word was added
      }
    } else {
      // No entry exists, create one with the new word
      if (saveBadWordsToDB([word])) {
        trace("Created bad words list with word: " + word);
        return true;
      }
    }
    
    return false;
  } catch (e) {
    trace("Error adding bad word: " + e);
    return false;
  }
}

// Function to remove a word from the bad words list
function removeBadWord(word) {
  try {
    // Convert to lowercase for consistency
    word = word.toLowerCase().trim();
    
    if (!word) {
      return false; // Empty word
    }
    
    // Get current bad words from database
    var badWords = getBadWordsFromDB();
    
    if (badWords) {
      var wordFound = false;
      var newBadWords = [];
      
      // Remove the word from the list
      for (var i = 0; i < badWords.length; i++) {
        if (badWords[i].trim() !== word) {
          newBadWords.push(badWords[i]);
        } else {
          wordFound = true;
        }
      }
      
      if (wordFound) {
        // Save updated list to database
        if (saveBadWordsToDB(newBadWords)) {
          trace("Removed bad word: " + word);
          return true; // Word was removed
        }
      }
    }
    
    return false; // Word wasn't in the list
  } catch (e) {
    trace("Error removing bad word: " + e);
    return false;
  }
}

// Function to get the list of all bad words
function getAllBadWords() {
  try {
    var badWords = getBadWordsFromDB();
    
    if (badWords) {
      // Trim each word and filter out empty strings
      var trimmedWords = [];
      for (var i = 0; i < badWords.length; i++) {
        var word = badWords[i].trim();
        if (word) {
          trimmedWords.push(word);
        }
      }
      return trimmedWords;
    }
    
    return []; // Return empty array if no words found
  } catch (e) {
    trace("Error getting all bad words: " + e);
    return [];
  }
} 