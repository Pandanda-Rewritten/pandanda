package
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   
   public class ParlourCandleButton extends MovieClip
   {
      
      public function ParlourCandleButton()
      {
         super();
         gotoAndStop(0);
         this.mouseChildren = false;
         addEventListener(MouseEvent.CLICK,onMouseClickListener,false,0,true);
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.CLICK,onMouseClickListener);
      }
      
      public function update() : void
      {
         var _loc1_:Object = null;
         if(this.currentFrame == this.totalFrames)
         {
            _loc1_ = new Object();
            _loc1_.itemId = "BG142";
            dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_ADD_SECRET_ITEM,_loc1_));
            gotoAndStop(1);
         }
      }
      
      private function onMouseClickListener(param1:MouseEvent) : void
      {
         gotoAndPlay("over");
      }
   }
}

