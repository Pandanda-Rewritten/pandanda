package
{
   import flash.display.*;
   import flash.events.*;
   
   public class DragonContestHotSpot extends MovieClip
   {
      
      public function DragonContestHotSpot()
      {
         super();
         addEventListener(MouseEvent.CLICK,onClickListener,false,0,true);
      }
      
      private function onClickListener(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         _loc2_ = new Object();
         _loc2_.title = "Yea! You Found A Dragon.";
         _loc2_.msg = "You found one of Izzy\'s missing dragons. Remember the location and the color of the dragon to include in your contest entry. \n\nSee Henry\'s blog for contest details.";
         dispatchEvent(new GameEvent(GameEvent.EVENT_DISPLAY_GAME_MESSAGE_DIALOG,_loc2_));
         removeEventListener(MouseEvent.CLICK,onClickListener);
      }
   }
}

