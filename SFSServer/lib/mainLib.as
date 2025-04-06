/*
* SmartFoxServer PRO
* ActionScript server side main function library
* mainLib -- version 2.3.0
* 
* April 9th 2009
* 
* (c) 2005-2009 gotoAndPlay() -- www.smartfoxserver.com -- www.gotoandplay.it
* 
*/

//-------------------------------------------------------------------
// Internal Objects Definitions
//-------------------------------------------------------------------

__lib 			= Packages.it.gotoandplay.smartfoxserver.lib
__data  		= Packages.it.gotoandplay.smartfoxserver.data
__db			= Packages.it.gotoandplay.smartfoxserver.db
__crypto		= Packages.it.gotoandplay.smartfoxserver.crypto
__extensions	= Packages.it.gotoandplay.smartfoxserver.extensions
__json			= Packages.org.json
__json2			= Packages.net.sf.json
__jutil			= Packages.java.util
__mailer 		= __lib.MailManager.getInstance()
__helper		= __extensions.ExtensionHelper.instance()
__loadvars		= Packages.it.gotoandplay.smartfoxserver.lib.http


// _global scope
_global				= new Object()

// _server scope
_server 			= new Object()
_server.instance 	= __smartFoxServer
_server.AsObject	= __lib.ActionscriptObject
_server.Serializer	= __lib.ASObjectSerializer
_server.User		= __data.User
_server.DataRow		= __db.DataRow

// constants
_server.QUERY_STRING_KEYS = 1
_server.QUERY_INT_KEYS 	= 0

_server.MOD_MESSAGE_TO_USER = 0
_server.MOD_MESSAGE_TO_ROOM = 1
_server.MOD_MESSAGE_TO_ZONE = 2

_server.PROTOCOL_XML = "xml"
_server.PROTOCOL_STR = "str"
_server.PROTOCOL_JSON = "json"

_server.BAN_BY_NAME = 0
_server.BAN_BY_IP = 1

_sysHandler 		= _server.instance.getSysHandler()

newline = "\n"


//-------------------------------------------------------------------
// Internal logger
//-------------------------------------------------------------------
_logger = function()
{
	/* loggin levels
	* this.LEVEL_FINER = "finer"
	* this.LEVEL_FINE = "fine"
	* this.LEVEL_INFO = "info"
	* this.LEVEL_WARNING = "warning"
	* this.LEVEL_SEVERE = "severe"
	*/
}

_logger.prototype.finer = function(errorMsg)
{
	_server.instance.log.finer(errorMsg)
}

_logger.prototype.fine = function(errorMsg)
{
	_server.instance.log.fine(errorMsg)
}

_logger.prototype.info = function(errorMsg)
{
	_server.instance.log.info(errorMsg)
}

_logger.prototype.warning = function(errorMsg)
{
	_server.instance.log.warning(errorMsg)
}

_logger.prototype.severe = function(errorMsg)
{
	_server.instance.log.severe(errorMsg)
}

_server.logger = new _logger()



//-------------------------------------------------------------------
// Convert AS Obj into >> ActionScriptObject
//-------------------------------------------------------------------
__convertToAsObject = function(obj)
{
	var ao = new _server.AsObject()
	
	for (var i in obj)
	{
		var t = typeof obj[i]
		
		// Check it this is an object coming from Java
		// If so, translate to the corresponding JS type, if possible
		if (obj[i] != null)
		{
			if (t == "object")
			{
				if ( obj[i] instanceof Packages.java.util.Collection )
				{
					ao.putCollection(i, obj[i] )
					continue
				}
				else if ( obj[i] instanceof Packages.java.util.Map )
				{
					ao.putMap( i, obj[i] )
					continue
				}
				else if ( obj[i] instanceof _server.DataRow)
				{
					ao.putDataRow( i, obj[i] )
					continue
				}
				else if ( obj[i].getClass != undefined )
				{
					obj[i] = __convertJavaObject(obj[i])
					t = typeof obj[i]
				}
					
			}
		
			switch(t)
			{
				case "string":
					ao.put(i, obj[i])
				break;
				
				case "object":
					ao.put(i, __convertToAsObject(obj[i]))				
				break;
				
				case "number":
					ao.putNumber(i, obj[i])
				break;
				
				case "boolean":
					ao.putBool(i, obj[i])
				break;
			}
		}
	}
	
	/*
	* debug only...
	* _server.Serializer.dump(ao, 0)
	*/
	return ao
}



