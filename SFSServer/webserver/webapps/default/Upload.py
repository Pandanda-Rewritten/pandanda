#
# Java Imports
#
from javax.servlet.http import HttpServlet
from http.utils.multipartrequest import ServletMultipartRequest
from http.utils.multipartrequest import MultipartRequest
from http.utils.multipartrequest import MaxReadBytesException
from it.gotoandplay.smartfoxserver.webserver import WebHelper
from it.gotoandplay.smartfoxserver import SmartFoxServer
from java.io import File
from java.lang import System
from java.util import HashMap

#
# Python Imports
#
import os
import shutil
from random import Random


#------------------------------------------------------------
# Servlet Class
#------------------------------------------------------------
class Upload(HttpServlet):
	
	#
	# Constructor
	#
	def __init__(self):
		self.version = "1.1.0"
		self.br = "<br>"
		self.hr = "<hr>"
		
		self.htmlHead = """	<html>
							<head>
								<title>SmartFoxServer :: multiuser socket server</title>
							</head>
							<body style='font-family:Verdana; font-size:11px;'>
						"""
		self.closeHtml = "</body></html>"
		
		self.tempUploadDir = "./webserver/webapps/default/tempUploads/"
		self.uploadDir = "./webserver/webapps/default/uploads/"
		
		self.logger = SmartFoxServer.log
		self.MAX_FILE_SIZE = 1024000 # 1mb size limit
		
	#
	# Handle GET data
	#
	def doGet(self, request, response):
		writer = response.getWriter()
		writer.write(self.htmlHead)
		writer.write("<span style='font-size:120%;font-weight:bold'>SmartFoxServer Upload component</span>" + self.br)
		writer.write(("version: %s %s " % (self.version, self.hr)))
		writer.write("(c) 2004-2006 gotoAndPlay()" + self.br)
		writer.write("<a href='http://www.gotoandplay.it' target='_blank'>www.gotoandplay.it</a>" + self.br)
		writer.write("<a href='http://www.smartfoxserver.com' target='_blank'>www.smartfoxserver.com</a>")
		writer.write(self.closeHtml)
	#
	# Handle POST data
	#
	def doPost(self, request, response):

		#
		# HACK: this is necessary because the flash player upload sends TWO REQUESTS
		# the first one is completely empty!!!
		# The 2nd one is good!
		#
			
		if request.getContentLength() > 0:
			page = response.getWriter()
			senderId = request.getParameter("id")
			senderNick = request.getParameter("nick")
			
			# debug only
			# print "id: %s, nick: %s, ip: %s" % (senderId, senderNick, request.getRemoteAddr())
			
			# Verify user
			isValidUser = WebHelper.verifyUploadUser(senderId, senderNick, request.getRemoteAddr())
			
			if isValidUser:
				# pass the request object and the target folder
				# if the size exceeds the passed MAX SIZE
				# the upfile will be completely ignored
				parser = ServletMultipartRequest(request, 
												self.tempUploadDir, 
												self.MAX_FILE_SIZE, 
												MultipartRequest.IGNORE_FILES_IF_MAX_BYES_EXCEEDED, 
												None)
				
				# get all file-upload fields in the request
				files = parser.getFileParameterNames()
				
				# Random generator
				rnd = Random()
				
				# List of files successfully transferred
				transFiles = HashMap()
				
				for file in files:
					fileRef = parser.getFile(file)
					
					# Get original file name
					fileOriginalName = parser.getBaseFilename(file)
					
					# Extract extension
					fileExt = fileOriginalName[fileOriginalName.rfind("."):]
					
					# Create the unique filename keeping the original extension
					# Also adds a random at the end to avoid name collisions
					fileName = "file_" + str(System.currentTimeMillis()) + "_" + str(rnd.randint(0, 1000)) + fileExt # before:  parser.getBaseFilename(file)
					
					# Info data, needed for debug only
					contentType = parser.getContentType(file)
					fileSize = parser.getFileSize(file)
					
					# Let's copy the file
					if not fileRef == None:
						#print "File: %s, type: %s, size: %s, senderId: %s" % (fileName, contentType, fileSize, senderId)
						self.logger.fine(("File upload: %s, type: %s, size: %s, senderId: %s" % (fileName, contentType, fileSize, senderId)))
						wasMoved = self.moveFile(fileRef.getName(), fileName)
						
						if wasMoved == False:
							self.logger.warning(("Failed moving uploaded file: %s, userId: %s " % (fileName, senderId)))
						else:
							transFiles.put(fileName, fileOriginalName)

				# Fire event
				sfs = SmartFoxServer.getInstance()
				sfs.getSysHandler().broadcastFileUploaded(senderId, transFiles)
			
			else:
				SmartFoxServer.log.warning("Invalid user upload from: " + request.getRemoteHost())
		
	
	#
	# Move file from temp folder to final destination
	#
	def moveFile(self, tempFile, newFilename):
		res = False
		
		try:
			src = self.tempUploadDir + tempFile
			dst = self.uploadDir + newFilename

			shutil.copyfile( src, dst )
			os.remove( src )
			
			res = True
		
		except IOError, ioe:
			pass
			
		except OSError, ose:
			pass
			
		else:
			return res

	
	