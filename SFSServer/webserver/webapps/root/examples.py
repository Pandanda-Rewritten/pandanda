from javax.servlet.http import HttpServlet
from it.gotoandplay.smartfoxserver.config import ConfigData
from java.lang import Thread, Boolean
from java.util import HashMap

import installer

class examples(HttpServlet):
	
	def __init__(self):
		self.data = self.processData()
		self.true = Boolean("true")
		self.false = Boolean("false")
		
	def doGet(self, request, response):
		request.setAttribute("data", self.data)
		configErr = self.false
		
		if ConfigData.SERVER_PORT != 9339:
			configErr = self.true
			
		elif ConfigData.SERVER_ADDR != '*' and ConfigData.SERVER_ADDR != "127.0.0.1":
			configErr = self.true
		
		request.setAttribute("configErr", configErr)
		request.setAttribute("sfsPort", ConfigData.SERVER_PORT)
		request.setAttribute("sfsAddr", ConfigData.SERVER_ADDR)
		
		dispatcher = request.getRequestDispatcher("_examples.jsp")
		dispatcher.forward(request, response)
		
	def doPost(self, request, response):	
		pass
		
	def processData(self):
		data = HashMap()
		
		for key in installer.examplesData.keys():
			html = '<ul>'
			itemList = installer.examplesData[key]
			
			for item in itemList:
				html += "<li><a href='Examples/%s/' target='blank'>%s</a></li>" % (item['path'], item['label'])
				
			html += '</ul>'
			data.put(key, html)
		
		return data
			
		