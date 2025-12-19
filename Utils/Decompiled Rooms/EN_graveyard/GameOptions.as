package
{
   public class GameOptions
   {
      
      internal static var m_instance:GameOptions;
      
      public static const BORDER_COLORS:Array = ["0xFFFFFF","0x33BAFF","0xCC4BAC","0xFF99FF","0x3DD187","0xFFB233","0xF9DF39","0xD00013","0x003399","0x000000"];
      
      public static const OPTIONS_ANTIALIASING_LOW:int = 2;
      
      public static const OPTIONS_ANTIALIASING_HIGH:int = 0;
      
      public static const OPTIONS_ANTIALIASING_MEDIUM:int = 1;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      public var m_borderColor:String;
      
      public var m_isMusicOn:Boolean;
      
      public var m_borderColorIndex:int;
      
      public var m_allowFriendRequests:Boolean;
      
      public var m_antiAliasing:int;
      
      public var m_isSoundOn:Boolean;
      
      public var m_scale:Number;
      
      public function GameOptions()
      {
         super();
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use Clothing.getInstance() instead of new.");
         }
         trace("GameOptions Constuctor");
         this.m_isMusicOn = false;
         this.m_isSoundOn = true;
         this.m_scale = 1;
         this.m_antiAliasing = OPTIONS_ANTIALIASING_HIGH;
         this.m_borderColorIndex = 0;
         this.m_allowFriendRequests = false;
      }
      
      public static function getInstance() : GameOptions
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new GameOptions();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function setFriendRequests(param1:Boolean) : void
      {
         if(this.m_allowFriendRequests != param1)
         {
            this.m_allowFriendRequests = param1;
         }
      }
      
      public function isSoundOn() : Boolean
      {
         return this.m_isSoundOn;
      }
      
      public function getAntiAliasing() : int
      {
         return this.m_antiAliasing;
      }
      
      public function setSoundOn(param1:Boolean) : void
      {
         if(this.m_isSoundOn != param1)
         {
            this.m_isSoundOn = param1;
            GameSound.getInstance().toggleSound();
         }
      }
      
      public function setBorderColor(param1:int) : void
      {
         this.m_borderColorIndex = param1;
      }
      
      public function setAntiAliasing(param1:int) : void
      {
         this.m_antiAliasing = param1;
      }
      
      public function isMusicOn() : Boolean
      {
         return this.m_isMusicOn;
      }
      
      public function doAllowFriendRequests() : Boolean
      {
         return this.m_allowFriendRequests;
      }
      
      public function setMusicOn(param1:Boolean) : void
      {
         if(this.m_isMusicOn != param1)
         {
            this.m_isMusicOn = param1;
            GameSound.getInstance().toggleMusic();
         }
      }
      
      public function getBorderColor() : String
      {
         if(BORDER_COLORS[this.m_borderColorIndex])
         {
            return BORDER_COLORS[this.m_borderColorIndex];
         }
         return "0xFFFFFF";
      }
      
      public function getBorderColorIndex() : int
      {
         return this.m_borderColorIndex;
      }
   }
}

