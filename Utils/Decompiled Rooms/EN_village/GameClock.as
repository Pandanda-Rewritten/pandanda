package
{
   public class GameClock
   {
      
      internal static var m_instance:GameClock;
      
      internal static const NIGHT_START_HOUR:int = 19;
      
      internal static const DAY_START_HOUR:int = 7;
      
      internal static const PANDANDA_GMT_OFFSET:int = 7;
      
      internal static const DAY_START_MINUTE:int = 5;
      
      internal static const NIGHT_START_MINUTE:int = 5;
      
      internal static const CLOCK_TIMER:int = 10000;
      
      internal static const TRANSITION_SPEED:uint = 360;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      m_allowInstantiation = false;
      m_allowInstantiation = false;
      
      internal var m_timeZoneOffsetInSeconds:int;
      
      internal var m_loginTime:uint;
      
      internal var m_localOffsetInSeconds:int;
      
      public function GameClock()
      {
         super();
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use GameClock.getInstance() instead of new.");
         }
         trace("GameClock Constuctor");
         this.m_localOffsetInSeconds = 0;
         this.m_timeZoneOffsetInSeconds = 0;
      }
      
      public static function getInstance() : GameClock
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new GameClock();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function getLoginTime() : uint
      {
         return this.m_loginTime;
      }
      
      public function getDayStartHour() : int
      {
         return DAY_START_HOUR;
      }
      
      public function getDate() : Date
      {
         var _loc1_:* = 0;
         var _loc2_:* = undefined;
         _loc1_ = new Date().getTime() / 1000;
         _loc1_ -= this.m_localOffsetInSeconds;
         return new Date(_loc1_ * 1000);
      }
      
      public function getMinutes() : int
      {
         return this.getDate().getMinutes();
      }
      
      public function getNightStartHour() : int
      {
         return NIGHT_START_HOUR;
      }
      
      public function getDayNightTransitionSpeed() : int
      {
         return TRANSITION_SPEED;
      }
      
      public function setDate(param1:uint) : void
      {
         var _loc2_:* = null;
         _loc2_ = new Date();
         this.m_timeZoneOffsetInSeconds = PANDANDA_GMT_OFFSET * 3600 - _loc2_.getTimezoneOffset() * 60;
         this.m_localOffsetInSeconds = _loc2_.getTime() / 1000 - param1;
         trace("localOffsetInSeconds : " + this.m_localOffsetInSeconds);
         this.m_loginTime = _loc2_.getTime() / 1000;
         this.m_loginTime -= this.m_localOffsetInSeconds + this.m_timeZoneOffsetInSeconds;
      }
      
      public function getNightStartMinute() : int
      {
         return NIGHT_START_MINUTE;
      }
      
      public function isNight() : Boolean
      {
         if(this.getHours() > this.getNightStartHour() || this.getHours() == this.getNightStartHour() && this.getMinutes() >= this.getNightStartMinute() || this.getHours() < this.getDayStartHour() || this.getHours() == this.getDayStartHour() && this.getMinutes() <= this.getDayStartMinute())
         {
            return true;
         }
         return false;
      }
      
      public function getServerDate() : Date
      {
         var _loc1_:* = 0;
         var _loc2_:* = undefined;
         _loc1_ = new Date().getTime() / 1000;
         _loc1_ -= this.m_localOffsetInSeconds + this.m_timeZoneOffsetInSeconds;
         return new Date(_loc1_ * 1000);
      }
      
      public function getDayStartMinute() : int
      {
         return DAY_START_MINUTE;
      }
      
      public function getHours() : int
      {
         return this.getDate().getHours();
      }
      
      public function destroy() : void
      {
      }
      
      public function getSeconds() : int
      {
         return this.getDate().getSeconds();
      }
   }
}

