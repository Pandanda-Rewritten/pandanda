package
{
   import flash.display.Sprite;
   
   internal interface IFurnitureItemsDoc
   {
      
      function destroy() : void;
      
      function getBackpackSprite(param1:String) : Sprite;
      
      function getFurnitureItem(param1:String) : IFurnitureItem;
   }
}

