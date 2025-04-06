#
# SmartFoxServer Python Extensions Main Library
# version 1.3.5
#
# author: Marco "Lapo" Lapi
#
# (c) 2006-2007 gotoAndPlay()
# www.smartfoxserver.com
# www.gotoandplay.it
#

# Main Java imports
import it.gotoandplay.smartfoxserver.lib as __lib
import it.gotoandplay.smartfoxserver.data as __data
import it.gotoandplay.smartfoxserver.db as __db
import it.gotoandplay.smartfoxserver.crypto as __crypto
import it.gotoandplay.smartfoxserver.extensions as __extensions
import it.gotoandplay.smartfoxserver.exceptions as __exceptions
import org.json as __json

import java
import types
from java.util import ArrayList, HashMap, LinkedList


#
# Login Exception
#
class LoginError:
	pass

#
# Join Error
#
class JoinError:
	pass

#
# Creat Room Error
class CreateRoomError:
	pass

## Room Variable Class
# <b>The object describes a server side Room Variable.
# @see	_Server::setRoomVariables
class RoomVariable:
	
	## Default Constructor
	#
	# @param name			name of the variable
	# @param val			value of the variable ( can be string, number, boolean )
	# @param priv			flag, if True marks the variable as <em>private</em>
	# @param persistent		flag, if True marks the variable as <em>persistent</em>
	def __init__(self, name, val, priv = False, persistent = False):
		self.name = name
		self.val = val
		self.priv = priv
		self.persistent = persistent


## Logger class
# <p>Allows to log data in the default SmartFoxServer loggin system. <br>
# Available logging levels are:
# </p>
#
# <ul>
# <li>finer</li>
# <li>fine</li>
# <li>info</li>
# <li>warning</li>
# <li>severe</li>
# </ul>
#
# <p><b>NOTE:</b> You shouldn't instantiate this object. An instance is already available as _Server._logger</p>
# @see _Server::_loggers
#
class _Logger:

	def __init__(self):
		self._sfsLog = __smartFoxServer.log
		
	def finer(self, msg):
		self._sfsLog.finer(msg)
	
	def fine(self, msg):
		self._sfsLog.fine(msg)
			
	def info(self, msg):
		self._sfsLog.info(msg)

	def warning(self, msg):
		self._sfsLog.warning(msg)
		
	def severe(self, msg):
		self._sfsLog.severe(msg)

	
