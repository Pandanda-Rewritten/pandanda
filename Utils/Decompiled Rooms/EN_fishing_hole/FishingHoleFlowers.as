package
{
   import flash.display.*;
   import flash.geom.*;
   
   public class FishingHoleFlowers extends Sprite implements IInteractiveObject
   {
      
      public var m_yDepth:int;
      
      public function FishingHoleFlowers()
      {
         super();
         trace("FishingHoleFlowers Constructor");
         this.cacheAsBitmap = true;
         m_yDepth = 0;
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_SOLID;
      }
      
      public function setYDepth(param1:int) : void
      {
         m_yDepth = param1;
      }
      
      public function getYDepth() : int
      {
         return m_yDepth;
      }
      
      public function setNightMask(param1:Number) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = null;
         if(param1 > 0)
         {
            _loc2_ = param1 * FishingHoleScene.NIGHT_MASK_SCENE_ALPHA;
            _loc3_ = this.transform.colorTransform;
            _loc3_.redMultiplier = 1 - _loc2_;
            _loc3_.greenMultiplier = 1 - _loc2_;
            _loc3_.blueMultiplier = 1 - _loc2_;
            transform.colorTransform = _loc3_;
         }
      }
   }
}

