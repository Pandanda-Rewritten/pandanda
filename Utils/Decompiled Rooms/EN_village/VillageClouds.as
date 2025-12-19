package
{
   import flash.display.*;
   import flash.utils.*;
   
   public class VillageClouds extends MovieClip
   {
      
      internal static const CLOUD1_SPEED:Number = 1.5;
      
      internal static const CLOUD2_SPEED:Number = 1.5;
      
      internal static const CLOUD3_SPEED:Number = 1.5;
      
      internal static const CLOUD_COUNT:int = 5;
      
      internal static const SCREEN_WIDTH:int = 935;
      
      internal static const CLOUD_Y_MAX_OFFSET:int = 40;
      
      internal static const acceleration:Number = 0.08;
      
      internal var m_timeLastFrame:Number;
      
      public var stg_cloud1:Sprite;
      
      public var stg_cloud2:Sprite;
      
      public var stg_cloud3:Sprite;
      
      public function VillageClouds()
      {
         super();
         this.stg_cloud1.cacheAsBitmap = true;
         this.stg_cloud2.cacheAsBitmap = true;
         this.stg_cloud3.cacheAsBitmap = true;
         this.stg_cloud1.x = Math.floor(Math.random() * 300) + 630;
         this.stg_cloud1.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET);
         this.stg_cloud2.x = Math.floor(Math.random() * 300);
         this.stg_cloud2.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         this.stg_cloud3.x = Math.floor(Math.random() * 300) + 320;
         this.stg_cloud3.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         setInterval(this.updateClouds,10);
         this.m_timeLastFrame = getTimer();
      }
      
      public function updateClouds() : void
      {
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         _loc1_ = getTimer();
         _loc2_ = (_loc1_ - this.m_timeLastFrame) / 100;
         this.stg_cloud1.x += _loc2_ * CLOUD1_SPEED - acceleration;
         if(this.stg_cloud1.x > SCREEN_WIDTH)
         {
            this.stg_cloud1.x = -this.stg_cloud1.width;
            this.stg_cloud1.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         }
         this.stg_cloud2.x += _loc2_ * CLOUD2_SPEED - acceleration;
         if(this.stg_cloud2.x > SCREEN_WIDTH)
         {
            this.stg_cloud2.x = -this.stg_cloud2.width;
            this.stg_cloud2.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         }
         this.stg_cloud3.x += _loc2_ * CLOUD3_SPEED - acceleration;
         if(this.stg_cloud3.x > SCREEN_WIDTH)
         {
            this.stg_cloud3.x = -this.stg_cloud3.width;
            this.stg_cloud3.y = Math.floor(Math.random() * CLOUD_Y_MAX_OFFSET) - 5;
         }
         this.m_timeLastFrame = _loc1_;
      }
   }
}

