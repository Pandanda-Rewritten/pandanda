package
{
   import flash.display.*;
   
   public class OrchardSpider extends MovieClip
   {
      
      public function OrchardSpider()
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

