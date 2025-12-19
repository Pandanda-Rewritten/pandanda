package
{
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   
   public class Explosion extends Sprite
   {
      
      internal var m_numberOfParticles:int = 0;
      
      internal var m_particlesArray:Array;
      
      public function Explosion()
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = undefined;
         var _loc6_:* = NaN;
         var _loc7_:* = undefined;
         var _loc8_:* = null;
         m_numberOfParticles = 0;
         super();
         m_particlesArray = new Array();
         m_numberOfParticles = Math.floor(Math.random() * 30) + 10;
         _loc1_ = new Color();
         _loc2_ = 16777215 * Math.random();
         if((_loc2_ & 0x808080) == 0)
         {
            _loc2_ |= 10526880;
         }
         _loc1_.setTint(_loc2_,1);
         _loc3_ = Math.random();
         _loc4_ = 360 / m_numberOfParticles;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = 0;
         while(_loc7_ < m_numberOfParticles)
         {
            _loc8_ = new Particle();
            _loc6_ = Math.random() * 2 + 1;
            _loc8_.speedY = Math.sin(_loc5_ * Math.PI / 180) * _loc6_;
            _loc8_.speedX = Math.cos(_loc5_ * Math.PI / 180) * _loc6_;
            _loc8_.scaleX = _loc3_;
            _loc8_.scaleY = _loc3_;
            m_particlesArray.push(_loc8_);
            _loc8_.transform.colorTransform = _loc1_;
            addChild(_loc8_);
            _loc5_ += _loc4_;
            _loc7_++;
         }
         addEventListener(Event.ENTER_FRAME,enterFrameHandler);
      }
      
      internal function enterFrameHandler(param1:Event) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = null;
         _loc2_ = 0;
         while(_loc2_ < m_particlesArray.length)
         {
            _loc3_ = m_particlesArray[_loc2_];
            _loc3_.y += _loc3_.speedY;
            _loc3_.x += _loc3_.speedX;
            _loc3_.rotation = randRange(0,360);
            _loc3_.scaleX = _loc3_.scaleY = randRange(0.2,1);
            _loc3_.alpha -= 0.02;
            _loc2_++;
         }
         if(m_particlesArray[0].alpha < -0.1)
         {
            _loc2_ = 0;
            while(_loc2_ < numChildren)
            {
               removeChildAt(0);
               _loc2_++;
            }
            if(parent.contains(this))
            {
               parent.removeChild(this);
            }
            removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            m_particlesArray.length = 0;
            m_particlesArray = null;
         }
      }
      
      internal function randRange(param1:Number, param2:Number) : Number
      {
         var _loc3_:* = NaN;
         return Math.random() * (param2 - param1) + param1;
      }
   }
}

