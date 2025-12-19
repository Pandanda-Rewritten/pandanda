package
{
   import flash.display.*;
   
   public class BeachPalm2 extends Sprite implements IInteractiveObject
   {
      
      internal static const SIGN_MAX_ALPHA:Number = 1;
      
      public var s_nightMask:Sprite;
      
      public var m_yDepth:int;
      
      public function BeachPalm2()
      {
         super();
         trace("BeachPalm2 Constructor");
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
         if(param1 != 0)
         {
            s_nightMask.visible = true;
            s_nightMask.alpha = param1 * BeachScene.NIGHT_MASK_SCENE_ALPHA * SceneRoot.DEFAULT_NIGHT_MASK_INTENSITY;
         }
         else
         {
            s_nightMask.visible = false;
         }
      }
   }
}

