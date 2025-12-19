package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class BeachScene extends SceneRoot implements IScene, IBeach
   {
      
      internal static const DEBUG:int = 0;
      
      internal static const LARGE_WAVE_TIMER:int = 170;
      
      internal static const MAX_SCENE_X_OFFSET:int = 935;
      
      internal static const NIGHT_MASK_TOP_ALPHA:Number = 0.3;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.35;
      
      internal static const SCROLL_SPEED:int = 4;
      
      internal static const SMALL_WAVE_1_X_OFFSET:int = 70;
      
      internal static const SMALL_WAVE_TIMER:int = 120;
      
      internal static const MIN_SCENE_X_OFFSET:int = 0;
      
      internal static const SMALL_WAVE_2_X_OFFSET:int = 1160;
      
      internal var m_smallWave1:BeachSmallWave;
      
      internal var m_palm1:BeachPalm1;
      
      internal var m_palm2:BeachPalm2;
      
      internal var m_waveTimer1:int;
      
      internal var m_effectsContainerNightMaskTop:BeachNightMaskWater;
      
      internal var m_umbrella:BeachUmbrella;
      
      public var s_largeWaves:MovieClip;
      
      public var s_exitToOrchard:MovieClip;
      
      internal var m_rocks:BeachRocks;
      
      internal var m_sceneXOffset:int;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_bonfire:BeachBonfire;
      
      internal var m_fireBack:BeachBonfireBack;
      
      internal var m_log2:BeachLogRight;
      
      internal var m_spawnPoint:Point;
      
      internal var m_log1:BeachLogLeft;
      
      internal var m_chair1:BeachChairLeft;
      
      internal var m_chair2:BeachChairRight;
      
      public var s_ocean:Sprite;
      
      internal var m_fireFront:BeachBonfireFront;
      
      internal var m_smallWaveTimer2:int;
      
      internal var m_scrollRight:Boolean;
      
      public var s_beach:Sprite;
      
      internal var m_smallWave2:BeachSmallWave;
      
      internal var m_smallWaveTimer1:int;
      
      public var s_horizon:BeachHorizon;
      
      public function BeachScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         m_scrollRight = true;
         s_ground.cacheAsBitmap = true;
         trace("BeachScene Constructor");
         m_spawnPoint = new Point(514,273);
         m_avatarScaleLimits = new Array(0.65,1);
         if(SHOW_FIREWORKS)
         {
            m_fireworks = new Fireworks(150);
         }
         _loc1_ = getChildIndex(s_ocean);
         m_smallWave1 = new BeachSmallWave();
         m_smallWave1.x = SMALL_WAVE_1_X_OFFSET;
         m_smallWave1.y = 319;
         m_smallWave1.gotoAndStop(1);
         addChildAt(m_smallWave1,_loc1_);
         m_smallWave2 = new BeachSmallWave();
         m_smallWave2.x = SMALL_WAVE_2_X_OFFSET;
         m_smallWave2.y = 295;
         m_smallWave2.gotoAndStop(1);
         addChildAt(m_smallWave2,_loc1_);
         s_beach.mouseEnabled = false;
         s_beach.cacheAsBitmap = true;
         s_ocean.mouseEnabled = false;
         s_ocean.cacheAsBitmap = true;
         s_exitToOrchard.visible = false;
         if(s_nightSky)
         {
            s_nightSky.gotoAndStop(1);
            s_nightSky.cacheAsBitmap = true;
         }
         m_effectsContainerNightMaskTop = new BeachNightMaskWater();
         m_effectsContainerNightMaskTop.x = 0;
         m_effectsContainerNightMaskTop.y = 0;
         m_effectsContainerNightMaskTop.cacheAsBitmap = true;
         m_waveTimer1 = LARGE_WAVE_TIMER;
         m_smallWaveTimer1 = SMALL_WAVE_TIMER;
         m_smallWaveTimer2 = SMALL_WAVE_TIMER;
         m_palm1 = new BeachPalm1();
         m_palm1.x = 0;
         m_palm1.y = 0;
         m_palm1.width = 231;
         m_palm1.height = 284;
         m_palm1.setYDepth(274);
         m_palm2 = new BeachPalm2();
         m_palm2.x = 367;
         m_palm2.y = 0;
         m_palm2.width = 360;
         m_palm2.height = 271;
         m_palm2.setYDepth(241);
         m_chair1 = new BeachChairLeft();
         m_chair1.x = 398;
         m_chair1.y = 214;
         m_chair1.width = 114;
         m_chair1.height = 73;
         m_chair1.setYDepth(244);
         m_chair2 = new BeachChairRight();
         m_chair2.x = 575;
         m_chair2.y = 214;
         m_chair2.width = 114;
         m_chair2.height = 73;
         m_chair2.setYDepth(244);
         m_log1 = new BeachLogLeft();
         m_log1.x = 913;
         m_log1.y = 208;
         m_log1.width = 100;
         m_log1.height = 85;
         m_log1.setYDepth(213);
         m_log2 = new BeachLogRight();
         m_log2.x = 1311;
         m_log2.y = 208;
         m_log2.width = 100;
         m_log2.height = 85;
         m_log2.setYDepth(213);
         m_bonfire = new BeachBonfire();
         m_bonfire.x = 1119;
         m_bonfire.y = 120;
         m_bonfire.width = 94;
         m_bonfire.height = 148;
         m_bonfire.setYDepth(270);
         m_fireFront = new BeachBonfireFront();
         m_fireFront.x = 1117;
         m_fireFront.y = 179;
         m_fireFront.width = 124;
         m_fireFront.height = 111;
         m_fireFront.setYDepth(272);
         m_fireBack = new BeachBonfireBack();
         m_fireBack.x = 1088;
         m_fireBack.y = 189;
         m_fireBack.width = 151;
         m_fireBack.height = 97;
         m_fireBack.setYDepth(269);
         m_umbrella = new BeachUmbrella();
         m_umbrella.x = 1635;
         m_umbrella.y = 95;
         m_umbrella.width = 163;
         m_umbrella.height = 148;
         m_umbrella.setYDepth(235);
         m_rocks = new BeachRocks();
         m_rocks.x = 1525;
         m_rocks.y = 1;
         m_rocks.width = 345;
         m_rocks.height = 188;
         m_rocks.setYDepth(1);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_palm1);
         m_sceneObjects.push(m_palm2);
         m_sceneObjects.push(m_chair1);
         m_sceneObjects.push(m_chair2);
         m_sceneObjects.push(m_log1);
         m_sceneObjects.push(m_log2);
         m_sceneObjects.push(m_umbrella);
         m_sceneObjects.push(m_rocks);
         m_sceneObjects.push(m_fireFront);
         m_sceneObjects.push(m_fireBack);
         _loc2_ = 0;
         while(_loc2_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc2_].mouseEnabled = false;
            m_sceneObjects[_loc2_].mouseChildren = false;
            m_sceneObjects[_loc2_].cacheAsBitmap = true;
            _loc2_++;
         }
         m_sceneObjects.push(m_bonfire);
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         m_sceneTime = 5;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_COCONUT);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_FISH);
         if(DEBUG)
         {
            _loc3_ = new Sprite();
            addChild(_loc3_);
            getSceneObjects(_loc3_);
            addEventListener(Event.ENTER_FRAME,updateFrame,false,0,true);
            _loc3_ = new Sprite();
            setEffectsContainer(_loc3_);
            addChild(_loc3_);
         }
         m_sceneXOffset = 0;
         setSceneXOffset(m_sceneXOffset);
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
      
      public function getMouseCursorType() : String
      {
         if(Boolean(s_water) && s_water.hitTestPoint(mouseX + m_sceneXOffset,mouseY,true))
         {
            return "fish";
         }
         if(!s_ground.hitTestPoint(mouseX + m_sceneXOffset,mouseY,true))
         {
            return "none";
         }
         if(s_exitToOrchard.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
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
      
      override public function setEffectsContainer(param1:Sprite) : void
      {
         super.setEffectsContainer(param1);
         if(m_effectsContainerNightMaskTop)
         {
            param1.addChild(m_effectsContainerNightMaskTop);
         }
      }
      
      internal function updateFrame(param1:Event) : void
      {
         updateScene();
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         if(s_largeWaves.visible)
         {
            m_waveTimer1 = updateWave(s_largeWaves,m_waveTimer1,LARGE_WAVE_TIMER);
         }
         if(m_smallWave1.visible)
         {
            m_smallWaveTimer1 = updateWave(m_smallWave1,m_smallWaveTimer1,SMALL_WAVE_TIMER);
         }
         if(m_smallWave2.visible)
         {
            m_smallWaveTimer2 = updateWave(m_smallWave2,m_smallWaveTimer2,SMALL_WAVE_TIMER);
         }
         var _loc2_:* = m_sceneTime;
         switch(_loc2_)
         {
            case SCENE_TIME_DAY:
               break;
            case SCENE_TIME_EVENING:
               if(s_horizon)
               {
                  s_horizon.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT,NIGHT_MASK_TOP_ALPHA);
               }
               break;
            case SCENE_TIME_NIGHT:
               break;
            case SCENE_TIME_MORNING:
               if(s_horizon)
               {
                  s_horizon.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT,NIGHT_MASK_TOP_ALPHA);
                  break;
               }
         }
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(s_exitToOrchard.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_orchard";
         }
         return null;
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return m_avatarScaleLimits;
      }
      
      override public function isScrollable() : Boolean
      {
         return true;
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
      
      override public function getSceneXOffset() : int
      {
         return m_sceneXOffset;
      }
      
      public function getAvatarSpawnPoint() : Point
      {
         return m_spawnPoint;
      }
      
      override public function setSceneTime(param1:int, param2:Boolean = false) : void
      {
         super.setSceneTime(param1,param2);
         var _loc3_:* = m_sceneTime;
         switch(_loc3_)
         {
            case SCENE_TIME_DAY:
               if(s_largeWaves.currentFrame == 1)
               {
                  s_largeWaves.gotoAndPlay(1);
               }
               s_largeWaves.visible = true;
               if(s_horizon)
               {
                  s_horizon.setNightMask(0);
               }
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(0,NIGHT_MASK_TOP_ALPHA);
               }
               break;
            case SCENE_TIME_EVENING:
               s_largeWaves.gotoAndStop(1);
               s_largeWaves.visible = false;
               if(s_horizon)
               {
                  s_horizon.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT,NIGHT_MASK_TOP_ALPHA);
               }
               break;
            case SCENE_TIME_NIGHT:
               s_largeWaves.gotoAndStop(1);
               s_largeWaves.visible = false;
               if(s_horizon)
               {
                  s_horizon.setNightMask(1);
               }
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(1,NIGHT_MASK_TOP_ALPHA);
               }
               break;
            case SCENE_TIME_MORNING:
               s_largeWaves.gotoAndStop(1);
               s_largeWaves.visible = false;
               if(s_horizon)
               {
                  s_horizon.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(m_effectsContainerNightMaskTop)
               {
                  m_effectsContainerNightMaskTop.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT,NIGHT_MASK_TOP_ALPHA);
                  break;
               }
         }
      }
      
      override public function setSceneXOffset(param1:int) : void
      {
         if(param1 < MIN_SCENE_X_OFFSET)
         {
            m_sceneXOffset = MIN_SCENE_X_OFFSET;
         }
         else if(param1 > MAX_SCENE_X_OFFSET)
         {
            m_sceneXOffset = MAX_SCENE_X_OFFSET;
         }
         else
         {
            m_sceneXOffset = param1;
         }
         s_beach.x = -m_sceneXOffset;
         s_ocean.x = -m_sceneXOffset;
         s_horizon.x = -m_sceneXOffset * 0.33;
         s_nightMask.x = -m_sceneXOffset;
         m_smallWave1.x = SMALL_WAVE_1_X_OFFSET - m_sceneXOffset;
         m_smallWave2.x = SMALL_WAVE_2_X_OFFSET - m_sceneXOffset;
         s_largeWaves.x = -m_sceneXOffset;
         if(m_effectsContainer)
         {
            m_effectsContainer.x = -m_sceneXOffset;
         }
      }
   }
}

