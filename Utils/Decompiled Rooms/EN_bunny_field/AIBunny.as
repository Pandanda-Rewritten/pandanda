package
{
   import flash.display.*;
   import flash.text.*;
   
   public class AIBunny extends Avatar
   {
      
      internal static const FADE_COUNTER:int = 40;
      
      internal var m_isActive:Boolean;
      
      internal var m_index:int;
      
      internal var m_fadeCount:int;
      
      internal var m_textStyle:TextFormat;
      
      internal var m_isFading:Boolean;
      
      internal var m_scoreText:TextField;
      
      internal var m_isFadingComplete:Boolean;
      
      public function AIBunny(param1:int, param2:int, param3:int)
      {
         super(AvatarModels.AVATAR_MODEL_BUNNY);
         jumpTo(param1,param2);
         this.m_index = param3;
         if(this.m_index != 0)
         {
            if(this.m_index != 1)
            {
               setColorIndex(AvatarColors.BUNNY_COLOR_GREY_INDEX);
            }
            else
            {
               setColorIndex(AvatarColors.BUNNY_COLOR_BROWN_INDEX);
            }
         }
         else
         {
            setColorIndex(AvatarColors.BUNNY_COLOR_WHITE_INDEX);
         }
         this.m_scoreText = new TextField();
         this.m_scoreText.selectable = false;
         this.m_scoreText.width = 40;
         this.m_scoreText.height = 40;
         this.m_scoreText.x = -20;
         this.m_scoreText.y = -25;
         this.m_scoreText.antiAliasType = AntiAliasType.ADVANCED;
         this.m_scoreText.embedFonts = true;
         this.m_textStyle = new TextFormat("arial",22,16777032,true);
         this.m_textStyle.align = TextFormatAlign.CENTER;
         this.m_isActive = false;
         this.m_isFading = false;
         this.m_isFadingComplete = false;
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
      
      public function setPulse(param1:Boolean) : void
      {
         getModel().setPulse(param1,16777032);
      }
      
      public function update() : void
      {
         var _loc2_:* = undefined;
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
            if(this.m_fadeCount < FADE_COUNTER - 10)
            {
               loc3 = (_loc2_ = this.m_scoreText).y - 1;
               _loc2_.y = loc3;
               this.m_scoreText.alpha -= 0.06;
               this.m_scoreText.text = BunnyFieldScene.BUNNY_POINTS[this.m_index];
               this.m_scoreText.setTextFormat(this.m_textStyle);
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
         return InteractiveObjectType.IOBJECT_BUNNY;
      }
      
      public function getIndex() : int
      {
         return this.m_index;
      }
      
      public function setFade() : void
      {
         this.setPulse(false);
         this.m_isActive = false;
         this.m_isFading = true;
         this.m_isFadingComplete = false;
         this.m_fadeCount = FADE_COUNTER;
         stopWalking();
         this.m_scoreText.text = BunnyFieldScene.BUNNY_POINTS[this.m_index];
         this.m_scoreText.setTextFormat(this.m_textStyle);
         addChild(this.m_scoreText);
      }
   }
}

