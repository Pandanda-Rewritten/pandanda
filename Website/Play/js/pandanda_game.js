
var doShowAds = false;

function reloadAllAds()
{
	reloadAd(1);
	reloadAd(2);
//	reloadAd(3);
//	reloadAd(4);
}

function removeGoogleAds()
{
	var sr = document.getElementById('ad_links');
	sr.innerHTML = "";
//	sr.innerHTML = "<script type=\"text/javascript\"><!--google_ad_client = \"ca-pub-2941100122740530\";/* Links on Blog */google_ad_slot = \"4276377014\";google_ad_width = 728;google_ad_height = 15;//--></script><script type=\"text/javascript\" src=\"http://pagead2.googlesyndication.com/pagead/show_ads.js\"></script>";
//	alert(sr.innerHTML);
}

function reloadAd(ad)
{
	if (!doShowAds)
	{
		return;
	}
//	doShowAds = true;
	if (ad == 1)
	{
		var sr = document.getElementById('ad1');
		sr.height = "62";
//		sr.src = "http://social.bidsystem.com/displayAd.aspx?pid=391319&appId=218116&plid=24005&adSize=468x60&channel=";
//		sr.src = sr.src;
//		sr.src = sr.src;
//		alert(sr.src);
	}
	if (ad == 2)
	{
		var sr = document.getElementById('ad2');
		sr.height = "62";
//		sr.src = "http://social.bidsystem.com/displayAd.aspx?pid=391319&appId=218116&plid=24005&adSize=468x60&channel=";
//		sr.src = sr.src;
//		sr.src = sr.src;
//		alert(sr.src);
	}
	if (ad == 3)
	{
		var sr = document.getElementById('ad3');
		sr.width = "120";
		sr.src = "http://social.bidsystem.com/displayAd.aspx?pid=391319&appId=218116&plid=24005&adSize=120x600&channel=";
//		sr.src = sr.src;
//		sr.src = sr.src;
	}
	if (ad == 4)
	{
		var sr = document.getElementById('ad4');
		sr.width = "120";
	}
	//alert(sr.src);
}


function showAds()
{
	swffit("pandanda", 776, 498, 935, 600);

	doShowAds = true;
//	reloadAllAds();
}
