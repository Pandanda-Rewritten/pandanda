package
{
   import flash.display.*;
   
   public class GraveyardWindow extends Sprite implements IInteractiveObject
   {
      
      internal static const SIGN_MAX_ALPHA:Number = 1;
      
      public var s_nightMask:Sprite;
      
      public var s_light:Sprite;
      
      public var s_glow:Sprite;
      
      public var m_yDepth:int;
      
      public function GraveyardWindow()
      {
         super();
         trace("GraveyardWindow Constructor");
         this.cacheAsBitmap = true;
         this.m_yDepth = 0;
         this.s_light.visible = false;
         this.s_glow.visible = false;
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
            this.s_nightMask.alpha = param1 * GraveyardScene.NIGHT_MASK_SCENE_ALPHA * SceneRoot.DEFAULT_NIGHT_MASK_INTENSITY;
            this.s_light.visible = true;
            this.s_glow.visible = true;
         }
         else
         {
            this.s_nightMask.visible = false;
            this.s_light.visible = false;
            this.s_glow.visible = false;
         }
      }
   }
}

