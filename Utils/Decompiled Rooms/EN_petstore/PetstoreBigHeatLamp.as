package
{
   import flash.display.MovieClip;
   
   public class PetstoreBigHeatLamp extends MovieClip
   {
      
      public function PetstoreBigHeatLamp()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function playBigHeatLamp() : void
      {
         this.gotoAndPlay(1);
      }
      
      public function isActive() : Boolean
      {
         return this.currentFrame != 1;
      }
   }
}

