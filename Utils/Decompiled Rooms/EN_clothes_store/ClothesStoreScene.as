package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class ClothesStoreScene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.75;
      
      private static const DEBUG:* = 0;
      
      public var clothesStore_mc:Sprite;
      
      private var m_centerCurtain:ClothesStoreRightCurtain;
      
      private var m_island:ClothesStoreIsland;
      
      private var m_counterright:ClothesStoreCounter;
      
      public var s_exitLeft:Sprite;
      
      private var m_backrightshelves:ClothesStoreBackRightShelves;
      
      public var s_curtainMask:MovieClip;
      
      public var s_nightMaskPermanent:Sprite;
      
      private var m_counterleft:ClothesStoreCounterLeft;
      
      private var m_rightshelves:ClothesStoreRightShelves;
      
      private var m_backleftshelves:ClothesStoreBackLeftShelves;
      
      private var m_rightCurtain:ClothesStoreRightCurtain;
      
      private var m_avatarScaleLimits:Array;
      
      private var m_leftCurtain:ClothesStoreRightCurtain;
      
      private var m_spawnPoint:Point;
      
      public function ClothesStoreScene()
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("ClothesStoreScene Constructor");
         m_spawnPoint = new Point(330,450);
         m_avatarScaleLimits = new Array(0.8,1);
         clothesStore_mc.mouseEnabled = false;
         clothesStore_mc.cacheAsBitmap = true;
         s_nightMaskPermanent.mouseEnabled = false;
         s_nightMaskPermanent.mouseChildren = false;
         s_nightMaskPermanent.cacheAsBitmap = true;
         s_exitLeft.visible = false;
         s_curtainMask.s_leftMask.cacheAsBitmap = true;
         s_curtainMask.s_curtainLeft.cacheAsBitmap = true;
         s_curtainMask.s_curtainLeft.mask = s_curtainMask.s_leftMask;
         s_curtainMask.s_middleMask.cacheAsBitmap = true;
         s_curtainMask.s_curtainMiddle.cacheAsBitmap = true;
         s_curtainMask.s_curtainMiddle.mask = s_curtainMask.s_middleMask;
         s_curtainMask.s_rightMask.cacheAsBitmap = true;
         s_curtainMask.s_curtainRight.cacheAsBitmap = true;
         s_curtainMask.s_curtainRight.mask = s_curtainMask.s_rightMask;
         m_counterright = new ClothesStoreCounter();
         m_counterright.x = 131;
         m_counterright.y = 263;
         m_counterright.width = 169;
         m_counterright.height = 158;
         m_counterright.setYDepth(323);
         m_counterleft = new ClothesStoreCounterLeft();
         m_counterleft.x = 130;
         m_counterleft.y = 263;
         m_counterleft.width = 179;
         m_counterleft.height = 156;
         m_counterleft.setYDepth(411);
         m_backleftshelves = new ClothesStoreBackLeftShelves();
         m_backleftshelves.x = 322;
         m_backleftshelves.y = 20;
         m_backleftshelves.width = 107;
         m_backleftshelves.height = 285;
         m_backleftshelves.setYDepth(299);
         m_backrightshelves = new ClothesStoreBackRightShelves();
         m_backrightshelves.x = 500;
         m_backrightshelves.y = 20;
         m_backrightshelves.width = 107;
         m_backrightshelves.height = 285;
         m_backrightshelves.setYDepth(299);
         m_rightshelves = new ClothesStoreRightShelves();
         m_rightshelves.x = 821;
         m_rightshelves.y = 1;
         m_rightshelves.width = 115;
         m_rightshelves.height = 542;
         m_rightshelves.setYDepth(426);
         m_island = new ClothesStoreIsland();
         m_island.x = 473;
         m_island.y = 234;
         m_island.width = 152;
         m_island.height = 231;
         m_island.setYDepth(448);
         m_rightCurtain = new ClothesStoreRightCurtain();
         m_rightCurtain.x = 595;
         m_rightCurtain.y = 113;
         m_rightCurtain.width = 91;
         m_rightCurtain.height = 174;
         m_rightCurtain.setYDepth(280);
         m_centerCurtain = new ClothesStoreRightCurtain();
         m_centerCurtain.x = 419;
         m_centerCurtain.y = 113;
         m_centerCurtain.width = 91;
         m_centerCurtain.height = 174;
         m_centerCurtain.setYDepth(280);
         m_leftCurtain = new ClothesStoreRightCurtain();
         m_leftCurtain.x = 242;
         m_leftCurtain.y = 113;
         m_leftCurtain.width = 91;
         m_leftCurtain.height = 174;
         m_leftCurtain.setYDepth(280);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_counterright);
         m_sceneObjects.push(m_counterleft);
         m_sceneObjects.push(m_backleftshelves);
         m_sceneObjects.push(m_backrightshelves);
         m_sceneObjects.push(m_rightshelves);
         m_sceneObjects.push(m_island);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         m_sceneObjects.push(m_rightCurtain);
         m_sceneObjects.push(m_centerCurtain);
         m_sceneObjects.push(m_leftCurtain);
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         updateSceneTime();
         m_leftCurtain.addEventListener(MouseEvent.ROLL_OVER,onRollOverListener,false,0,true);
         m_leftCurtain.addEventListener(MouseEvent.ROLL_OUT,onRollOutListener,false,0,true);
         m_centerCurtain.addEventListener(MouseEvent.ROLL_OVER,onRollOverListener,false,0,true);
         m_centerCurtain.addEventListener(MouseEvent.ROLL_OUT,onRollOutListener,false,0,true);
         m_rightCurtain.addEventListener(MouseEvent.ROLL_OVER,onRollOverListener,false,0,true);
         m_rightCurtain.addEventListener(MouseEvent.ROLL_OUT,onRollOutListener,false,0,true);
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
         m_leftCurtain.removeEventListener(MouseEvent.ROLL_OVER,onRollOverListener);
         m_leftCurtain.removeEventListener(MouseEvent.ROLL_OUT,onRollOutListener);
         m_centerCurtain.removeEventListener(MouseEvent.ROLL_OVER,onRollOverListener);
         m_centerCurtain.removeEventListener(MouseEvent.ROLL_OUT,onRollOutListener);
         m_rightCurtain.removeEventListener(MouseEvent.ROLL_OVER,onRollOverListener);
         m_rightCurtain.removeEventListener(MouseEvent.ROLL_OUT,onRollOutListener);
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
      
      private function onRollOverListener(param1:MouseEvent) : void
      {
         var _loc2_:ClothesStoreRightCurtain = null;
         if(param1.currentTarget == m_leftCurtain)
         {
            _loc2_ = s_curtainMask.s_curtainLeft;
         }
         else if(param1.currentTarget == m_centerCurtain)
         {
            _loc2_ = s_curtainMask.s_curtainMiddle;
         }
         else if(param1.currentTarget == m_rightCurtain)
         {
            _loc2_ = s_curtainMask.s_curtainRight;
         }
         if(_loc2_)
         {
            _loc2_.s_close.visible = false;
            _loc2_.s_open.visible = true;
            _loc2_.s_open.gotoAndPlay(1);
         }
         param1.currentTarget.s_close.visible = false;
         param1.currentTarget.s_open.visible = true;
         param1.currentTarget.s_open.gotoAndPlay(1);
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
         if(s_exitLeft.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_TOWN_SQUARE;
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
      
      private function onRollOutListener(param1:MouseEvent) : void
      {
         var _loc2_:ClothesStoreRightCurtain = null;
         if(param1.currentTarget == m_leftCurtain)
         {
            _loc2_ = s_curtainMask.s_curtainLeft;
         }
         else if(param1.currentTarget == m_centerCurtain)
         {
            _loc2_ = s_curtainMask.s_curtainMiddle;
         }
         else if(param1.currentTarget == m_rightCurtain)
         {
            _loc2_ = s_curtainMask.s_curtainRight;
         }
         if(_loc2_)
         {
            _loc2_.s_open.visible = false;
            _loc2_.s_close.visible = true;
            _loc2_.s_close.gotoAndPlay(1);
         }
         param1.currentTarget.s_open.visible = false;
         param1.currentTarget.s_close.visible = true;
         param1.currentTarget.s_close.gotoAndPlay(1);
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

