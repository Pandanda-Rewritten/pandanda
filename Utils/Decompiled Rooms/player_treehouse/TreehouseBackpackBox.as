package
{
   import flash.display.*;
   
   public class TreehouseBackpackBox extends MovieClip
   {
      
      public function TreehouseBackpackBox(param1:Number, param2:Number)
      {
         super();
         gotoAndStop("off");
         this.mouseChildren = false;
         this.x = param1;
         this.y = param2;
      }
      
      public function destroy() : void
      {
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
   }
}

