package
{
   import flash.display.Sprite;
   
   public class StonehengeRockRight extends Sprite implements IInteractiveObject
   {
      
      public var s_nightMask:Sprite;
      
      public var m_yDepth:int;
      
      public function StonehengeRockRight()
      {
         super();
         trace("StonehengeRockRight Constructor");
         this.mouseEnabled = false;
         this.cacheAsBitmap = true;
         s_nightMask.visible = false;
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
         if(param1 == 0)
         {
            s_nightMask.visible = false;
         }
         else
         {
            s_nightMask.visible = true;
            s_nightMask.alpha = param1 * StonehengeScene.NIGHT_MASK_SCENE_ALPHA * SceneRoot.DEFAULT_NIGHT_MASK_INTENSITY;
         }
      }
   }
}

