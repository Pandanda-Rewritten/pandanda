package
{
   import flash.display.*;
   
   public class GraveyardEyes extends MovieClip
   {
      
      public function GraveyardEyes()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function playBlinkingEyes() : void
      {
         this.gotoAndPlay(1);
      }
      
      public function isActive() : Boolean
      {
         return this.currentFrame != 1;
      }
   }
}

