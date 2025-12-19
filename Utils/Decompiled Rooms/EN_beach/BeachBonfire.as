package
{
   import flash.display.*;
   
   public class BeachBonfire extends Sprite implements IInteractiveObject
   {
      
      public var m_flames:MovieClip;
      
      public var m_flames1:MovieClip;
      
      public var m_yDepth:int;
      
      public function BeachBonfire()
      {
         super();
         trace("BeachBonfire Constructor");
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
         if(param1 > 0)
         {
            m_flames.visible = true;
            addChildAt(m_flames,1);
            m_flames1.visible = true;
            addChildAt(m_flames1,1);
         }
         else
         {
            m_flames.visible = false;
            if(contains(m_flames))
            {
               removeChild(m_flames);
            }
            m_flames1.visible = false;
            if(contains(m_flames1))
            {
               removeChild(m_flames1);
            }
         }
      }
   }
}

