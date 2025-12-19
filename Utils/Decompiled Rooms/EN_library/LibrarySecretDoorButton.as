package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class LibrarySecretDoorButton extends MovieClip
   {
      
      public function LibrarySecretDoorButton()
      {
         super();
         gotoAndStop(0);
         this.mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener,false,0,true);
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener);
         removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener);
      }
      
      private function onMouseOutListener(param1:MouseEvent) : void
      {
         gotoAndPlay("off");
      }
      
      private function onMouseOverListener(param1:MouseEvent) : void
      {
         gotoAndPlay("over");
      }
   }
}

