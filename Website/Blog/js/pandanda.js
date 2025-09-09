// Flash Player Version Detection - Rev 1.6
// Detect Client Browser type
// Copyright(c) 2005-2006 Adobe Macromedia Software, LLC. All rights reserved.

// this top half is from Adobe for flash detection

// Globals
// Major version of Flash required
var requiredMajorVersion = 9;
// Minor version of Flash required
var requiredMinorVersion = 0;
// Minor version of Flash required
var requiredRevision = 0;

var isIE  = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
var isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1) ? true : false;
var isOpera = (navigator.userAgent.indexOf("Opera") != -1) ? true : false;

function ControlVersion()
{
	var version;
	var axo;
	var e;

	// NOTE : new ActiveXObject(strFoo) throws an exception if strFoo isn't in the registry

	try {
		// version will be set for 7.X or greater players
		axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");
		version = axo.GetVariable("$version");
	} catch (e) {
	}

	if (!version)
	{
		try {
			// version will be set for 6.X players only
			axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");

			// installed player is some revision of 6.0
			// GetVariable("$version") crashes for versions 6.0.22 through 6.0.29,
			// so we have to be careful.

			// default to the first public version
			version = "WIN 6,0,21,0";

			// throws if AllowScripAccess does not exist (introduced in 6.0r47)
			axo.AllowScriptAccess = "always";

			// safe to call for 6.0r47 or greater
			version = axo.GetVariable("$version");

		} catch (e) {
		}
	}

	if (!version)
	{
		try {
			// version will be set for 4.X or 5.X player
			axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
			version = axo.GetVariable("$version");
		} catch (e) {
		}
	}

	if (!version)
	{
		try {
			// version will be set for 3.X player
			axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
			version = "WIN 3,0,18,0";
		} catch (e) {
		}
	}

	if (!version)
	{
		try {
			// version will be set for 2.X player
			axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
			version = "WIN 2,0,0,11";
		} catch (e) {
			version = -1;
		}
	}

	return version;
}

// JavaScript helper required to detect Flash Player PlugIn version information
function GetSwfVer(){
	// NS/Opera version >= 3 check for Flash plugin in plugin array
	var flashVer = -1;

	if (navigator.plugins != null && navigator.plugins.length > 0) {
		if (navigator.plugins["Shockwave Flash 2.0"] || navigator.plugins["Shockwave Flash"]) {
			var swVer2 = navigator.plugins["Shockwave Flash 2.0"] ? " 2.0" : "";
			var flashDescription = navigator.plugins["Shockwave Flash" + swVer2].description;
			var descArray = flashDescription.split(" ");
			var tempArrayMajor = descArray[2].split(".");
			var versionMajor = tempArrayMajor[0];
			var versionMinor = tempArrayMajor[1];
			var versionRevision = descArray[3];
			if (versionRevision == "") {
				versionRevision = descArray[4];
			}
			if (versionRevision[0] == "d") {
				versionRevision = versionRevision.substring(1);
			} else if (versionRevision[0] == "r") {
				versionRevision = versionRevision.substring(1);
				if (versionRevision.indexOf("d") > 0) {
					versionRevision = versionRevision.substring(0, versionRevision.indexOf("d"));
				}
			}
			var flashVer = versionMajor + "." + versionMinor + "." + versionRevision;
//			alert("flashVer="+flashVer);
		}
	}
	// MSN/WebTV 2.6 supports Flash 4
	else if (navigator.userAgent.toLowerCase().indexOf("webtv/2.6") != -1) flashVer = 4;
	// WebTV 2.5 supports Flash 3
	else if (navigator.userAgent.toLowerCase().indexOf("webtv/2.5") != -1) flashVer = 3;
	// older WebTV supports Flash 2
	else if (navigator.userAgent.toLowerCase().indexOf("webtv") != -1) flashVer = 2;
	else if ( isIE && isWin && !isOpera ) {
		flashVer = ControlVersion();
	}
	return flashVer;
}

// When called with reqMajorVer, reqMinorVer, reqRevision returns true if that version or greater is available
function DetectFlashVer(reqMajorVer, reqMinorVer, reqRevision)
{
	versionStr = GetSwfVer();
	if (versionStr == -1 ) {
		return false;
	} else if (versionStr != 0) {
		if(isIE && isWin && !isOpera) {
			// Given "WIN 2,0,0,11"
			tempArray         = versionStr.split(" "); 	// ["WIN", "2,0,0,11"]
			tempString        = tempArray[1];			// "2,0,0,11"
			versionArray      = tempString.split(",");	// ['2', '0', '0', '11']
		} else {
			versionArray      = versionStr.split(".");
		}
		var versionMajor      = versionArray[0];
		var versionMinor      = versionArray[1];
		var versionRevision   = versionArray[2];

        	// is the major.revision >= requested major.revision AND the minor version >= requested minor
		if (versionMajor > parseFloat(reqMajorVer)) {
			return true;
		} else if (versionMajor == parseFloat(reqMajorVer)) {
			if (versionMinor > parseFloat(reqMinorVer))
				return true;
			else if (versionMinor == parseFloat(reqMinorVer)) {
				if (versionRevision >= parseFloat(reqRevision))
					return true;
			}
		}
		return false;
	}
}