//-------------------------------------------------------------------
// Convert basic Java types into basic AS types
//-------------------------------------------------------------------
__convertJavaObject = function(o)
{
	
	var t = o.getClass().getName()
	var res = null
	
	if (t == "java.lang.String")
		res = String(o)
	else 
		res = String(o.toString())

	return res
}


//-------------------------------------------------------------------
// Get an instance of a DatabaseManager:
// 
// you must provide the unique name of the zone where the database
// is configured
//-------------------------------------------------------------------
_server.getDatabaseManager = function(zoneName)
{
	if (zoneName == undefined)
	{
		zoneName = __extension.getOwnerZone()
	}
	
	var zone = _server.instance.getZone(zoneName)
	
	if (zone.dbManager == null)
		trace("DB Manager is not active in this Zone!")
		
	return zone.dbManager;

}


//-------------------------------------------------------------------
// Tries to login a connected channel
//-------------------------------------------------------------------
_server.loginUser = function(nick, pwd, chan, forceLogin)
{
	var res = {}
	res.success = true
	
	// Updated in 1.6.3
	if (forceLogin == undefined)
		forceLogin = false
	
	try
	{
		_server.instance.canLogin(nick, pwd, chan, __extension.getOwnerZone(), forceLogin)
	}
	catch(exception)
	{
		// Get the various error messages
		// 
		// 0 - Java Exception
		// 1 - Type of the Exception
		// 2 - The exception message
		var msgs = exception.toString().split(":")
		
		res.success = false
		res.error = msgs[2]
	}

	return res
}

//-------------------------------------------------------------------
// Return an automatic guest name
//-------------------------------------------------------------------
_server.getGuestName = function()
{
	return _server.instance.getGuestName()
}


//-------------------------------------------------------------------
// Get current zone
//-------------------------------------------------------------------
_server.getCurrentZone = function()
{
	var zn = __extension.getOwnerZone()
	return _server.instance.getZone(zn)
}


//-------------------------------------------------------------------
// Get current Room
//-------------------------------------------------------------------
_server.getCurrentRoom = function()
{
	var zn = __extension.getOwnerZone()
	var rm = __extension.getOwnerRoom()
	
	var zone =_server.instance.getZone(zn)
	var room = null
	
	if (rm != null && zone != null)
	{
		room = zone.getRoomByName(rm)
	}
	
	return room
}

//-------------------------------------------------------------------
// Get User
//-------------------------------------------------------------------
_server.getUserById = function(uid)
{
	return __smartFoxServer.getUserById(uid)
}

_server.getUserByChannel = function(ch)
{
	return __smartFoxServer.getUserByChannel(ch)
}


//-------------------------------------------------------------------
// Get an MD5 hash string
//-------------------------------------------------------------------
_server.md5 = function(str)
{
	return String(__crypto.MD5.instance().getHash(str))
}


//-------------------------------------------------------------------
// Return the user/channel random key
//-------------------------------------------------------------------
_server.getSecretKey = function(channel)
{
	var type = channel.getClass().getName()

	if (type != "sun.nio.ch.SocketChannelImpl")
	{
		trace("Bad srgument in getSecretKey() !")
	}
	else
	{
		var sk = channel.keyFor(_server.instance.getReadSelector())
		var at = sk.attachment()
	
		// Return the key
		return at.getSecretKey()
	}
}

//-------------------------------------------------------------------
// CreateRoom
// return room obj
//-------------------------------------------------------------------
_server.createRoom = function(	paramObj, 
								user,
								sendUpdate, 
								broadcastEvt,
								roomVars, 
								varsOwner, 
								setOwnership
							)
{
	var r = null
	var error = ""
	
	if (setOwnership == undefined)
		setOwnership = true
	
	if (sendUpdate == undefined)
		sendUpdate = true
	
	if (broadcastEvt == undefined)
		broadcastEvt = true
	
	if (varsOwner == undefined)
		varsOwner = null
	
	map = new java.util.HashMap()
	
	// Convert to HashMap
	for (var i in paramObj)
	{
		map.put(new java.lang.String(i), new java.lang.String(paramObj[i]))
	}
	
	try
	{
		r = __helper.createRoom(	
								_server.getCurrentZone(),
								map,
								user,
								this._prepareRoomVars(roomVars, varsOwner),
								varsOwner,
								setOwnership,
								sendUpdate,
								broadcastEvt
								)
		
	}
	catch(exception)
	{
		trace("Exception! " + exception)
		this.logger.warning(exception.toString())
	}
	
	return r
}


