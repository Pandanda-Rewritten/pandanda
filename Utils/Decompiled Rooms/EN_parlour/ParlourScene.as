package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class ParlourScene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.75;
      
      private static const DEBUG:* = 0;
      
      public var s_exitToDarkRoom:Sprite;
      
      private var m_blueChairRight:ParlourBlueChairRight;
      
      public var s_exitToGraveyard:Sprite;
      
      private var m_fire:ParlourFire;
      
      public var s_kingEyes:ParlourEyes2;
      
      private var m_blueChairLeft:ParlourBlueChairLeft;
      
      public var s_candleButton:ParlourCandleButton;
      
      public var parlour_mc:Sprite;
      
      public var s_eyes2:ParlourEyes1;
      
      public var s_stealFruit:ParlourStealFruit;
      
      public var s_eyes1:ParlourEyes1;
      
      private var m_couch:ParlourCouch;
      
      private var m_redChairLeft:ParlourRedChairLeft;
      
      private var m_redChairRight:ParlourRedChairRight;
      
      private var m_table:ParlourTable;
      
      private var m_fireFrame:ParlourFireFrame;
      
      public var s_exitToLibrary:Sprite;
      
      private var m_avatarScaleLimits:Array;
      
      public var s_secretDoor:ParlourSecretDoorButton;
      
      private var m_spawnPoint:Point;
      
      public var s_lightning:ParlourLightning;
      
      public function ParlourScene()
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("ParlourScene Constructor");
         m_spawnPoint = new Point(120,484);
         m_avatarScaleLimits = new Array(0.7,1);
         parlour_mc.mouseEnabled = false;
         parlour_mc.cacheAsBitmap = true;
         s_exitToGraveyard.visible = false;
         s_exitToLibrary.visible = false;
         s_exitToDarkRoom.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         s_lightning.gotoAndStop(1);
         s_eyes1.gotoAndStop(1);
         s_eyes2.gotoAndStop(1);
         s_kingEyes.gotoAndStop(1);
         s_stealFruit.gotoAndStop(1);
         m_redChairLeft = new ParlourRedChairLeft();
         m_redChairLeft.x = 27;
         m_redChairLeft.y = 292;
         m_redChairLeft.width = 80;
         m_redChairLeft.height = 94;
         m_redChairLeft.setYDepth(342);
         m_redChairRight = new ParlourRedChairRight();
         m_redChairRight.x = 116;
         m_redChairRight.y = 283;
         m_redChairRight.width = 62;
         m_redChairRight.height = 86;
         m_redChairRight.setYDepth(329);
         m_blueChairLeft = new ParlourBlueChairLeft();
         m_blueChairLeft.x = 262;
         m_blueChairLeft.y = 304;
         m_blueChairLeft.width = 77;
         m_blueChairLeft.height = 108;
         m_blueChairLeft.setYDepth(352);
         m_blueChairRight = new ParlourBlueChairRight();
         m_blueChairRight.x = 475;
         m_blueChairRight.y = 301;
         m_blueChairRight.width = 77;
         m_blueChairRight.height = 108;
         m_blueChairRight.setYDepth(349);
         m_table = new ParlourTable();
         m_table.x = 77;
         m_table.y = 326;
         m_table.width = 87;
         m_table.height = 76;
         m_table.setYDepth(392);
         m_couch = new ParlourCouch();
         m_couch.x = 295;
         m_couch.y = 395;
         m_couch.width = 223;
         m_couch.height = 99;
         m_couch.setYDepth(464);
         m_fireFrame = new ParlourFireFrame();
         m_fireFrame.x = 320;
         m_fireFrame.y = 198;
         m_fireFrame.width = 219;
         m_fireFrame.height = 126;
         m_fireFrame.setYDepth(318);
         m_fire = new ParlourFire();
         m_fire.x = 396;
         m_fire.y = 249;
         m_fire.width = 66;
         m_fire.height = 71;
         m_fire.setYDepth(315);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_redChairLeft);
         m_sceneObjects.push(m_redChairRight);
         m_sceneObjects.push(m_blueChairLeft);
         m_sceneObjects.push(m_blueChairRight);
         m_sceneObjects.push(m_table);
         m_sceneObjects.push(m_couch);
         m_sceneObjects.push(m_fireFrame);
         m_sceneObjects.push(m_fire);
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
         s_secretDoor.destroy();
         s_candleButton.destroy();
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
      
      public function getAvatarSpawnPoint() : Point
      {
         return m_spawnPoint;
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return m_avatarScaleLimits;
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
         s_candleButton.update();
         if(Math.random() * 1000 < 2)
         {
            if(!s_lightning.isActive())
            {
               s_lightning.playLightning();
            }
         }
         if(Math.random() * 1000 < 2)
         {
            if(!s_eyes1.isActive())
            {
               s_eyes1.playBlinkingEyes();
            }
         }
         if(Math.random() * 1000 < 2)
         {
            if(!s_eyes2.isActive())
            {
               s_eyes2.playBlinkingEyes();
            }
         }
         if(Math.random() * 1000 < 2)
         {
            if(!s_kingEyes.isActive())
            {
               s_kingEyes.playShiftingEyes();
            }
         }
         if(Math.random() * 1000 < 1.5)
         {
            if(!s_stealFruit.isActive())
            {
               s_stealFruit.playStealFruit();
            }
         }
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
         if(s_exitToGraveyard.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_GRAVEYARD;
         }
         if(s_exitToLibrary.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_LIBRARY;
         }
         if(s_exitToDarkRoom.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_DARK_ROOM;
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
         return new String();
      }
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(s_exitToGraveyard.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitToLibrary.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitToDarkRoom.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

