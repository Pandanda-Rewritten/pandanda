from javax.servlet.http import HttpServlet
from java.util import HashMap

#
# Simple JSP Usage Example
# Check the related JspExample.jsp page to see the HTML/Jsp code
#

class JspExample(HttpServlet):
	
	def doGet(self, request, response):	
		# Simple properties
		request.setAttribute("name", "Sethi II")
		request.setAttribute("location", "Karnak")
		request.setAttribute("country", "Egypt")
		
		# A List
		request.setAttribute("fruit", ["apple", "oranges", "apricoats", "mellons", "pears", "peaches"])
		
		# A HashMap
		hashmap = HashMap()
		hashmap.put("Commodore", "C-64")
		hashmap.put("BBC", "BBC Atom")
		hashmap.put("Synclair", "ZX Spectrum")
		hashmap.put("Sony", "MSX")
		hashmap.put("Apple", "Apple Lisa")
		
		request.setAttribute("retroComputers", hashmap.entrySet())
		
		# Dispatch request to the JSP page
		dispatcher = request.getRequestDispatcher("JspExample.jsp")
		dispatcher.forward(request, response)
		
		
	def doPost(self, request, response):	
		pass
		