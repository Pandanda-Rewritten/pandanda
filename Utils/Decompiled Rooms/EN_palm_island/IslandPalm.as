package
{
   import flash.display.*;
   import flash.geom.*;
   
   public class IslandPalm extends Sprite implements IInteractiveObject
   {
      
      public var m_yDepth:int;
      
      public function IslandPalm()
      {
         super();
         trace("IslandPalm Constructor");
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
      }
   }
}

