package
{
   import flash.display.*;
   
   public class AISlime extends Avatar
   {
      
      internal static const FADE_COUNTER:int = 40;
      
      internal var m_isActive:Boolean;
      
      internal var m_fadeCount:int;
      
      internal var m_isFading:Boolean;
      
      internal var m_isFadingComplete:Boolean;
      
      public function AISlime(param1:int, param2:int)
      {
         super(AvatarModels.AVATAR_MODEL_GHOST2);
         jumpTo(param1,param2);
         this.m_isActive = false;
         this.m_isFading = false;
         this.m_isFadingComplete = false;
         getModel().setPulse(true,4688116);
      }
      
      public function setActive(param1:Boolean) : void
      {
         this.m_isActive = param1;
      }
      
      public function isFading() : Boolean
      {
         return this.m_isFading;
      }
      
      public function isFadeComplete() : Boolean
      {
         return this.m_isFadingComplete;
      }
      
      public function update() : void
      {
         var _loc1_:* = null;
         if(this.m_isFading)
         {
            --this.m_fadeCount;
            _loc1_ = Sprite(this.getModel());
            if(_loc1_.scaleY > 0)
            {
               if(_loc1_.scaleX > 0)
               {
                  _loc1_.scaleX -= 0.05;
               }
               else
               {
                  _loc1_.scaleX += 0.05;
               }
               _loc1_.scaleY -= 0.05;
            }
            else
            {
               _loc1_.visible = false;
            }
            if(this.m_fadeCount <= 0)
            {
               this.m_isFadingComplete = true;
               this.m_isFading = false;
            }
         }
         else
         {
            updateAvatar();
         }
      }
      
      public function isActive() : Boolean
      {
         return this.m_isActive;
      }
      
      override public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_SLIME;
      }
      
      public function setFade() : void
      {
         this.m_isActive = false;
         this.m_isFading = true;
         this.m_isFadingComplete = false;
         this.m_fadeCount = FADE_COUNTER;
      }
   }
}

