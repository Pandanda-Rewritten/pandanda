package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class StonehengeScene extends SceneRoot implements IScene
   {
      
      private static const DEBUG:* = 0;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.6;
      
      private var m_plant:StonehengePlant;
      
      private var m_rockRight:StonehengeRockRight;
      
      public var Clouds_MC:MovieClip;
      
      public var s_exitToGreen:Sprite;
      
      private var m_rockLeftBorder:StonehengeRockLeftBorder;
      
      private var m_rockLeft:StonehengeRockLeft;
      
      public var direction_left:SimpleButton;
      
      private var m_flame:StonehengeFlame;
      
      private var m_rockRightBorder:StonehengeRockRightBorder;
      
      private var m_rockCenter:StonehengeRockCenter;
      
      public var direction_right:SimpleButton;
      
      public var s_exitToBlue:Sprite;
      
      private var m_rockFlowers:StonehengeRockFlowers;
      
      public var s_objectMasks:MovieClip;
      
      public var stonehenge_mc:Sprite;
      
      private var m_avatarScaleLimits:Array;
      
      private var m_flowers:StonehengeFlowers;
      
      private var m_spawnPoint:Point;
      
      public function StonehengeScene()
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         super();
         trace("StonehengeScene Constructor");
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         m_spawnPoint = new Point(400,400);
         m_avatarScaleLimits = new Array(0.6,1);
         if(SHOW_FIREWORKS)
         {
            m_fireworks = new Fireworks(100);
         }
         stonehenge_mc.mouseEnabled = false;
         stonehenge_mc.cacheAsBitmap = true;
         s_exitToBlue.visible = false;
         s_exitToGreen.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         s_objectMasks.s_leftMask.cacheAsBitmap = true;
         s_objectMasks.s_leftClip.cacheAsBitmap = true;
         s_objectMasks.s_leftClip.mask = s_objectMasks.s_leftMask;
         s_objectMasks.s_rightMask.cacheAsBitmap = true;
         s_objectMasks.s_rightClip.cacheAsBitmap = true;
         s_objectMasks.s_rightClip.mask = s_objectMasks.s_rightMask;
         s_objectMasks.s_centerMask.cacheAsBitmap = true;
         s_objectMasks.s_centerClip.cacheAsBitmap = true;
         s_objectMasks.s_centerClip.mask = s_objectMasks.s_centerMask;
         m_effectsContainerNightMask = new StonehengeNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         m_rockLeft = new StonehengeRockLeft();
         m_rockLeft.x = 167;
         m_rockLeft.y = 140;
         m_rockLeft.width = 114;
         m_rockLeft.height = 216;
         m_rockLeft.setYDepth(330);
         m_rockRight = new StonehengeRockRight();
         m_rockRight.x = 471;
         m_rockRight.y = 130;
         m_rockRight.width = 197;
         m_rockRight.height = 328;
         m_rockRight.setYDepth(434);
         m_rockCenter = new StonehengeRockCenter();
         m_rockCenter.x = 441;
         m_rockCenter.y = 186;
         m_rockCenter.width = 79;
         m_rockCenter.height = 128;
         m_rockCenter.setYDepth(291);
         m_plant = new StonehengePlant();
         m_plant.x = 201;
         m_plant.y = 301;
         m_plant.width = 80;
         m_plant.height = 85;
         m_plant.setYDepth(364);
         m_flowers = new StonehengeFlowers();
         m_flowers.x = 371;
         m_flowers.y = 450;
         m_flowers.width = 108;
         m_flowers.height = 62;
         m_flowers.setYDepth(510);
         m_rockFlowers = new StonehengeRockFlowers();
         m_rockFlowers.x = 563;
         m_rockFlowers.y = 404;
         m_rockFlowers.width = 145;
         m_rockFlowers.height = 81;
         m_rockFlowers.setYDepth(454);
         m_flame = new StonehengeFlame();
         m_flame.x = 589;
         m_flame.y = 253;
         m_flame.width = 98;
         m_flame.height = 128;
         m_flame.setYDepth(452);
         m_rockLeftBorder = new StonehengeRockLeftBorder();
         m_rockLeftBorder.x = 0;
         m_rockLeftBorder.y = 166;
         m_rockLeftBorder.width = 153;
         m_rockLeftBorder.height = 439;
         m_rockLeftBorder.setYDepth(601);
         m_rockRightBorder = new StonehengeRockRightBorder();
         m_rockRightBorder.x = 792;
         m_rockRightBorder.y = 29;
         m_rockRightBorder.width = 150;
         m_rockRightBorder.height = 603;
         m_rockRightBorder.setYDepth(602);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_rockLeft);
         m_sceneObjects.push(m_rockRight);
         m_sceneObjects.push(m_rockCenter);
         m_sceneObjects.push(m_plant);
         m_sceneObjects.push(m_flowers);
         m_sceneObjects.push(m_rockFlowers);
         m_sceneObjects.push(m_rockLeftBorder);
         m_sceneObjects.push(m_rockRightBorder);
         m_sceneObjects.push(m_flame);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         m_sceneTime = 10;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_MUSHROOM);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_VEGETABLE);
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
         if(m_effectsContainer)
         {
            while(m_effectsContainer.numChildren > 0)
            {
               m_effectsContainer.removeChildAt(0);
            }
         }
         m_effectsContainer = null;
         m_rockRight = null;
         m_rockCenter = null;
         m_rockLeft = null;
         m_plant = null;
         m_flowers = null;
         m_rockFlowers = null;
         m_rockLeftBorder = null;
         m_rockRightBorder = null;
         m_sceneObjects.length = 0;
         super.destroy();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      override public function setEffectsContainer(param1:Sprite) : void
      {
         m_effectsContainer = s_nightSky;
         if(m_effectsContainerNightMask)
         {
            param1.addChild(m_effectsContainerNightMask);
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
               trace("setting day time");
               if(MovieClip(stonehenge_mc).s_flame1)
               {
                  MovieClip(stonehenge_mc).s_flame1.visible = false;
               }
               if(MovieClip(stonehenge_mc).s_flame2)
               {
                  MovieClip(stonehenge_mc).s_flame2.visible = false;
               }
               break;
            case SCENE_TIME_EVENING:
               if(MovieClip(stonehenge_mc).s_flame1)
               {
                  MovieClip(stonehenge_mc).s_flame1.visible = true;
               }
               if(MovieClip(stonehenge_mc).s_flame2)
               {
                  MovieClip(stonehenge_mc).s_flame2.visible = true;
               }
               break;
            case SCENE_TIME_NIGHT:
               if(MovieClip(stonehenge_mc).s_flame1)
               {
                  MovieClip(stonehenge_mc).s_flame1.visible = true;
               }
               if(MovieClip(stonehenge_mc).s_flame2)
               {
                  MovieClip(stonehenge_mc).s_flame2.visible = true;
               }
               break;
            case SCENE_TIME_MORNING:
               if(MovieClip(stonehenge_mc).s_flame1)
               {
                  MovieClip(stonehenge_mc).s_flame1.visible = true;
               }
               if(MovieClip(stonehenge_mc).s_flame2)
               {
                  MovieClip(stonehenge_mc).s_flame2.visible = true;
                  break;
               }
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
         if(s_exitToBlue.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_village";
         }
         if(s_exitToGreen.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_harvest_grove";
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
         if(s_exitToBlue.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitToGreen.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

