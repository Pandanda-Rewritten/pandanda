package
{
   import flash.display.*;
   
   public class VillageLampPost extends MovieClip implements IInteractiveObject
   {
      
      public var m_yDepth:int;
      
      public var s_light:Sprite;
      
      public function VillageLampPost()
      {
         super();
         trace("VillageLampPost Constructor");
         this.m_yDepth = 0;
         this.s_light.visible = false;
         cacheAsBitmap = true;
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_SOLID;
      }
      
      public function isTransparentable() : Boolean
      {
         return false;
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
            this.s_light.visible = true;
         }
         else
         {
            this.s_light.visible = false;
         }
      }
   }
}

