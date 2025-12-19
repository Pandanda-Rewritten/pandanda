package
{
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.*;
   
   public class Firefly extends Sprite
   {
      
      internal var m_dx:Number;
      
      internal var m_dy:Number;
      
      internal var m_firefly:Sprite;
      
      internal var m_timer:int;
      
      public function Firefly()
      {
         var _loc1_:* = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         super();
         this.m_firefly = new Sprite();
         this.m_firefly.graphics.beginFill(16772203,1);
         this.m_firefly.graphics.drawCircle(100,100,3);
         this.m_firefly.graphics.endFill();
         _loc1_ = this.filters;
         _loc2_ = new BlurFilter(4,4);
         _loc1_.push(_loc2_);
         _loc3_ = new GlowFilter();
         _loc3_.color = 16772203;
         _loc3_.alpha = 1;
         _loc3_.inner = false;
         _loc3_.blurX = 11;
         _loc3_.blurY = 11;
         _loc3_.quality = BitmapFilterQuality.MEDIUM;
         _loc1_.push(_loc3_);
         this.m_firefly.filters = _loc1_;
         addChild(this.m_firefly);
         this.m_dx = Math.random() * 2 - 1;
         this.m_dy = Math.random() * 2 - 1;
         this.m_timer = Math.floor(Math.random() * 100) + 15;
      }
      
      public function destroy() : void
      {
         this.m_firefly = null;
      }
      
      public function hasExpired() : Boolean
      {
         if(this.m_timer <= 0)
         {
            return true;
         }
         return false;
      }
      
      public function update() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(GameOptions.getInstance().getAntiAliasing() == GameOptions.OPTIONS_ANTIALIASING_HIGH)
         {
            this.x += this.m_dx;
            this.y += Math.random() * 0.5 - 0.25;
         }
         --this.m_timer;
      }
   }
}