//-------------------------------------------------------------------
// Dispatch a public message
//-------------------------------------------------------------------
_server.dispatchPublicMessage = function(msg, r, u)
{
	__helper.dispatchPublicMessage(msg, r, u)
}

//-------------------------------------------------------------------
// Dispatch a private message
//-------------------------------------------------------------------
_server.dispatchPrivateMessage = function(msg, room, sender, recipient)
{
	__helper.dispatchPrivateMessage(msg, room, sender, recipient)
}


//-------------------------------------------------------------------
// JoinRoom
//
// usr			User obj 			(User)
// currRoom		id of room 			(number)
// leaveRoom		leave current room 		(bool)
// newRoom		new room id 			(number)
// pass			password for new room 		(string)
// isSpec		join as spectator 		(bool)
// broadcast		broadcast default info 		(bool)
//
// return true / false
//-------------------------------------------------------------------
_server.joinRoom = function(usr, currRoom, leaveRoom, newRoom, pass, isSpec, broadcast)
{
	var ok = false
	
	if (leaveRoom == undefined)
		leaveRoom = true
	
	if (pass == undefined)
		pass = ""
	
	if (isSpec == undefined)
		isSpec = false
		
	if (broadcast == undefined)
		broadcast = true
		
	
	try
	{
		ok = __helper.joinRoom(	
						usr,
						currRoom,
						newRoom,
						leaveRoom,
						pass,
						isSpec,
						broadcast
					)
		
	}
	catch(exception)
	{
		this.logger.warning(exception.toString())
	}
	
	return ok
}

//-------------------------------------------------------------------
// Logout a user from the current zone
// @param user 	can be either the userId or 
//			the User object
//-------------------------------------------------------------------
_server.logoutUser = function(user, fireClientEvt, fireInternalEvt)
{
	if (fireClientEvt == undefined)
		fireClientEvt = true
		
	if (fireInternalEvt == undefined)
		fireInternalEvt = true
		
	__helper.logoutUser(user, fireClientEvt, fireInternalEvt)
}

//-------------------------------------------------------------------
// Send Default roomList
//-------------------------------------------------------------------
_server.sendRoomList = function(user)
{
	__helper.sendRoomList(user.getChannel())
}

//-------------------------------------------------------------------
// Send moderator message
//-------------------------------------------------------------------
_server.sendModeratorMessage = function(message, sender, type, id)
{
	if (id == null)
		id = -1
		
	__helper.sendModeratorMessage(message, sender, type, id)
}

//-------------------------------------------------------------------
// Send Response
//-------------------------------------------------------------------
_server.sendResponse = function(response, fromRoom, u, userList, type)
{
	var result;
	
	if (type == "xml" || type == undefined)
		result = __convertToAsObject(response)

	else if (type == "str")
		result = response
	
	else if (type == "json")
		result = __convertToJSON2(response)
	
	// userList can also accept a socketChannel
	// used when sending a Login response
	if (userList.length == undefined)
	{
		var list = new java.util.LinkedList()
		list.add(userList)
		__extension.sendResponse(result, fromRoom, u, list)
	}
	
	// userList is treated as a list of it.gotoandplay.smartfoxserver.data.User objects
	else if (userList.length > 0 && response != undefined)
	{
		var list = new java.util.LinkedList()
		var usr = null
		
		for (var i in userList)
		{
			usr = userList[i]
			if (usr != null)
				list.add(usr.getChannel())
		}
		
		__extension.sendResponse(result, fromRoom, u, list)
	}	
}

/**
* Send a generic text / xml message
*/
_server.sendGenericMessage = function(msg, sender, userList)
{
	var chanList = new java.util.LinkedList()
	
	for (var i = 0; i < userList.length; i++)
	{
		chanList.add(userList[i].getChannel())
	}
	
	var senderCh = (sender == null) ? null : sender.getChannel()
	
	__helper.sendGenericMessage(msg, senderCh, chanList)
}	

/**
* Set room variables
* * varList expects a lists of objects with the following properties:
* 
* name, val, priv, persistent
* 
* ( broadcastAll is not yet implemented )
* 
*/
_server.setRoomVariables = function(room, who, varList, setOwnership, broadcastAll)
{
	if (room != null)
	{
		if (setOwnership == undefined)
			setOwnership = true
			
		if (broadcastAll == undefined)
			broadcastAll = true
		
		if (who == undefined)
			who = null
			
		map = this._prepareRoomVars(varList, who)
		
		// Create variables
		if (map.size() > 0)
			__helper.setRoomVariables(	room,
										who,
										map,
										setOwnership,
										broadcastAll
									)
	}
}


