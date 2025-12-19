package
{
   import flash.display.Sprite;
   
   public class StonehengeFlame extends Sprite implements IInteractiveObject
   {
      
      public var m_yDepth:int;
      
      public function StonehengeFlame()
      {
         super();
         trace("StonehengeFlame Constructor");
         this.cacheAsBitmap = true;
         this.visible = false;
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
         if(param1 == 0)
         {
            this.visible = false;
         }
         if(param1 > 0)
         {
            this.visible = true;
         }
      }
   }
}

