package
{
   import flash.display.*;
   import flash.geom.*;
   
   public class VillageFountain extends Sprite implements IInteractiveObject
   {
      
      internal static const FOUNTAIN_MAX_ALPHA:Number = 1;
      
      internal var m_colorTransform:ColorTransform;
      
      public var s_nightMask:Sprite;
      
      public var m_yDepth:int;
      
      public function VillageFountain()
      {
         super();
         trace("VillageFountain Constructor");
         m_yDepth = 0;
         cacheAsBitmap = true;
         s_nightMask.visible = false;
         m_colorTransform = transform.colorTransform;
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
            s_nightMask.visible = true;
            s_nightMask.alpha = param1 * FOUNTAIN_MAX_ALPHA;
         }
         else
         {
            s_nightMask.visible = false;
         }
      }
   }
}

