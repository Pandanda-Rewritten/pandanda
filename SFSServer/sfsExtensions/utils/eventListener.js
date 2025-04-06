var dbase,
  handlers = new Object();
var _sfs;

function handleRequest(cmd, params, user, fromRoom) {
  var fromRoom;

  try {
    fromRoom = zone.getRoom(fromRoom);
  } catch (e) {
    fromRoom = null;
  }
  if (handlers[cmd] != null) handlers[cmd](params, user);

  handlePandandaPacket(cmd, params, user, fromRoom);
}
function handleInternalEvent(evtObj) {
  trace("Handling " + evtObj.name);
  if (evtObj.name == "serverReady") {
    Packages.java.lang.System.out.println("\n|:::::::SERVER READY:::::::|");
    _sfs = Packages.it.gotoandplay.smartfoxserver.SmartFoxServer;
    _sfs.log.info("Zone [" + _server.getCurrentZone().getName() + "] ready");
  } else if (evtObj.name == "pubMsg")
    handlePublicMessage(evtObj.user, evtObj.msg, evtObj.room);
  else if (evtObj.name == "loginRequest")
    handleLogin(evtObj.nick, evtObj.pass, evtObj.chan);
}
