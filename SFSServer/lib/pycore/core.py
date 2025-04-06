# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 	SmartFoxServer pyCore lib
# 	version 1.6.0
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

import sys, os
importPath = os.path.abspath("lib/pycore/")
if not (importPath in sys.path):
	sys.path.append(importPath)

from it.gotoandplay.smartfoxserver.py import IPyClass
from main import *
from util import *

class PyClassWrapper(IPyClass):
	
	def __init__(self, innerClass):
		self.innerClass = innerClass
		
	def call(self, methodName, params):
			method = self.innerClass.__getattribute__( methodName )
			return apply(method, params)

			
def init():
	boot()
	classDict = 	{
						"taskGenHelper" : PyClassWrapper( TaskGenHelper() ),
						"msGen" : PyClassWrapper( util.MSF )
					}

	for id, classItem in classDict.items():
		__classes__.put( id, classItem )
		