/*
* Prepare room variables for ExtensionHelper
*/
_server._prepareRoomVars = function(varList, who)
{
	// In case param was not passed from upper level caller
	if (varList == null)
		return null
		
	var map = new java.util.HashMap()
	
	for (var i in varList)
	{
		var v = varList[i]

		if (v != null && v.name != null && v.name != "")
		{
			var t = null
	
			// Check type
			if (typeof v.val == "boolean")
			{
				t = "b"
				v.val = (v.val) ? 1:0	
			}
			else if (typeof v.val == "number")
				t = "n"
			else if (typeof v.val == "string")
				t = "s"
			else if (typeof v.val == "undefined")
				t = "x"
			
			if (v.priv == undefined)
				v.priv = false
				
			if (v.persistent == undefined)
				v.persistent = false

			// Add to map
			if (t != null)
			  map.put(v.name, new __data.RoomVariable(v.val, t, who, v.persistent, v.priv))

		}
	}
	
	return map
}


/**
 * Set UserVariables
 * varList expects an object with each variable as its properties 
 * 
 * (broadcastAll is not yet implemented)
 * 
 */     
_server.setUserVariables = function (who, varList, broadcastAll)
{
  if (who != null)
  {
    if (broadcastAll == undefined)
      broadcastAll = true
    
    var map = new java.util.HashMap()
    
    for (var i in varList)
    {
      var v = varList[i]

		if (i != "")
		{
			var t = null

			// Check type
			if (typeof v == "boolean")
			{
				t = "b"
				v = v ? 1:0	
			}
			else if (typeof v == "number")
				t = "n"
			else if (typeof v == "string")
				t = "s"
			else if (typeof v == "undefined")
				t = "x"

			// Add to map
			if (t != null)
			  map.put(i, new __data.UserVariable(v, t))
		}
    }
    
    // Create variables
	if (map.size() > 0)
	{
		__helper.setUserVariables(who, map, broadcastAll)
	}
  }
}

/**
* get a zone from its name
*/
_server.getZone = function(zoneName)
{
	return __helper.getZone(zoneName)
}

/**
* Leave a room, if the user is in multi-room mode
*/
_server.leaveRoom = function(user, roomId, broadcastAll)
{
	if (broadcastAll == undefined)
		broadcastAll = true
	
	__helper.leaveRoom(user, roomId, broadcastAll)
}

/**
* Switch spectator to player, if possible.
*/
_server.switchSpectator = function(user, roomId, broadcastAll)
{
	if (broadcastAll == undefined)
		broadcastAll = true
	
	__helper.switchSpectator(user, roomId, broadcastAll)
}

/**
* Switch player to spectator, if possible.
* Since 1.6.6
*/
_server.switchPlayer = function(user, roomId, broadcastAll)
{
	if (broadcastAll == undefined)
		broadcastAll = true
	
	__helper.switchPlayer(user, roomId, broadcastAll)
}

_server.disconnectUser = function(user)
{
	__helper.disconnectUser(user)
}

/**
* Destroy a server room
* 
* @zone		the zone object
* @roomId	the id of the room
* 
* @return 	true if the room was removed
* 
*/
_server.destroyRoom = function(zone, roomId)
{
	return __helper.destroyRoom(zone, roomId)
}


/*
* Reads a text file from disk and return a string with the text
* Return null if file could not be opened
*/
_server.readFile = function(fileName)
{
	var res = null
	
	try
	{
		var byteData = __lib.SmartFoxLib.readFileInClassPath(fileName)
		var fileData = new java.lang.String(byteData)
		res = String(fileData)
	}
	catch(e)
	{
		_server.logger.warning("Could not read file: " + fileName)
	}
	
	return res
}


/*
* Writes a text file to disk and return true if ok or false if any error occurred
*/
_server.writeFile = function(fileName, fileData, append)
{
	var res = false
	
	if (append == undefined)
		append = false
	
	try
	{
		var fw = new java.io.FileWriter(fileName, append)
		fw.write(fileData)
		fw.close()
		
		res = true
	}
	catch(e)
	{
		_server.logger.warning("Could not write file: " + fileName + " -- Exception: " + e)
	}
	
	return res
}

