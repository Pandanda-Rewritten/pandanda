package
{
   import flash.display.*;
   import flash.utils.*;
   
   public class VillageClouds extends MovieClip
   {
      
      internal static const CLOUD1_SPEED:Number = 10;
      
      internal static const CLOUD_COUNT:int = 4;
      
      internal static const CLOUD3_SPEED:Number = 9;
      
      internal static const SCREEN_WIDTH:int = 935;
      
      internal static const CLOUD2_SPEED:Number = 8;
      
      internal static const CLOUD_Y_MAX_OFFSET:int = 40;
      
      internal var m_timeLastFrame:Number;
      
      public var stg_cloud1:Sprite;
      
      public var stg_cloud2:Sprite;
      
      public var stg_cloud3:Sprite;
      
      public function VillageClouds()
      {
         super();
         stg_cloud1.cacheAsBitmap = true;
         stg_cloud2.cacheAsBitmap = true;
         stg_cloud3.cacheAsBitmap = true;
         stg_cloud1.x = Math.floor(Math.random() * 300) + 630;
         stg_cloud1.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET);
         stg_cloud2.x = Math.floor(Math.random() * 300);
         stg_cloud2.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         stg_cloud3.x = Math.floor(Math.random() * 300) + 320;
         stg_cloud3.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         m_timeLastFrame = getTimer();
      }
      
      public function updateClouds() : void
      {
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         _loc1_ = getTimer();
         _loc2_ = (_loc1_ - m_timeLastFrame) / 1000;
         stg_cloud1.x += _loc2_ * CLOUD1_SPEED;
         if(stg_cloud1.x > SCREEN_WIDTH)
         {
            stg_cloud1.x = -stg_cloud1.width;
            stg_cloud1.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         }
         stg_cloud2.x += _loc2_ * CLOUD2_SPEED;
         if(stg_cloud2.x > SCREEN_WIDTH)
         {
            stg_cloud2.x = -stg_cloud2.width;
            stg_cloud2.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         }
         stg_cloud3.x += _loc2_ * CLOUD3_SPEED;
         if(stg_cloud3.x > SCREEN_WIDTH)
         {
            stg_cloud3.x = -stg_cloud3.width;
            stg_cloud3.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         }
         m_timeLastFrame = _loc1_;
      }
   }
}

