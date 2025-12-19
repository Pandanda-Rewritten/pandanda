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
         this.m_gameItemCategoryList = new Array();
         this.s_ground.visible = false;
         if(this.s_groundHorse)
         {
            this.s_groundHorse.visible = false;
         }
         if(this.s_spawnGround)
         {
            this.s_spawnGround.visible = false;
         }
         if(this.s_water)
         {
            this.s_water.visible = false;
         }
         if(this.s_fishZone)
         {
            this.s_fishZone.visible = false;
         }
         if(this.s_nightMask)
         {
            this.s_nightMask.cacheAsBitmap = true;
         }
         if(this.s_nightSky)
         {
            this.s_nightSky.gotoAndStop(1);
            this.s_nightSky.cacheAsBitmap = true;
         }
         this.m_fireflyList = new Array();
         this.m_clockTimer = new Timer(CLOCK_TIMER,0);
         this.m_clockTimer.addEventListener(TimerEvent.TIMER,this.onClockTimerListener,false,0,true);
         this.m_clockTimer.start();
         this.m_nightMaskIntensity = DEFAULT_NIGHT_MASK_INTENSITY;
         this.m_isTestingTime = false;
      }
      
      public function makePath(param1:Point, param2:Point) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = NaN;
         var _loc7_:* = null;
         _loc3_ = this.findCollisionPoints(param1,param2);
         if(_loc3_.length == 0)
         {
            if(param2 == this.m_objectExitPt)
            {
               this.m_newObject = true;
               this.m_direction = 0;
            }
            this.m_pathArray.push(param2);
            --this.m_recursiveDepth;
            return;
         }
         ++this.m_recursiveDepth;
         if(this.m_recursiveDepth > 50)
         {
            trace("RECUSIVE DEPTH TOO HIGH, BAILING");
            this.m_pathCreationFailed = true;
            return;
         }
         _loc4_ = _loc3_[0];
         _loc5_ = _loc3_[1];
         _loc6_ = Math.sqrt((_loc5_.x - _loc4_.x) * (_loc5_.x - _loc4_.x) + (_loc5_.y - _loc4_.y) * (_loc5_.y - _loc4_.y));
         if(_loc6_ < MINIMUM_AB_DIST)
         {
            return;
         }
         _loc7_ = this.findPointC(_loc4_,_loc5_);
         if(_loc7_.x == 0 && _loc7_.y == 0)
         {
            trace("crap, couldn\'t find C just bail");
            this.m_pathCreationFailed = true;
            return;
         }
         if(this.m_newObject)
         {
            this.m_newObject = false;
            this.m_objectExitPt = _loc5_;
            this.makePath(param1,_loc7_);
            this.makePath(_loc7_,_loc5_);
            if(_loc5_ != param2)
            {
               this.makePath(_loc5_,param2);
            }
         }
         else
         {
            this.makePath(param1,_loc7_);
            this.makePath(_loc7_,param2);
         }
      }
      
      public function getName() : String
      {
         return this.m_locationName;
      }
      
      public function setHalloweenSceneTime(param1:int, param2:Boolean) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         this.m_isTestingTime = param2;
         this.m_sceneTime = param1;
         _loc3_ = 0;
         var _loc5_:* = this.m_sceneTime;
         switch(_loc5_)
         {
            case SCENE_TIME_DAY:
               trace("setting day time");
               if(this.m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.m_sceneObjects.length)
                  {
                     this.m_sceneObjects[_loc3_].setNightMask(HALLOWEEN_MIN_NIGHT_TRANSITION);
                     _loc3_++;
                  }
               }
               if(this.s_nightMask)
               {
                  this.s_nightMask.visible = true;
                  this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * HALLOWEEN_MIN_NIGHT_TRANSITION;
               }
               if(this.m_effectsContainerNightMask)
               {
                  this.m_effectsContainerNightMask.setNightMask(HALLOWEEN_MIN_NIGHT_TRANSITION);
               }
               if(this.s_nightSky)
               {
                  this.s_nightSky.gotoAndStop(Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION));
               }
               if(this.s_windows)
               {
                  this.s_windows.gotoAndStop(Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION));
               }
               if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
               {
                  if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(this.m_fireworks)))
                  {
                     this.m_effectsContainer.removeChild(this.m_fireworks);
                  }
               }
               break;
            case SCENE_TIME_EVENING:
               trace("setting evening time");
               _loc4_ = GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getNightStartMinute()) * 60;
               if(this.m_isTestingTime)
               {
                  this.m_transitionFrame = Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION);
               }
               else
               {
                  this.m_transitionFrame = Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION) + _loc4_ / (GameClock.getInstance().getDayNightTransitionSpeed() / 30);
               }
               trace("transition frame : " + this.m_transitionFrame);
               if(this.m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION)
               {
                  this.m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION;
               }
               else if(this.m_transitionFrame < NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION)
               {
                  this.m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION;
               }
               if(this.m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.m_sceneObjects.length)
                  {
                     this.m_sceneObjects[_loc3_].setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     _loc3_++;
                  }
               }
               this.m_sceneTimeCounter = 0;
               if(this.s_nightMask)
               {
                  this.s_nightMask.visible = true;
                  this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
               }
               if(this.m_effectsContainerNightMask)
               {
                  this.m_effectsContainerNightMask.setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(this.s_nightSky)
               {
                  this.s_nightSky.gotoAndStop(this.m_transitionFrame);
               }
               if(this.s_windows)
               {
                  this.s_windows.gotoAndStop(this.m_transitionFrame);
               }
               break;
            case SCENE_TIME_NIGHT:
               trace("setting night time");
               if(this.m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.m_sceneObjects.length)
                  {
                     this.m_sceneObjects[_loc3_].setNightMask(HALLOWEEN_MAX_NIGHT_TRANSITION);
                     _loc3_++;
                  }
               }
               if(this.s_nightMask)
               {
                  this.s_nightMask.visible = true;
                  this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * HALLOWEEN_MAX_NIGHT_TRANSITION;
               }
               if(this.m_effectsContainerNightMask)
               {
                  this.m_effectsContainerNightMask.setNightMask(HALLOWEEN_MAX_NIGHT_TRANSITION);
               }
               if(this.s_nightSky)
               {
                  this.s_nightSky.gotoAndStop(Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION));
               }
               if(this.s_windows)
               {
                  this.s_windows.gotoAndStop(Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION));
               }
               if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
               {
                  if(Boolean(this.m_effectsContainer) && !this.m_effectsContainer.contains(this.m_fireworks))
                  {
                     this.m_effectsContainer.addChild(this.m_fireworks);
                  }
               }
               break;
            case SCENE_TIME_MORNING:
               trace("setting morning time");
               _loc4_ = GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getDayStartMinute()) * 60;
               if(this.m_isTestingTime)
               {
                  this.m_transitionFrame = Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION);
               }
               else
               {
                  this.m_transitionFrame = Math.floor(NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION) - _loc4_ / (GameClock.getInstance().getDayNightTransitionSpeed() / 30);
               }
               if(this.m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION)
               {
                  this.m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION;
               }
               else if(this.m_transitionFrame < NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION)
               {
                  this.m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION;
               }
               if(this.m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.m_sceneObjects.length)
                  {
                     this.m_sceneObjects[_loc3_].setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     _loc3_++;
                  }
               }
               this.m_sceneTimeCounter = 0;
               if(this.s_nightMask)
               {
                  this.s_nightMask.visible = true;
                  this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
               }
               if(this.m_effectsContainerNightMask)
               {
                  this.m_effectsContainerNightMask.setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(this.s_nightSky)
               {
                  this.s_nightSky.gotoAndStop(this.m_transitionFrame);
               }
               if(this.s_windows)
               {
                  this.s_windows.gotoAndStop(this.m_transitionFrame);
               }
               if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
               {
                  if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(this.m_fireworks)))
                  {
                     this.m_effectsContainer.removeChild(this.m_fireworks);
                  }
                  break;
               }
         }
      }
      
      public function setName(param1:String) : void
      {
         this.m_locationName = param1;
      }
      
      public function init() : void
      {
         this.m_sceneTime = 10;
         this.updateSceneTime();
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
            if(this.m_fireflyList.length < MAX_FIREFLIES)
            {
               _loc3_ = Math.floor(Math.random() * 935);
               _loc4_ = Math.floor(Math.random() * 600);
               _loc5_ = new Firefly();
               _loc5_.x = _loc3_;
               _loc5_.y = _loc4_;
               this.m_fireflyList.push(_loc5_);
               if(this.m_effectsContainer)
               {
                  this.m_effectsContainer.addChild(_loc5_);
               }
            }
         }
         _loc2_ = this.m_fireflyList.length - 1;
         while(_loc2_ >= 0)
         {
            this.m_fireflyList[_loc2_].update();
            if(this.m_fireflyList[_loc2_].hasExpired())
            {
               if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(this.m_fireflyList[_loc2_])))
               {
                  this.m_effectsContainer.removeChild(this.m_fireflyList[_loc2_]);
               }
               this.m_fireflyList[_loc2_].destroy();
               this.m_fireflyList.splice(_loc2_,1);
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
         this.m_pathArray = new Array();
         this.m_pathArray.length = 0;
         if(!this.s_ground)
         {
            return this.m_pathArray;
         }
         if(!this.isGroundHit(param2))
         {
            return this.m_pathArray;
         }
         this.m_direction = 0;
         this.m_recursiveDepth = 0;
         this.m_newObject = true;
         this.m_pathCreationFailed = false;
         this.m_pathArray.push(param1);
         this.makePath(param1,param2);
         if(this.m_pathCreationFailed)
         {
            this.m_pathArray.length = 0;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_pathArray.length - 1)
            {
               _loc4_ = this.m_pathArray.length - 1;
               while(_loc4_ > _loc3_ + 1)
               {
                  if(this.findCollisionPoints(this.m_pathArray[_loc3_],this.m_pathArray[_loc4_]).length == 0)
                  {
                     this.m_pathArray.splice(_loc3_ + 1,_loc4_ - _loc3_ - 1);
                     break;
                  }
                  _loc4_--;
               }
               _loc3_++;
            }
            this.m_pathArray.shift();
         }
         return this.m_pathArray;
      }
      
      public function destroy() : void
      {
         var _loc1_:* = 0;
         trace("sceneroot destroy");
         GameSound.getInstance().clearSounds();
         if(this.m_pathArray)
         {
            this.m_pathArray.length = 0;
            this.m_pathArray = null;
         }
         if(this.m_fireworks)
         {
            this.m_fireworks.destroy();
         }
         this.m_clockTimer.stop();
         this.m_clockTimer.removeEventListener(TimerEvent.TIMER,this.onClockTimerListener);
         this.m_gameItemCategoryList.length = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_fireflyList.length)
         {
            this.m_fireflyList[_loc1_].destroy();
            _loc1_++;
         }
         this.m_fireflyList.length = 0;
         this.m_fireflyList = null;
      }
      
      protected function onTimerNotice() : void
      {
      }
      
      public function isGroundHit(param1:Point, param2:Boolean = false) : Boolean
      {
         if(!this.s_ground)
         {
            trace("ERROR: ground not loaded to SceneRoot");
            return false;
         }
         if(param2 && Boolean(this.s_groundHorse))
         {
            return this.s_groundHorse.hitTestPoint(param1.x,param1.y,true);
         }
         return this.s_ground.hitTestPoint(param1.x,param1.y,true);
      }
      
      public function setSceneXOffset(param1:int) : void
      {
      }
      
      public function isWaterHit(param1:Point) : Boolean
      {
         if(!this.s_water)
         {
            return false;
         }
         return this.s_water.hitTestPoint(param1.x,param1.y,true);
      }
      
      internal function onClockTimerListener(param1:TimerEvent) : void
      {
         if(!this.m_isTestingTime)
         {
            this.updateSceneTime();
         }
         this.onTimerNotice();
      }
      
      public function setSceneTime(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(GameConstants.ACTIVE_FESTIVAL == GameConstants.PUMPKIN_FESTIVAL)
         {
            this.setHalloweenSceneTime(param1,param2);
            return;
         }
         this.m_isTestingTime = param2;
         this.m_sceneTime = param1;
         _loc3_ = 0;
         var _loc5_:* = this.m_sceneTime;
         switch(_loc5_)
         {
            case SCENE_TIME_DAY:
               trace("setting day time");
               if(this.m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.m_sceneObjects.length)
                  {
                     this.m_sceneObjects[_loc3_].setNightMask(0);
                     _loc3_++;
                  }
               }
               if(this.s_nightMask)
               {
                  this.s_nightMask.visible = false;
               }
               if(this.m_effectsContainerNightMask)
               {
                  this.m_effectsContainerNightMask.setNightMask(0);
               }
               if(this.s_nightSky)
               {
                  this.s_nightSky.gotoAndStop(1);
               }
               if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
               {
                  if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(this.m_fireworks)))
                  {
                     this.m_effectsContainer.removeChild(this.m_fireworks);
                  }
               }
               break;
            case SCENE_TIME_EVENING:
               trace("setting evening time");
               _loc4_ = GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getNightStartMinute()) * 60;
               if(param2)
               {
                  this.m_transitionFrame = 0;
               }
               else
               {
                  this.m_transitionFrame = _loc4_ / (GameClock.getInstance().getDayNightTransitionSpeed() / 30);
               }
               if(this.m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT)
               {
                  this.m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT;
               }
               else if(this.m_transitionFrame < 0)
               {
                  this.m_transitionFrame = 0;
               }
               if(this.m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.m_sceneObjects.length)
                  {
                     this.m_sceneObjects[_loc3_].setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     _loc3_++;
                  }
               }
               this.m_sceneTimeCounter = 0;
               if(this.s_nightMask)
               {
                  this.s_nightMask.visible = true;
                  this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
               }
               if(this.m_effectsContainerNightMask)
               {
                  this.m_effectsContainerNightMask.setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(this.s_nightSky)
               {
                  this.s_nightSky.gotoAndStop(this.m_transitionFrame);
               }
               if(this.s_windows)
               {
                  this.s_windows.gotoAndStop(this.m_transitionFrame);
               }
               break;
            case SCENE_TIME_NIGHT:
               trace("setting night time");
               if(this.m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.m_sceneObjects.length)
                  {
                     this.m_sceneObjects[_loc3_].setNightMask(1);
                     _loc3_++;
                  }
               }
               if(this.s_nightMask)
               {
                  this.s_nightMask.visible = true;
                  this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity;
               }
               if(this.m_effectsContainerNightMask)
               {
                  this.m_effectsContainerNightMask.setNightMask(1);
               }
               if(this.s_nightSky)
               {
                  this.s_nightSky.gotoAndStop(NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(this.s_windows)
               {
                  this.s_windows.gotoAndStop(NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
               {
                  if(Boolean(this.m_effectsContainer) && !this.m_effectsContainer.contains(this.m_fireworks))
                  {
                     this.m_effectsContainer.addChild(this.m_fireworks);
                  }
               }
               break;
            case SCENE_TIME_MORNING:
               trace("setting morning time");
               _loc4_ = GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getDayStartMinute()) * 60;
               if(param2)
               {
                  this.m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT;
               }
               else
               {
                  this.m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT - _loc4_ / (GameClock.getInstance().getDayNightTransitionSpeed() / 30);
               }
               if(this.m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT)
               {
                  this.m_transitionFrame = NIGHT_TRANSITION_FRAME_COUNT;
               }
               else if(this.m_transitionFrame < 0)
               {
                  this.m_transitionFrame = 0;
               }
               if(this.m_sceneObjects)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.m_sceneObjects.length)
                  {
                     this.m_sceneObjects[_loc3_].setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     _loc3_++;
                  }
               }
               this.m_sceneTimeCounter = 0;
               if(this.s_nightMask)
               {
                  this.s_nightMask.visible = true;
                  this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
               }
               if(this.m_effectsContainerNightMask)
               {
                  this.m_effectsContainerNightMask.setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               if(this.s_nightSky)
               {
                  this.s_nightSky.gotoAndStop(this.m_transitionFrame);
               }
               if(this.s_windows)
               {
                  this.s_windows.gotoAndStop(this.m_transitionFrame);
               }
               if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
               {
                  if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(this.m_fireworks)))
                  {
                     this.m_effectsContainer.removeChild(this.m_fireworks);
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
         if(!this.s_fishZone)
         {
            return false;
         }
         return this.s_fishZone.hitTestPoint(param1.x,param1.y,true);
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
            this.updateHalloweenScene();
            return;
         }
         i = 0;
         if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
         {
            if(this.m_effectsContainer)
            {
               if(this.m_effectsContainer.contains(this.m_fireworks))
               {
                  this.m_fireworks.update(this.getSceneXOffset());
               }
            }
         }
         loc2 = this.m_sceneTime;
         switch(loc2)
         {
            case SCENE_TIME_DAY:
               break;
            case SCENE_TIME_EVENING:
               ++this.m_sceneTimeCounter;
               if(this.m_sceneTimeCounter > GameClock.getInstance().getDayNightTransitionSpeed())
               {
                  this.m_transitionFrame += 1;
                  try
                  {
                     if(this.m_sceneObjects)
                     {
                        i = 0;
                        while(i < this.m_sceneObjects.length)
                        {
                           this.m_sceneObjects[i].setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                           i++;
                        }
                     }
                     if(this.s_nightMask)
                     {
                        this.s_nightMask.visible = true;
                        this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
                     }
                     if(this.m_effectsContainerNightMask)
                     {
                        this.m_effectsContainerNightMask.setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     }
                     if(this.s_nightSky)
                     {
                        this.s_nightSky.gotoAndStop(this.m_transitionFrame);
                     }
                     if(this.s_windows)
                     {
                        this.s_windows.gotoAndStop(this.m_transitionFrame);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("ERROR: " + e.message);
                  }
                  if(this.m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT)
                  {
                     this.setSceneTime(SCENE_TIME_NIGHT);
                  }
                  this.m_sceneTimeCounter = 0;
               }
               break;
            case SCENE_TIME_NIGHT:
               break;
            case SCENE_TIME_MORNING:
               ++this.m_sceneTimeCounter;
               if(this.m_sceneTimeCounter > GameClock.getInstance().getDayNightTransitionSpeed())
               {
                  --this.m_transitionFrame;
                  try
                  {
                     if(this.m_sceneObjects)
                     {
                        i = 0;
                        while(i < this.m_sceneObjects.length)
                        {
                           this.m_sceneObjects[i].setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                           i++;
                        }
                     }
                     if(this.s_nightMask)
                     {
                        this.s_nightMask.visible = true;
                        this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
                     }
                     if(this.m_effectsContainerNightMask)
                     {
                        this.m_effectsContainerNightMask.setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     }
                     if(this.s_nightSky)
                     {
                        this.s_nightSky.gotoAndStop(this.m_transitionFrame);
                     }
                     if(this.s_windows)
                     {
                        this.s_windows.gotoAndStop(this.m_transitionFrame);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("ERROR: " + e.message);
                  }
                  if(this.m_transitionFrame <= 0)
                  {
                     this.setSceneTime(SCENE_TIME_DAY);
                  }
                  this.m_sceneTimeCounter = 0;
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
            if(this.isGroundHit(_loc8_))
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
         this.m_effectsContainer = param1;
         param1.mouseEnabled = false;
         if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
         {
            param1.addChild(this.m_fireworks);
         }
         if(this.m_effectsContainerNightMask)
         {
            param1.addChild(this.m_effectsContainerNightMask);
         }
      }
      
      public function getAvatarWalkingPath(param1:Point, param2:Point) : Array
      {
         return this.getWalkingPath(param1,param2);
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
            if(!this.m_direction || this.m_direction == 1)
            {
               _loc7_.x = _loc3_.x + _loc4_.x * _loc9_;
               _loc7_.y = _loc3_.y + _loc4_.y * _loc9_;
               if(this.isGroundHit(_loc7_))
               {
                  _loc8_ = _loc7_;
                  this.m_direction = 1;
                  break;
               }
            }
            if(!this.m_direction || this.m_direction == 2)
            {
               _loc7_.x = _loc3_.x + _loc5_.x * _loc9_;
               _loc7_.y = _loc3_.y + _loc5_.y * _loc9_;
               if(this.isGroundHit(_loc7_))
               {
                  _loc8_ = _loc7_;
                  this.m_direction = 2;
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
            return this.s_spawnGround;
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
         if(SHOW_FIREWORKS && Boolean(this.m_fireworks))
         {
            if(this.m_effectsContainer)
            {
               if(this.m_effectsContainer.contains(this.m_fireworks))
               {
                  this.m_fireworks.update(this.getSceneXOffset());
               }
            }
         }
         loc2 = this.m_sceneTime;
         switch(loc2)
         {
            case SCENE_TIME_DAY:
               break;
            case SCENE_TIME_EVENING:
               ++this.m_sceneTimeCounter;
               if(this.m_sceneTimeCounter > GameClock.getInstance().getDayNightTransitionSpeed())
               {
                  this.m_transitionFrame += 1;
                  try
                  {
                     if(this.m_sceneObjects)
                     {
                        i = 0;
                        while(i < this.m_sceneObjects.length)
                        {
                           this.m_sceneObjects[i].setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                           i++;
                        }
                     }
                     if(this.s_nightMask)
                     {
                        this.s_nightMask.visible = true;
                        this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
                     }
                     if(this.m_effectsContainerNightMask)
                     {
                        this.m_effectsContainerNightMask.setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     }
                     if(this.s_nightSky)
                     {
                        this.s_nightSky.gotoAndStop(this.m_transitionFrame);
                     }
                     if(this.s_windows)
                     {
                        this.s_windows.gotoAndStop(this.m_transitionFrame);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("ERROR: " + e.message);
                  }
                  if(this.m_transitionFrame >= NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MAX_NIGHT_TRANSITION)
                  {
                     this.setSceneTime(SCENE_TIME_NIGHT);
                  }
                  this.m_sceneTimeCounter = 0;
               }
               break;
            case SCENE_TIME_NIGHT:
               break;
            case SCENE_TIME_MORNING:
               ++this.m_sceneTimeCounter;
               if(this.m_sceneTimeCounter > GameClock.getInstance().getDayNightTransitionSpeed())
               {
                  --this.m_transitionFrame;
                  try
                  {
                     if(this.m_sceneObjects)
                     {
                        i = 0;
                        while(i < this.m_sceneObjects.length)
                        {
                           this.m_sceneObjects[i].setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                           i++;
                        }
                     }
                     if(this.s_nightMask)
                     {
                        this.s_nightMask.visible = true;
                        this.s_nightMask.alpha = this.getNightMaskSceneAlpha() * this.m_nightMaskIntensity * this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT;
                     }
                     if(this.m_effectsContainerNightMask)
                     {
                        this.m_effectsContainerNightMask.setNightMask(this.m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                     }
                     if(this.s_nightSky)
                     {
                        this.s_nightSky.gotoAndStop(this.m_transitionFrame);
                     }
                     if(this.s_windows)
                     {
                        this.s_windows.gotoAndStop(this.m_transitionFrame);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("ERROR: " + e.message);
                  }
                  if(this.m_transitionFrame <= NIGHT_TRANSITION_FRAME_COUNT * HALLOWEEN_MIN_NIGHT_TRANSITION)
                  {
                     this.setSceneTime(SCENE_TIME_DAY);
                  }
                  this.m_sceneTimeCounter = 0;
                  break;
               }
         }
      }
      
      public function getBackpackItemCategoryList() : Array
      {
         if(this.m_gameItemCategoryList)
         {
            return this.m_gameItemCategoryList;
         }
         return new Array();
      }
      
      protected function updateSceneTime() : void
      {
         var _loc1_:* = 0;
         if(GameClock.getInstance().getHours() > GameClock.getInstance().getDayStartHour() && GameClock.getInstance().getHours() < GameClock.getInstance().getNightStartHour())
         {
            this.setSceneTime(SCENE_TIME_DAY);
         }
         else if(GameClock.getInstance().getHours() > GameClock.getInstance().getNightStartHour() || GameClock.getInstance().getHours() < GameClock.getInstance().getDayStartHour())
         {
            this.setSceneTime(SCENE_TIME_NIGHT);
         }
         else if(GameClock.getInstance().getHours() != GameClock.getInstance().getNightStartHour())
         {
            if(GameClock.getInstance().getHours() == GameClock.getInstance().getDayStartHour())
            {
               _loc1_ = NIGHT_TRANSITION_FRAME_COUNT * GameClock.getInstance().getDayNightTransitionSpeed() / 30;
               if(GameClock.getInstance().getMinutes() < GameClock.getInstance().getDayStartMinute())
               {
                  this.setSceneTime(SCENE_TIME_NIGHT);
               }
               else if(GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getDayStartMinute()) * 60 < _loc1_)
               {
                  this.setSceneTime(SCENE_TIME_MORNING);
               }
               else
               {
                  this.setSceneTime(SCENE_TIME_DAY);
               }
            }
         }
         else
         {
            _loc1_ = NIGHT_TRANSITION_FRAME_COUNT * GameClock.getInstance().getDayNightTransitionSpeed() / 30;
            if(GameClock.getInstance().getMinutes() < GameClock.getInstance().getNightStartMinute())
            {
               this.setSceneTime(SCENE_TIME_DAY);
            }
            else if(GameClock.getInstance().getSeconds() + (GameClock.getInstance().getMinutes() - GameClock.getInstance().getNightStartMinute()) * 60 < _loc1_)
            {
               this.setSceneTime(SCENE_TIME_EVENING);
            }
            else
            {
               this.setSceneTime(SCENE_TIME_NIGHT);
            }
         }
      }
      
      public function getSceneXOffset() : int
      {
         return 0;
      }
   }
}

