package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class TreeHouseScene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.75;
      
      private static const DEBUG:* = 0;
      
      public var s_exitToForest:Sprite;
      
      private var m_chairBack:TreeHouseChairBack;
      
      public var s_gameTable1:MiniGameHotSpot;
      
      public var s_gameTable3:MiniGameHotSpot;
      
      public var s_gameTable2:MiniGameHotSpot;
      
      private var m_cubby:TreeHouseCubby;
      
      public var treehouse_mc:Sprite;
      
      private var m_linefour1:TreeHouseLineFour1;
      
      private var m_linefour2:TreeHouseLineFour2;
      
      private var m_chairFront:TreeHouseChairFront;
      
      private var m_avatarScaleLimits:Array;
      
      public var s_exitToTreehouses:Sprite;
      
      private var m_spawnPoint:Point;
      
      public function TreeHouseScene()
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("TreeHouseScene Constructor");
         m_spawnPoint = new Point(465,450);
         m_avatarScaleLimits = new Array(0.8,1.1);
         treehouse_mc.mouseEnabled = false;
         treehouse_mc.cacheAsBitmap = true;
         s_exitToTreehouses.visible = false;
         s_exitToForest.visible = false;
         m_chairBack = new TreeHouseChairBack();
         m_chairBack.x = 327;
         m_chairBack.y = 4;
         m_chairBack.width = 69;
         m_chairBack.height = 357;
         m_chairBack.setYDepth(326);
         m_chairFront = new TreeHouseChairFront();
         m_chairFront.x = 328;
         m_chairFront.y = 267;
         m_chairFront.width = 83;
         m_chairFront.height = 97;
         m_chairFront.setYDepth(342);
         m_cubby = new TreeHouseCubby();
         m_cubby.x = 532;
         m_cubby.y = 163;
         m_cubby.width = 154;
         m_cubby.height = 178;
         m_cubby.setYDepth(298);
         m_linefour1 = new TreeHouseLineFour1();
         m_linefour1.x = 204;
         m_linefour1.y = 460;
         m_linefour1.width = 57;
         m_linefour1.height = 56;
         m_linefour1.setYDepth(507);
         m_linefour2 = new TreeHouseLineFour2();
         m_linefour2.x = 587;
         m_linefour2.y = 473;
         m_linefour2.width = 57;
         m_linefour2.height = 56;
         m_linefour2.setYDepth(520);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_chairFront);
         m_sceneObjects.push(m_chairBack);
         m_sceneObjects.push(m_cubby);
         m_sceneObjects.push(m_linefour1);
         m_sceneObjects.push(m_linefour2);
         m_sceneObjects.push(s_gameTable1);
         m_sceneObjects.push(s_gameTable2);
         m_sceneObjects.push(s_gameTable3);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         updateSceneTime();
         if(DEBUG)
         {
            _loc2_ = new Sprite();
            addChild(_loc2_);
            getSceneObjects(_loc2_);
            addEventListener(Event.ENTER_FRAME,updateFrame,false,0,true);
            _loc2_ = new Sprite();
            setEffectsContainer(_loc2_);
            addChild(_loc2_);
         }
      }
      
      override public function destroy() : void
      {
         m_sceneObjects.length = 0;
         if(m_effectsContainer)
         {
            while(m_effectsContainer.numChildren > 0)
            {
               m_effectsContainer.removeChildAt(0);
            }
         }
         m_effectsContainer = null;
         super.destroy();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      private function updateFrame(param1:Event) : void
      {
         updateScene();
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return m_avatarScaleLimits;
      }
      
      public function getAvatarSpawnPoint() : Point
      {
         return m_spawnPoint;
      }
      
      override public function setSceneTime(param1:int, param2:Boolean = false) : void
      {
         super.setSceneTime(param1,param2);
         switch(m_sceneTime)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         switch(m_sceneTime)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(s_exitToTreehouses.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_TREEHOUSE_LOBBY;
         }
         if(s_exitToForest.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_FOREST;
         }
         return null;
      }
      
      public function getSceneObjects(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < m_sceneObjects.length)
         {
            if(m_sceneObjects[_loc2_])
            {
               param1.addChild(m_sceneObjects[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      override public function getMiniGameId() : String
      {
         if(s_gameTable1.hitTestPoint(mouseX,mouseY,true))
         {
            return "MG005d";
         }
         if(s_gameTable2.hitTestPoint(mouseX,mouseY,true))
         {
            return "MG005e";
         }
         if(s_gameTable3.hitTestPoint(mouseX,mouseY,true))
         {
            return "MG004d";
         }
         return new String();
      }
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(s_exitToTreehouses.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitToForest.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

