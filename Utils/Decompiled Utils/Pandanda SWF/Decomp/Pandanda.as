package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class Pandanda extends Sprite
   {
      
      private static var HOST_ALLOWLIST:Array = ["localhost","localhost"];
      
      public static const RETRIEVE_PASSWORD:String = "rpw";
      
      public static const CHANGE_PASSWORD:String = "cpw";
      
      public static const CACHE_VERSION_LOGIN:String = "2014-12-28";
      
      private static var SOME_INT_1:int = 335;
      
      private static var SOME_INT_2:int = 10;
      
      private var backgroundLayer:Sprite;
      
      private var stream:URLStream;
      
      private var loginLoader:Loader;
      
      private var nocacheStamp:Number;
      
      private var loadingLabel:String;
      
      public var s_version:MovieClip;
      
      private var loginObject:LoginObject;
      
      private var registrationLoader:Loader;
      
      private var action:String;
      
      private var clientLoader:Loader;
      
      private var referral:String;
      
      private var borderMask:Sprite;
      
      public var s_preloader:MovieClip;
      
      public function Pandanda()
      {
         var _loc1_:Boolean = false;
         var _loc2_:Date = null;
         var _loc3_:int = 0;
         super();
         trace("iPandanda Constuctor");
         _loc1_ = false;
         if(BuildConfig.isDev)
         {
            if(loaderInfo.url.indexOf("file:") != -1)
            {
               _loc1_ = true;
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < HOST_ALLOWLIST.length)
               {
                  if(loaderInfo.url.indexOf(HOST_ALLOWLIST[_loc3_]) != -1)
                  {
                     _loc1_ = true;
                  }
                  _loc3_++;
               }
            }
            if(!_loc1_)
            {
               navigateToURL(new URLRequest("http://localhost"),"_self");
               return;
            }
         }
         Security.loadPolicyFile("http://localhost/crossdomain.xml");
         Security.allowDomain("*");
         _loc2_ = new Date();
         nocacheStamp = _loc2_.time;
         borderMask = new Sprite();
         borderMask.graphics.beginFill(3766986);
         borderMask.graphics.drawRect(-200,0,200,600);
         borderMask.graphics.drawRect(936,0,200,600);
         borderMask.graphics.drawRect(-200,-200,1335,200);
         borderMask.graphics.drawRect(-200,600,1335,200);
         borderMask.graphics.endFill();
         addChild(borderMask);
         backgroundLayer = new Sprite();
         backgroundLayer.graphics.beginFill(3766986);
         backgroundLayer.graphics.drawRect(0,0,935,600);
         backgroundLayer.graphics.endFill();
         backgroundLayer.addChild(s_preloader);
         setLoadingText("Loading Pandanda");
         s_version.s_version.text = BuildConfig.VERSION;
         s_version.s_version.antiAliasType = AntiAliasType.ADVANCED;
         referral = new String();
         action = new String();
         this.loaderInfo.addEventListener(Event.COMPLETE,onLoaderInfoComplete);
      }
      
      public function loadLogin() : void
      {
         var _loc1_:URLRequest = null;
         stream = new URLStream();
         stream.addEventListener(Event.COMPLETE,onLoginBytesLoaded,false,0,true);
         stream.addEventListener(ProgressEvent.PROGRESS,onStreamProgress,false,0,true);
         stream.addEventListener(IOErrorEvent.IO_ERROR,onIoError,false,0,true);
         _loc1_ = new URLRequest(TextResources.getString(165,11));
         if(BuildConfig.isDev)
         {
            _loc1_.url = _loc1_.url.concat("?v=" + CACHE_VERSION_LOGIN);
         }
         stream.load(_loc1_);
         loadingLabel = new String("Login");
         addChild(backgroundLayer);
         addChild(s_version);
         addChild(borderMask);
      }
      
      private function onRegistrationBytesLoaded(param1:*) : void
      {
         var _loc2_:ByteArray = null;
         stream.removeEventListener(Event.COMPLETE,onRegistrationBytesLoaded);
         stream.removeEventListener(ProgressEvent.PROGRESS,onStreamProgress);
         stream.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
         _loc2_ = new ByteArray();
         stream.readBytes(_loc2_);
         if(BuildConfig.isDev)
         {
            if(_loc2_.length != 0)
            {
               OverrideCache.instance().saveBytes(_loc2_);
            }
         }
         registrationLoader = new Loader();
         registrationLoader.loadBytes(_loc2_);
         registrationLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onRegistrationSwfLoaded,false,0,true);
         registrationLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIoError,false,0,true);
         loadingLabel = new String("Registration");
         addChild(registrationLoader);
         addChild(backgroundLayer);
         addChild(s_version);
         addChild(borderMask);
      }
      
      public function onLoginBytesLoaded(param1:Event) : void
      {
         var _loc2_:ByteArray = null;
         stream.removeEventListener(Event.COMPLETE,onLoginBytesLoaded);
         stream.removeEventListener(ProgressEvent.PROGRESS,onStreamProgress);
         stream.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
         _loc2_ = new ByteArray();
         stream.readBytes(_loc2_);
         if(BuildConfig.isDev)
         {
            if(_loc2_.length != 0)
            {
               OverrideCache.instance().saveBytes(_loc2_);
            }
         }
         loginLoader = new Loader();
         loginLoader.loadBytes(_loc2_);
         loginLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoginSwfLoaded,false,0,true);
         loginLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIoError,false,0,true);
         addChild(loginLoader);
         addChild(backgroundLayer);
         addChild(s_version);
         addChild(borderMask);
      }
      
      private function onStreamProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = Math.floor(param1.bytesLoaded / 1024);
         _loc3_ = Math.floor(param1.bytesTotal / 1024);
         _loc4_ = Math.floor(_loc2_ / _loc3_ * 100);
         setLoadingText(String("Loading " + loadingLabel + " " + _loc4_ + "%"));
      }
      
      private function onRegistrationSwfLoaded(param1:Event) : void
      {
         registrationLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onRegistrationSwfLoaded);
         registrationLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onStreamProgress);
         registrationLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
         if(contains(backgroundLayer))
         {
            removeChild(backgroundLayer);
         }
         addEventListener(LoginEvent.EVENT_RETURN_TO_LOGIN,onReturnToLogin,false,0,true);
         IPandandaRegistration(registrationLoader.content).setReferral(referral);
      }
      
      private function setLoadingText(param1:String) : void
      {
         s_preloader.s_text.text = param1;
      }
      
      private function onReturnToLogin(param1:LoginEvent) : void
      {
         removeEventListener(LoginEvent.EVENT_RETURN_TO_LOGIN,onReturnToLogin);
         if(Boolean(registrationLoader) && contains(registrationLoader))
         {
            removeChild(registrationLoader);
            registrationLoader = null;
         }
         if(Boolean(clientLoader) && contains(clientLoader))
         {
            removeChild(clientLoader);
            clientLoader = null;
         }
         loadLogin();
      }
      
      private function onIoError(param1:IOErrorEvent) : void
      {
      }
      
      private function onLoginSuccess(param1:LoginEvent) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:ByteArray = null;
         removeEventListener(LoginEvent.EVENT_LOGIN_SUCCESS,onLoginSuccess);
         if(Boolean(loginLoader) && contains(loginLoader))
         {
            IPandandaLogin(loginLoader.content).destroy();
            removeChild(loginLoader);
            loginLoader = null;
         }
         if(param1.params.login is LoginObject)
         {
            loginObject = LoginObject(param1.params.login);
         }
         clientLoader = new Loader();
         _loc2_ = new URLRequest();
         if(BuildConfig.isDev)
         {
            if(contains(backgroundLayer))
            {
               removeChild(backgroundLayer);
            }
            if(contains(s_version))
            {
               removeChild(s_version);
            }
            if(param1.params.client)
            {
               trace("client loaded");
               _loc3_ = Base64.decode64(param1.params.client);
               clientLoader.loadBytes(_loc3_);
               trace("Image Loading Complete! TOT: " + _loc3_.length + " bytes.");
            }
            else
            {
               _loc2_.url = "uClient.swf?nocache=" + nocacheStamp;
               clientLoader.load(_loc2_);
            }
         }
         else
         {
            _loc2_.url = TextResources.getString(167,9);
            clientLoader.load(_loc2_);
         }
         clientLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onClientLoaded,false,0,true);
         clientLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onStreamProgress,false,0,true);
         clientLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIoError,false,0,true);
         loadingLabel = new String("Game Engine");
         setLoadingText(String("Loading " + loadingLabel + "... "));
         addChild(clientLoader);
         addChild(backgroundLayer);
         addChild(s_version);
         addChild(borderMask);
      }
      
      private function onGoToRegistration(param1:Event) : void
      {
         trace(TextResources.getString(166,12));
         removeEventListener(LoginEvent.EVENT_LOGIN_SUCCESS,onLoginSuccess);
         removeEventListener(LoginEvent.EVENT_GO_TO_REGISTRATION,onGoToRegistration);
         if(Boolean(loginLoader) && contains(loginLoader))
         {
            IPandandaLogin(loginLoader.content).destroy();
            removeChild(loginLoader);
            loginLoader = null;
         }
         loadRegistration();
      }
      
      private function onLoaderInfoComplete(param1:Event) : void
      {
         var _loc2_:Object = null;
         this.loaderInfo.removeEventListener(Event.COMPLETE,onLoaderInfoComplete);
         _loc2_ = this.loaderInfo.parameters;
         if(_loc2_.r)
         {
            referral = _loc2_.r;
            if(referral == "WT")
            {
               referral += "&" + (_loc2_.brand ? _loc2_.brand : " ");
               referral += "&" + (_loc2_.dp ? _loc2_.dp : " ");
               referral += "&" + (_loc2_.locale ? _loc2_.locale : " ");
            }
         }
         if(_loc2_.a)
         {
            action = _loc2_.a;
         }
         if(action == "reg")
         {
            loadRegistration();
         }
         else
         {
            loadLogin();
         }
      }
      
      private function onClientLoaded(param1:Event) : void
      {
         clientLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onClientLoaded);
         clientLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onStreamProgress);
         clientLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
         if(contains(backgroundLayer))
         {
            removeChild(backgroundLayer);
         }
         if(contains(s_version))
         {
            removeChild(s_version);
         }
         Sprite(clientLoader.content).focusRect = false;
         IUClient(clientLoader.content).launchGame(loginObject);
         addEventListener(LoginEvent.EVENT_RETURN_TO_LOGIN,onReturnToLogin,false,0,true);
      }
      
      private function loadRegistration() : void
      {
         var _loc1_:URLRequest = null;
         stream = new URLStream();
         stream.addEventListener(Event.COMPLETE,onRegistrationBytesLoaded,false,0,true);
         stream.addEventListener(ProgressEvent.PROGRESS,onStreamProgress,false,0,true);
         stream.addEventListener(IOErrorEvent.IO_ERROR,onIoError,false,0,true);
         _loc1_ = new URLRequest(TextResources.getString(168,10));
         if(BuildConfig.isDev)
         {
            _loc1_.url = _loc1_.url.concat("?nocache=" + nocacheStamp);
         }
         stream.load(_loc1_);
         loadingLabel = new String("Registration");
         addChild(backgroundLayer);
         addChild(s_version);
         addChild(borderMask);
      }
      
      private function destroy() : void
      {
      }
      
      private function onLoginSwfLoaded(param1:Event) : void
      {
         loginLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoginSwfLoaded);
         loginLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onStreamProgress);
         loginLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
         if(contains(backgroundLayer))
         {
            removeChild(backgroundLayer);
         }
         addEventListener(LoginEvent.EVENT_LOGIN_SUCCESS,onLoginSuccess,false,0,true);
         addEventListener(LoginEvent.EVENT_GO_TO_REGISTRATION,onGoToRegistration,false,0,true);
         addChild(s_version);
         IPandandaLogin(loginLoader.content).init(referral,action);
      }

      // Decompiler placeholders (kept minimal so this file parses).
      // These are expected to be defined elsewhere in the decompiled output.
      // If not, they can be replaced with real implementations later.
   }
}

