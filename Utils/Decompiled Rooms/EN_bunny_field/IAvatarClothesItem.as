package
{
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   internal interface IAvatarClothesItem
   {
      
      function stopAnimation() : void;
      
      function setColor(param1:uint) : void;
      
      function getPieceMC(param1:int) : Sprite;
      
      function getType() : String;
      
      function getSitColorTransform(param1:int) : ColorTransform;
      
      function playAnimation() : void;
      
      function doDrawBehindHand() : Boolean;
      
      function destroy() : void;
   }
}

