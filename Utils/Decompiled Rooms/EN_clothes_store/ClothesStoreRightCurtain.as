package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ClothesStoreRightCurtain extends Sprite implements IInteractiveObject
   {
      
      public var s_close:MovieClip;
      
      public var s_open:MovieClip;
      
      public var m_yDepth:int;
      
      public function ClothesStoreRightCurtain()
      {
         super();
         trace("ClothesStoreRightCurtain Constructor");
         s_open.gotoAndStop(1);
         s_close.visible = false;
         this.cacheAsBitmap = true;
         m_yDepth = 0;
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_TRANSPARENT;
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

