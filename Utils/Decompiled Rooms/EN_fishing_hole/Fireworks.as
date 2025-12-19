package
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   
   public class Fireworks extends Sprite
   {
      
      internal static const MAX_FIREWORK_TIMER:int = 100;
      
      internal static const MIN_FIREWORK_TIMER:int = 15;
      
      internal var m_xOffset:int;
      
      internal var m_maxYOffset:int;
      
      internal var m_soundEffect:Sound;
      
      internal var m_timer:int;
      
      public function Fireworks(param1:int)
      {
         super();
         m_maxYOffset = param1;
         m_soundEffect = new Sound();
         m_soundEffect.addEventListener(IOErrorEvent.IO_ERROR,ioEffectErrorListener,false,0,true);
         m_soundEffect.load(new URLRequest("sound/firecracker03.mp3"));
      }
      
      internal function destroy() : void
      {
      }
      
      internal function newExplosion() : void
      {
         var _loc1_:* = null;
         _loc1_ = new Explosion();
         _loc1_.x = m_xOffset + Math.random() * 935;
         _loc1_.y = Math.random() * (m_maxYOffset - 10) + 10;
         addChild(_loc1_);
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
         trace("ioEffectErrorListener: " + param1);
      }
      
      public function update(param1:int) : void
      {
         m_xOffset = param1;
         --m_timer;
         if(m_timer <= 0)
         {
            newExplosion();
            playSoundEffect();
            m_timer = Math.random() * (MAX_FIREWORK_TIMER - MIN_FIREWORK_TIMER) + MIN_FIREWORK_TIMER;
         }
      }
   }
}