_server.isDir = function(path)
{
	var f = new java.io.File(path)
	return f.isDirectory()
}

_server.isFile = function(path)
{
	var f = new java.io.File(path)
	return f.isFile()
}

_server.getFileList = function(path)
{
	if (path == undefined || path == "")
		path = "./"
		
	var f = new java.io.File(path)
	return f.list()
}

_server.makeDir = function(path)
{
	var f = new java.io.File(path)
	return f.mkdirs()
}

_server.fileExist = function(path)
{
	var f = new java.io.File(path)
	return f.exists()
}

_server.getFileLength = function(path)
{
	var f = new java.io.File(path)
	return f.length()
}

/*
* Delete a file from disk and return true if ok or false if any error occurred
*/
_server.removeFile = function(fileName)
{
	return __lib.SmartFoxLib.deleteFile(fileName)
}


/*
* Escape quotes in strings for SQL statements
*/
_server.escapeQuotes = function(str)
{		
	var res = __lib.SmartFoxLib.escapeQuotes(str)
	return String(res)
}

_server.sendMail = function(from, to, subject, message)
{
	return __mailer.sendMail(from, to, subject, message)
}

/**
* Add a buddy to a buddy list
* since 1.6
*/
_server.addBuddy = function(buddyName, user)
{
	__helper.addBuddy(buddyName, user)
}

/**
* Removes a buddy from a buddy list
* since 1.6
*/
_server.removeBuddy = function(buddyName, user)
{
	__helper.removeBuddy(buddyName, user)
}

/**
* Requests permission for adding the target user in the sender buddy list
* since 1.6
*/
_server.requestAddBuddyPermission = function(sender, targetUserName, optionalMessage)
{
	__helper.requestAddBuddyPermission(sender, targetUserName, optionalMessage)
}

/**
* Send a buddy list update to a user
* since 1.6
*/
_server.sendBuddyListUpdate = function(user)
{
	__helper.sendBuddyListUpdate(user)
}

/**
* Block / Unblock a buddy in the user's buddy list
* since 1.6
*/
_server.setBuddyBlockStatus = function(user, buddyName, isBlocked)
{
	__helper.setBuddyBlockStatus(user, buddyName, isBlocked)
}

/**
* Set buddy variables
* since 1.6
*/
_server.setBuddyVariables = function(user, variables)
{
	var hashMap = new java.util.HashMap()

	for (var key in variables)
		hashMap.put( key, variables[key] )
		
	__helper.setBuddyVariables(user, hashMap)
}

/**
* KickUser
* since 1.6.3
*/
_server.kickUser = function(user, delay, farewellMessage)
{
	__helper.kickUser(user, delay, farewellMessage)
}

/**
* Ban online user
* since 1.6.3
*/
_server.banUser = function(user, delay, farewellMessage, banType)
{
	__helper.banUser(user, delay, farewellMessage, banType)
}

/**
* Ban Offline User
* since 1.6.3
*/
_server.banOfflineUser = function(userName)
{
	__helper.banOfflineUser(userName)
}

/**
* Remove banned entry
* since 1.6.3
*/
_server.removeBanishment = function(param, banType)
{
	__helper.removeBanishment(param, banType)
}

/**
* Add new moderator in Zone
* since 1.6.3
*/
_server.addModerator = function(zoneName, modName, modPass)
{
	__helper.addModerator(zoneName, modName, modPass)
}

/**
* Remove moderator in Zone
* since 1.6.3
*/
_server.removeModerator = function(zoneName, modName)
{
	__helper.removeModerator(zoneName, modName)
}

/**
* Create NPC
* since 1.6.5
*/
_server.createNPC = function(userName, ipAdr, port, zoneName)
{
	return __helper.createNPC(userName, ipAdr, port, zoneName)
}

/*
* Handle request from parent Java scope
* params = ActionscriptObject is converted into an AS Native object
*/
function __handleJavaRequest(cmd, params, user, fromRoom, protocol)
{
	if (protocol == "xml")
		handleRequest(cmd, __ASObject2ASNative(params), user, fromRoom, protocol)
		
	else if (protocol == "str")
		handleRequest(cmd, params, user, fromRoom, protocol)
	
	else if (protocol == "json")
		handleRequest(cmd, __JSONObject2ASNative(params), user, fromRoom, protocol)
}

function __handleInternalRequest(obj)
{
	return handleInternalRequest(obj)
}

