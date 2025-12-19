package
{
   import flash.display.*;
   
   public class TreehouseBackpackBoxMask extends Sprite
   {
      
      public function TreehouseBackpackBoxMask()
      {
         super();
         visible = false;
         mouseEnabled = false;
         mouseChildren = false;
         this.mouseChildren = false;
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