## Server Class:
# This is the main framework object that allows access to the server core functionalities
#
class _Server:
	## Default constructor
	def __init__(self):
		self._sfs 		= __smartFoxServer								# The main SFS instance
		self._helper 	= __extensions.ExtensionHelper.instance()		# The helper instance
		self._logger 	= _Logger()										# The SFS logger
		self._mailer 	= __lib.MailManager.getInstance()				# The MailManager instance
		

		self.PROTOCOL_XML = "xml"
		self.PROTOCOL_STR = "str"
		self.PROTOCOL_JSON = "json"
	
	
	## Add a buddy to a user's buddy list
	#
	# @param buddyName		the name of the buddy
	# @param user			the buddy list owner
	#
	# @since 1.6.0
	#
	def addBuddy(self, buddyName, user):
		self._helper.addBuddy( buddyName, user )
		
	## Dynamically create a room
	#
	# @param paramObj		a dictionary with room properties
	# @param user			the creator (None by default == owned by the server itself)
	# @param roomVars		a list of roomVars to set (by default = None)
	# @param varsOwner		the owner of the room variables being created/modified
	# @param setOwnership	the roomVars setOwnership flag
	# @param sendUpdate		send default update to clients
	# @param broadCast		broadcast internal event
	#		
	def createRoom(self, paramObj, user = None, roomVars = None, varsOwner = None, setOwnership = False, sendUpdate = True, broadcast = True):
		room = None
		
		mapObj = java.util.HashMap()
		for key in paramObj.keys():
			mapObj.put(key, str(paramObj[key]))
		
		
		room = self._helper.createRoom(	self.getCurrentZone(), 
										mapObj, 
										user, 
										self._prepareRoomVars(roomVars, user),
										varsOwner,
										setOwnership,
										sendUpdate, 
										broadcast)
			
		return room
	
			
	
	## Destroy a server room
	#
	# @param zone		the zone object
	# @param roomId		the id of the room to destroy
	#
	def destroyRoom(self, zone, roomId):
		return self._helper.destroyRoom(zone, roomId)
	
	
	## Disconnect a user
	#
	# @param user		the user to be disconnected
	#
	def disconnectUser(self, user):
		self._helper.disconnectUser(user)
	
	
	## Dispatches a public message
	# (after a "pubMsg" internal event)
	# 
	# @param message	the message
	# @param room		the target room
	# @param user		the sender user
	#
	def dispatchPublicMessage(self, message, room, user):
		return self._helper.dispatchPublicMessage(message, room, user)
	
	
	
	## Dispatches a private message
	# (after a "privMsg" internal event)
	# 
	# @param message	the message
	# @param room		the target room
	# @param sender		the sender user
	# @param recipient	the recipient user
	#
	def dispatchPrivateMessage(self, message, room, sender, recipient):
		return self._helper.dispatchPrivateMessage(message, room, sender, recipient)
	
		
	## Get the current extensions zone
	#
	# @return the current zone
	def getCurrentZone(self):
		return self._sfs.getZone(__baseExtension.getOwnerZone())
	
	
	## Get the room to which the extension is attached to 
	# ( note: this is valid only for Room-Level extensions )
	#
	# @return the current Room
	def getCurrentRoom(self):
		zn = __baseExtension.getOwnerZone()
		rm = __baseExtension.getOwnerRoom()
		zone = self._sfs.getZone(zn)
		
		room = None
		
		if (rm != None):
			room = zone.getRoomByName(rm)
		
		return room
	
	
	
	## Get the database manager	object (if configured in the current Zone)
	# <br>( see more details in the javadoc -> DbManager Class )
	#
	# @return the DbManager instance
	def getDatabaseManager(self, zoneName = None):
		if zoneName == None:
			zoneName = __baseExtension.getOwnerZone()
		
		zone = self._sfs.getZone(zoneName)
				
		if zone.dbManager == None:
			self.trace("DB Manager is not active in this Zone!")
			
		return zone.dbManager
	
	
	
	## Get a guest user name
	# <br>
	# returns an auto-generated guest user name in the form <em>guest_x</em> where <b>x</b> 
	# is a progressive integer.
	#
	# @return the guest user name
	def getGuestName(self):
		return self._sfs.getGuestName()
	
	
	
	## Get the user/channel random key
	# <br>This key is unique for each user session and it used to perform a
	# secure login. You learn more about this in the tutorial at chapter 8.9 of the documentation
	#
	# @return the secret key
	def getSecretKey(self, channel):
		# If the object is not Java skip the whole thing
		try:
			vType = channel.getClass().getName()
			
			if vType == "sun.nio.ch.SocketChannelImpl":
				sk = channel.keyFor(self._sfs.getReadSelector())
				at = sk.attachment()
				
				return at.getSecretKey()
			
			else:
				self._logger.warning("getSecretKey: unexpected channel type")
			
		except AttributeError:
			self._logger.warning("getSecretKey: invalid channel object")
	
	
	
	## Return current time in milliseconds
	#
	# @return current time
	def getTimer(self):
		return java.lang.System.currentTimeMillis()
	
	
	
	## Get a user from its user id
	#
	# @return the User object
	def getUserById(self, uid):
		return self._sfs.getUserById(uid)
	
	
	
	## Get a user from its socket channel
	#
	# @return the User object	
	def getUserByChannel(self, channel):
		return self._sfs.getUserByChannel(channel)
	
	
	## Get a Zone object from its name
	# 
	# @return the Zone object
	def getZone(self, zoneName):
		return self._helper.getZone(zoneName)
	
	
	
	## Join a Room
	#
	# @param user				the user 
	# @param currRoomId			the current room in which the user is already joined ( -1 = no room )
	# @param leaveRoom			if True the user will leave the current room
	# @param user newRoomId		the room id of the room you want to join
	# @param pwd				an optional password, if the room is private
	# @param isSpec				True = join as Spectator ( must be a game room )
	# @param broadcast			True = broadcast the event to the users in the target room
	#
	# @throws	it.gotoandplay.smartfoxserver.exceptions.JoinException
	#
	def joinRoom(self, user, currRoomId, leaveRoom, newRoomId, pwd = "", isSpec = False, broadcast = True):
		
		try:
			self._helper.joinRoom(user, currRoomId, newRoomId, leaveRoom, pwd, isSpec, broadcast)
		
		except __exceptions.JoinRoomException, exc:
			raise __exceptions.JoinException, exc.getMessage()
	
	
	
	## Leave a room (for users in two or more rooms at the same time)
	# <br> Note: it won't work if the user is joined in one room only
	def leaveRoom(self, user, roomId, broadcastAll=True):
		self._helper.leaveRoom(user, roomId, broadcastAll)
	
	
	
	## Login User
	# 
	# @param nick	the user nickname
	# @param pwd	the user password (can be empty)
	# @param chan	the client SocketChannel
	# @param forceLogin if True it will force the user to login even if he's already logged in
	#
	# @throws	it.gotoandplay.smartfoxserver.exceptions.LoginException
	def loginUser(self, nick, pwd, chan, forceLogin = False):
		try:
			user = self._sfs.canLogin(nick, pwd, chan, __baseExtension.getOwnerZone(), forceLogin)
			return user
		
		# Raise the exception to the extension
		except __exceptions.LoginException, exc:
			raise __exceptions.LoginException, exc.getMessage()
	
	
	
	## Logout User
	#
	# @param user 				the user 
	# @param fireClientEvt		True = fire event to other clients
	# @param fireInternalEvt	True = fire an internal event, so extensions will be notified
	def logoutUser(self, user, fireClientEvt = True, fireInternalEvt = True):
		self._helper.logoutUser(user, fireClientEvt, fireInternalEvt)
			
	
	
	
	## Get MD5 hash
	#
	# @param strValue	a string
	# @return 			an MD5 hex hash of the passed string
	def md5(self, strValue):
		return __crypto.MD5.instance().getHash(strValue)
	
	
	
	## Sends a generic Message
	# <br> With this method you can send an arbitrary message, for example a modified version of a room list.<br>
	# <b>Note:</b> The generic message implies that you send also the message header, so a good knowledge of the SFS Xml protocol is required.
	#
	# @param msg			the message
	# @param sender			the sender User ( None = the server )
	# @param recipients		a list of recipients
	def sendGenericMessage(self, msg, sender, recipients):
		chanList = LinkedList()

		for recipient in recipients:
			chanList.add(recipient.getChannel())
		
		senderCh = None
		if not sender == None:
			senderCh = sender.getChannel()

		self._helper.sendGenericMessage(msg, senderCh, chanList)
	
	
	## Removes a buddy from a user buddy list
	#
	# If <em>mutualRemoveBuddy</em> is activated both users will be removed to their respective buddy lists.
	#
	# @param buddyName 		the name of the buddy to remove
	# @param user			the owner of the buddy list 
	#
	# @since 1.6.0
	#
	def removeBuddy(self, buddyName, user):
		self._helper.removeBuddy( buddyName, user )
	
	## Removes a user from the server, disconnecting him
	#  
	# @param who	the user
	def removeUser(self, who):
		self._sfs.removeUser(who)
	
	
	## Requests permission for adding the target user in the sender buddy list.
	# <p>
	# This is already done by default if the security mode
	# of the buddy list is set to ADVANCED. In most of the cases you wouldn't need to call this method in your extension.
	# </p>
	# <p>
	# It could be used to implement an off-line permission request system, where the system stores the requests for off-line users 
	# in a database and sends the requests as soon as the target user logs in.
	# </p>
	# 
	# @param sender				the requester
	# @param targetUserName		the name of the target user
	# @param optionalMessage	an optional text message for the request. 
	# 
	# @since 1.6.0
	#
	def requestAddBuddyPermission(self, sender, targetUserName, optionalMessage=None):
		self._helper.requestAddBuddyPermission( sender, targetUserName, optionalMessage )
	
	## Send a buddy list update.
	# <p>
	# Send an update about the specified User to all clients that have him/her in their buddy list.<br>
	# Normally you don't need to call this method. Updates are sent automatically when needed.<br>
	# You may need to force an update if you're manipulating the buddy lists without using the regular commands (add, remove, etc...)
	# </p>
	#
	# @param user	the user that should be updated
	#
	# @since 1.6.0
	def sendBuddyListUpdate(self, user):
		self._helper.sendBuddyListUpdate( user )
		
		
	## Send an Html formatted email
	#
	# @param fromName	the sender name
	# @param to			the recipient email address
	# @param subject	the email subject
	# @param message	the email html message
	#
	# @return 			True if email was sent successfully
	def sendMail(self, fromName, to, subject, message):
		return self._mailer.sendMail(fromName, to, subject, message)
	

	
	## Send an Extension Response/Message to the client(s)
	#
	# <p>
	# The <b>resObj</b> object is a dictionary containing any number of properties 
	# (strings, numbers, lists, dictionaries) that should be sent to the client(s)
	# </p>
	# <p>
	# Dictionaries and lists can be nested to create complex data structures, which are supported
	# by <b>xml</b> and <b>json</b> formats. If you use the <b>str</b> format you will need to pass
	# an array of strings.
	# </p>
	# @param resObj			the response object
	# @param fromRoom		an optional room id ( -1 if not needed )
	# @param who			the sender ( None if not needed )
	# @param recipientList	a list of recipients
	# @param msgType		the type of message -> can be "xml", "json", "str"
	#
	def sendResponse(self, resObj, fromRoom, who, recipientList, msgType="xml"):

		# XML response
		if msgType == "xml":
			response =  self._convertToJavaObject(resObj)

		# Str response
		elif msgType == "str":
			response = resObj
		
		elif msgType == "json":
			response = self._convertToJSON(resObj)
		
		# Recipient list
		chList = java.util.LinkedList()
		
		
		# Handle a list of recipients:
		# the list can be both a native pyhton list or a java Array
		if type(recipientList) == list or type(recipientList) == types.ArrayType:
			for recipient in recipientList:
				if recipient != None:
					chList.add(recipient.getChannel())
		
		# Special case in which a java.nio.SocketChannel is passed (at login time)
		else:
			chList.add(recipientList)

		
		__baseExtension.sendResponse(response, fromRoom, who, chList)
	
	
	
	## Send Room List
	#
	# @param who 	the recipient User	
	def sendRoomList(self, who):
		self._helper.sendRoomList(who.getChannel())
	
	
	## Set the buddy variables of the specified user.
	# <p>The variables dictionary should contain all the variables to set, where the key and value are strings</p>
	# <p>
	# Since version <b>1.6.0</b> you can set off-line buddy variables by using a '$' sign as the first character of
	# the variable name.<br>
	#
	# @since 1.6.0
	# 
	# @param user			the User
	# @param variables		a map containing the variables to set
	#
	def setBuddyVariables(self, user, varDict):
		hashMap = HashMap()
		
		for key, value in varDict.items():
			hashMap.put(key, value)
		
		self._helper.setBuddyVariables( user, hashMap )
		
	
	## Blocks / unblocks a buddy in the user's buddy list 
	# When the isBlocked flag is set to <b>true</b> the buddy won't be able to send any messages to the user.
	#
	# @param user			the owner of the buddy list
	# @param buddyName		the name of the buddy to block / unblock
	# @param isBlocked		the status (true == blocked)
	#
	# @since 1.6.0
	#
	def setBuddyBlockStatus(self, user, buddyName, isBlocked):
		self._helper.setBuddyBlockStatus(user, buddyName, isBlocked)
		
		
	## Set Room Variables
	# <p>For further informations about <b>Room Variables</b> check the examples and tutorials coming with SmartFoxServer PRO</p>
	#
	# <p>
	# The <b>varList</b> argument is a list of RoomVariable instances
	# </p>
	# @param room				the target Room object
	# @param who				the user, owner of the variables ( None = Server )
	# @param varList			a list of variables			
	# @param setOwnership		if True will change the ownership of the variables to the user passed in the <b>who</b> argument
	# @param broadcastAll		if True will send an update to the other clients in the target Room
	#
	def setRoomVariables(self, room, who, varList, setOwnership = True, broadcastAll = True):
		# TODO: Handle float types!!
		if not room == None:
			
			varMap = self._prepareRoomVars(varList, who)
					
			# Create vars
			if varMap.size() > 0:
				self._helper.setRoomVariables(room, who, varMap, setOwnership, broadcastAll)
	
	
	#
	# Create the proper data structure for setting roomVars
	#
	def _prepareRoomVars(self, varList, who):
		if varList == None:
			return varList
			
		varMap = HashMap()
		
		for var in varList:
			if not var == None:
				varT = type(var.val)
				
				if varT == types.IntType or varT == types.LongType or varT == types.FloatType:
					t = "n"
				elif varT == types.StringType:
					t = "s"
				elif varT == types.NoneType:
					t = "x"
					
				#
				# TODO: Handle Booleans?
				#
				varMap.put(var.name, __data.RoomVariable(str(var.val), t, who, var.persistent, var.priv))
		
		return varMap
	
	
	## Set User Variables
	# <p>
	# Set one or more User Variables. The <b>varMap</b> argument is a dictionary containing
	# any number of number, string or boolean values.
	# </p>
	# @param who			the target User
	# @param varMap			a dictionary of variables
	# @param broadcastAll	if True will send an update to the other users in Room
	#
	def setUserVariables(self, who, varMap, broadcastAll = True):
		uvMap = HashMap()
		
		keys = varMap.keys()
		for key in keys:
			uvar = str( varMap[key] )
			varT = type(uvar)
			
			if varT == types.IntType or varT == types.LongType or varT == types.FloatType:
				t = "n"
			elif varT == types.StringType:
				t = "s"
			elif varT == types.NoneType:
				t = "x"
				
			uvMap.put(key, __data.UserVariable(uvar, t))
		
		if uvMap.size() > 0:
			self._helper.setUserVariables(who, uvMap, broadcastAll)
			
	
	
	## Switch a spectator into a player, if possible
	#
	# @param user				the user to switch (must be a spectator)
	# @param roomId				the Room in which the user is joined (must be a game room)
	# @param broadcastAll		if True, sends and update to all other clients in the Room
	#
	def switchSpectator(self, user, roomId, broadcastAll=True):
		self._helper.switchSpectator(user, roomId, broadcastAll)
	
	
	
	## Trace a message to the console and AdminTool (if feature is active)
	#
	# @param msg	a text message
	def trace(self, msg):
		message = "[" + __baseExtension.getScriptFileName() + "]: " + str(msg)
		__baseExtension.adminExtension.logRemoteTrace(__baseExtension.getOwnerZone(), __baseExtension.getOwnerRoom(), message)
		print message
	
	
	#
	# Handle request coming from the java environment
	# Parse the parameters according to the serialization format
	# and pass the request to the extensions
	#
	def _handleJavaRequest(self, cmd, params, user, fromRoom, proto):
		if proto == "xml":
			handleRequest(cmd, self._convertToPyObject(params), user, fromRoom, proto)
			
		elif proto == "str":
			handleRequest(cmd, params, user, fromRoom, proto)
			
		elif proto == "json":
			handleRequest(cmd, self._convertJSON2Py(params), user, fromRoom, proto)
	
	
	#
	# Convert native python dictionary to
	# SFS Actionscript object
	# 
	# TODO: Currently does not support lists
	#
	def _convertToJavaObject(self, obj):
		ao = __lib.ActionscriptObject()
		
		for key in obj.keys():
			o = obj[key]
			t = type(o)
			
			# Convert a list to dict
			# Internally we only use dicts
			if t == list:
				d = {}
				c = 0
				for i in o:
					d[c] = i
					c += 1
				
				o = d
				t = type(o)
			
			if t == str:
				ao.put(key, o)
			
			elif t == int or t == float or t == long:
				ao.putNumber(key, o)
			
			elif t == dict:
				ao.put(key, self._convertToJavaObject(o))
		
		return ao
	
	#
	# Convert it.gotoandplay.smartfoxserver.lib.ActionscriptObject to native python dictionary
	# 
	# TODO: Currently does not support lists
	#
	def _convertToPyObject(self, obj):
		reqObj = {}
		keys = obj.keySet()
		
		for key in keys:
			val = obj.get(key)
			
			if not val == None:
				vType = val.getClass().getName()
			else:
				reqObj[key] = ""
				continue
			
			if vType == "it.gotoandplay.smartfoxserver.lib.ActionscriptObject":
				reqObj[key] = self._convertToPyObject(val)
			else:
				reqObj[key] = val
		
		return reqObj
		
	#
	# Convert native Python object to JSON
	#
	def _convertToJSON(self, obj):
		objType = type(obj)
		reqObj = None
		
		# Handle List
		if objType == types.ListType:
			reqObj = __json.JSONArray()
			
			for item in obj:
				reqObj.put(self._convertToJSON(item))
				
		# Handle Dictionary
		elif objType == types.DictionaryType:
			reqObj = __json.JSONObject()
			keys = obj.keys()
			
			for key in keys:
				# Force key to be a string
				reqObj.put(str(key), self._convertToJSON(obj[key]))
		
		# Handle a "simple" type and just return it	
		else:
			return obj
		
		# return the populated object
		return reqObj
	
	#
	# Convert a native JSON object
	# into a native Python object
	#
	def _convertJSON2Py(self, jso):
		reqObj = None
		
		if str(type(jso)) == "<type 'javainstance'>":
			jType = jso.getClass().getName()
		
			# Handle HashMap --> Dictionary
			if jType == "org.json.JSONObject":
				reqObj = {}
				mapData = jso.getData()
				keySet = mapData.keySet()
			
				for key in keySet:
					reqObj[key] = self._convertJSON2Py(mapData[key])
		
			# Handle ArrayList --> List
			elif jType == "org.json.JSONArray":
				reqObj = []
				listData = jso.getData()
			
				for item in listData:
					reqObj.append(self._convertJSON2Py(item))
		
		# Handle "simple" types and simply return it
		else:
			return jso
			
		# return the populated py object
		return reqObj
		
		
	def _dumpASObject(self, ao):
		__lib.ASObjectSerializer.dump(ao, 0)
		
