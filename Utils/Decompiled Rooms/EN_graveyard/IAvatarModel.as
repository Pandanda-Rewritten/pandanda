package
{
   import flash.display.Sprite;
   
   internal interface IAvatarModel
   {
      
      function setAnimation(param1:String, param2:int = -1, param3:Boolean = false) : void;
      
      function getWalkSpeed() : Number;
      
      function update() : void;
      
      function setAnimationYOffset(param1:int) : void;
      
      function isHit(param1:Number, param2:Number) : Boolean;
      
      function isSitting() : Boolean;
      
      function rotateColor(param1:Boolean) : void;
      
      function setClothing(param1:Array) : void;
      
      function setTransparency(param1:Number) : void;
      
      function getBusyBubble() : IBusyBubble;
      
      function setWaterCoverage(param1:int) : void;
      
      function setPulse(param1:Boolean, param2:uint = 0) : void;
      
      function setColor(param1:uint) : void;
      
      function getColorIndex() : int;
      
      function isDancing() : Boolean;
      
      function getHitZone() : Sprite;
      
      function isJumping() : Boolean;
      
      function setSizeMulitplier(param1:Number) : void;
      
      function getNPCIcons() : INPCIcons;
      
      function setScaleMultiplier(param1:Number) : void;
      
      function setColorIndex(param1:int) : void;
      
      function isSleeping() : Boolean;
      
      function destroy() : void;
      
      function getMessageBubble() : IMessageBubble;
   }
}

