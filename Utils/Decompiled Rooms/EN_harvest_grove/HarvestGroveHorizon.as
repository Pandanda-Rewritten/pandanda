package
{
   import flash.display.*;
   import flash.geom.*;
   
   public class HarvestGroveHorizon extends Sprite
   {
      
      public function HarvestGroveHorizon()
      {
         super();
         this.cacheAsBitmap = true;
      }
      
      public function setNightMask(param1:Number) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = null;
         if(param1 >= 0)
         {
            _loc2_ = param1 * HarvestGroveScene.NIGHT_MASK_SCENE_ALPHA * SceneRoot.DEFAULT_NIGHT_MASK_INTENSITY;
            _loc3_ = this.transform.colorTransform;
            _loc3_.redMultiplier = 1 - _loc2_;
            _loc3_.greenMultiplier = 1 - _loc2_;
            _loc3_.blueMultiplier = 1 - _loc2_;
            transform.colorTransform = _loc3_;
         }
      }
   }
}

