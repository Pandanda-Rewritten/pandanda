package
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   
   public class BarnChicken extends MovieClip implements IInteractiveObject
   {
      
      internal static const CHICKEN_DOWN_TIME:int = 10;
      
      internal static const CHICKEN_TIMER:int = 50;
      
      public var m_yDepth:int;
      
      internal var m_timer:int;
      
      internal var m_isRaised:Boolean;
      
      internal var m_soundEffect:Sound;
      
      public function BarnChicken()
      {
         super();
         trace("BarnChicken Constructor");
         this.cacheAsBitmap = true;
         mouseChildren = false;
         m_yDepth = 0;
         m_timer = 0;
         m_isRaised = false;
         addEventListener(MouseEvent.ROLL_OVER,onRollOverListener,false,0,true);
         m_soundEffect = new Sound();
         m_soundEffect.addEventListener(IOErrorEvent.IO_ERROR,ioEffectErrorListener,false,0,true);
         m_soundEffect.load(new URLRequest("sound/chicken_cackle02a.mp3"));
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,onRollOverListener);
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_CURSOR_TOP;
      }
      
      internal function playSoundEffect() : void
      {
         var loc1:* = undefined;
         if(GameOptions.getInstance().isSoundOn())
         {
            try
            {
               m_soundEffect.play(0,1);
            }
            catch(e:Error)
            {
               trace("Error loading sound " + e.message);
            }
         }
      }
      
      internal function ioEffectErrorListener(param1:Event) : void
      {
      }
      
      public function update() : void
      {
         --m_timer;
         if(m_timer <= 0 && Boolean(m_isRaised))
         {
            gotoAndStop("off");
            this.mouseEnabled = true;
            m_isRaised = false;
            m_timer = CHICKEN_DOWN_TIME;
         }
      }
      
      public function setYDepth(param1:int) : void
      {
         m_yDepth = param1;
      }
      
      public function getYDepth() : int
      {
         return m_yDepth;
      }
      
      internal function onRollOverListener(param1:MouseEvent) : void
      {
         if(m_timer <= 0 && !m_isRaised)
         {
            this.gotoAndStop("over");
            this.mouseEnabled = false;
            m_timer = CHICKEN_TIMER;
            m_isRaised = true;
            playSoundEffect();
         }
      }
      
      public function setNightMask(param1:Number) : void
      {
      }
   }
}

