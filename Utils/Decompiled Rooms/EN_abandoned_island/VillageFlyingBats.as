package
{
   import flash.display.*;
   
   public class VillageFlyingBats extends MovieClip
   {
      
      public function VillageFlyingBats()
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

