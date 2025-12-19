package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class ForestScene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.67;
      
      private static const DEBUG:* = 0;
      
      private var m_lights:ForestLights;
      
      public var s_exitToTreehouse:Sprite;
      
      private var m_centerFern:ForestCenterFern;
      
      private var m_rightTree:ForestRightTree;
      
      public var s_exitLeft:Sprite;
      
      public var direction_left:SimpleButton;
      
      public var s_exitRight:Sprite;
      
      public var forest_mc:Sprite;
      
      public var direction_right:SimpleButton;
      
      public var s_exitBack:Sprite;
      
      private var m_leftFern:ForestLeftFern;
      
      private var m_avatarScaleLimits:Array;
      
      public var direction_back:SimpleButton;
      
      private var m_spawnPoint:Point;
      
      public function ForestScene()
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("ForestScene Constructor");
         m_spawnPoint = new Point(465,450);
         m_avatarScaleLimits = new Array(0.65,1);
         forest_mc.mouseEnabled = false;
         forest_mc.cacheAsBitmap = true;
         s_exitLeft.visible = false;
         s_exitRight.visible = false;
         s_exitBack.visible = false;
         s_exitToTreehouse.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         m_effectsContainerNightMask = new ForestNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         m_centerFern = new ForestCenterFern();
         m_centerFern.x = 676;
         m_centerFern.y = 287;
         m_centerFern.width = 131;
         m_centerFern.height = 117;
         m_centerFern.setYDepth(387);
         m_leftFern = new ForestLeftFern();
         m_leftFern.x = 0;
         m_leftFern.y = 412;
         m_leftFern.width = 160;
         m_leftFern.height = 188;
         m_leftFern.setYDepth(592);
         m_rightTree = new ForestRightTree();
         m_rightTree.x = 790;
         m_rightTree.y = 325;
         m_rightTree.width = 146;
         m_rightTree.height = 275;
         m_rightTree.setYDepth(645);
         m_lights = new ForestLights();
         m_lights.x = 199;
         m_lights.y = 40;
         m_lights.width = 373;
         m_lights.height = 107;
         m_lights.setYDepth(240);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_centerFern);
         m_sceneObjects.push(m_leftFern);
         m_sceneObjects.push(m_rightTree);
         m_sceneObjects.push(m_lights);
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
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_MUSHROOM);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_GEM);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_TREASURE);
         if(DEBUG)
         {
            _loc2_ = new Sprite();
            addChild(_loc2_);
            getSceneObjects(_loc2_);
            addEventListener(Event.ENTER_FRAME,updateFrame,false,0,true);
         }
      }
      
      override public function destroy() : void
      {
         m_centerFern = null;
         m_leftFern = null;
         m_rightTree = null;
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
               break;
            case SCENE_TIME_NIGHT:
               updateFireflies();
               break;
            case SCENE_TIME_MORNING:
         }
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(s_exitLeft.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_TOWN_SQUARE;
         }
         if(s_exitRight.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_HARVEST_GROVE;
         }
         if(s_exitBack.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_GRAVEYARD;
         }
         if(s_exitToTreehouse.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_TREEHOUSE;
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
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(s_exitLeft.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitRight.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitBack.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitToTreehouse.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

