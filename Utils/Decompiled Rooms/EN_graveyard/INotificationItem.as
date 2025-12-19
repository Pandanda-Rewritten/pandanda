package
{
   internal interface INotificationItem
   {
      
      function getType() : String;
      
      function getMessage() : String;
      
      function destroy() : void;
   }
}

