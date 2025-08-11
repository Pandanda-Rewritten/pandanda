// Crypto utilities for reversible IP encryption using AES-CBC + HMAC-SHA256

(function () {
  var Cipher = Packages.javax.crypto.Cipher;
  var SecretKeySpec = Packages.javax.crypto.spec.SecretKeySpec;
  var IvParameterSpec = Packages.javax.crypto.spec.IvParameterSpec;
  var SecureRandom = Packages.java.security.SecureRandom;
  var Mac = Packages.javax.crypto.Mac;
  var Arrays = Packages.java.util.Arrays;
  var BASE64Encoder = Packages.sun.misc.BASE64Encoder;
  var BASE64Decoder = Packages.sun.misc.BASE64Decoder;

  function b64encode(bytes) {
    var enc = new BASE64Encoder().encode(bytes);
    // remove CR/LF inserted by encoder
    return String(enc).replace(/\r|\n/g, "");
  }

  function b64decode(text) {
    return new BASE64Decoder().decodeBuffer(String(text));
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