/*
* Handle internal events coming from parent Java scope
* returns native AS object 
*/
function __handleJavaEvent(evt)
{
	var evtName = evt.getEventName()
	var params = {}

	params.name = evtName
	
	if (evtName == "userJoin")
	{
		//params.zone = String(evt.getParam("zone"))
		params.user = evt.getObject("user")
		params.room = evt.getObject("room")
		
		handleInternalEvent(params)
	}
	
	else if (evtName == "userExit")
	{
		params.userId = evt.getParam("uid")
		params.oldPlayerIndex = evt.getParam("oldPlayerIndex")
		params.room = evt.getObject("room")
		params.user = evt.getObject("user")
		
		handleInternalEvent(params)
	}
	
	else if (evtName == "userLost" || evtName == "logOut")
	{
		var roomName 			= __extension.getOwnerRoom()
		var userRooms 			= evt.getObject("roomIds")
		var userPlayerIndexes 	= evt.getObject("playerIndexes")
		var userObj				= evt.getObject("user")
		var found = false
		
		if (evtName == "logOut")
			params.chan = evt.getObject("chan")
		
		// Zone Extension
		if (roomName == null)
		{
			found = true
			
			// Transfer roomIds in native Array
			params.roomIds = []
			for (var i = 0; i < userRooms.length; i++)
				params.roomIds.push(userRooms[i])
			
			// Transfer playerIndexes in native Array
			params.playerIndexes = []
			for (var i = 0; i < userPlayerIndexes.length; i++)
				params.playerIndexes.push(userPlayerIndexes[i])
			
			// Pass the playerIndex if user is present in one room only at a time
			if (params.playerIndexes.length == 1)
				params.oldPlayerIndex = params.playerIndexes[0]
		}
		
		// Room Extension
		else
		{
			var zoneName 	= __extension.getOwnerZone()
			var zoneObj 	= _server.instance.getZone(zoneName)
			var roomName 	= __extension.getOwnerRoom()
			
			for (var i = 0; i < userRooms.length; i++)
			{
				var r = zoneObj.getRoom(userRooms[i])
				if (r.getName() == roomName)
				{
					found = true
					params.oldPlayerIndex = userPlayerIndexes[i]
					break
				}
			}
		}
		
		// Dispatch Event
		if (found)
		{
			params.userId = evt.getParam("uid")
		
			// @since 1.5.8d
			params.user = userObj
		
			handleInternalEvent(params)
		}
	}
	
	else if (evtName == "roomLost")
	{
		params.roomId = evt.getParam("roomId")
		handleInternalEvent(params)
	}
	
	else if (evtName == "newRoom")
	{
		params.room = evt.getObject("room")
		handleInternalEvent(params)
	}
	
	else if (evtName == "loginRequest")
	{
		params.nick = String(evt.getParam("nick"))
		params.pass = String(evt.getParam("pass"))
		params.chan = evt.getObject("chan")

		handleInternalEvent(params)
	}
	
	else if (evtName == "spectatorSwitched")
	{
		params.user = evt.getObject("user")
		params.playerIndex = evt.getParam("playerIndex")
		params.room = evt.getObject("room")

		handleInternalEvent(params)
	}
	
	else if (evtName == "playerSwitched")
	{
		params.user = evt.getObject("user")
		params.room = evt.getObject("room")
		
		handleInternalEvent(params)
	}
	
	else if (evtName == "pubMsg")
	{
		params.zone = evt.getObject("zone")
		params.room = evt.getObject("room")
		params.user = evt.getObject("user")
		params.msg = String(evt.getParam("msg"))

		handleInternalEvent(params)
	}
	
	else if (evtName == "privMsg")
	{
		params.zone = evt.getObject("zone")
		params.room = evt.getObject("room")
		params.sender = evt.getObject("sender")
		params.recipient = evt.getObject("recipient")
		params.msg = String(evt.getParam("msg"))

		handleInternalEvent(params)
	}
	
	else if (evtName == "fileUpload")
	{
		var files = evt.getObject("files")
		
		if (files.size() > 0)
		{
			params.files = []
			
			var keys = files.keySet()
			var key = null
			
			for (var i = keys.iterator(); i.hasNext();)
			{
				key = String(i.next())
				params.files.push({fileName:key, originalName:files.get(key)})
			}
			
		}
		
		params.user = evt.getObject("user")
		handleInternalEvent(params)
	}
	
	else if (evtName == "serverReady")
	{
		handleInternalEvent(params)
	}
}


