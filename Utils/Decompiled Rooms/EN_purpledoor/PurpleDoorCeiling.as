package
{
   import flash.display.*;
   import flash.geom.*;
   
   public class PurpleDoorCeiling extends Sprite
   {
      
      private static const TIME_BETWEEN_LIGHT_ANIMATION:int = 300;
      
      private static const TIME_BETWEEN_COLOR_SHIFTS:int = 600;
      
      private static const COLOR_STOP_FRAMES:Array = [26,57,86,114,147];
      
      public var s_light3:MovieClip;
      
      public var s_light5:MovieClip;
      
      public var s_light6:MovieClip;
      
      public var s_light7:MovieClip;
      
      public var s_light1:MovieClip;
      
      private var m_colorIndex:int;
      
      public var s_light4:MovieClip;
      
      public var s_light2:MovieClip;
      
      private var m_lightList:Array;
      
      private var m_prevFrameTime:uint;
      
      private var m_currLightPattern:int;
      
      public var s_color:MovieClip;
      
      private var m_lightCounter:int;
      
      private var m_colorCounter:int;
      
      public function PurpleDoorCeiling()
      {
         var _loc1_:int = 0;
         super();
         trace("PurpleDoorCeiling Constructor");
         s_color.gotoAndStop(1);
         m_lightList = new Array();
         m_lightList.push(s_light1);
         m_lightList.push(s_light2);
         m_lightList.push(s_light3);
         m_lightList.push(s_light4);
         m_lightList.push(s_light5);
         m_lightList.push(s_light6);
         m_lightList.push(s_light7);
         _loc1_ = 0;
         while(_loc1_ < m_lightList.length)
         {
            m_lightList[_loc1_].gotoAndStop(1);
            _loc1_++;
         }
         this.cacheAsBitmap = true;
         m_lightCounter = TIME_BETWEEN_LIGHT_ANIMATION;
         m_currLightPattern = 0;
         m_colorCounter = TIME_BETWEEN_COLOR_SHIFTS + 150;
         m_colorIndex = 4;
         s_color.gotoAndStop(COLOR_STOP_FRAMES[m_colorIndex]);
         m_prevFrameTime = new Date().getTime();
      }
      
      public function setLowQuality() : void
      {
         var _loc1_:int = 0;
         if(s_color.currentFrame != 1)
         {
            s_color.gotoAndStop(1);
         }
         _loc1_ = 0;
         while(_loc1_ < m_lightList.length)
         {
            if(m_lightList[_loc1_].currentFrame != 1)
            {
               m_lightList[_loc1_].gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      public function update() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         --m_lightCounter;
         if(m_lightCounter <= 0)
         {
            if(m_currLightPattern == 0)
            {
               m_lightList[0].gotoAndPlay(1);
               m_lightList[2].gotoAndPlay(1);
               m_lightList[4].gotoAndPlay(1);
               m_lightList[6].gotoAndPlay(1);
               m_currLightPattern = 1;
            }
            else
            {
               m_lightList[1].gotoAndPlay(1);
               m_lightList[3].gotoAndPlay(1);
               m_lightList[5].gotoAndPlay(1);
               m_currLightPattern = 0;
            }
            m_lightCounter = TIME_BETWEEN_LIGHT_ANIMATION;
         }
         if(s_color.currentFrame < COLOR_STOP_FRAMES[m_colorIndex])
         {
            _loc1_ = uint(new Date().getTime());
            _loc2_ = Math.ceil((_loc1_ - m_prevFrameTime) / 33);
            _loc3_ = s_color.currentFrame + _loc2_;
            if(_loc3_ < COLOR_STOP_FRAMES[m_colorIndex])
            {
               s_color.gotoAndPlay(_loc3_);
            }
            else
            {
               s_color.gotoAndStop(COLOR_STOP_FRAMES[m_colorIndex]);
            }
            m_prevFrameTime = _loc1_;
         }
         --m_colorCounter;
         if(m_colorCounter <= 0)
         {
            if(GameOptions.getInstance().getAntiAliasing() == GameOptions.OPTIONS_ANTIALIASING_HIGH)
            {
               if(s_color.currFrame == s_color.totalFrames)
               {
                  s_color.gotoAndPlay(1);
               }
               else
               {
                  s_color.play();
               }
               m_prevFrameTime = new Date().getTime();
            }
            else
            {
               s_color.gotoAndStop(COLOR_STOP_FRAMES[m_colorIndex]);
            }
            ++m_colorIndex;
            if(m_colorIndex >= COLOR_STOP_FRAMES.length)
            {
               m_colorIndex = 0;
            }
            m_colorCounter = TIME_BETWEEN_COLOR_SHIFTS;
         }
      }
      
      public function destroy() : void
      {
         m_lightList.length = 0;
         m_lightList = null;
      }
   }
}

