package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.text.*;
   
   public class PurpleDoorScene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.55;
      
      private static const PLATFORM_LOWERED_TIME:int = 150;
      
      private static const PLATFORM_RAISED_TIME:int = 100;
      
      private static const MUSIC_TRACK_LEGNTH:int = 2;
      
      private static const TOTAL_MUSIC_TRACKS:int = 2;
      
      private static const DEBUG:* = 0;
      
      private var m_platform:PurpleDoorDance;
      
      public var s_wall:PurpleDoorWallEffects;
      
      private var m_couchFront:PurpleDoorCouchFront;
      
      private var m_table2:PurpleDoorTable;
      
      private var m_table3:PurpleDoorTable;
      
      private var m_table1:PurpleDoorTable;
      
      private var m_platformCounter:int;
      
      private var m_interactiveContainer:Sprite;
      
      private var m_couchBack:PurpleDoorCouchBack;
      
      private var m_prevGraphicsQuality:int;
      
      public var s_exitLeft:Sprite;
      
      public var s_fish:MovieClip;
      
      public var s_background:Sprite;
      
      public var s_speakersLeft:MovieClip;
      
      public var s_ceiling:PurpleDoorCeiling;
      
      public var s_nightMaskPermanent:Sprite;
      
      public var s_speakersRight:MovieClip;
      
      private var m_column:PurpleDoorColumn;
      
      private var m_avatarScaleLimits:Array;
      
      private var m_isPlatformRaised:Boolean;
      
      private var m_column1:PurpleDoorColumn1;
      
      private var m_spawnPoint:Point;
      
      public function PurpleDoorScene()
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("PurpleDoorScene Constructor");
         m_spawnPoint = new Point(465,450);
         m_avatarScaleLimits = new Array(0.5,1);
         s_background.mouseEnabled = false;
         s_background.cacheAsBitmap = true;
         s_exitLeft.visible = false;
         s_nightMaskPermanent.mouseEnabled = false;
         s_nightMaskPermanent.mouseChildren = false;
         s_nightMaskPermanent.cacheAsBitmap = true;
         m_table1 = new PurpleDoorTable();
         m_table1.x = 37;
         m_table1.y = 390;
         m_table1.width = 63;
         m_table1.height = 61;
         m_table1.setYDepth(433);
         m_table2 = new PurpleDoorTable();
         m_table2.x = 140;
         m_table2.y = 357;
         m_table2.width = 63;
         m_table2.height = 61;
         m_table2.setYDepth(400);
         m_table3 = new PurpleDoorTable();
         m_table3.x = 96;
         m_table3.y = 448;
         m_table3.width = 63;
         m_table3.height = 61;
         m_table3.setYDepth(491);
         m_couchFront = new PurpleDoorCouchFront();
         m_couchFront.x = 58;
         m_couchFront.y = 488;
         m_couchFront.width = 132;
         m_couchFront.height = 34;
         m_couchFront.setYDepth(503);
         m_couchBack = new PurpleDoorCouchBack();
         m_couchBack.x = 37;
         m_couchBack.y = 492;
         m_couchBack.width = 175;
         m_couchBack.height = 80;
         m_couchBack.setYDepth(544);
         m_column = new PurpleDoorColumn();
         m_column.x = 670;
         m_column.y = 72;
         m_column.width = 129;
         m_column.height = 367;
         m_column.setYDepth(391);
         m_column1 = new PurpleDoorColumn1();
         m_column1.x = 864;
         m_column1.y = 0;
         m_column1.width = 71;
         m_column1.height = 566;
         m_column1.setYDepth(520);
         m_platform = new PurpleDoorDance();
         m_platform.x = 342;
         m_platform.y = 397;
         m_platform.width = 130;
         m_platform.height = 88;
         m_platform.setYDepth(412);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_table1);
         m_sceneObjects.push(m_table2);
         m_sceneObjects.push(m_table3);
         m_sceneObjects.push(m_couchFront);
         m_sceneObjects.push(m_couchBack);
         m_sceneObjects.push(m_column);
         m_sceneObjects.push(m_column1);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         m_platformCounter = PLATFORM_LOWERED_TIME;
         m_isPlatformRaised = false;
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         updateSceneTime();
         m_prevGraphicsQuality = GameOptions.getInstance().getAntiAliasing();
         if(GameOptions.getInstance().getAntiAliasing() == GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            s_fish.s_alive.gotoAndStop(1);
            s_fish.s_alive.visible = false;
            s_fish.s_dead.visible = true;
            s_fish.cacheAsBitmap = true;
            s_wall.setLowQuality();
            s_ceiling.setLowQuality();
         }
         else
         {
            s_fish.s_dead.visible = false;
         }
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
         s_wall.destroy();
         s_ceiling.destroy();
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
      
      override public function init() : void
      {
         var _loc1_:int = 0;
         super.init();
         _loc1_ = GameClock.getInstance().getMinutes() / MUSIC_TRACK_LEGNTH % GameSound.getInstance().getMusicListSize();
         GameSound.getInstance().setMusicTrack(_loc1_);
      }
      
      override protected function onTimerNotice() : void
      {
         var _loc1_:int = 0;
         _loc1_ = GameClock.getInstance().getMinutes() / MUSIC_TRACK_LEGNTH % GameSound.getInstance().getMusicListSize();
         if(_loc1_ != GameSound.getInstance().getMusicTrack())
         {
            GameSound.getInstance().setMusicTrack(_loc1_);
         }
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
         if(m_prevGraphicsQuality == GameOptions.getInstance().getAntiAliasing())
         {
            if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
            {
               s_wall.update();
               s_ceiling.update();
            }
         }
         else
         {
            if(GameOptions.getInstance().getAntiAliasing() == GameOptions.OPTIONS_ANTIALIASING_LOW)
            {
               s_wall.setLowQuality();
               s_ceiling.setLowQuality();
            }
            m_prevGraphicsQuality = GameOptions.getInstance().getAntiAliasing();
         }
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
         if(s_exitLeft.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_TOWN_SQUARE2;
         }
         return null;
      }
      
      public function getSceneObjects(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         m_interactiveContainer = param1;
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
         return "ground";
      }
   }
}

