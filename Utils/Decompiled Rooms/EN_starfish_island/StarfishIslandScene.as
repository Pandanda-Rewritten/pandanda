package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class StarfishIslandScene extends SceneRoot implements IScene
   {
      
      internal static const DEBUG:int = 1;
      
      internal static const LARGE_WAVE_TIMER:int = 170;
      
      internal static const NIGHT_MASK_TOP_ALPHA:Number = 0.3;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.35;
      
      internal var m_waveTimer1:int;
      
      public var s_ocean:Sprite;
      
      public var s_island:MovieClip;
      
      public var s_largeWaves:MovieClip;
      
      internal var m_palm:IslandPalm;
      
      internal var m_water:IslandWater;
      
      internal var m_effectsContainerNightMaskTop:IslandSceneNightMask;
      
      public function StarfishIslandScene()
      {
         var _loc2_:* = null;
         super();
         trace("StarfishIslandScene Constructor");
         m_waveTimer1 = LARGE_WAVE_TIMER;
         s_island.cacheAsBitmap = true;
         s_ocean.cacheAsBitmap = true;
         s_ground.cacheAsBitmap = true;
         m_spawnPoint = new Point(540,304);
         m_avatarScaleLimits = new Array(0.6,1);
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         m_effectsContainerNightMaskTop = new IslandSceneNightMask();
         m_effectsContainerNightMaskTop.x = -293;
         m_effectsContainerNightMaskTop.y = 165;
         m_effectsContainerNightMaskTop.cacheAsBitmap = true;
         m_palm = new IslandPalm();
         m_palm.x = 201;
         m_palm.y = 0;
         m_palm.width = 517;
         m_palm.height = 382;
         m_palm.setYDepth(324);
         m_sceneObjects = new Array();
         m_water = new IslandWater();
         m_water.x = 0;
         m_water.y = 380;
         m_water.width = 1545;
         m_water.height = 560;
         m_water.setYDepth(560);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_water);
         m_sceneObjects.push(m_palm);
         _loc2_ = 0;
         while(_loc2_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc2_].mouseEnabled = false;
            m_sceneObjects[_loc2_].mouseChildren = false;
            m_sceneObjects[_loc2_].cacheAsBitmap = true;
            _loc2_++;
         }
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         m_sceneTime = 5;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_COCONUT);
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
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      override public function setEffectsContainer(param1:Sprite) : void
      {
         super.setEffectsContainer(param1);
         if(m_effectsContainerNightMaskTop)
         {
            param1.addChild(m_effectsContainerNightMaskTop);
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
      
      internal function updateWave(param1:MovieClip, param2:int, param3:int) : int
      {
         var _loc4_:* = 0;
         if(param1.visible)
         {
            if(param2 > 0)
            {
               param2--;
               if(param2 <= 0)
               {
                  param1.gotoAndPlay(1);
                  _loc4_ = 0;
                  while(_loc4_ < param1.numChildren)
                  {
                     if(param1.getChildAt(_loc4_) is MovieClip)
                     {
                        MovieClip(param1.getChildAt(_loc4_)).gotoAndPlay(1);
                     }
                     _loc4_++;
                  }
                  param2 == 0;
               }
            }
            else if(param1.currentFrame == param1.totalFrames)
            {
               param1.stop();
               _loc4_ = 0;
               while(_loc4_ < param1.numChildren)
               {
                  if(param1.getChildAt(_loc4_) is MovieClip)
                  {
                     MovieClip(param1.getChildAt(_loc4_)).stop();
                  }
                  _loc4_++;
               }
               param2 = param3;
            }
         }
         return param2;
      }
      
      override public function destroy() : void
      {
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
         return m_spawnPoint;
      }
      
      override public function updateScene() : void
      {
         var _loc1_:* = undefined;
         super.updateScene();
         if(s_largeWaves.visible)
         {
            m_waveTimer1 = updateWave(s_largeWaves,m_waveTimer1,LARGE_WAVE_TIMER);
         }
         _loc1_ = m_sceneTime;
         switch(_loc1_)
         {
            case SCENE_TIME_DAY:
               break;
            case SCENE_TIME_EVENING:
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT,NIGHT_MASK_TOP_ALPHA);
               }
               break;
            case SCENE_TIME_NIGHT:
               break;
            case SCENE_TIME_MORNING:
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT,NIGHT_MASK_TOP_ALPHA);
                  break;
               }
         }
      }
      
      internal function updateFrame(param1:Event) : void
      {
         updateScene();
      }
      
      public function getMouseCursorType() : String
      {
         if(Boolean(s_water) && s_water.hitTestPoint(mouseX,mouseY,true))
         {
            return "fish";
         }
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         return "ground";
      }
      
      public function getSceneObjects(param1:Sprite) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         if(m_sceneObjects)
         {
            while(_loc2_ < m_sceneObjects.length)
            {
               if(m_sceneObjects[_loc2_])
               {
                  param1.addChild(m_sceneObjects[_loc2_]);
               }
               _loc2_++;
            }
         }
      }
      
      override public function setSceneTime(param1:int, param2:Boolean = false) : void
      {
         super.setSceneTime(param1,param2);
         var _loc3_:* = m_sceneTime;
         m_waveTimer1 = updateWave(s_largeWaves,m_waveTimer1,LARGE_WAVE_TIMER);
         switch(_loc3_)
         {
            case SCENE_TIME_DAY:
               if(s_largeWaves.currentFrame == 1)
               {
                  s_largeWaves.gotoAndPlay(1);
               }
               s_largeWaves.visible = true;
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(0,NIGHT_MASK_TOP_ALPHA);
               }
               break;
            case SCENE_TIME_EVENING:
               s_largeWaves.gotoAndStop(1);
               s_largeWaves.visible = false;
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT,NIGHT_MASK_TOP_ALPHA);
               }
               break;
            case SCENE_TIME_NIGHT:
               s_largeWaves.gotoAndStop(1);
               s_largeWaves.visible = false;
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(1,NIGHT_MASK_TOP_ALPHA);
               }
               break;
            case SCENE_TIME_MORNING:
               s_largeWaves.gotoAndStop(1);
               s_largeWaves.visible = false;
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT,NIGHT_MASK_TOP_ALPHA);
                  break;
               }
         }
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return m_avatarScaleLimits;
      }
      
      public function checkForExit(param1:Point) : String
      {
         return null;
      }
   }
}

