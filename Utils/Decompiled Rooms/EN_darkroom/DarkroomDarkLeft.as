package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DarkroomDarkLeft extends Sprite implements IInteractiveObject
   {
      
      public var s_monster:MovieClip;
      
      public var m_yDepth:int;
      
      public function DarkroomDarkLeft()
      {
         super();
         trace("DarkroomDarkLeft Constructor");
         this.cacheAsBitmap = true;
         s_monster.gotoAndStop(1);
         m_yDepth = 0;
      }
      
      public function playMonster() : void
      {
         s_monster.gotoAndPlay(1);
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
      
      public function isActive() : Boolean
      {
         return s_monster.currentFrame != 1;
      }
      
      public function setNightMask(param1:Number) : void
      {
      }
   }
}

