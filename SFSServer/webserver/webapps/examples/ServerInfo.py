#
# Simple servlet example
# Display basic SmartFoxServer status infos
#

from javax.servlet.http import HttpServlet
from it.gotoandplay.smartfoxserver.webserver import WebHelper

class ServerInfo(HttpServlet):

	def __init__(self):
		self.htmlHead = "<html><head></head><body style='font-family:Verdana'>"
		self.closeHtml = "</body></html>"
	
	#
	# Handle GET requests
	#
	def doGet(self, request, response):	
		w = response.getWriter()
		w.println(self.htmlHead)
		
		status = WebHelper.getServerStatus()
		keys = status.keySet()
		
		w.println("<h2>SmartFoxServer :: Status</h2><hr>")
		w.println("<table cellpadding='6' cellspacing='0' border='0'>")
		w.println("<tr bgcolor='#eeeeee'><th align='left'>Key</th><th align='left'>Value</th></tr>")
		
		for key in keys:
			w.println("<tr>")
			w.println("<td>%s</td><td>%s</td>" % (key, status[key]))
			w.println("</tr>")
		
		w.println("</table><hr>")
		
		w.println(self.closeHtml)
		w.close()
		
	#
	# Handle POST requests
	#
	def doPost(self, request, response):	
		pass
		
		