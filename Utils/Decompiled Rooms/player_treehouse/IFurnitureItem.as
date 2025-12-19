package
{
   import flash.display.Sprite;
   
   internal interface IFurnitureItem
   {
      
      function rotateSprite(param1:Boolean) : void;
      
      function getSpriteHeight() : int;
      
      function destroy() : void;
      
      function getWallIndex() : int;
      
      function getSpriteWidth() : int;
      
      function setWall(param1:int) : void;
      
      function getId() : String;
      
      function setSpriteIndex(param1:int) : void;
      
      function getCategory() : String;
      
      function setGlow(param1:Boolean) : void;
      
      function getSpriteIndex() : int;
      
      function getAttachment() : String;
      
      function getColorList() : Array;
      
      function getSprite() : Sprite;
      
      function setId(param1:String) : void;
   }
}

