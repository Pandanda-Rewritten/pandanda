package
{
   internal interface IMailItem
   {
      
      function getType() : String;
      
      function destroy() : void;
      
      function getSender() : String;
   }
}

