<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
		<title>..:: Simple JSP page ::..</title>
	</head>
	
	<body style="font: 100% Georgia, Arial, sans">
		<h3>Simple JSP page</h3>
		<p style="font: 70% Verdana, Arial, sans; color:#777777; margin-top:-12px;">
			SmartFoxServer PRO :: (c) 2007 gotoAndPlay()<br />
			Simple Python-Servlet/Jsp example showing the creation of dynamic pages using the embedded <a href="http://www.mortbay.org/" target="_blank">Jetty</a> webserver.<br />
		</p>
		<hr size="1" />
		
		<!-- Example with simple properties -->
		<p style="font-weight:bold; color:#ff3300;">&raquo; Simple properties</p>
		<div style="background:#fffff0; border:1px dotted #ff9900; padding:12px">
			Param <b>name:</b> ${name}<br />
			Param <b>location:</b> ${location}<br />
			Param <b>country:</b> ${country}<br />
		</div>
		
		<!-- Example with a list -->
		<p style="font-weight:bold; color:#ff3300;">&raquo; List example</p>
		<div style="background:#fffff0; border:1px dotted #ff9900; padding:12px">
			<ul>
				<c:forEach var="item" items="${fruit}">
					<li>${item}</li>
				</c:forEach>
			</ul>
		</div>
		
		<!-- Example with a map -->
		<p style="font-weight:bold; color:#ff3300;">&raquo; Map example</p>
		<div style="background:#fffff0; border:1px dotted #ff9900; padding:12px">
		<table cellspacing="1" cellpadding="4" bgColor="white">
			<tr bgColor="#ffcc00"><th>Brand</th><th>Model</th></tr>
			<c:forEach var="item" items="${retroComputers}">
				<tr>
					<td>${item.key}</td><td>${item.value}</td>
				</tr>
			</c:forEach>
		</table>
		</div>
		
	</body>
	
</html>