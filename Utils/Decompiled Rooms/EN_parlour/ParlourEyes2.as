package
{
   import flash.display.MovieClip;
   
   public class ParlourEyes2 extends MovieClip
   {
      
      public function ParlourEyes2()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function isActive() : Boolean
      {
         return this.currentFrame != 1;
      }
      
      public function playShiftingEyes() : void
      {
         this.gotoAndPlay(1);
      }
   }
}

