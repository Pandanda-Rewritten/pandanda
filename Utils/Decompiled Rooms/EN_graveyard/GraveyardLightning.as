package
{
   import flash.display.*;
   
   public class GraveyardLightning extends MovieClip
   {
      
      public function GraveyardLightning()
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

