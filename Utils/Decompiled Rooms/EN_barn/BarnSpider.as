package
{
   import flash.display.*;
   
   public class BarnSpider extends MovieClip
   {
      
      public function BarnSpider()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function playSpider() : void
      {
         this.gotoAndPlay(1);
      }
      
      public function isActive() : Boolean
      {
         return this.currentFrame != 1;
      }
   }
}

