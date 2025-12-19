package
{
   import flash.display.*;
   
   public class OrchardTreeLeft extends Sprite implements IInteractiveObject
   {
      
      internal static const SIGN_MAX_ALPHA:Number = 1;
      
      public var s_nightMask:Sprite;
      
      public var m_yDepth:int;
      
      public function OrchardTreeLeft()
      {
         super();
         trace("OrchardTreeLeft Constructor");
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
         if(param1 != 0)
         {
            this.s_nightMask.visible = true;
            this.s_nightMask.alpha = param1 * OrchardScene.NIGHT_MASK_SCENE_ALPHA;
         }
         else
         {
            this.s_nightMask.visible = false;
         }
      }
   }
}

