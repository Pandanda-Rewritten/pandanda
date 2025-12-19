package
{
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class StonehengeFlowers extends Sprite implements IInteractiveObject
   {
      
      private static const FLOWERS_MAX_ALPHA:Number = 0.5;
      
      public var m_yDepth:int;
      
      public function StonehengeFlowers()
      {
         super();
         trace("StonehengeFlowers Constructor");
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
         var _loc2_:Number = NaN;
         var _loc3_:ColorTransform = null;
         if(param1 > 0)
         {
            _loc2_ = param1 * FLOWERS_MAX_ALPHA;
            _loc3_ = this.transform.colorTransform;
            _loc3_.redMultiplier = 1 - _loc2_;
            _loc3_.greenMultiplier = 1 - _loc2_;
            _loc3_.blueMultiplier = 1 - _loc2_;
            transform.colorTransform = _loc3_;
         }
      }
   }
}

