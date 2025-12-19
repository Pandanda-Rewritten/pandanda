package
{
   import flash.display.*;
   
   public class TownSquare2Pumpkin2 extends Sprite implements IInteractiveObject
   {
      
      public var m_yDepth:int;
      
      public function TownSquare2Pumpkin2()
      {
         super();
         trace("TownSquare2Pumpkin2 Constructor");
         this.cacheAsBitmap = true;
         this.visible = true;
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
         if(param1 > 0)
         {
            this.visible = true;
         }
      }
   }
}

