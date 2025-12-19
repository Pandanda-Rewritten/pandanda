package
{
   internal interface IBackpackItem
   {
      
      function getName() : String;
      
      function isUsable() : Boolean;
      
      function getSellCategory() : String;
      
      function isCombinable() : Boolean;
      
      function isQuestItem() : Boolean;
      
      function getCollectionText() : String;
      
      function getId() : String;
      
      function getActionButtonText() : String;
      
      function getCategory() : String;
      
      function getCombineText() : String;
      
      function getCombinesWithIds() : String;
      
      function destroy() : void;
      
      function setId(param1:String) : void;
   }
}

