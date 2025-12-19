package
{
   internal interface IMessageBubble
   {
      
      function isActive() : Boolean;
      
      function setMessageBubble(param1:int, param2:int, param3:String, param4:int, param5:Boolean = false, param6:Boolean = false) : void;
      
      function updateBubble() : void;
      
      function destroy() : void;
      
      function isModerator() : Boolean;
   }
}

