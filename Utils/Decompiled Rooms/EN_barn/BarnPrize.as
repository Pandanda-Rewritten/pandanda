package
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   
   public class BarnPrize extends MovieClip
   {
      
      public function BarnPrize()
      {
         super();
         gotoAndStop(1);
         this.mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener,false,0,true);
         addEventListener(MouseEvent.CLICK,onMouseClickListener,false,0,true);
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener);
         removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener);
         removeEventListener(MouseEvent.CLICK,onMouseClickListener);
      }
      
      internal function onMouseOutListener(param1:MouseEvent) : void
      {
         gotoAndPlay("off");
      }
      
      internal function onMouseOverListener(param1:MouseEvent) : void
      {
         gotoAndPlay("over");
      }
      
      internal function onMouseClickListener(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         _loc2_ = new Object();
         _loc2_.itemId = "C507c";
         dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_ADD_SECRET_ITEM,_loc2_));
      }
   }
}

