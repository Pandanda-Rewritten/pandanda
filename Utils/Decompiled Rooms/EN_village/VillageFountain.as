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
         this.m_yDepth = 0;
         cacheAsBitmap = true;
         this.s_nightMask.visible = false;
         this.m_colorTransform = transform.colorTransform;
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
            this.s_nightMask.visible = true;
            this.s_nightMask.alpha = param1 * FOUNTAIN_MAX_ALPHA;
         }
         else
         {
            this.s_nightMask.visible = false;
         }
      }
   }
}

