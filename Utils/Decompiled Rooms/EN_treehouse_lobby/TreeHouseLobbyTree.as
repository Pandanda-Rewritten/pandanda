package
{
   import flash.display.*;
   import flash.events.*;
   
   public class TreeHouseLobbyTree extends Sprite implements IInteractiveObject
   {
      
      internal static const SIGN_MAX_ALPHA:Number = 1;
      
      public var s_nightMask:Sprite;
      
      public var m_yDepth:int;
      
      public function TreeHouseLobbyTree()
      {
         super();
         trace("TreeHouseLobbyTree Constructor");
         this.cacheAsBitmap = true;
         m_yDepth = 0;
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_TRANSPARENT;
      }
      
      internal function onRollOutListener(param1:MouseEvent) : void
      {
         trace("out");
      }
      
      public function setYDepth(param1:int) : void
      {
         m_yDepth = param1;
      }
      
      public function getYDepth() : int
      {
         return m_yDepth;
      }
      
      internal function onRollOverListener(param1:MouseEvent) : void
      {
         trace("over");
      }
      
      public function setNightMask(param1:Number) : void
      {
         if(param1 != 0)
         {
            s_nightMask.visible = true;
            s_nightMask.alpha = param1 * TreeHouseLobbyScene.NIGHT_MASK_SCENE_ALPHA * SceneRoot.DEFAULT_NIGHT_MASK_INTENSITY;
         }
         else
         {
            s_nightMask.visible = false;
         }
      }
      
      internal function onMouseClickListener(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CustomEvents.EVENT_SHOW_HOUSE_LIST_DIALOG,true));
      }
   }
}

