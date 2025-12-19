package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   internal interface IAvatarPaperDoll
   {
      
      function setColor(param1:int) : void;
      
      function getMount() : MovieClip;
      
      function getBackground() : MovieClip;
      
      function setClothing(param1:Array) : Array;
      
      function clearMount() : void;
      
      function setBackground(param1:Sprite) : void;
      
      function setAnimations(param1:Boolean) : void;
      
      function setBackgroundColor(param1:int) : void;
      
      function getAvatar() : MovieClip;
      
      function setMount(param1:Sprite) : void;
      
      function destroy() : void;
      
      function clearBackground() : void;
      
      function hideMount(param1:Boolean) : void;
      
      function hideBackground(param1:Boolean) : void;
   }
}

