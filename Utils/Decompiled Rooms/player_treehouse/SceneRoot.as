package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   
   public class SceneRoot extends Sprite
   {
      
      public static const SCENE_TIME_EVENING:int = 2;
      
      internal static const MINIMUM_AB_DIST:Number = 10;
      
      public static const SCENE_TIME_NIGHT:int = 1;
      
      internal static const HALLOWEEN_MIN_NIGHT_TRANSITION:Number = 0.37;
      
      public static const SCENE_TIME_DAY:int = 0;
      
      internal static const PERP_DIST_TEST:Number = 15;
      
      public static const EFFECTS_LAYER_NIGHT_MASK_ALPHA:Number = 0.25;
      
      internal static const MAX_FIREFLIES:int = 10;
      
      public static const DEFAULT_NIGHT_MASK_INTENSITY:Number = 0.9;
      
      public static const NIGHT_TRANSITION_FRAME_COUNT:Number = 99;
      
      internal static const MIN_DIST_TEST:Number = 7;
      
      internal static const CLOCK_TIMER:int = 15000;
      
      public static const SCENE_TIME_MORNING:int = 3;
      
      internal static const HALLOWEEN_MAX_NIGHT_TRANSITION:Number = 0.7;
      
      protected static const SHOW_FIREWORKS:Boolean = false;
      
      internal var m_clockTimer:Timer;
      
      protected var m_fireflyList:Array;
      
      protected var m_gameItemCategoryList:Array;
      
      public var s_spawnGround:Sprite;
      
      protected var m_sceneTime:uint;
      
      protected var m_effectsContainer:Sprite;
      
      protected var m_sceneTimeCounter:int;
      
      public var s_water:Sprite;
      
      public var s_ground:Sprite;
      
      protected var m_isTestingTime:Boolean;
      
      public var s_nightSky:MovieClip;
      
      protected var m_pathArray:Array;
      
      internal var m_direction:int;
      
      protected var m_effectsContainerNightMask:EffectsContainerNightMask;
      
      internal var m_dx:Number;
      
      protected var m_sceneObjects:Array;
      
      internal var m_pathCreationFailed:Boolean;
      
      internal var m_newObject:Boolean;
      
      protected var m_nightMaskIntensity:Number;
      
      protected var m_transitionFrame:int;
      
      public var s_windows:MovieClip;
      
      protected var m_fireworks:Fireworks;
      
      internal var m_locationName:String;
      
      internal var m_recursiveDepth:int;
      
      internal var m_objectExitPt:Point;
      
      internal var m_dy:Number;
      
      public var s_groundHorse:Sprite;
      
      public var s_fishZone:Sprite;
      
      public var s_nightMask:Sprite;
      
      public function SceneRoot()
      {
         super();
         trace("SceneRoot Constructor");
         m_gameItemCategoryList = new Array();
         s_ground.visible = false;
         if(s_groundHorse)
         {
            s_groundHorse.visible = false;
         }
         if(s_spawnGround)
         {
            s_spawnGround.visible = false;
         }
         if(s_water)
         {
            s_water.visible = false;
         }
         if(s_fishZone)
         {
            s_fishZone.visible = false;
         }
         if(s_nightMask)
         {
            s_nightMask.cacheAsBitmap = true;
         }
         if(s_nightSky)
         {
            s_nightSky.gotoAndStop(1);
            s_nightSky.cacheAsBitmap = true;
         }
         m_fireflyList = new Array();
         m_clockTimer = new Timer(CLOCK_TIMER,0);
         m_clockTimer.addEventListener(TimerEvent.TIMER,onClockTimerListener,false,0,true);
         m_clockTimer.start();
         m_nightMaskIntensity = DEFAULT_NIGHT_MASK_INTENSITY;
         m_isTestingTime = false;
      }
      
      public function makePath(param1:Point, param2:Point) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = NaN;
         var _loc7_:* = null;
         _loc3_ = findCollisionPoints(param1,param2);
         if(_loc3_.length == 0)
         {
            if(param2 == m_objectExitPt)
            {
               m_newObject = true;
               m_direction = 0;
            }
            m_pathArray.push(param2);
            --m_recursiveDepth;
            return;
         }
         ++m_recursiveDepth;
         if(m_recursiveDepth > 50)
         {
            trace("RECUSIVE DEPTH TOO HIGH, BAILING");
            m_pathCreationFailed = true;
            return;
         }
         _loc4_ = _loc3_[0];
         _loc5_ = _loc3_[1];
         _loc6_ = Math.sqrt((_loc5_.x - _loc4_.x) * (_loc5_.x - _loc4_.x) + (_loc5_.y - _loc4_.y) * (_loc5_.y - _loc4_.y));
         if(_loc6_ < MINIMUM_AB_DIST)
         {
            return;
         }
         _loc7_ = findPointC(_loc4_,_loc5_);
         if(_loc7_.x == 0 && _loc7_.y == 0)
         {
            trace("crap, couldn\'t find C just bail");
            m_pathCreationFailed = true;
            return;
         }
         if(m_newObject)
         {
            m_newObject = false;
            m_objectExitPt = _loc5_;
            makePath(param1,_loc7_);
            makePath(_loc7_,_loc5_);
            if(_loc5_ != param2)
            {
               makePath(_loc5_,param2);
            }
         }
         else
         {
            makePath(param1,_loc7_);
            makePath(_loc7_,param2);
         }
      }
      
      public function getName() : String
      {
         return m_locationName;
      }
      
      public function setHalloweenSceneTime(param1:int, param2:Boolean) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         m_isTestingTime = param2;
         m_sceneTime = param1;
         _loc3_ = 0;
         var _loc5_:* = m_sceneTime;
         switch(_loc5_)
         {
            case SCENE_TIME_DAY:
               trace("setting day time");
               if(m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     m_sceneObjects[_loc3_].setNightMask(HALLOWEEN_MIN_NIGHT_TRANSITION);
                     _loc3_++;
                  }
               }
               if(s_nightMask)
               {
                  s_nightMask.visible = true;
                  s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * HALLOWEEN_MIN_NIGHT_TRANSITION;
               }
               if(m_effectsContainerNightMask)
               {
                  m_effectsContainerNightMask.setNightMask(HALLOWEEN_MIN_NIGHT_TRANSITION);
               }
               if(s_nightSky)
               {
                  s_nightSky.gotoAndStop(Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION));
               }
               if(s_windows)
               {
                  s_windows.gotoAndStop(Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION));
               }
               if(SHOW_FIREWORKS && Boolean(m_fireworks))
               {
                  if(Boolean(m_effectsContainer) && m_effectsContainer.contains(m_fireworks))
                  {
                     m_effectsContainer.removeChild(m_fireworks);
                  }
               }
               break;
            case SCENE_TIME_EVENING:
               trace("setting evening time");
               _loc4_ = GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getNightStartMinute()) * 60;
               if(m_isTestingTime)
               {
                  m_transitionFrame = Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION);
               }
               else
               {
                  m_transitionFrame = Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION) + _loc4_ / (GameClock.getInstance().getDayNightTransitionSpeed() / 30);
               }
               trace("transition frame : " + m_transitionFrame);
               if(m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION)
               {
                  m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION;
               }
               else if(m_transitionFrame < NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION)
               {
                  m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION;
               }
               if(m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     m_sceneObjects[_loc3_].setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     _loc3_++;
                  }
               }
               m_sceneTimeCounter = 0;
               if(s_nightMask)
               {
                  s_nightMask.visible = true;
                  s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
               }
               if(m_effectsContainerNightMask)
               {
                  m_effectsContainerNightMask.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(s_nightSky)
               {
                  s_nightSky.gotoAndStop(m_transitionFrame);
               }
               if(s_windows)
               {
                  s_windows.gotoAndStop(m_transitionFrame);
               }
               break;
            case SCENE_TIME_NIGHT:
               trace("setting night time");
               if(m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     m_sceneObjects[_loc3_].setNightMask(HALLOWEEN_MAX_NIGHT_TRANSITION);
                     _loc3_++;
                  }
               }
               if(s_nightMask)
               {
                  s_nightMask.visible = true;
                  s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * HALLOWEEN_MAX_NIGHT_TRANSITION;
               }
               if(m_effectsContainerNightMask)
               {
                  m_effectsContainerNightMask.setNightMask(HALLOWEEN_MAX_NIGHT_TRANSITION);
               }
               if(s_nightSky)
               {
                  s_nightSky.gotoAndStop(Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION));
               }
               if(s_windows)
               {
                  s_windows.gotoAndStop(Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION));
               }
               if(SHOW_FIREWORKS && Boolean(m_fireworks))
               {
                  if(Boolean(m_effectsContainer) && !m_effectsContainer.contains(m_fireworks))
                  {
                     m_effectsContainer.addChild(m_fireworks);
                  }
               }
               break;
            case SCENE_TIME_MORNING:
               trace("setting morning time");
               _loc4_ = GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getDayStartMinute()) * 60;
               if(m_isTestingTime)
               {
                  m_transitionFrame = Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION);
               }
               else
               {
                  m_transitionFrame = Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION) - _loc4_ / (GameClock.getInstance().getDayNightTransitionSpeed() / 30);
               }
               if(m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION)
               {
                  m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION;
               }
               else if(m_transitionFrame < NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION)
               {
                  m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION;
               }
               if(m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     m_sceneObjects[_loc3_].setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     _loc3_++;
                  }
               }
               m_sceneTimeCounter = 0;
               if(s_nightMask)
               {
                  s_nightMask.visible = true;
                  s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
               }
               if(m_effectsContainerNightMask)
               {
                  m_effectsContainerNightMask.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(s_nightSky)
               {
                  s_nightSky.gotoAndStop(m_transitionFrame);
               }
               if(s_windows)
               {
                  s_windows.gotoAndStop(m_transitionFrame);
               }
               if(SHOW_FIREWORKS && Boolean(m_fireworks))
               {
                  if(Boolean(m_effectsContainer) && m_effectsContainer.contains(m_fireworks))
                  {
                     m_effectsContainer.removeChild(m_fireworks);
                  }
                  break;
               }
         }
      }
      
      public function setName(param1:String) : void
      {
         m_locationName = param1;
      }
      
      public function init() : void
      {
         m_sceneTime = 10;
         updateSceneTime();
      }
      
      protected function updateFireflies() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         if(GameConstants.ACTIVE_FESTIVAL == GameConstants.PUMPKIN_FESTIVAL)
         {
            return;
         }
         _loc1_ = Math.floor(Math.random() * 100);
         if(_loc1_ > 95)
         {
            if(m_fireflyList.length < MAX_FIREFLIES)
            {
               _loc3_ = Math.floor(Math.random() * 935);
               _loc4_ = Math.floor(Math.random() * 600);
               _loc5_ = new Firefly();
               _loc5_.x = _loc3_;
               _loc5_.y = _loc4_;
               m_fireflyList.push(_loc5_);
               if(m_effectsContainer)
               {
                  m_effectsContainer.addChild(_loc5_);
               }
            }
         }
         _loc2_ = m_fireflyList.length - 1;
         while(_loc2_ >= 0)
         {
            m_fireflyList[_loc2_].update();
            if(m_fireflyList[_loc2_].hasExpired())
            {
               if(Boolean(m_effectsContainer) && m_effectsContainer.contains(m_fireflyList[_loc2_]))
               {
                  m_effectsContainer.removeChild(m_fireflyList[_loc2_]);
               }
               m_fireflyList[_loc2_].destroy();
               m_fireflyList.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      protected function getNightMaskSceneAlpha() : Number
      {
         trace("ERROR: we need to override the function getNightMaskSceneAlpha in each scene file");
         return 1;
      }
      
      public function getWalkingPath(param1:Point, param2:Point) : Array
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         m_pathArray = new Array();
         m_pathArray.length = 0;
         if(!s_ground)
         {
            return m_pathArray;
         }
         if(!isGroundHit(param2))
         {
            return m_pathArray;
         }
         m_direction = 0;
         m_recursiveDepth = 0;
         m_newObject = true;
         m_pathCreationFailed = false;
         m_pathArray.push(param1);
         makePath(param1,param2);
         if(m_pathCreationFailed)
         {
            m_pathArray.length = 0;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < m_pathArray.length - 1)
            {
               _loc4_ = m_pathArray.length - 1;
               while(_loc4_ > _loc3_ + 1)
               {
                  if(findCollisionPoints(m_pathArray[_loc3_],m_pathArray[_loc4_]).length == 0)
                  {
                     m_pathArray.splice(_loc3_ + 1,_loc4_ - _loc3_ - 1);
                     break;
                  }
                  _loc4_--;
               }
               _loc3_++;
            }
            m_pathArray.shift();
         }
         return m_pathArray;
      }
      
      public function destroy() : void
      {
         var _loc1_:* = 0;
         trace("sceneroot destroy");
         GameSound.getInstance().clearSounds();
         if(m_pathArray)
         {
            m_pathArray.length = 0;
            m_pathArray = null;
         }
         if(m_fireworks)
         {
            m_fireworks.destroy();
         }
         m_clockTimer.stop();
         m_clockTimer.removeEventListener(TimerEvent.TIMER,onClockTimerListener);
         m_gameItemCategoryList.length = 0;
         _loc1_ = 0;
         while(_loc1_ < m_fireflyList.length)
         {
            m_fireflyList[_loc1_].destroy();
            _loc1_++;
         }
         m_fireflyList.length = 0;
         m_fireflyList = null;
      }
      
      protected function onTimerNotice() : void
      {
      }
      
      public function isGroundHit(param1:Point, param2:Boolean = false) : Boolean
      {
         if(!s_ground)
         {
            trace("ERROR: ground not loaded to SceneRoot");
            return false;
         }
         if(param2 && Boolean(s_groundHorse))
         {
            return s_groundHorse.hitTestPoint(param1.x,param1.y,true);
         }
         return s_ground.hitTestPoint(param1.x,param1.y,true);
      }
      
      public function setSceneXOffset(param1:int) : void
      {
      }
      
      public function isWaterHit(param1:Point) : Boolean
      {
         if(!s_water)
         {
            return false;
         }
         return s_water.hitTestPoint(param1.x,param1.y,true);
      }
      
      internal function onClockTimerListener(param1:TimerEvent) : void
      {
         if(!m_isTestingTime)
         {
            updateSceneTime();
         }
         onTimerNotice();
      }
      
      public function setSceneTime(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(GameConstants.ACTIVE_FESTIVAL == GameConstants.PUMPKIN_FESTIVAL)
         {
            setHalloweenSceneTime(param1,param2);
            return;
         }
         m_isTestingTime = param2;
         m_sceneTime = param1;
         _loc3_ = 0;
         var _loc5_:* = m_sceneTime;
         switch(_loc5_)
         {
            case SCENE_TIME_DAY:
               trace("setting day time");
               if(m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     m_sceneObjects[_loc3_].setNightMask(0);
                     _loc3_++;
                  }
               }
               if(s_nightMask)
               {
                  s_nightMask.visible = false;
               }
               if(m_effectsContainerNightMask)
               {
                  m_effectsContainerNightMask.setNightMask(0);
               }
               if(s_nightSky)
               {
                  s_nightSky.gotoAndStop(1);
               }
               if(SHOW_FIREWORKS && Boolean(m_fireworks))
               {
                  if(Boolean(m_effectsContainer) && m_effectsContainer.contains(m_fireworks))
                  {
                     m_effectsContainer.removeChild(m_fireworks);
                  }
               }
               break;
            case SCENE_TIME_EVENING:
               trace("setting evening time");
               _loc4_ = GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getNightStartMinute()) * 60;
               if(param2)
               {
                  m_transitionFrame = 0;
               }
               else
               {
                  m_transitionFrame = _loc4_ / (GameClock.getInstance().getDayNightTransitionSpeed() / 30);
               }
               if(m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT)
               {
                  m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT;
               }
               else if(m_transitionFrame < 0)
               {
                  m_transitionFrame = 0;
               }
               if(m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     m_sceneObjects[_loc3_].setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     _loc3_++;
                  }
               }
               m_sceneTimeCounter = 0;
               if(s_nightMask)
               {
                  s_nightMask.visible = true;
                  s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
               }
               if(m_effectsContainerNightMask)
               {
                  m_effectsContainerNightMask.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(s_nightSky)
               {
                  s_nightSky.gotoAndStop(m_transitionFrame);
               }
               if(s_windows)
               {
                  s_windows.gotoAndStop(m_transitionFrame);
               }
               break;
            case SCENE_TIME_NIGHT:
               trace("setting night time");
               if(m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     m_sceneObjects[_loc3_].setNightMask(1);
                     _loc3_++;
                  }
               }
               if(s_nightMask)
               {
                  s_nightMask.visible = true;
                  s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity;
               }
               if(m_effectsContainerNightMask)
               {
                  m_effectsContainerNightMask.setNightMask(1);
               }
               if(s_nightSky)
               {
                  s_nightSky.gotoAndStop(NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(s_windows)
               {
                  s_windows.gotoAndStop(NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(SHOW_FIREWORKS && Boolean(m_fireworks))
               {
                  if(Boolean(m_effectsContainer) && !m_effectsContainer.contains(m_fireworks))
                  {
                     m_effectsContainer.addChild(m_fireworks);
                  }
               }
               break;
            case SCENE_TIME_MORNING:
               trace("setting morning time");
               _loc4_ = GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getDayStartMinute()) * 60;
               if(param2)
               {
                  m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT;
               }
               else
               {
                  m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT - _loc4_ / (GameClock.getInstance().getDayNightTransitionSpeed() / 30);
               }
               if(m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT)
               {
                  m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT;
               }
               else if(m_transitionFrame < 0)
               {
                  m_transitionFrame = 0;
               }
               if(m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     m_sceneObjects[_loc3_].setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     _loc3_++;
                  }
               }
               m_sceneTimeCounter = 0;
               if(s_nightMask)
               {
                  s_nightMask.visible = true;
                  s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
               }
               if(m_effectsContainerNightMask)
               {
                  m_effectsContainerNightMask.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(s_nightSky)
               {
                  s_nightSky.gotoAndStop(m_transitionFrame);
               }
               if(s_windows)
               {
                  s_windows.gotoAndStop(m_transitionFrame);
               }
               if(SHOW_FIREWORKS && Boolean(m_fireworks))
               {
                  if(Boolean(m_effectsContainer) && m_effectsContainer.contains(m_fireworks))
                  {
                     m_effectsContainer.removeChild(m_fireworks);
                  }
                  break;
               }
         }
      }
      
      public function isTreehouse() : Boolean
      {
         return false;
      }
      
      public function setMouseClick(param1:Point, param2:Point = null) : void
      {
      }
      
      public function getMiniGameId() : String
      {
         return new String();
      }
      
      public function isFishZoneHit(param1:Point) : Boolean
      {
         if(!s_fishZone)
         {
            return false;
         }
         return s_fishZone.hitTestPoint(param1.x,param1.y,true);
      }
      
      public function serverExtensionResponse(param1:String, param2:Object) : void
      {
      }
      
      public function updateScene() : void
      {
         var loc2:*;
         var i:int = 0;
         var loc1:* = undefined;
         i = 0;
         if(GameConstants.ACTIVE_FESTIVAL == GameConstants.PUMPKIN_FESTIVAL)
         {
            updateHalloweenScene();
            return;
         }
         i = 0;
         if(SHOW_FIREWORKS && Boolean(m_fireworks))
         {
            if(m_effectsContainer)
            {
               if(m_effectsContainer.contains(m_fireworks))
               {
                  m_fireworks.update(getSceneXOffset());
               }
            }
         }
         loc2 = m_sceneTime;
         switch(loc2)
         {
            case SCENE_TIME_DAY:
               break;
            case SCENE_TIME_EVENING:
               ++m_sceneTimeCounter;
               if(m_sceneTimeCounter > GameClock.getInstance().getDayNightTransitionSpeed())
               {
                  m_transitionFrame += 1;
                  try
                  {
                     if(m_sceneObjects)
                     {
                        i = 0;
                        while(i < m_sceneObjects.length)
                        {
                           m_sceneObjects[i].setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                           i++;
                        }
                     }
                     if(s_nightMask)
                     {
                        s_nightMask.visible = true;
                        s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
                     }
                     if(m_effectsContainerNightMask)
                     {
                        m_effectsContainerNightMask.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     }
                     if(s_nightSky)
                     {
                        s_nightSky.gotoAndStop(m_transitionFrame);
                     }
                     if(s_windows)
                     {
                        s_windows.gotoAndStop(m_transitionFrame);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("ERROR: " + e.message);
                  }
                  if(m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT)
                  {
                     setSceneTime(SCENE_TIME_NIGHT);
                  }
                  m_sceneTimeCounter = 0;
               }
               break;
            case SCENE_TIME_NIGHT:
               break;
            case SCENE_TIME_MORNING:
               ++m_sceneTimeCounter;
               if(m_sceneTimeCounter > GameClock.getInstance().getDayNightTransitionSpeed())
               {
                  --m_transitionFrame;
                  try
                  {
                     if(m_sceneObjects)
                     {
                        i = 0;
                        while(i < m_sceneObjects.length)
                        {
                           m_sceneObjects[i].setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                           i++;
                        }
                     }
                     if(s_nightMask)
                     {
                        s_nightMask.visible = true;
                        s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
                     }
                     if(m_effectsContainerNightMask)
                     {
                        m_effectsContainerNightMask.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     }
                     if(s_nightSky)
                     {
                        s_nightSky.gotoAndStop(m_transitionFrame);
                     }
                     if(s_windows)
                     {
                        s_windows.gotoAndStop(m_transitionFrame);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("ERROR: " + e.message);
                  }
                  if(m_transitionFrame <= 0)
                  {
                     setSceneTime(SCENE_TIME_DAY);
                  }
                  m_sceneTimeCounter = 0;
                  break;
               }
         }
      }
      
      public function findCollisionPoints(param1:Point, param2:Point) : Array
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = NaN;
         _loc3_ = param2.x - param1.x;
         _loc4_ = param2.y - param1.y;
         _loc5_ = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
         _loc3_ = _loc3_ * MIN_DIST_TEST / _loc5_;
         _loc4_ = _loc4_ * MIN_DIST_TEST / _loc5_;
         _loc6_ = Math.floor(_loc5_ / MIN_DIST_TEST);
         _loc7_ = new Array();
         _loc8_ = new Point(0,0);
         _loc9_ = 0;
         while(_loc9_ < _loc6_)
         {
            _loc8_.x = param1.x + _loc3_ * (_loc9_ + 1);
            _loc8_.y = param1.y + _loc4_ * (_loc9_ + 1);
            if(isGroundHit(_loc8_))
            {
               if(_loc7_.length == 1)
               {
                  _loc7_.push(_loc8_);
                  break;
               }
            }
            else if(_loc7_.length == 0)
            {
               _loc7_.push(new Point(param1.x + _loc3_ * _loc9_,param1.y + _loc4_ * _loc9_));
            }
            _loc9_++;
         }
         if(_loc7_.length == 1)
         {
            _loc7_.push(param2);
         }
         return _loc7_;
      }
      
      public function setEffectsContainer(param1:Sprite) : void
      {
         m_effectsContainer = param1;
         param1.mouseEnabled = false;
         if(SHOW_FIREWORKS && Boolean(m_fireworks))
         {
            param1.addChild(m_fireworks);
         }
         if(m_effectsContainerNightMask)
         {
            param1.addChild(m_effectsContainerNightMask);
         }
      }
      
      public function getAvatarWalkingPath(param1:Point, param2:Point) : Array
      {
         return getWalkingPath(param1,param2);
      }
      
      public function findPointC(param1:Point, param2:Point) : Point
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = NaN;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = 0;
         _loc3_ = new Point(param2.x - param1.x,param2.y - param1.y);
         _loc3_.x *= 0.5;
         _loc3_.y *= 0.5;
         _loc3_.x += param1.x;
         _loc3_.y += param1.y;
         _loc4_ = new Point(-(_loc3_.y - param1.y),_loc3_.x - param1.x);
         _loc5_ = new Point(_loc3_.y - param1.y,-(_loc3_.x - param1.x));
         _loc6_ = Math.sqrt(_loc4_.x * _loc4_.x + _loc4_.y * _loc4_.y);
         _loc4_.x = _loc4_.x / _loc6_ * PERP_DIST_TEST;
         _loc4_.y = _loc4_.y / _loc6_ * PERP_DIST_TEST;
         _loc5_.x = _loc5_.x / _loc6_ * PERP_DIST_TEST;
         _loc5_.y = _loc5_.y / _loc6_ * PERP_DIST_TEST;
         _loc7_ = new Point(0,0);
         _loc8_ = new Point(0,0);
         _loc9_ = 1;
         while(_loc9_ < 50)
         {
            if(!m_direction || m_direction == 1)
            {
               _loc7_.x = _loc3_.x + _loc4_.x * _loc9_;
               _loc7_.y = _loc3_.y + _loc4_.y * _loc9_;
               if(isGroundHit(_loc7_))
               {
                  _loc8_ = _loc7_;
                  m_direction = 1;
                  break;
               }
            }
            if(!m_direction || m_direction == 2)
            {
               _loc7_.x = _loc3_.x + _loc5_.x * _loc9_;
               _loc7_.y = _loc3_.y + _loc5_.y * _loc9_;
               if(isGroundHit(_loc7_))
               {
                  _loc8_ = _loc7_;
                  m_direction = 2;
                  break;
               }
            }
            _loc9_++;
         }
         return _loc8_;
      }
      
      public function isScrollable() : Boolean
      {
         return false;
      }
      
      public function getSpawnPlaneSprite(param1:String) : Sprite
      {
         if(param1 == GameCollectableSpawnPlane.SPAWN_GROUND)
         {
            return s_spawnGround;
         }
         trace("ERROR: override getSpawnPlaneSprite in this location!!");
         return null;
      }
      
      public function updateHalloweenScene() : void
      {
         var loc2:*;
         var i:int = 0;
         var loc1:* = undefined;
         i = 0;
         i = 0;
         if(SHOW_FIREWORKS && Boolean(m_fireworks))
         {
            if(m_effectsContainer)
            {
               if(m_effectsContainer.contains(m_fireworks))
               {
                  m_fireworks.update(getSceneXOffset());
               }
            }
         }
         loc2 = m_sceneTime;
         switch(loc2)
         {
            case SCENE_TIME_DAY:
               break;
            case SCENE_TIME_EVENING:
               ++m_sceneTimeCounter;
               if(m_sceneTimeCounter > GameClock.getInstance().getDayNightTransitionSpeed())
               {
                  m_transitionFrame += 1;
                  try
                  {
                     if(m_sceneObjects)
                     {
                        i = 0;
                        while(i < m_sceneObjects.length)
                        {
                           m_sceneObjects[i].setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                           i++;
                        }
                     }
                     if(s_nightMask)
                     {
                        s_nightMask.visible = true;
                        s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
                     }
                     if(m_effectsContainerNightMask)
                     {
                        m_effectsContainerNightMask.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     }
                     if(s_nightSky)
                     {
                        s_nightSky.gotoAndStop(m_transitionFrame);
                     }
                     if(s_windows)
                     {
                        s_windows.gotoAndStop(m_transitionFrame);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("ERROR: " + e.message);
                  }
                  if(m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION)
                  {
                     setSceneTime(SCENE_TIME_NIGHT);
                  }
                  m_sceneTimeCounter = 0;
               }
               break;
            case SCENE_TIME_NIGHT:
               break;
            case SCENE_TIME_MORNING:
               ++m_sceneTimeCounter;
               if(m_sceneTimeCounter > GameClock.getInstance().getDayNightTransitionSpeed())
               {
                  --m_transitionFrame;
                  try
                  {
                     if(m_sceneObjects)
                     {
                        i = 0;
                        while(i < m_sceneObjects.length)
                        {
                           m_sceneObjects[i].setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                           i++;
                        }
                     }
                     if(s_nightMask)
                     {
                        s_nightMask.visible = true;
                        s_nightMask.alpha = getNightMaskSceneAlpha() * m_nightMaskIntensity * m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
                     }
                     if(m_effectsContainerNightMask)
                     {
                        m_effectsContainerNightMask.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     }
                     if(s_nightSky)
                     {
                        s_nightSky.gotoAndStop(m_transitionFrame);
                     }
                     if(s_windows)
                     {
                        s_windows.gotoAndStop(m_transitionFrame);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("ERROR: " + e.message);
                  }
                  if(m_transitionFrame <= NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION)
                  {
                     setSceneTime(SCENE_TIME_DAY);
                  }
                  m_sceneTimeCounter = 0;
                  break;
               }
         }
      }
      
      public function getBackpackItemCategoryList() : Array
      {
         if(m_gameItemCategoryList)
         {
            return m_gameItemCategoryList;
         }
         return new Array();
      }
      
      protected function updateSceneTime() : void
      {
         var _loc1_:* = 0;
         if(GameClock.getInstance().getHours() > GameClock.getInstance().getDayStartHour() && GameClock.getInstance().getHours() < GameClock.getInstance().getNightStartHour())
         {
            setSceneTime(SCENE_TIME_DAY);
         }
         else if(GameClock.getInstance().getHours() > GameClock.getInstance().getNightStartHour() || GameClock.getInstance().getHours() < GameClock.getInstance().getDayStartHour())
         {
            setSceneTime(SCENE_TIME_NIGHT);
         }
         else if(GameClock.getInstance().getHours() != GameClock.getInstance().getNightStartHour())
         {
            if(GameClock.getInstance().getHours() == GameClock.getInstance().getDayStartHour())
            {
               _loc1_ = NIGHT_TRANSITION_FRAME_COUNT * GameClock.getInstance().getDayNightTransitionSpeed() / 30;
               if(GameClock.getInstance().getMinutes() < GameClock.getInstance().getDayStartMinute())
               {
                  setSceneTime(SCENE_TIME_NIGHT);
               }
               else if(GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getDayStartMinute()) * 60 < _loc1_)
               {
                  setSceneTime(SCENE_TIME_MORNING);
               }
               else
               {
                  setSceneTime(SCENE_TIME_DAY);
               }
            }
         }
         else
         {
            _loc1_ = NIGHT_TRANSITION_FRAME_COUNT * GameClock.getInstance().getDayNightTransitionSpeed() / 30;
            if(GameClock.getInstance().getMinutes() < GameClock.getInstance().getNightStartMinute())
            {
               setSceneTime(SCENE_TIME_DAY);
            }
            else if(GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getNightStartMinute()) * 60 < _loc1_)
            {
               setSceneTime(SCENE_TIME_EVENING);
            }
            else
            {
               setSceneTime(SCENE_TIME_NIGHT);
            }
         }
      }
      
      public function getSceneXOffset() : int
      {
         return 0;
      }
   }
}

