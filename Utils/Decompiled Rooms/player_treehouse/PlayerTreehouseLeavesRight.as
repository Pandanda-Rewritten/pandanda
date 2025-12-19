package
{
   import flash.display.*;
   
   public class PlayerTreehouseLeavesRight extends Sprite implements IInteractiveObject
   {
      
      internal static const SIGN_MAX_ALPHA:Number = 1;
      
      public var s_nightMask:Sprite;
      
      public var m_yDepth:int;
      
      public function PlayerTreehouseLeavesRight()
      {
         super();
         trace("PlayerTreehouseLeavesRight Constructor");
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
      }
   }
}

