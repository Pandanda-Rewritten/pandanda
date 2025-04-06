<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<title>..:: SmartFoxServer -- Welcome ::..</title>
		<link rel="stylesheet" href="styles.css" type="text/css" media="screen" charset="utf-8">
		<script type="text/javascript" charset="utf-8">
			function contactUs()
			{
				var adr = "info"
				var dmn = "smartfoxserver"
				var ext = "com"
				var fulladr = adr + "@" + dmn + "." + ext
				location.href = "mailto:" + fulladr 
			}
			
			function showLoader()
			{
				var element = document.getElementById("loader")
				element.style.display = "block"
				
			}
		</script>
		
	</head>
	
	<body>
		<div id="header">
			<img src="images/title-sfs.png" width="354" height="72" alt="Title">
			<br>
			<img src="images/spacer.gif" width="10" height="40" alt="Spacer">
		</div>
		
		<div id="content">
			
			<!-- Getting Started -->
			<div style="border: 1px dotted #ff3300; background-color: #ffffcc; padding: 10px;">
				<strong style="font-size: 100%; color: #ff3300">SmartFoxServer PRO ${version} was installed successfully!</strong>
				<br><br>
				In this welcome page we we will guide you through the first steps in getting started with <strong>SmartFoxServer</strong>. <br>
				You will be able to explore the many examples provided, access the latest documentation, learn how to get support and more.
			</div>
			
			<br><br>

			<!-- Examples -->
			<c:choose>
				<c:when test="${examplesInstalled == 1}">
					<span class="bigTitle">&raquo; Browse Examples</span>
					<c:choose>
						<c:when test="${installationOk == 1}">
							<br><br>
							<strong>( Examples were installed succesfully! )</strong>
						</c:when>
					</c:choose>
					<br><br>
					Click the button below to browse the live examples coming with SmartFoxServer (<a href="http://www.adobe.com/products/flashplayer/" target="_blank" title="Adobe Flash Player">Flash Player 9</a> or higher required.)
					<br><br>
					<a href="examples.py"><img src="images/bt_browse.png" width="172" height="44" alt="Browse" border="0"></a>					
				</c:when>
				
				<c:otherwise>
					<span class="bigTitle">&raquo; Install Examples</span>
					<br><br>
					It looks like this is a fresh installation of <strong>SmartFoxServer</strong>.<br>
					In order to be able to check the many examples provided we simply need to install them locally in the http server folders.<br>
					This is a very simple, <strong>one-time operation</strong> that is performed automatically by clicking the button below. 
					<br><br>
					It takes less than one minute.
					<br><br>
					<a href='?action=install'><img src="images/bt_install.png" width="172" height="44" border="0" alt="Install" onClick="showLoader()"></a>
					<p id="loader" style="display: none;">
						<img src="images/loading.gif" width="20" height="20" align="left">&nbsp; Installing example files, please wait...
					</p>

					<c:if test='${error != null}'>
						<br><br>
						<div style="border: 1px dotted #330000; background-color: #AA0000; padding: 10px; color:white">
							<strong>Unexpected Error: </strong>${error}
						</div>
					</c:if>

				</c:otherwise>
			</c:choose>
			
			<br><br><br>
			
			<!-- Documentation -->
			<span class="bigTitle">&raquo; Documentation</span>
			<br><br>
			SmartFoxServer provides a detailed off-line documentation that is found under the <strong>Docs/</strong> folder in your 
			SmartFoxServer installation directory. 
			We also recommend to check our online documentation and white paper section which are updated very frequently:
			<ul>
				<li><a href="http://www.smartfoxserver.com/docs" target="_blank" title="SmartFoxServer Documentation">SmartFoxServer online documentation</a></li>
				<li><a href="http://www.smartfoxserver.com/whitepapers/" target="_blank" title="SmartFoxServer: Highly scalable multiplayer server clusters">SmartFoxServer white papers</a></li>
				<li><a href="http://www.smartfoxserver.com/bits/docs.php" target="_blank" title="SmartFoxBits | Flex/Flash components for SmartFoxServer">SmartFoxBits online documentation</a></li>
				<li><a href="http://www.openspace-engine.com/_docs/" target="_blank" title="OpenSpace documentation">OpenSpace online documentation</a></li>
			</ul>
			
			<br><br>
			
			<!-- Support -->
			<span class="bigTitle">&raquo; Support</span>
			<br><br>
			We have a <strong>very active support forum</strong> where you can get free help for any problems regarding the server, the API, notify bugs etc...
			For any other problem, dedicated support or other inquries feel free to can <a href="mailto:info@smartfoxserver.com">contact us via email</a>.
			<br><br>
			<a href="http://www.smartfoxserver.com/forums" target="_blank" title="smartfoxserver.com ~ Index"><img src="images/bt_forums.png" border="0" width="172" height="44" alt="Bt Forums"></a>
			<br><br><br><br><br><br><br><br>
		</div>
		
		<div id="footer">
			<br><br>
			(c) 2004-2009 gotoAndPlay()<br>
			:: All rights reserved ::<br>
			www.smartfoxserver.com --- www.gotoandplay.it
			<br><br><br>
		</div>
		
		
	</body>
	
</html>