package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   internal interface IAvatarDoc
   {
      
      function getAvatarColorArray(param1:String) : Array;
      
      function getAvatarPaperDoll() : IAvatarPaperDoll;
      
      function getAvatarModel(param1:String) : IAvatarModel;
      
      function getModeratorSymbol() : Sprite;
      
      function getMountItem(param1:String) : IGameItem;
      
      function getSafeChatSymbol() : MovieClip;
      
      function getLevelUpAnimation(param1:int) : MovieClip;
      
      function getMagicEffectMC(param1:int) : MovieClip;
   }
}