/*
* it.gotoandplay.smartfoxserver.lib.ActionscriptObject >> [object Object]
*/
function __ASObject2ASNative(ASObj)
{
	var key
	var item
	var itemType
	
	var reqObj = []
	
	var keySet = ASObj.keySet()
	
	for (var it = keySet.iterator(); it.hasNext();)
	{	
		key = String(it.next())

		item = ASObj.get(key)
		
		if (item != null)
			itemType = item.getClass().getName()
		else 
		{
			reqObj[key] = ""
			continue
		}
		
		if (itemType == "java.lang.Double")
			reqObj[key] = item.doubleValue()
			
		else if (itemType == "java.lang.Boolean")
			reqObj[key] = item.booleanValue()
			
		else if (itemType == "java.lang.String")
			reqObj[key] = String(item)
		
		else 
			reqObj[key] = __ASObject2ASNative(item)

	}
	
	return reqObj
}

/*
* JSON >> [object Object]
*/
function __JSONObject2ASNative(jso)
{
	var key
	var item
	var itemType
	
	var reqObj = null
	var jType = jso.getClass().getName()
	
	// Handle Map
	if (jType == "org.json.JSONObject")
	{
		reqObj = {}
		var objData = jso.getData()
		var keySet = objData.keySet()
		
		for (var it = keySet.iterator(); it.hasNext();)
		{
			key 		= String(it.next())
			item 		= objData.get(key)
			
			reqObj[key]	= __JSONObject2ASNative(item)
			//trace(key + " : " + item + " : " + item.getClass().getName())
		}
	}
	
	// Handle List
	else if (jType == "org.json.JSONArray")
	{
		reqObj = []
		var objData = jso.getData()
		
		for (var ii = 0; ii < objData.size(); ii++)
		{
			item 		= objData.get(ii)
			reqObj[ii]	= __JSONObject2ASNative(item)
			//trace(ii + " : " + item + " : " + item.getClass().getName())
		}
	}
	
	// Handle String
	else if (jType == "java.lang.String")
		return String(jso)
	
	else if (jType == "java.lang.Double")
		return jso.doubleValue()
		
	else if (jType == "java.lang.Integer")
		return jso.intValue()
			
	else if (jType == "java.lang.Boolean")
		return jso.booleanValue()
	
	
	return reqObj
}

// [object Object] >> JSON
function __convertToJSON(obj)
{
	var itemType = typeof(obj) 
	var reqObj = null
		
	// Handle Object
	if (itemType == "object" && obj.length == undefined)
	{
		reqObj = new __json.JSONObject()
		
		for (var i in obj)
		{
			reqObj.put(i, __convertToJSON(obj[i]))	
			//trace(key + " : " + item + " : " + item.getClass().getName())
		}
	}
	
	// Handle Array
	else if (itemType == "object" && obj.length != undefined)
	{
		reqObj = new __json.JSONArray()
		
		for (var i = 0; i < obj.length; i++)
		{
			reqObj.put(__convertToJSON(obj[i]))
			//trace(ii + " : " + item + " : " + item.getClass().getName())
		}
	}
		
	else
	{
		return obj
	}

	return reqObj
}

/**
*	New version 2.0
*	@since SmartFoxServer PRO 1.6.0
*	October 17th 2007
*/
function __convertToJSON2(obj)
{
	var itemType = typeof(obj) 
	var reqObj = null
	
	// We have an object
	if ( itemType == "object" )
	{
		// We have a Java Object ( allow DataRow, Collection and Map )
		if ( obj.getClass != undefined )
		{
			if ( obj instanceof _server.DataRow )
				reqObj = __json2.JSONObject.fromObject( obj.getData() )
			
			else if ( obj instanceof __jutil.Collection || obj instanceof __jutil.Map )
				reqObj = __json2.JSONObject.fromObject( obj )
		}
		
		// Non-Java object
		else
		{
			// JS Object
			if ( obj.length == undefined)
			{
				reqObj = new __json2.JSONObject()

				for (var i in obj)
				{
					reqObj.put( i, __convertToJSON2(obj[i]) )	
				}
			}
			
			// JS Array
			else
			{
				reqObj = new __json2.JSONArray()

				for (var i = 0; i < obj.length; i++)
				{
					reqObj.add( __convertToJSON2(obj[i]) )
				}
			}
		}
	}
	
	// We presume it's a "basic" type ( string, number, boolean, null )
	else
	{
		return obj
	}
	
	return reqObj
}

