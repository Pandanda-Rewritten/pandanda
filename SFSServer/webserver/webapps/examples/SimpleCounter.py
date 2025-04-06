#
# Simple servlet example
# Keeps a count of the number of times it was called
#
from javax.servlet.http import HttpServlet

class SimpleCounter(HttpServlet):

	def __init__(self):
		self.htmlHead = "<html><head></head><body style='font-family:Verdana'>"
		self.closeHtml = "</body></html>"
		self.hitCount = 0
		
	def doGet(self, request, response):	
		w = response.getWriter()
		w.println(self.htmlHead)
		
		w.println("<h3>Simple Counter</h3><hr>")
		w.println("Servlet path: " + request.getServletPath() + "<br>")
		w.println("This servlet was hit %s times" % self.hitCount)
		
		self.hitCount += 1
		
		params = request.getParameterNames()
		
		if params.hasMoreElements():
			w.println("<br><br><b>PARAMS:<b><hr>")
			for param in params:
				w.println("<p style='font-size:70%'><b>" + param + "</b> &gt; " + request.getParameter(param) + "</p>")
		
		else:
			w.println("<p style='font-size:70%'>Try passing any number of paramater in the query string.<br>Example: ?name=Frank&amp;age=40</p>")
		
		w.println(self.closeHtml)
		w.close()
		
	def doPost(self, request, response):
		pass
		
		