eval(_server.readFile("utils/json.js"));
eval(_server.readFile("utils/functions.js"));
eval(_server.readFile("utils/eventListener.js"));

var zone, _sfs;

function init() {
  zone = _server.getCurrentZone();
  _sfs = Packages.it.gotoandplay.smartfoxserver.SmartFoxServer;
  setInterval("sendSlimeUpdates", 2000);
}

function sendSlimeUpdates() {
  try {
    var ghostroom = zone.getRoomByName("EN_graveyard");
    var usrz = ghostroom.getAllUsers();

    var slimeMove = generateRandomSlimePositions();

    for (var i in usrz) {
      Users.SendJSON(usrz[i], {
        _cmd: "ghostGame",
        cmd2: "update",
        slimeMove: slimeMove,
      });
    }
  } catch (e) {
    trace("Error in sendSlimeUpdates: " + e);
  }
}

function generateRandomSlimePositions() {
  var slimePositions = [];
  for (var i = 0; i < 2; i++) {
    var x = Math.floor(Math.random() * 800);
    var y = Math.floor(Math.random() * 600);
    slimePositions.push(i + "," + x + "," + y);
  }
  return slimePositions.join(";");
}

function destroy() {
  trace("Nice knowing you, bye! :)");
}
