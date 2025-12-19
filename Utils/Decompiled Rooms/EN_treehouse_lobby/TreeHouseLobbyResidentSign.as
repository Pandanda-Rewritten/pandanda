package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TreeHouseLobbyResidentSign extends MovieClip
   {
      
      public var s_txtTop:TextField;
      
      public var s_txtMiddle:TextField;
      
      public function TreeHouseLobbyResidentSign()
      {
         var _loc1_:* = null;
         super();
         gotoAndStop(1);
         this.cacheAsBitmap = true;
         this.mouseChildren = false;
         _loc1_ = new TextFormat("arial",16);
         _loc1_.bold = true;
         _loc1_.align = TextFormatAlign.CENTER;
         s_txtTop.embedFonts = true;
         s_txtTop.text = "Pandanda Land Residents";
         s_txtTop.antiAliasType = AntiAliasType.ADVANCED;
         s_txtTop.setTextFormat(_loc1_);
         _loc1_ = new TextFormat("arial",14);
         _loc1_.bold = false;
         _loc1_.align = TextFormatAlign.CENTER;
         s_txtMiddle.embedFonts = true;
         s_txtMiddle.text = "Click here for a directory of member treehouses";
         s_txtMiddle.antiAliasType = AntiAliasType.ADVANCED;
         s_txtMiddle.setTextFormat(_loc1_);
         addEventListener(MouseEvent.ROLL_OVER,onRollOverListener,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,onRollOutListener,false,0,true);
         addEventListener(MouseEvent.CLICK,onMouseClickListener,false,0,true);
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,onRollOverListener);
         removeEventListener(MouseEvent.ROLL_OUT,onRollOutListener);
         removeEventListener(MouseEvent.CLICK,onMouseClickListener);
      }
      
      internal function onRollOutListener(param1:MouseEvent) : void
      {
         gotoAndStop("off");
      }
      
      internal function onRollOverListener(param1:MouseEvent) : void
      {
         gotoAndStop("over");
      }
      
      internal function onMouseClickListener(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CustomEvents.EVENT_SHOW_HOUSE_LIST_DIALOG,true));
      }
   }
}

