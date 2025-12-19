package
{
   import flash.display.*;
   
   public class BunnyFieldHutch extends Sprite implements IInteractiveObject
   {
      
      public var s_doors:MovieClip;
      
      public var m_yDepth:int;
      
      public function BunnyFieldHutch()
      {
         super();
         trace("BunnyFieldHutch Constructor");
         this.cacheAsBitmap = true;
         this.s_doors.gotoAndStop("close");
         this.m_yDepth = 0;
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_SOLID;
      }
      
      public function openDoors(param1:Boolean) : void
      {
         if(param1)
         {
            this.s_doors.gotoAndStop("open");
         }
         else
         {
            this.s_doors.gotoAndStop("close");
         }
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
         if(param1 <= 0)
         {
         }
      }
   }
}

