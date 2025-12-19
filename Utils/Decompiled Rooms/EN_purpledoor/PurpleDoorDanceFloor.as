package
{
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PurpleDoorDanceFloor extends Sprite implements IInteractiveObject
   {
      
      private static const SIGN_MAX_ALPHA:Number = 1;
      
      private static const MAX_PLATFORM_HEIGHT:int = 75;
      
      private static const PLATFORM_NONE:int = 0;
      
      private static const PLATFORM_RAISE:int = 1;
      
      private static const PLATFORM_LOWER:int = 2;
      
      private var m_animation:int;
      
      private var m_yOffset:int;
      
      public var s_platform:Sprite;
      
      public var m_yDepth:int;
      
      public function PurpleDoorDanceFloor()
      {
         super();
         trace("PurpleDoorDanceFloor Constructor");
         this.cacheAsBitmap = true;
         m_yDepth = 0;
         s_platform.cacheAsBitmap = true;
         m_yOffset = 0;
         m_animation = PLATFORM_NONE;
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SCENE_SOLID;
      }
      
      public function getHeight() : int
      {
         return this.localToGlobal(new Point(s_platform.x,s_platform.y)).y;
      }
      
      public function update() : void
      {
         if(m_animation == PLATFORM_RAISE)
         {
            ++m_yOffset;
            if(m_yOffset > MAX_PLATFORM_HEIGHT)
            {
               m_animation = PLATFORM_NONE;
               m_yOffset = MAX_PLATFORM_HEIGHT;
            }
            s_platform.y = -m_yOffset;
         }
         else if(m_animation == PLATFORM_LOWER)
         {
            --m_yOffset;
            if(m_yOffset <= 0)
            {
               m_animation = PLATFORM_NONE;
               m_yOffset = 0;
            }
            s_platform.y = -m_yOffset;
         }
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
      
      public function togglePlatform(param1:Boolean) : void
      {
         if(param1)
         {
            m_animation = PLATFORM_RAISE;
         }
         else
         {
            m_animation = PLATFORM_LOWER;
         }
      }
   }
}

