var dbase, zone, _sfs;
var popInterval;

var Decoder = {
  decodeData: function (encoded, key) {
    var rotatedBytes = Base64.decodeBytes(encoded);
    var originalBytes = [];
    var cursor = 0,
      lng = rotatedBytes.length;
    var decoded = "";
    while (cursor < lng) {
      var rotatedUint = ByteArray.readUnsignedInt(rotatedBytes, cursor);
      var originalUint = (rotatedUint << (32 - key)) | (rotatedUint >>> key);
      cursor += 4;
      ByteArray.writeUnsignedInt(originalBytes, originalUint);
    }
    for (var i = 0; i < originalBytes.length; i++)
      decoded += String.fromCharCode(originalBytes[i]);
    return decoded.split(";")[0];
  },
};

var ByteArray = {
  bigEndian: false,
  readUnsignedInt: function (byteArray, start) {
    var out = 0,
      i = 0,
      x = 0;
    for (i = 0; i < 4; i++) {
      x = this.bigEndian ? i + start : start + 3 - i;
      out += byteArray[x] << (i * 8);
    }
    return out;
  },
  writeUnsignedInt: function (byteArray, value) {
    for (var i = 0; i < 4; i++) {
      var shift = 8 * (this.bigEndian ? i : 3 - i);
      var mask = 255 << shift;
      var maskedVal = (value & mask) >> shift;
      byteArray.push(maskedVal);
    }
  },
};

var Base64 = {
  _b64chars:
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
  decodeBytes: function (input) {
    var output = [];
    var chr1, chr2, chr3;
    var enc1, enc2, enc3, enc4;
    var i = 0;
    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
    while (i < input.length) {
      enc1 = Base64._b64chars.indexOf(input.charAt(i++));
      enc2 = Base64._b64chars.indexOf(input.charAt(i++));
      enc3 = Base64._b64chars.indexOf(input.charAt(i++));
      enc4 = Base64._b64chars.indexOf(input.charAt(i++));
      chr1 = (enc1 << 2) | (enc2 >> 4);
      chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
      chr3 = ((enc3 & 3) << 6) | enc4;
      output.push(chr1);
      if (enc3 != 64) output.push(chr2);
      if (enc4 != 64) output.push(chr3);
    }
    return output;
  },
};
var result = Decoder.decodeData(
  "K5ujo5GZoYnZiZmpiamRqZmZkcGRodnJqbMbIQszIYMRucsrIcnDK6GRqxGZkYMxyzHJoaMJwyk=",
  11
);
trace(result);

function Do() {
  this.When = function (statement, closure) {
    var Handler = function (_params) {
      if (eval(_params[0]) == true) eval(_params[1]);
      trace("NOT :(");
      setTimeout(this, 1000, _params);
    };
    Handler([statement, closure]);
  };
}
var _global = { debug: true };
function ToJSArray(array) {
  return Array.prototype.slice.call(array, 0);
}
function Users() {
  this.UpdateCrumbs = function (id, object) {
    var crumbs = JSON.parse(
      dbase
        .executeQuery(
          "SELECT crumbs FROM users WHERE id='" +
            _server.escapeQuotes(id) +
            "';"
        )
        .get(0)
        .getItem("crumbs")
    );
    if (crumbs == null) crumbs = {};
    for (var i in object) {
      crumbs[i] = object[i];
      if (typeof object[i] == "undefined") delete crumbs[i];
    }
    return Boolean(
      dbase.executeCommand(
        "UPDATE users SET crumbs='" +
          _server.escapeQuotes(JSON.stringify(crumbs)).split('""').join('"') +
          "' WHERE id='" +
          _server.escapeQuotes(id) +
          "';"
      )
    );
  };
  this.UpdateCrumb = function (id, key, value) {
    var crumbs = JSON.parse(
      dbase
        .executeQuery(
          "SELECT crumbs FROM users WHERE id='" +
            _server.escapeQuotes(id) +
            "';"
        )
        .get(0)
        .getItem("crumbs")
    );
    if (crumbs == null) crumbs = {};
    crumbs[key] = value;
    return Boolean(
      dbase.executeCommand(
        "UPDATE users SET crumbs='" +
          _server.escapeQuotes(JSON.stringify(crumbs)).split('""').join('"') +
          "' WHERE id='" +
          _server.escapeQuotes(id) +
          "';"
      )
    );
  };
  this.PopulateObject = function (user, crumbs) {
    for (var i in crumbs) user.properties.put(i, crumbs[i]);
    return user;
  };
  this.SendJSON = function (user, packet) {
    if (_global.debug == true)
      trace(
        user.getUserId() +
          " <--- " +
          JSON.stringify(packet).split('""').join('"')
      );
    _server.sendResponse(
      packet,
      -1,
      null,
      user instanceof Array ? user : [user],
      "json"
    );
  };
  this.SendAdmin = function (user, message, room) {
    _server.sendGenericMessage(
      "<msg t='sys'><body action='dmnMsg' r='" +
        room.getId() +
        "'><user id='" +
        user.getPlayerIndex(room) +
        "'/><txt><![CDATA[" +
        CDATAEscape(message) +
        "]]></txt></body></msg>",
      null,
      user instanceof Array ? user : [user]
    );
  };
  this.GetUserByName = function (username) {
    var users = zone.getUserList().toArray();
    for (var i in users) {
      if (users[i].getName().toLowerCase() == username.toLowerCase())
        return users[i];
    }
    return false;
  };
}
Users = new Users();
function CDATAEscape(message) {
  return message.split("]]>").join("]]]]><![CDATA[>");
}
function sendLoginError(chan, message, error, extra) {
  var data = {
    _cmd: "loginFail",
    cmd2: message,
    error: error,
  };
  _server.sendResponse(mergeObjects(data, extra), -1, null, chan, "xml");
}

function mergeObjects(a, b) {
  for (var i in b) {
    a[i] = b[i];
  }
  return a;
}

function sortByKey(array, key) {
  return array.sort(function (a, b) {
    var x = a[key];
    var y = b[key];
    return x < y ? -1 : x > y ? 1 : 0;
  });
}

function updatePop() {
  dbase.executeCommand(
    "UPDATE servers SET population='" +
      _server.escapeQuotes(
        String(Math.floor((Number(zone.getUserCount()) / 600) * 100))
      ) +
      "' WHERE zone='" +
      _server.escapeQuotes(String(zone.getName())) +
      "';"
  );
}

function formatDate(date) {
  var d = new Date(date),
    month = "" + (d.getMonth() + 1),
    day = "" + d.getDate(),
    year = d.getFullYear();

  if (month.length < 2) month = "0" + month;
  if (day.length < 2) day = "0" + day;

  return [year, month, day].join("/");
}

if (!String.prototype.trim) {
  String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, "");
  };
}
