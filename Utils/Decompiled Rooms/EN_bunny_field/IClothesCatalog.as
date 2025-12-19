package
{
   internal interface IClothesCatalog
   {
      
      function destroy() : void;
      
      function getItemColor(param1:String) : uint;
      
      function getGameItem(param1:String) : IGameItem;
   }
}

