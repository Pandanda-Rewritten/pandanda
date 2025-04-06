<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<title>..:: SmartFoxServer -- Examples ::..</title>
		<link rel="stylesheet" href="styles.css" type="text/css" media="screen" charset="utf-8">
	</head>
	
	<body>
		<div id="header">
			<img src="images/title-sfs.png" width="354" height="72" alt="Title">
			<br>
			<img src="images/spacer.gif" width="10" height="40" alt="Spacer">
		</div>
		
		<div id="content">
			<!-- Examples -->
			<span class="bigTitle">&raquo; Live Local Examples</span>
			<br><br>
			All examples contained in this collection connect to the local <strong>SmartFoxServer</strong> that is curretly running. <br><br>
			<c:choose>
				<c:when test="${configErr}">
					<div style="border: 1px dotted #ff3300; background-color: #ffffcc; padding: 10px;">
						All local examples will connect by default to <strong>127.0.0.1:9339</strong> but SmartFoxServer is currently
						configured differently and you won't be able to use socket connections.<br><br>
						Your current configuration is <strong>${sfsAddr}:${sfsPort}</strong> - You should change the config.xml and restart the Server. 
					</div>
					<br>
				</c:when>
			</c:choose>
			
			In order to view the examples correctly there are a few basic requirements.
			<ul>
				<li>You should have the <strong>Flash Player 9 plugin</strong> (or higher) installed in your browser. If not, you can <a href="http://www.adobe.com/products/flashplayer/" target="_blank" title="Adobe Flash Player">quickly upgrade here.</a></li>
				<li>For examples that require two or more users to interact (chats, games etc...) you can simply click multiple times the application name to launch multiple instances.</li>
				<li>If you have problems with the server connections make sure that your personal firewall is not blocking access to <strong>TCP port 9339</strong> on the localhost (127.0.0.1)</li>
			</ul>
			
			<hr style="border: 1px dashed #cccccc" />

			<table border="0" cellspacing="8" cellpadding="0" width="760">
				<tr>
					<td valign='top' width="50%">
						<p class="bigTitle">&raquo; Tutorials (AS 2.0)</p>
						<p>
							${data['AS2']}
						</p>

					</td>
					
					<td valign='top' width="50%">
						<p class="bigTitle">&raquo; Tutorials (AS 3.0)</p>
						<p>${data['AS3']}

						</p>
						
						<p class="bigTitle">&raquo; OpenSpace (AS 3.0)</p>
						<p>
							${data['OS']}
						</p>
						
						<p class="bigTitle">&raquo; SmartFoxBits (AS 3.0)</p>
						<p>
							${data['Bits']}
						</p>
						
						<p class="bigTitle">&raquo; RedBox (Audio/Video) (AS 3.0)</p>
						<p>
							${data['RedBox']}
						</p>

						
					</td>					
				</tr>
			</table>

			<p>
				<a href='/'><img src="images/bt_back.png" width="172" border="0" height="44" alt="Bt Back"></a>
			</p>
			
			
			<br><br>
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