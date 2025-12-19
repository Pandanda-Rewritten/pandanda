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
         m_yDepth = 0;
         s_light.visible = false;
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
            s_light.visible = true;
         }
         else
         {
            s_light.visible = false;
         }
      }
   }
}

