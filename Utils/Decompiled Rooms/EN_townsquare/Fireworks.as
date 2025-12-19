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
         this.m_maxYOffset = param1;
         this.m_soundEffect = new Sound();
         this.m_soundEffect.addEventListener(IOErrorEvent.IO_ERROR,this.ioEffectErrorListener,false,0,true);
         this.m_soundEffect.load(new URLRequest("sound/firecracker03.mp3"));
      }
      
      internal function destroy() : void
      {
      }
      
      internal function newExplosion() : void
      {
         var _loc1_:* = null;
         _loc1_ = new Explosion();
         _loc1_.x = this.m_xOffset + Math.random() * 935;
         _loc1_.y = Math.random() * (this.m_maxYOffset - 10) + 10;
         addChild(_loc1_);
      }
      
      internal function playSoundEffect() : void
      {
         var loc1:* = undefined;
         loc1 = undefined;
         loc1 = undefined;
         if(GameOptions.getInstance().isSoundOn())
         {
            try
            {
               this.m_soundEffect.play(0,1);
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
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.m_xOffset = param1;
         --this.m_timer;
         if(this.m_timer <= 0)
         {
            this.newExplosion();
            this.playSoundEffect();
            this.m_timer = Math.random() * (MAX_FIREWORK_TIMER - MIN_FIREWORK_TIMER) + MIN_FIREWORK_TIMER;
         }
      }
   }
}

