package
{
   import flash.display.Sprite;
   
   public class EffectsContainerNightMask extends Sprite
   {
      
      public function EffectsContainerNightMask()
      {
         super();
         trace("EffectsContainerNightMask Constructor");
         this.alpha = 0;
         visible = false;
         mouseEnabled = false;
         mouseChildren = false;
         cacheAsBitmap = true;
      }
      
      public function setNightMask(param1:Number, param2:Number = 0) : void
      {
         if(param1 == 0)
         {
            this.visible = false;
         }
         else
         {
            this.visible = true;
            if(param2 == 0)
            {
               this.alpha = param1 * SceneRoot.EFFECTS_LAYER_NIGHT_MASK_ALPHA;
            }
            else
            {
               this.alpha = param1 * param2;
            }
         }
      }
   }
}

