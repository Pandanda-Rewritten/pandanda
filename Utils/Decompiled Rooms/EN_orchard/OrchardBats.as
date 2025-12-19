package
{
   import flash.display.*;
   
   public class OrchardBats extends MovieClip
   {
      
      public function OrchardBats()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function playBats() : void
      {
         this.gotoAndPlay(1);
      }
      
      public function isActive() : Boolean
      {
         return this.currentFrame != 1;
      }
   }
}

