package
{
   import flash.display.MovieClip;
   
   public class ParlourEyes1 extends MovieClip
   {
      
      public function ParlourEyes1()
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

