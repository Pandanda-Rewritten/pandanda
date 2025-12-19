package
{
   internal interface IPet
   {
      
      function isEgg() : Boolean;
      
      function updatePetInfo(param1:IPet) : void;
      
      function doAction(param1:String) : void;
      
      function getPetIndex() : int;
      
      function getAge() : int;
      
      function setAge(param1:int) : void;
      
      function performActionAnimation(param1:String) : void;
      
      function getActions() : Array;
      
      function getAbilityLevel() : int;
      
      function isOnWalk() : Boolean;
      
      function getBirthday() : String;
      
      function getPetName() : String;
      
      function getStats() : String;
      
      function isFlying() : Boolean;
      
      function breatheFire() : void;
      
      function getOwner() : String;
      
      function setBirthday(param1:String) : void;
   }
}

