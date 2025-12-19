package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class VillageScene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.6;
      
      internal static const DEBUG:int = 0;
      
      public var village_mc:Sprite;
      
      public var s_bats1:VillageFlyingBats;
      
      internal var m_pumpkinsRight:VillagePumpkinsRight;
      
      public var s_bats:VillageFlyingBats;
      
      internal var m_pumpkinlights1:VillagePumpkinLights1;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_vines:VillageVines;
      
      internal var m_spawnPoint:Point;
      
      public var st_Village:Sprite;
      
      internal var m_pumpkinlights:VillagePumpkinLights;
      
      internal var m_pumpkinsLeft:VillagePumpkinsLeft;
      
      public function VillageScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         trace("VillageScene Constructor");
         m_spawnPoint = new Point(465,450);
         m_avatarScaleLimits = new Array(0.6,1);
         village_mc.mouseEnabled = false;
         st_Village.visible = false;
         village_mc.cacheAsBitmap = true;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         s_bats.gotoAndStop(1);
         s_bats1.gotoAndStop(1);
         m_effectsContainerNightMask = new VillageNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 14;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         m_pumpkinlights = new VillagePumpkinLights();
         m_pumpkinlights.x = 60;
         m_pumpkinlights.y = 71;
         m_pumpkinlights.width = 308;
         m_pumpkinlights.height = 111;
         m_pumpkinlights.setYDepth(173);
         m_pumpkinlights1 = new VillagePumpkinLights1();
         m_pumpkinlights1.x = 621;
         m_pumpkinlights1.y = 116;
         m_pumpkinlights1.width = 127;
         m_pumpkinlights1.height = 59;
         m_pumpkinlights1.setYDepth(175);
         m_vines = new VillageVines();
         m_vines.x = 109;
         m_vines.y = 224;
         m_vines.width = 245;
         m_vines.height = 160;
         m_vines.setYDepth(384);
         m_pumpkinsRight = new VillagePumpkinsRight();
         m_pumpkinsRight.x = 685;
         m_pumpkinsRight.y = 461;
         m_pumpkinsRight.width = 252;
         m_pumpkinsRight.height = 153;
         m_pumpkinsRight.setYDepth(614);
         m_pumpkinsLeft = new VillagePumpkinsLeft();
         m_pumpkinsLeft.x = 0;
         m_pumpkinsLeft.y = 485;
         m_pumpkinsLeft.width = 218;
         m_pumpkinsLeft.height = 129;
         m_pumpkinsLeft.setYDepth(614);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_pumpkinlights);
         m_sceneObjects.push(m_pumpkinlights1);
         m_sceneObjects.push(m_vines);
         m_sceneObjects.push(m_pumpkinsRight);
         m_sceneObjects.push(m_pumpkinsLeft);
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
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_TRASH);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_FISH);
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
      
      override public function getSpawnPlaneSprite(param1:String) : Sprite
      {
         if(param1 == GameCollectableSpawnPlane.SPAWN_GROUND)
         {
            return s_spawnGround;
         }
         if(param1 == GameCollectableSpawnPlane.SPAWN_SALT_WATER)
         {
            return s_water;
         }
         trace("ERROR: override getSpawnPlaneSprite in this location!!");
         return null;
      }
      
      public function getAvatarSpawnPoint() : Point
      {
         return m_spawnPoint;
      }
      
      override public function updateScene() : void
      {
         var _loc1_:* = undefined;
         super.updateScene();
         _loc1_ = m_sceneTime;
         var _loc2_:* = _loc1_;
         var _loc3_:* = _loc2_;
         switch(_loc3_)
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
      
      internal function updateFrame(param1:Event) : void
      {
         updateScene();
      }
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            if(Boolean(s_water) && s_water.hitTestPoint(mouseX,mouseY,true))
            {
               return "fish";
            }
            return "none";
         }
         if(st_Village.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
      
      public function getSceneObjects(param1:Sprite) : void
      {
         var _loc2_:* = 0;
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
      
      override public function setSceneTime(param1:int, param2:Boolean = false) : void
      {
         super.setSceneTime(param1,param2);
         var _loc3_:* = m_sceneTime;
         var _loc4_:*;
         var _loc5_:* = _loc4_ = _loc3_;
         switch(_loc5_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return m_avatarScaleLimits;
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(st_Village.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_FISHING_HOLE;
         }
         return null;
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
   }
}

