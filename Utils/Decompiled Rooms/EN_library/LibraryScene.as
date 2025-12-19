package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class LibraryScene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.75;
      
      private static const DEBUG:* = 0;
      
      public var s_gameTable3:MiniGameHotSpot;
      
      public var s_gameTable2:MiniGameHotSpot;
      
      private var m_chairPurple:LibraryChairPurple;
      
      public var s_gameTable1:MiniGameHotSpot;
      
      public var s_exitToParlour:Sprite;
      
      private var m_chairOrange:LibraryChairOrange;
      
      private var m_chairYellow:LibraryChairYellow;
      
      private var m_fire:LibraryFire;
      
      public var s_exitRight:Sprite;
      
      public var s_chimneyMask:MovieClip;
      
      private var m_chimneyRight:LibraryChimneyRight;
      
      private var m_chimneyLeft:LibraryChimneyLeft;
      
      private var m_avatarScaleLimits:Array;
      
      public var library_mc:Sprite;
      
      private var m_dragonLeg:LibraryDragonLeg;
      
      private var m_dragonHead:LibraryDragonHead;
      
      public var s_secretDoor:LibrarySecretDoorButton;
      
      private var m_spawnPoint:Point;
      
      public function LibraryScene()
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("LibraryScene Constructor");
         m_spawnPoint = new Point(465,450);
         m_avatarScaleLimits = new Array(0.8,1.05);
         s_chimneyMask.s_mymask.cacheAsBitmap = true;
         s_chimneyMask.s_myclip.cacheAsBitmap = true;
         s_chimneyMask.s_myclip.mask = s_chimneyMask.s_mymask;
         library_mc.mouseEnabled = false;
         library_mc.cacheAsBitmap = true;
         s_exitRight.visible = false;
         s_exitToParlour.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         s_nightSky.s_skyGradient.cacheAsBitmap = true;
         m_chimneyRight = new LibraryChimneyRight();
         m_chimneyRight.x = 480;
         m_chimneyRight.y = 0;
         m_chimneyRight.width = 202;
         m_chimneyRight.height = 458;
         m_chimneyRight.setYDepth(398);
         m_chimneyLeft = new LibraryChimneyLeft();
         m_chimneyLeft.x = 482;
         m_chimneyLeft.y = 294;
         m_chimneyLeft.width = 95;
         m_chimneyLeft.height = 164;
         m_chimneyLeft.setYDepth(434);
         m_fire = new LibraryFire();
         m_fire.x = 543;
         m_fire.y = 300;
         m_fire.width = 183;
         m_fire.height = 179;
         m_fire.setYDepth(420);
         m_chairPurple = new LibraryChairPurple();
         m_chairPurple.x = 390;
         m_chairPurple.y = 312;
         m_chairPurple.width = 116;
         m_chairPurple.height = 64;
         m_chairPurple.setYDepth(332);
         m_chairOrange = new LibraryChairOrange();
         m_chairOrange.x = 349;
         m_chairOrange.y = 402;
         m_chairOrange.width = 100;
         m_chairOrange.height = 71;
         m_chairOrange.setYDepth(422);
         m_chairYellow = new LibraryChairYellow();
         m_chairYellow.x = 634;
         m_chairYellow.y = 410;
         m_chairYellow.width = 121;
         m_chairYellow.height = 86;
         m_chairYellow.setYDepth(440);
         m_dragonLeg = new LibraryDragonLeg();
         m_dragonLeg.x = 169;
         m_dragonLeg.y = 118;
         m_dragonLeg.width = 105;
         m_dragonLeg.height = 248;
         m_dragonLeg.setYDepth(343);
         m_dragonHead = new LibraryDragonHead();
         m_dragonHead.x = 30;
         m_dragonHead.y = 306;
         m_dragonHead.width = 166;
         m_dragonHead.height = 175;
         m_dragonHead.setYDepth(396);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_chimneyRight);
         m_sceneObjects.push(m_chimneyLeft);
         m_sceneObjects.push(m_fire);
         m_sceneObjects.push(m_chairPurple);
         m_sceneObjects.push(m_chairOrange);
         m_sceneObjects.push(m_chairYellow);
         m_sceneObjects.push(m_dragonLeg);
         m_sceneObjects.push(m_dragonHead);
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
         s_secretDoor.destroy();
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
         if(s_exitRight.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_VILLAGE;
         }
         if(s_exitToParlour.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_PARLOUR;
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
            return "MG004a";
         }
         if(s_gameTable2.hitTestPoint(mouseX,mouseY,true))
         {
            return "MG004b";
         }
         if(s_gameTable3.hitTestPoint(mouseX,mouseY,true))
         {
            return "MG004c";
         }
         return new String();
      }
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(s_exitRight.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitToParlour.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

