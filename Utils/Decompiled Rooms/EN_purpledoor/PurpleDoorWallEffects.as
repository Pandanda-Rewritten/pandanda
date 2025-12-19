package
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.utils.getTimer;
   
   public class PurpleDoorWallEffects extends Sprite
   {
      
      private static const MAX_DISTANCE:int = 150;
      
      private static const EFFECTS_WIDTH:int = 281;
      
      private static const EFFECTS_HEIGHT:int = 174;
      
      private static const WALL_EFFECTS_COUNT:int = 5;
      
      private var m_points:Array;
      
      private var m_prevLaserX:int;
      
      private var m_prevLaserY:int;
      
      private var m_counter:int;
      
      private var m_animation:int;
      
      private var m_rectList:Array;
      
      private var m_height:*;
      
      private var m_bf:BlurFilter;
      
      private var m_sp:Sprite;
      
      private var m_animationCounter:Array;
      
      private var m_width:*;
      
      private var m_glowFilter:GlowFilter;
      
      public var s_animation1:MovieClip;
      
      public var s_animation2:MovieClip;
      
      private var m_pulseCounter:int;
      
      public function PurpleDoorWallEffects()
      {
         var _loc1_:Sprite = null;
         m_sp = new Sprite();
         m_points = new Array();
         m_bf = new BlurFilter(3,3,1);
         m_glowFilter = new GlowFilter(52479,2,20,10,2,3,true,false);
         super();
         s_animation1.gotoAndStop(1);
         s_animation1.visible = false;
         m_animation = 1;
         m_width = EFFECTS_WIDTH;
         m_height = EFFECTS_HEIGHT;
         _loc1_ = new Sprite();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawRect(0,0,m_width,m_height);
         _loc1_.graphics.endFill();
         addChildAt(_loc1_,0);
         this.addChildAt(m_sp,1);
         m_prevLaserX = m_width / 2;
         m_prevLaserY = m_height / 2;
         m_rectList = new Array();
         m_sp.filters = [m_bf];
         m_animationCounter = new Array();
         m_animationCounter[0] = 240;
         m_animationCounter[1] = 500;
         m_animationCounter[2] = 400;
         m_animationCounter[3] = 500;
         m_animationCounter[4] = 400;
      }
      
      public function setLowQuality() : void
      {
         m_sp.graphics.clear();
         if(s_animation1.currentFrame != 35)
         {
            s_animation1.gotoAndStop(35);
            s_animation1.visible = true;
            s_animation2.visible = false;
         }
      }
      
      private function updateLasers() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         _loc1_ = m_sp.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(2,16777215);
         _loc2_ = new Point(m_prevLaserX,m_prevLaserY);
         if(m_counter & 2)
         {
            do
            {
               _loc2_.x = m_prevLaserX + (Math.random() * MAX_DISTANCE - MAX_DISTANCE / 2);
            }
            while(_loc2_.x > m_width || _loc2_.x < 0);
            
            do
            {
               _loc2_.y = m_prevLaserY + (Math.random() * MAX_DISTANCE - MAX_DISTANCE / 2);
            }
            while(_loc2_.y > m_height || _loc2_.y < 0);
            
         }
         _loc1_.moveTo(_loc2_.x,_loc2_.y);
         _loc3_ = _loc2_.x - m_prevLaserX;
         _loc4_ = _loc3_ ? _loc3_ : Math.random() * randSet(-1,1);
         _loc5_ = _loc2_.y - m_prevLaserY;
         _loc6_ = _loc5_ ? _loc5_ : Math.random() * randSet(-1,1);
         _loc7_ = Number(m_points.push({
            "x":_loc2_.x,
            "y":_loc2_.y,
            "vx":_loc4_ / 20,
            "vy":_loc6_ / 20,
            "life":getTimer()
         }));
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            if(m_points[_loc8_])
            {
               if(getTimer() - m_points[_loc8_].life > 700)
               {
                  m_points.splice(_loc8_--,1);
               }
               else if(_loc8_ != 0 && Boolean(m_points[_loc8_]))
               {
                  m_points[_loc8_].x += m_points[_loc8_].vx;
                  if(m_points[_loc8_].x > m_width)
                  {
                     m_points[_loc8_].x = m_width;
                  }
                  else if(m_points[_loc8_].x < 0)
                  {
                     m_points[_loc8_].x = 0;
                  }
                  m_points[_loc8_].y += m_points[_loc8_].vy;
                  if(m_points[_loc8_].y > m_height)
                  {
                     m_points[_loc8_].y = m_height;
                  }
                  else if(m_points[_loc8_].y < 0)
                  {
                     m_points[_loc8_].y = 0;
                  }
                  _loc9_ = Number(m_points[_loc8_ - 1].x);
                  _loc10_ = Number(m_points[_loc8_ - 1].y);
                  _loc1_.curveTo(_loc9_,_loc10_,(m_points[_loc8_].x + _loc9_) * 0.5,(m_points[_loc8_].y + _loc10_) * 0.5);
               }
               else
               {
                  _loc1_.moveTo(m_points[_loc8_].x,m_points[_loc8_].y);
               }
            }
            _loc8_++;
         }
         m_prevLaserX = _loc2_.x;
         m_prevLaserY = _loc2_.y;
      }
      
      private function updateStars() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         m_sp.graphics.clear();
         m_sp.graphics.lineStyle(2,16777215);
         _loc4_ = 0;
         while(_loc4_ < m_rectList.length)
         {
            _loc3_ = int(m_rectList[_loc4_][2]);
            _loc2_ = int(m_rectList[_loc4_][0]);
            _loc1_ = int(m_rectList[_loc4_][1]);
            _loc1_ -= 3 + _loc4_ % 2;
            m_sp.graphics.moveTo(_loc2_,_loc1_);
            m_sp.graphics.lineTo(_loc2_ + _loc3_,_loc1_);
            m_sp.graphics.lineTo(_loc2_ + _loc3_ * 0.2,_loc1_ + _loc3_ * 0.6);
            m_sp.graphics.lineTo(_loc2_ + _loc3_ * 0.5,_loc1_ - _loc3_ * 0.4);
            m_sp.graphics.lineTo(_loc2_ + _loc3_ * 0.8,_loc1_ + _loc3_ * 0.6);
            m_sp.graphics.lineTo(_loc2_,_loc1_);
            if(_loc1_ < -20)
            {
               m_rectList[_loc4_][0] = Math.random() * EFFECTS_WIDTH;
               m_rectList[_loc4_][1] = EFFECTS_HEIGHT;
               m_rectList[_loc4_][2] = Math.random() * 30 + 10;
            }
            else
            {
               m_rectList[_loc4_][1] = _loc1_;
            }
            _loc4_++;
         }
      }
      
      private function createSquares() : void
      {
         m_rectList.length = 0;
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,5));
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,15));
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,25));
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,35));
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,45));
      }
      
      private function createStars() : void
      {
         m_rectList.length = 0;
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,Math.random() * 30 + 10));
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,Math.random() * 30 + 10));
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,Math.random() * 30 + 10));
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,Math.random() * 30 + 10));
         m_rectList.push(new Array(Math.random() * EFFECTS_WIDTH,Math.random() * EFFECTS_HEIGHT,Math.random() * 30 + 10));
      }
      
      public function update() : void
      {
         ++m_counter;
         if(m_counter > m_animationCounter[m_animation])
         {
            m_sp.graphics.clear();
            m_animation = (m_animation + 1) % WALL_EFFECTS_COUNT;
            selectAnimation();
            m_counter = 0;
         }
         if(m_animation == 0 || m_animation == 1 || m_animation == 3)
         {
            updateLasers();
         }
         else if(m_animation == 2)
         {
            updateSquares();
         }
         else if(m_animation == 4)
         {
            updateStars();
         }
      }
      
      private function updateSquares() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         m_sp.graphics.clear();
         m_sp.graphics.lineStyle(2,16777215);
         _loc2_ = 0;
         while(_loc2_ < m_rectList.length)
         {
            _loc1_ = int(m_rectList[_loc2_][2]);
            _loc1_ += 1;
            m_sp.graphics.drawRect(m_rectList[_loc2_][0] - _loc1_ / 2,m_rectList[_loc2_][1] - _loc1_ / 2,_loc1_,_loc1_);
            if(_loc1_ > 50)
            {
               m_rectList[_loc2_][0] = Math.random() * EFFECTS_WIDTH;
               m_rectList[_loc2_][1] = Math.random() * EFFECTS_HEIGHT;
               m_rectList[_loc2_][2] = 5;
            }
            else
            {
               m_rectList[_loc2_][2] = _loc1_;
            }
            _loc2_++;
         }
      }
      
      private function selectAnimation() : void
      {
         if(m_animation == 0)
         {
            m_sp.filters = [m_bf,m_glowFilter];
            s_animation1.gotoAndPlay(1);
            s_animation1.visible = true;
            s_animation2.visible = false;
         }
         else if(m_animation == 1 || m_animation == 3)
         {
            m_sp.filters = [m_bf];
            s_animation1.gotoAndStop(1);
            s_animation1.visible = false;
            s_animation2.visible = true;
         }
         else if(m_animation == 2)
         {
            m_sp.filters = [m_bf];
            s_animation1.gotoAndStop(1);
            s_animation1.visible = false;
            s_animation2.visible = true;
            createSquares();
         }
         else if(m_animation == 4)
         {
            m_sp.filters = [m_bf];
            s_animation1.gotoAndStop(1);
            s_animation1.visible = false;
            s_animation2.visible = true;
            createStars();
         }
      }
      
      public function destroy() : void
      {
         m_rectList.length = 0;
         m_rectList = null;
      }
      
      private function randSet(param1:Number, param2:Number) : Number
      {
         return Math.floor(Math.random() * 2);
      }
   }
}

