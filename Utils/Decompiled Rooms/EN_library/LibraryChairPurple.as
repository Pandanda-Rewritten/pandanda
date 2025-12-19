package
{
   import flash.display.Sprite;
   
   public class LibraryChairPurple extends Sprite implements IInteractiveObject
   {
      
      private static const SIGN_MAX_ALPHA:Number = 1;
      
      public var s_nightMask:Sprite;
      
      public var m_yDepth:int;
      
      public function LibraryChairPurple()
      {
         super();
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_SOLID;
      }
      
      public function LibraryChimneyLeft() : *
      {
         trace("LibraryChairPurple Constructor");
         this.cacheAsBitmap = true;
         m_yDepth = 0;
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

