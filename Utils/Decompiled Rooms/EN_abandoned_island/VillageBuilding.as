package
{
   import flash.display.*;
   import flash.geom.*;
   
   public class VillageBuilding extends Sprite implements IInteractiveObject
   {
      
      internal static const BUILDING_MAX_ALPHA:Number = 0.6;
      
      internal var m_colorTransform:ColorTransform;
      
      public var s_nightMask:Sprite;
      
      public var m_yDepth:int;
      
      public function VillageBuilding()
      {
         super();
         trace("VillageBuilding Constructor");
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
            s_nightMask.alpha = param1 * VillageScene.NIGHT_MASK_SCENE_ALPHA * SceneRoot.DEFAULT_NIGHT_MASK_INTENSITY;
         }
         else
         {
            s_nightMask.visible = false;
         }
      }
   }
}

