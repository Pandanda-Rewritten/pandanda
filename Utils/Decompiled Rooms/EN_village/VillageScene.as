package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class VillageScene extends SceneRoot implements IScene
   {
      
      internal static const DEBUG:int = 1;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.6;
      
      public var s_exitToParlour:Sprite;
      
      public var s_rightDirections:MovieClip;
      
      public var stg_exitToIceCream:Sprite;
      
      internal var m_clubSignCounter:int;
      
      public var s_exitToLibrary:Sprite;
      
      public var s_leftDirections:MovieClip;
      
      public var s_cone:MovieClip;
      
      internal var m_avatarScaleLimits:Array;
      
      public var stg_exitToGreen:Sprite;
      
      internal var m_sign:VillageSign;
      
      internal var m_fountain:VillageFountain;
      
      public var s_clubSign:MovieClip;
      
      internal var m_building:VillageBuilding;
      
      public var stg_exitToBlue:Sprite;
      
      internal var m_lamp1:VillageLampPost;
      
      internal var m_lamp2:VillageLampPost;
      
      internal var m_spawnPoint:Point;
      
      public var stg_clouds:MovieClip;
      
      public var village_mc:Sprite;
      
      public function VillageScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         trace("VillageScene Constructor");
         this.m_spawnPoint = new Point(465,450);
         this.m_avatarScaleLimits = new Array(0.6,1);
         this.village_mc.mouseEnabled = false;
         this.village_mc.cacheAsBitmap = true;
         this.stg_exitToBlue.visible = false;
         this.stg_exitToGreen.visible = false;
         this.stg_exitToIceCream.visible = false;
         this.stg_clouds.visible = true;
         this.s_exitToLibrary.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         s_windows.gotoAndStop(1);
         s_windows.cacheAsBitmap = true;
         m_effectsContainerNightMask = new VillageNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 14;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         this.m_lamp1 = new VillageLampPost();
         this.m_lamp1.x = 382;
         this.m_lamp1.y = 192;
         this.m_lamp1.width = 45;
         this.m_lamp1.height = 180;
         this.m_lamp1.setYDepth(367);
         this.m_lamp2 = new VillageLampPost();
         this.m_lamp2.x = 460;
         this.m_lamp2.y = 115;
         this.m_lamp2.width = 30;
         this.m_lamp2.height = 120;
         this.m_lamp2.setYDepth(230);
         this.m_fountain = new VillageFountain();
         this.m_fountain.x = 440;
         this.m_fountain.y = 465;
         this.m_fountain.width = 217;
         this.m_fountain.height = 145;
         this.m_fountain.setYDepth(520);
         this.m_building = new VillageBuilding();
         this.m_building.x = 309;
         this.m_building.y = 161;
         this.m_building.width = 42;
         this.m_building.height = 214;
         this.m_building.setYDepth(374);
         this.m_sign = new VillageSign();
         this.m_sign.x = 479;
         this.m_sign.y = 208;
         this.m_sign.width = 65;
         this.m_sign.height = 49;
         this.m_sign.setYDepth(240);
         m_sceneObjects = new Array();
         m_sceneObjects.push(this.m_lamp1);
         m_sceneObjects.push(this.m_lamp2);
         m_sceneObjects.push(this.m_fountain);
         m_sceneObjects.push(this.m_building);
         m_sceneObjects.push(this.m_sign);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         this.m_clubSignCounter = 0;
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_TRASH);
         if(DEBUG)
         {
            _loc2_ = new Sprite();
            addChild(_loc2_);
            this.getSceneObjects(_loc2_);
            addEventListener(Event.ENTER_FRAME,this.updateFrame,false,0,true);
            _loc2_ = new Sprite();
            setEffectsContainer(_loc2_);
            addChild(_loc2_);
         }
      }
      
      override public function destroy() : void
      {
         this.m_lamp1 = null;
         this.m_lamp2 = null;
         this.m_fountain = null;
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
      
      public function getAvatarSpawnPoint() : Point
      {
         return this.m_spawnPoint;
      }
      
      override public function updateScene() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         super.updateScene();
         ++this.m_clubSignCounter;
         if(this.m_clubSignCounter > 500)
         {
            this.s_clubSign.gotoAndPlay(1);
            this.m_clubSignCounter = 0;
         }
         _loc2_ = m_sceneTime;
         _loc1_ = _loc2_;
         _loc3_ = _loc1_;
         switch(_loc3_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      internal function updateFrame(param1:Event) : void
      {
         this.updateScene();
      }
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(this.stg_exitToBlue.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.stg_exitToGreen.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.stg_exitToIceCream.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToLibrary.hitTestPoint(mouseX,mouseY,true))
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
               this.stg_clouds.visible = true;
               break;
            case SCENE_TIME_EVENING:
               this.stg_clouds.visible = false;
               break;
            case SCENE_TIME_NIGHT:
               this.stg_clouds.visible = false;
               break;
            case SCENE_TIME_MORNING:
               this.stg_clouds.visible = true;
         }
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return this.m_avatarScaleLimits;
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(this.stg_exitToBlue.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_FISHING_HOLE;
         }
         if(this.stg_exitToGreen.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_STONEHENGE;
         }
         if(this.stg_exitToIceCream.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_ICE_CREAM_SHOP;
         }
         if(this.s_exitToLibrary.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_LIBRARY;
         }
         return null;
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
   }
}