//---------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------
// Pandanda functions are added below

function LoadBearSWF()
{


   	document.write('<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="804" height="426" ID="Shockwaveflash1">\n');
   	document.write('<param name="movie" value="pandanda_bear.swf">\n');
   	document.write('<param name="quality" value="high">\n');

   	document.write('<embed src="pandanda_bear.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="804" height="426"></embed>\n');
   	document.write('</object>\n');
}

function LoadBearHTML()
{
	// avatar bear
	document.write('<TABLE border=0; cellspacing=0; cellpadding=0;>\n');
	document.write('<tr width=100%><td>\n');
	document.write('<table border=0; cellspacing=0; cellpadding=0; class="TablePageTitle">\n');
	document.write('<td><img src="images/gray_gradient.gif" width="35" height="171" alt="pandanda Flash game title"></td>\n');
	document.write('<td><a href="http://www.adobe.com/go/getflash/"><img src="images/avatar.gif" border="0" width="153" height="171" alt="get Flash"></a></td>\n');
	document.write('<td><img src="images/gray_gradient.gif" width="612" height="171" alt="pandanda Flash game title"></td>\n');
	document.write('</tr>\n');
	document.write('</table>\n');
	document.write('</td></tr>\n');
	document.write('</table>\n');
	// buttons
	document.write('<div class="buttonmenu">\n');
	document.write('<div class="button1"><a href="pandanda_about.htm" title="What is Pandanda?"><img src="images/button_left_off.gif" alt="what is pandanda?" ></a></div>\n');
	document.write('<div class="button2"><a href="pandanda_sneakpeek.htm" title="Pandanda Sneak Peek"><img src="images/button_middle_off.gif" alt="pandanda sneak peek" ></a></div>\n');
	document.write('<div class="button3"><a href="pandanda_faq.htm" title="Pandanda FAQ"><img src="images/button_right_off.gif" alt="pandanda FAQ" ></a></div>\n');
	document.wirte('</div>\n');
}

function LoadAvatarRegion()
{
	var hasReqestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);

	// Check to see if the version meets the requirements for playback
	if (hasReqestedVersion)
	{
		// we've detected an acceptable version
		// embed the Flash Content SWF
		LoadBearSWF();
	}
	else
	{
		// flash is too old or we can't detect the plugin
		LoadBearHTML();
	}
}

function LoadAboutButtons()
{
//	document.write('<div class="buttonmenu">\n');
	document.write('<div class="button1"><img src="images/buttonTab_left_selected.gif" alt="What is Pandanda?" ></div>\n');
	document.write('<div class="button2"><a href="pandanda_sneakpeek.htm" title="Pandanda Sneak Peek"><img src="images/buttonTab_middle_off.gif" alt="pandanda sneak peek" ></a></div>\n');
	document.write('<div class="button3"><a href="pandanda_faq.htm" title="Pandanda FAQ"><img src="images/buttonTab_right_off.gif" alt="pandanda FAQ" ></a></div>\n');
//	document.wirte('</div>\n');

}

function LoadFAQButtons()
{
//	document.write('<div class="buttonmenu">\n');
	document.write('<div class="button1"><a href="pandanda_about.htm" title="What is Pandanda?"><img src="images/buttonTab_left_off.gif" alt="What is Pandanda?" ></a></div>\n');
	document.write('<div class="button2"><a href="pandanda_sneakpeek.htm" title="Pandanda Sneak Peek"><img src="images/buttonTab_middle_off.gif" alt="pandanda sneak peek" ></a></div>\n');
	document.write('<div class="button3"><img src="images/buttonTab_right_selected.gif" alt="pandanda FAQ" ></div>\n');
//	document.wirte('</div>\n');
}

function LoadSneakPeekButtons()
{
//	document.write('<div>\n');
	document.write('<div class="button1"><a href="pandanda_about.htm" title="What is Pandanda?"><img src="images/buttonTab_left_off.gif" alt="What is Pandanda?" ></a></div>\n');
	document.write('<div class="button2"><img src="images/buttonTab_middle_selected.gif" alt="pandanda sneak peek" ></div>\n');
	document.write('<div class="button3"><a href="pandanda_faq.htm" title="Pandanda FAQ"><img src="images/buttonTab_right_off.gif" alt="pandanda FAQ" ></a></div>\n');
//	document.wirte('</div>\n');
}

