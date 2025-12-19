package
{
   import flash.display.Sprite;
   
   public class MiniGameHotSpot extends Sprite implements IInteractiveObject
   {
      
      public function MiniGameHotSpot()
      {
         super();
         this.mouseChildren = false;
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_CURSOR_TOP;
      }
      
      public function getYDepth() : int
      {
         return 0;
      }
      
      public function setYDepth(param1:int) : void
      {
      }
      
      public function setNightMask(param1:Number) : void
      {
      }
   }
}

