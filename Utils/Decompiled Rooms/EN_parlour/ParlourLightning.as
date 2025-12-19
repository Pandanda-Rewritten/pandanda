package
{
   import flash.display.MovieClip;
   
   public class ParlourLightning extends MovieClip
   {
      
      public function ParlourLightning()
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
      
      public function playLightning() : void
      {
         this.gotoAndPlay(1);
         GameSound.getInstance().playSoundEffect(0);
      }
   }
}

