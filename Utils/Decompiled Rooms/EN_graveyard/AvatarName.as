package
{
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class AvatarName extends Sprite
   {
      
      internal var m_nameField2:TextField;
      
      internal var m_isCelebrity:Boolean;
      
      internal var m_hasBackground:Boolean;
      
      internal var m_isModerator:Boolean;
      
      internal var m_name:String;
      
      internal var m_textStyle:TextFormat;
      
      internal var m_shadow:DropShadowFilter;
      
      internal var m_safeSymbol:MovieClip;
      
      internal var m_nameField:TextField;
      
      internal var m_isSafeChat:Boolean;
      
      public function AvatarName(param1:String, param2:Boolean, param3:Boolean, param4:Boolean = false)
      {
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = 0;
         super();
         this.m_name = new String(param1);
         this.m_hasBackground = false;
         this.m_isModerator = param2;
         this.m_isCelebrity = param3;
         this.m_textStyle = new TextFormat("Verdana",12);
         this.m_textStyle.color = "0x17376E";
         this.m_textStyle.align = TextFormatAlign.CENTER;
         this.m_nameField = new TextField();
         _loc5_ = 0;
         if(param2)
         {
            this.m_textStyle.color = "0xE7E7E7";
            this.m_nameField = new TextField();
            this.m_nameField.autoSize = TextFieldAutoSize.CENTER;
            this.m_nameField.border = false;
            this.m_nameField.background = false;
            this.m_nameField.selectable = false;
            this.m_nameField.height = 12;
            this.m_nameField.multiline = true;
            this.m_nameField.text = this.m_name;
            if(!this.m_isCelebrity)
            {
               _loc5_ = this.m_nameField.width;
               this.m_nameField.appendText("\nModerator");
            }
            this.m_nameField.embedFonts = true;
            this.m_nameField.antiAliasType = AntiAliasType.ADVANCED;
            this.m_nameField.setTextFormat(this.m_textStyle);
            this.m_nameField.x = 0;
            this.m_nameField.y = 0;
            addChild(this.m_nameField);
            _loc6_ = new Shape();
            if(this.m_isCelebrity)
            {
               _loc6_.graphics.beginFill(3239120,0.85);
               _loc6_.graphics.drawRoundRect(-5,0,this.m_nameField.width + 10,20,16,16);
            }
            else
            {
               _loc7_ = AvatarModels.getInstance().getModeratorSymbol();
               _loc7_.y = 3;
               addChildAt(_loc7_,1);
               _loc8_ = _loc5_ - this.m_nameField.width + 29;
               if(_loc8_ > 0)
               {
                  this.m_nameField.x = _loc8_;
               }
               _loc6_.graphics.beginFill(7415689,0.85);
               _loc6_.graphics.drawRoundRect(-5,0,this.width + 10,35,16,16);
            }
            _loc6_.graphics.endFill();
            _loc6_.y = this.m_nameField.y;
            addChildAt(_loc6_,0);
         }
         else
         {
            this.m_textStyle.align = TextFormatAlign.CENTER;
            this.m_nameField.autoSize = TextFieldAutoSize.CENTER;
            this.m_nameField.border = false;
            this.m_nameField.background = false;
            this.m_nameField.selectable = false;
            this.m_nameField.height = 12;
            this.m_nameField.text = this.m_name;
            this.m_nameField.embedFonts = true;
            this.m_nameField.antiAliasType = AntiAliasType.ADVANCED;
            this.m_nameField.setTextFormat(this.m_textStyle);
            this.m_nameField.x = 0;
            this.m_nameField.y = 0;
            addChild(this.m_nameField);
         }
         this.m_isSafeChat = param4;
         if(this.m_isSafeChat)
         {
            this.m_safeSymbol = AvatarModels.getInstance().getSafeChatSymbol();
            this.m_safeSymbol.y = 5;
            addChildAt(this.m_safeSymbol,0);
            this.m_nameField.x = 13;
         }
         this.cacheAsBitmap = true;
      }
      
      public function getName() : String
      {
         return this.m_name;
      }
      
      public function setName(param1:String) : void
      {
         this.m_name = param1;
         this.m_nameField.text = this.m_name;
      }
      
      public function setBackground(param1:Boolean) : void
      {
         var _loc2_:* = null;
         if(this.m_isModerator)
         {
            return;
         }
         if(param1)
         {
            this.m_textStyle.color = "0xE7E7E7";
            if(GameConstants.ACTIVE_FESTIVAL == GameConstants.PUMPKIN_FESTIVAL)
            {
               this.m_textStyle.color = "0xFF6701";
            }
            this.m_nameField.text = this.m_name;
            this.m_nameField.setTextFormat(this.m_textStyle);
            this.m_nameField.filters = null;
            if(this.m_safeSymbol)
            {
               this.m_safeSymbol.setHighlight(true);
            }
            _loc2_ = new Shape();
            _loc2_.graphics.beginFill(3239120,0.85);
            if(GameConstants.ACTIVE_FESTIVAL == GameConstants.PUMPKIN_FESTIVAL)
            {
               _loc2_.graphics.beginFill(2631720,0.85);
            }
            _loc2_.graphics.drawRoundRect(-5,0,this.width + 10,this.m_nameField.height + 1,16,16);
            _loc2_.graphics.endFill();
            _loc2_.y = this.m_nameField.y;
            addChildAt(_loc2_,0);
         }
         else
         {
            if(numChildren > 1)
            {
               removeChildAt(0);
            }
            this.m_textStyle.color = "0x17376E";
            this.m_nameField.text = this.m_name;
            this.m_nameField.setTextFormat(this.m_textStyle);
            if(this.m_safeSymbol)
            {
               this.m_safeSymbol.setHighlight(false);
            }
         }
      }
      
      public function setPet() : void
      {
         this.m_textStyle = new TextFormat("Verdana",10);
         this.m_textStyle.color = "0x17376E";
         this.m_textStyle.align = TextFormatAlign.CENTER;
         this.m_textStyle.align = TextFormatAlign.CENTER;
         this.m_nameField.autoSize = TextFieldAutoSize.CENTER;
         this.m_nameField.border = false;
         this.m_nameField.background = false;
         this.m_nameField.selectable = false;
         this.m_nameField.height = 10;
         this.m_nameField.text = this.m_name;
         this.m_nameField.embedFonts = true;
         this.m_nameField.antiAliasType = AntiAliasType.ADVANCED;
         this.m_nameField.setTextFormat(this.m_textStyle);
         this.m_nameField.x = 0;
         this.m_nameField.y = 0;
         this.x = -this.width * 0.5;
         this.y = 8;
      }
      
      public function destroy() : void
      {
      }
   }
}

