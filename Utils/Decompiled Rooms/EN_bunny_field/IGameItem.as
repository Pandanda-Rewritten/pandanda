package
{
   import flash.display.Sprite;
   
   internal interface IGameItem
   {
      
      function getCollectionText() : String;
      
      function getName() : String;
      
      function getSortGroup() : String;
      
      function getId() : String;
      
      function destroy() : void;
      
      function getSprite() : Sprite;
      
      function setId(param1:String) : void;
      
      function getStorageType() : String;
   }
}

