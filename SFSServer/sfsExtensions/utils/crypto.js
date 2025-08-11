// Crypto utilities for reversible IP encryption using AES-CBC + HMAC-SHA256
// Blob format: v1:<base64(iv)>:<base64(ciphertext)>:<base64(tag)>

(function () {
  var Cipher = Packages.javax.crypto.Cipher;
  var SecretKeySpec = Packages.javax.crypto.spec.SecretKeySpec;
  var IvParameterSpec = Packages.javax.crypto.spec.IvParameterSpec;
  var SecureRandom = Packages.java.security.SecureRandom;
  var Mac = Packages.javax.crypto.Mac;
  var Arrays = Packages.java.util.Arrays;

  // Pure JavaScript Base64 implementation to avoid Java class resolution issues
  var b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  var b64tab = {};
  for (var i = 0; i < b64chars.length; i++) {
    b64tab[b64chars.charAt(i)] = i;
  }

  function b64encode(bytes) {
    var str = '';
    var len = bytes.length;
    for (var i = 0; i < len; i += 3) {
      var b1 = bytes[i] & 0xff;
      var b2 = i + 1 < len ? bytes[i + 1] & 0xff : 0;
      var b3 = i + 2 < len ? bytes[i + 2] & 0xff : 0;
      
      var e1 = b1 >> 2;
      var e2 = ((b1 & 3) << 4) | (b2 >> 4);
      var e3 = ((b2 & 15) << 2) | (b3 >> 6);
      var e4 = b3 & 63;
      
      str += b64chars.charAt(e1) + b64chars.charAt(e2);
      str += i + 1 < len ? b64chars.charAt(e3) : '=';
      str += i + 2 < len ? b64chars.charAt(e4) : '=';
    }
    return str;
  }

  function b64decode(text) {
    var str = String(text).replace(/[^A-Za-z0-9\+\/\=]/g, '');
    var result = [];
    var len = str.length;
    
    for (var i = 0; i < len; i += 4) {
      var e1 = b64tab[str.charAt(i)];
      var e2 = b64tab[str.charAt(i + 1)];
      var e3 = b64tab[str.charAt(i + 2)];
      var e4 = b64tab[str.charAt(i + 3)];
      
      var b1 = (e1 << 2) | (e2 >> 4);
      var b2 = ((e2 & 15) << 4) | (e3 >> 2);
      var b3 = ((e3 & 3) << 6) | e4;
      
      result.push(b1);
      if (e3 !== undefined) result.push(b2);
      if (e4 !== undefined) result.push(b3);
    }
    
    // Convert JavaScript array to Java byte array
    var javaBytes = java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, result.length);
    for (var i = 0; i < result.length; i++) {
      // Convert to signed byte (-128 to 127)
      var byteValue = result[i] & 0xff;
      if (byteValue > 127) {
        byteValue = byteValue - 256;
      }
      javaBytes[i] = new java.lang.Byte(byteValue);
    }
    return javaBytes;
  }

  function getConfigValue(key) {
    try {
      var q = dbase.executeQuery(
        "SELECT `value` FROM config WHERE `key`='" + _server.escapeQuotes(String(key)) + "' LIMIT 1;"
      );
      if (q != null && q.size() > 0) {
        return String(q.get(0).getItem("value"));
      }
    } catch (e) {
      trace("crypto.js: getConfigValue error for key '" + key + "': " + e);
    }
    return null;
  }

  function setConfigValue(key, value) {
    try {
      var existing = dbase.executeQuery(
        "SELECT `value` FROM config WHERE `key`='" + _server.escapeQuotes(String(key)) + "' LIMIT 1;"
      );
      if (existing != null && existing.size() > 0) {
        return Boolean(
          dbase.executeCommand(
            "UPDATE config SET `value`='" + _server.escapeQuotes(String(value)) + "' WHERE `key`='" + _server.escapeQuotes(String(key)) + "';"
          )
        );
      } else {
        return Boolean(
          dbase.executeCommand(
            "INSERT INTO config (`key`, `value`) VALUES ('" + _server.escapeQuotes(String(key)) + "', '" + _server.escapeQuotes(String(value)) + "');"
          )
        );
      }
    } catch (e) {
      trace("crypto.js: setConfigValue error for key '" + key + "': " + e);
      return false;
    }
  }

  function generateKey(bytesLen) {
    var rng = new SecureRandom();
    var keyBytes = java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, bytesLen);
    rng.nextBytes(keyBytes);
    return keyBytes;
  }

  function ensureKeys() {
    // Use AES-128 (16 bytes) to avoid IllegalKeySize on older JVMs without unlimited policy
    var encKeyB64 = getConfigValue("ipEncKey");
    var macKeyB64 = getConfigValue("ipMacKey");

    if (!encKeyB64 || !macKeyB64) {
      // generate and persist (AES-128 + 32-byte HMAC key)
      var encKey = generateKey(16);
      var macKey = generateKey(32);
      encKeyB64 = b64encode(encKey);
      macKeyB64 = b64encode(macKey);
      setConfigValue("ipEncKey", encKeyB64);
      setConfigValue("ipMacKey", macKeyB64);
      trace("crypto.js: generated and stored new ipEncKey/ipMacKey in config (AES-128).");
    }

    var encKeyBytes = b64decode(encKeyB64);
    var macKeyBytes = b64decode(macKeyB64);

    // If encKey is not 16 bytes, downgrade to 16 to satisfy JVM policy
    if (encKeyBytes.length != 16) {
      var newEnc = java.util.Arrays.copyOf(encKeyBytes, 16);
      encKeyBytes = newEnc;
      try {
        setConfigValue("ipEncKey", b64encode(encKeyBytes));
        trace("crypto.js: adjusted ipEncKey to 16 bytes (AES-128) for compatibility.");
      } catch (e) {
        trace("crypto.js: failed to persist adjusted AES key: " + e);
      }
    }

    return { encKeyBytes: encKeyBytes, macKeyBytes: macKeyBytes };
  }

  function encryptIp(ip) {
    try {
      var keys = ensureKeys();
      var iv = generateKey(16);
      var ivSpec = new IvParameterSpec(iv);
      var keySpec = new SecretKeySpec(keys.encKeyBytes, "AES");
      var cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
      cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);
      var ct = cipher.doFinal(new java.lang.String(String(ip)).getBytes("UTF-8"));

      var mac = Mac.getInstance("HmacSHA256");
      mac.init(new SecretKeySpec(keys.macKeyBytes, "HmacSHA256"));
      mac.update(iv, 0, iv.length);
      mac.update(ct, 0, ct.length);
      var tag = mac.doFinal();

      return [
        "v1",
        b64encode(iv),
        b64encode(ct),
        b64encode(tag)
      ].join(":");
    } catch (e) {
      trace("crypto.js: encryptIp error: " + e);
      return null;
    }
  }

  function decryptIp(blob) {
    try {
      var parts = String(blob || "").split(":");
      if (parts.length !== 4 || parts[0] !== "v1") return null;
      var iv = b64decode(parts[1]);
      var ct = b64decode(parts[2]);
      var tag = b64decode(parts[3]);

      var keys = ensureKeys();
      var mac = Mac.getInstance("HmacSHA256");
      mac.init(new SecretKeySpec(keys.macKeyBytes, "HmacSHA256"));
      mac.update(iv, 0, iv.length);
      mac.update(ct, 0, ct.length);
      var calc = mac.doFinal();
      if (!Arrays.equals(tag, calc)) {
        trace("crypto.js: decryptIp tag mismatch");
        return null;
      }

      var keySpec = new SecretKeySpec(keys.encKeyBytes, "AES");
      var cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
      cipher.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv));
      var pt = cipher.doFinal(ct);
      return new java.lang.String(pt, "UTF-8");
    } catch (e) {
      trace("crypto.js: decryptIp error: " + e);
      return null;
    }
  }

  // Expose global helper
  this.CryptoUtil = {
    encryptIp: encryptIp,
    decryptIp: decryptIp
  };
})();


