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
  else if (evtObj.name == "user_join_room") {
    // Check for login item when user joins their first room after login
    if (evtObj.user && !evtObj.user.properties.get("loginItemChecked")) {
      // Mark as checked for this session to prevent multiple checks
      evtObj.user.properties.put("loginItemChecked", true);
      
      // Check and give login item if conditions are met
      if (typeof checkAndGiveLoginItem === "function") {
        checkAndGiveLoginItem(evtObj.user);
      }
    }
  } else if (evtObj.name == "userLost" || evtObj.name == "logOut") {
    if (typeof handleUserLost === "function" && evtObj.user) {
      handleUserLost(evtObj.user);
    }
  }
}
