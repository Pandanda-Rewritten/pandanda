package
{
   import flash.display.*;
   
   public class TownSquareRightLamp extends Sprite implements IInteractiveObject
   {
      
      public var m_yDepth:int;
      
      public function TownSquareRightLamp()
      {
         super();
         trace("TownSquareRightLamp Constructor");
         this.cacheAsBitmap = true;
         this.m_yDepth = 0;
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_SOLID;
      }
      
      public function setYDepth(param1:int) : void
      {
         this.m_yDepth = param1;
      }
      
      public function getYDepth() : int
      {
         return this.m_yDepth;
      }
      
      public function setNightMask(param1:Number) : void
      {
         if(param1 <= 0)
         {
         }
      }
   }
}