var currShot = 0;
var screenshots = new Array();
var screencapt = new Array();
screenshots[0] = "images/screenshots/screenshot1.jpg";
screencapt[0] = "Bear Hollow";
screenshots[1] = "images/screenshots/screenshot2.jpg";
screencapt[1] = "Tree House";
screenshots[2] = "images/screenshots/screenshot3.jpg";
screencapt[2] = "The Big Scoop";
screenshots[3] = "images/screenshots/screenshot4.jpg";
screencapt[3] = "Ice Cream Menu";
screenshots[4] = "images/screenshots/screenshot5.jpg";
screencapt[4] = "Shady Glen";
screenshots[5] = "images/screenshots/screenshot6.jpg";
screencapt[5] = "East Market Street";
screenshots[6] = "images/screenshots/screenshot7.jpg";
screencapt[6] = "Pawdington Forest";
screenshots[7] = "images/screenshots/screenshot10.jpg";
screencapt[7] = "Fishing Hole";


function UpdateImage()
{
	// update the captions
   	var imageText = document.getElementById("caption");
	imageText.firstChild.nodeValue= screencapt[currShot] + "  (" + (currShot + 1) +  "/" + screenshots.length + ")";

	// update the screenshot
  	mainimage.src = screenshots[currShot];
}

function LoadNextImage()
{
	// increment the current screenshot
	currShot++;
	if (currShot >= screenshots.length)
	{
		currShot = 0;
	}
	UpdateImage();

}

function LoadPreviousImage()
{
	// decrement the current screenshot
	if (currShot == 0)
	{
		currShot = (screenshots.length - 1);
	}
	else
	{
		currShot--;
	}
	UpdateImage();
}


function LoadArrow()
{
	var screenText = screencapt[currShot] + "  (" + (currShot + 1) +  "/" + screenshots.length + ")";
	document.write('<div class="buttonArrowLeft"><a href="javascript:LoadPreviousImage()"><img src="images/arrow_left_off.gif" alt="Pandanda left"></a></div>\n');
	document.write('<div class="arrowbar"><img src="images/arrow_bar.gif" alt="Pandanda bar"><span id="caption">' + screenText +'</span></div>\n');
	document.write('<div class="buttonArrowRight"><a href="javascript:LoadNextImage()"><img src="images/arrow_right_off.gif" alt="Pandanda right"></a></div>\n');
}

function popup(url)
{
	newwindow=window.open(url,'name','height=200,width=150');
	if (window.focus)
	{
		newwindow.focus()
	}
	return false;
}


function updateClock ( )
{
  var d = new Date ( );
  var utc = d.getTime() + (d.getTimezoneOffset() * 60000);
  var offset = -8;
  var pandanda = new Date(utc + (3600000*offset));

  var currentHours = pandanda.getHours ( );
  var currentMinutes = pandanda.getMinutes ( );
  var currentSeconds = pandanda.getSeconds ( );

  // Pad the minutes and seconds with leading zeros, if required
  currentMinutes = ( currentMinutes < 10 ? "0" : "" ) + currentMinutes;
  currentSeconds = ( currentSeconds < 10 ? "0" : "" ) + currentSeconds;

  // Choose either "AM" or "PM" as appropriate
  var timeOfDay = ( currentHours < 12 ) ? "AM" : "PM";

  // Convert the hours component to 12-hour format if needed
  currentHours = ( currentHours > 12 ) ? currentHours - 12 : currentHours;

  // Convert an hours component of "0" to "12"
  currentHours = ( currentHours == 0 ) ? 12 : currentHours;

  // Compose the string for display
  var currentTimeString = currentHours + ":" + currentMinutes + ":" + currentSeconds + " " + timeOfDay;

  // Update the time display
  document.getElementById("clock").firstChild.nodeValue = currentTimeString;
}


function createProfileCode()
{
	var name = document.profile.p.value;
	var w = document.profile.w.value;
	var h = Math.round(w * 1.36);
	if (name != "")
	{
		document.profile.link.value = "<iframe src=\"http://play.pandanda.com/panda.php?p=" + name + "&w="+ w +"\" scrolling=\"no\" frameborder=\"0\" allowTransparency=\"true\" align=\"left\" style=\"border:none; overflow:hidden; width:" + w +"px; height:" + h + "px\"></iframe>";
	}
	else
	{
		alert("You must enter your Panda's name.");
	}
	return false;
}

