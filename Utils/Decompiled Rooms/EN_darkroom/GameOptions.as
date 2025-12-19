package
{
   public class GameOptions
   {
      
      private static var m_instance:GameOptions;
      
      public static const OPTIONS_ANTIALIASING_HIGH:int = 0;
      
      public static const OPTIONS_ANTIALIASING_MEDIUM:int = 1;
      
      public static const OPTIONS_ANTIALIASING_LOW:int = 2;
      
      public static const BORDER_COLORS:Array = ["0xFFFFFF","0x33BAFF","0xCC4BAC","0xFF99FF","0x3DD187","0xFFB233","0xF9DF39","0xD00013","0x003399","0x000000"];
      
      private static var m_allowInstantiation:Boolean = false;
      
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
         m_isMusicOn = false;
         m_isSoundOn = true;
         m_scale = 1;
         m_antiAliasing = OPTIONS_ANTIALIASING_HIGH;
         m_borderColorIndex = 0;
         m_allowFriendRequests = false;
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
         if(m_allowFriendRequests != param1)
         {
            m_allowFriendRequests = param1;
         }
      }
      
      public function isSoundOn() : Boolean
      {
         return m_isSoundOn;
      }
      
      public function getAntiAliasing() : int
      {
         return m_antiAliasing;
      }
      
      public function setSoundOn(param1:Boolean) : void
      {
         if(m_isSoundOn != param1)
         {
            m_isSoundOn = param1;
            GameSound.getInstance().toggleSound();
         }
      }
      
      public function setBorderColor(param1:int) : void
      {
         m_borderColorIndex = param1;
      }
      
      public function setAntiAliasing(param1:int) : void
      {
         m_antiAliasing = param1;
      }
      
      public function isMusicOn() : Boolean
      {
         return m_isMusicOn;
      }
      
      public function doAllowFriendRequests() : Boolean
      {
         return m_allowFriendRequests;
      }
      
      public function setMusicOn(param1:Boolean) : void
      {
         if(m_isMusicOn != param1)
         {
            m_isMusicOn = param1;
            GameSound.getInstance().toggleMusic();
         }
      }
      
      public function getBorderColor() : String
      {
         if(BORDER_COLORS[m_borderColorIndex])
         {
            return BORDER_COLORS[m_borderColorIndex];
         }
         return "0xFFFFFF";
      }
      
      public function getBorderColorIndex() : int
      {
         return m_borderColorIndex;
      }
   }
}

