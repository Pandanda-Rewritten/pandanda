// cookie function used for referrals
var refCookie = "ref";

//--------------------------------------------------------
// setCookie
//--------------------------------------------------------
function setCookie(c_name, value, expiredays)
{
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	var ref_cookie = c_name+ "=" +escape(value)+((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
	ref_cookie += ";domain=pandanda.com";
	document.cookie=ref_cookie;
}

//--------------------------------------------------------
// getCookie
//--------------------------------------------------------
function getCookie(c_name)
{
  	var results = document.cookie.match(c_name + '=(.*?)(;|$)')
  	if(results)
  	{
    	return(results[1]);
    }
  	else
  	{
		return null;
    }
}

//--------------------------------------------------------
// checkReferral
//--------------------------------------------------------
function checkReferral(myQueryString)
{
	// take the search string and look for a referral. If there isn't one, set the
	// referal to Pandanda
	// remove the '?' sign if exists
	var urlHasReferral = false;
	var referral = getCookie(refCookie);
	if (referral != null)
	{
		// already have a referral cookie, bail out
//		alert('already have a referral ' + referral);
		return;
	}

	// no referral cookie, let's set one if it was passed in, or default to Pandanda
	if (myQueryString[0]='?')
	{
		myQueryString = myQueryString.substr(1, myQueryString.length-1);

		var myParamArray = myQueryString.split("&");
		if (myParamArray[0] != "")
		{
			var myValueArray = myParamArray[0].split("=");
			if ((myValueArray[0] == "r") || (myValueArray[0] == "partner"))
			{
				// we have a referral
//				alert('we have a referral ' + myValueArray[1]);
				setCookie(refCookie, myValueArray[1], 30);
				// loop through and save off all passed in variables as cookies
				var x;
				for (x in myParamArray)
				{
					myValueArray = myParamArray[x].split("=");
					setCookie(myValueArray[0], myValueArray[1], 30);
				}
			}
		}

	}

	// if there was no referral, we will set our own cookie so we know it's our player
	referral=getCookie(refCookie);
	if (referral == null || referral == "")
  	{
//		alert('no referral set pandanda ');
		// no referral cookie, set our own pandanda cookie
		setCookie(refCookie, 'pandanda', 9999);
	}

//	referral=getCookie(refCookie);
//	alert('referral set to ' + referral);

}






