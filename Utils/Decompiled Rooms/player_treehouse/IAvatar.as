package
{
   import flash.display.Sprite;
   
   internal interface IAvatar
   {
      
      function setScaleLimits(param1:Array) : void;
      
      function getPaperDoll() : IAvatarPaperDoll;
      
      function updateAvatar() : void;
      
      function setAvatarName(param1:String, param2:Boolean = false) : void;
      
      function getHitZone() : Sprite;
      
      function setAvatarScale(param1:Number) : void;
      
      function getName() : String;
      
      function getPortrait() : IAvatar;
      
      function destroy() : void;
      
      function resetNameLayer() : void;
      
      function isCelebrity() : Boolean;
      
      function getAvatarModel() : Sprite;
      
      function isModerator() : Boolean;
   }
}

