package
{
   import flash.geom.Point;
   
   internal interface IAvatarPanda
   {
      
      function setHandAnimation(param1:String) : void;
      
      function setHandHeldObject(param1:IHandHeldObject) : void;
      
      function setGhostPack(param1:Boolean) : void;
      
      function setFishing(param1:Point, param2:Boolean = false) : void;
      
      function setHoldNet(param1:Boolean) : void;
      
      function clearFishing() : void;
   }
}

