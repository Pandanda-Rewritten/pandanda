package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   internal interface IGameItemsDoc
   {
      
      function getFishingCollectionAnimation() : MovieClip;
      
      function getBackpackSellList(param1:Array) : Array;
      
      function getBackpackItem(param1:String) : Sprite;
      
      function destroy() : void;
      
      function getFishList(param1:int, param2:String) : Array;
      
      function getItemListFromCategoryList(param1:Array, param2:int = -1) : Array;
      
      function getAward(param1:String) : IGameAward;
   }
}