/*
* Dump an AS Object recursively
*/
function __dumpObj(o, lvl)
{
	var tabs = ""
	
	for (var j = 0; j < lvl; j++)
		tabs += "\t"
	
	if (lvl == undefined)
		lvl = 0
	
	if (lvl == 0)
		trace("--- OBJ DUMP ---------------------------------------")
		
	for (var i in o)
	{
		trace(tabs + i + ": " + o[i])
		
		if (typeof o[i] == "object")
			__dumpObj(o[i], lvl + 1)

	}
}


//================================================================================================
// ActionScript Commands
//================================================================================================


//-------------------------------------------------------------------
// Actionscript Trace command
//-------------------------------------------------------------------
function trace(message)
{
	var msg = "[" + __extension.getScriptFileName() + "]: " + message
	
	__extension.adminExtension.logRemoteTrace(__extension.getOwnerZone(), __extension.getOwnerRoom(), msg)
	__out.println(msg)
}


//-------------------------------------------------------------------
// AS setInterval() function
// Returns a java.util.Timer object
//-------------------------------------------------------------------
function setInterval(fnName, interval, params)
{
	var errorMsg = ""
	
	if (typeof fnName != "string" || fnName == "")
		errorMsg += "You must provide a valid function name."
	
	if (typeof interval != "number" || interval < 1)
		errorMsg += "'interval' must be a number > 0."
		

	if (errorMsg != "")
	{
		_server.logger.warning(errorMsg)
	}
	else
	{
		return __extension.setInterval(fnName, interval, interval, params)
	}	
}

// Clear the interval
function clearInterval(intervalObj)
{
	if (intervalObj != null)
	{
		intervalObj.cancel()
	}
	else
		_server.logger.warning("Invalid interval object passed to clearInterval()")
}

// SetTimout
function setTimeout(scope, fn, delay, params)
{
	var args = []
	for (var i = 3; i < arguments.length; i++)
		args.push(arguments[i])

	var timer = new Packages.java.util.Timer()
	var task = new Packages.java.util.TimerTask()
	{
		run:function()
		{
			fn.apply(scope, args)
		}
	}

	timer.schedule(task, delay)
}


//-------------------------------------------------------------------
// AS getTimer() function
//-------------------------------------------------------------------
function getTimer()
{
	return java.lang.System.currentTimeMillis()
}

//-------------------------------------------------------------------------
// LoadVars beta
//-------------------------------------------------------------------------
LoadVars = function() 
{
	this.target = this
	this._loadListener = {}
	this._loadListener.scope = this
	this._loadListener.onLoad = function(ok, params, err)
	{
		if (ok)
		{
			var keys = params.keySet()
			var key, val
			
			for (var i = keys.iterator(); i.hasNext();)
			{
				key = String(i.next())
				val = String(params.get(key))
				this.scope.target[key] = val
			}		
		}
		
		if (this.scope.target.onLoad != undefined)
			this.scope.target.onLoad(ok, err)
	}	
}

LoadVars.prototype.send = function(url, method)
{
	var meth = this.getMethod(method)
	var params = this.getParams()
	var loader = new __loadvars.LoadVars(params, meth)
	
	loader.setListener(new __loadvars.ILoadVarsListener(this._loadListener))
	loader.send(url)	
}

LoadVars.prototype.load = function(url)
{
	this.sendAndLoad(url)
}

LoadVars.prototype.sendAndLoad = function(url, target, method)
{
	if (target != undefined)
		this.target = target
		
	var meth = this.getMethod(method)
	var params = this.getParams()
	var loader = new __loadvars.LoadVars(params, meth)
	
	loader.setListener(new __loadvars.ILoadVarsListener(this._loadListener))
	loader.load(url)
}

LoadVars.prototype.getParams = function()
{
	var params = new java.util.HashMap()
	var t
	
	for (var i in this)
	{
		t = typeof(this[i])
		if (t != "function" && t != "object")
		{
			params.put(i, String(this[i]))
		}
	}
	
	return params
}

LoadVars.prototype.getMethod = function(m)
{
	// default
	var method = __loadvars.LoadVars.METHOD_GET

	if (typeof(m) == "string")
	{
		if (m.toUpperCase() == "POST")
			method = __loadvars.LoadVars.METHOD_POST
	}
	
	return method
}
