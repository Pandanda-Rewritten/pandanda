package
{
   import flash.display.MovieClip;
   
   public class ParlourStealFruit extends MovieClip
   {
      
      public function ParlourStealFruit()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function playStealFruit() : void
      {
         this.gotoAndPlay(1);
      }
      
      public function isActive() : Boolean
      {
         return this.currentFrame > 1 && this.currentFrame < this.totalFrames - 1;
      }
   }
}

