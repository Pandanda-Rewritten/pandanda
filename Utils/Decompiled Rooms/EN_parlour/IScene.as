package
{
   import flash.display.Sprite;
   import flash.geom.Point;
   
   internal interface IScene
   {
      
      function isGroundHit(param1:Point, param2:Boolean = false) : Boolean;
      
      function updateScene() : void;
      
      function getAvatarSpawnPoint() : Point;
      
      function getBackpackItemCategoryList() : Array;
      
      function isWaterHit(param1:Point) : Boolean;
      
      function getName() : String;
      
      function isFishZoneHit(param1:Point) : Boolean;
      
      function setName(param1:String) : void;
      
      function init() : void;
      
      function setSceneXOffset(param1:int) : void;
      
      function getMiniGameId() : String;
      
      function serverExtensionResponse(param1:String, param2:Object) : void;
      
      function getSceneObjects(param1:Sprite) : void;
      
      function checkForExit(param1:Point) : String;
      
      function setEffectsContainer(param1:Sprite) : void;
      
      function setMouseClick(param1:Point, param2:Point = null) : void;
      
      function getAvatarWalkingPath(param1:Point, param2:Point) : Array;
      
      function isScrollable() : Boolean;
      
      function getAvatarScaleLimits() : Array;
      
      function getSceneXOffset() : int;
      
      function setSceneTime(param1:int, param2:Boolean = false) : void;
      
      function isTreehouse() : Boolean;
      
      function destroy() : void;
      
      function getSpawnPlaneSprite(param1:String) : Sprite;
      
      function getMouseCursorType() : String;
   }
}

