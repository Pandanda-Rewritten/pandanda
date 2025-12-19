package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class OrchardScene extends SceneRoot implements IScene
   {
      
      internal static const DEBUG:int = 1;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.58;
      
      public var s_spider:OrchardSpider;
      
      internal var m_treeLeft:OrchardTreeLeft;
      
      public var s_spawnOranges:Sprite;
      
      public var orchard_mc:Sprite;
      
      public var s_exitToBunnyField:Sprite;
      
      public var s_exitToVillage:Sprite;
      
      internal var m_fruitFront:OrchardFruitFront;
      
      public var s_spawnLemons:Sprite;
      
      internal var m_avatarScaleLimits:Array;
      
      public var s_exitToFishingHole:Sprite;
      
      internal var m_fruitBack:OrchardFruitBack;
      
      public var s_spawnCherries:Sprite;
      
      internal var m_spawnPoint:Point;
      
      public var s_spawnApples:Sprite;
      
      internal var m_light1:OrchardLight1;
      
      internal var m_light2:OrchardLight2;
      
      internal var m_treeMiddle:OrchardTreeMiddle;
      
      public var s_spawnPears:Sprite;
      
      public var s_spawnPeaches:Sprite;
      
      public var s_spawnPlums:Sprite;
      
      public var s_bats:OrchardBats;
      
      public function OrchardScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         trace("OrchardScene Constructor");
         this.m_spawnPoint = new Point(465,400);
         this.m_avatarScaleLimits = new Array(0.65,1);
         this.s_spawnApples.visible = false;
         this.s_spawnOranges.visible = false;
         this.s_spawnPears.visible = false;
         this.s_spawnCherries.visible = false;
         this.s_spawnLemons.visible = false;
         this.s_spawnPeaches.visible = false;
         this.s_spawnPlums.visible = false;
         this.orchard_mc.mouseEnabled = false;
         this.orchard_mc.cacheAsBitmap = true;
         this.s_exitToFishingHole.visible = false;
         this.s_exitToVillage.visible = false;
         this.s_exitToBunnyField.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         this.s_spider.gotoAndStop(1);
         this.s_bats.gotoAndStop(1);
         m_effectsContainerNightMask = new OrchardNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         this.m_fruitBack = new OrchardFruitBack();
         this.m_fruitBack.x = 472;
         this.m_fruitBack.y = 270;
         this.m_fruitBack.width = 60;
         this.m_fruitBack.height = 46;
         this.m_fruitBack.setYDepth(300);
         this.m_fruitFront = new OrchardFruitFront();
         this.m_fruitFront.x = 244;
         this.m_fruitFront.y = 432;
         this.m_fruitFront.width = 127;
         this.m_fruitFront.height = 93;
         this.m_fruitFront.setYDepth(482);
         this.m_light1 = new OrchardLight1();
         this.m_light1.x = 382;
         this.m_light1.y = 255;
         this.m_light1.width = 18;
         this.m_light1.height = 21;
         this.m_light1.setYDepth(272);
         this.m_light2 = new OrchardLight2();
         this.m_light2.x = 538;
         this.m_light2.y = 339;
         this.m_light2.width = 89;
         this.m_light2.height = 62;
         this.m_light2.setYDepth(384);
         this.m_treeMiddle = new OrchardTreeMiddle();
         this.m_treeMiddle.x = 464;
         this.m_treeMiddle.y = 25;
         this.m_treeMiddle.width = 238;
         this.m_treeMiddle.height = 349;
         this.m_treeMiddle.setYDepth(345);
         this.m_treeLeft = new OrchardTreeLeft();
         this.m_treeLeft.x = 0;
         this.m_treeLeft.y = 197;
         this.m_treeLeft.width = 125;
         this.m_treeLeft.height = 316;
         this.m_treeLeft.setYDepth(457);
         m_sceneObjects = new Array();
         m_sceneObjects.push(this.m_fruitBack);
         m_sceneObjects.push(this.m_fruitFront);
         m_sceneObjects.push(this.m_light1);
         m_sceneObjects.push(this.m_light2);
         m_sceneObjects.push(this.m_treeMiddle);
         m_sceneObjects.push(this.m_treeLeft);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         m_sceneTime = 5;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_FRUIT);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_VEGETABLE);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_TREASURE);
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
      
      internal function updateFrame(param1:Event) : void
      {
         this.updateScene();
      }
      
      override public function setSceneTime(param1:int, param2:Boolean = false) : void
      {
         super.setSceneTime(param1,param2);
         var _loc3_:* = m_sceneTime;
         switch(_loc3_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      override public function getSpawnPlaneSprite(param1:String) : Sprite
      {
         var _loc2_:* = param1;
         var _loc3_:* = _loc2_;
         switch(_loc3_)
         {
            case GameCollectableSpawnPlane.SPAWN_GROUND:
               return s_spawnGround;
            case GameCollectableSpawnPlane.SPAWN_APPLE_TREE:
               return this.s_spawnApples;
            case GameCollectableSpawnPlane.SPAWN_ORANGE_TREE:
               return this.s_spawnOranges;
            case GameCollectableSpawnPlane.SPAWN_CHERRY_TREE:
               return this.s_spawnCherries;
            case GameCollectableSpawnPlane.SPAWN_PEAR_TREE:
               return this.s_spawnPears;
            case GameCollectableSpawnPlane.SPAWN_LEMON_TREE:
               return this.s_spawnLemons;
            case GameCollectableSpawnPlane.SPAWN_PEACH_TREE:
               return this.s_spawnPeaches;
            case GameCollectableSpawnPlane.SPAWN_PLUM_TREE:
               return this.s_spawnPlums;
            default:
               return null;
         }
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         if(Math.random() * 1000 < 2)
         {
            if(!this.s_spider.isActive())
            {
               this.s_spider.playSpider();
            }
         }
         if(Math.random() * 1000 < 1)
         {
            if(!this.s_bats.isActive())
            {
               this.s_bats.playBats();
            }
         }
         var _loc1_:* = m_sceneTime;
         switch(_loc1_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      public function getAvatarSpawnPoint() : Point
      {
         return this.m_spawnPoint;
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return this.m_avatarScaleLimits;
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(this.s_exitToFishingHole.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_FISHING_HOLE;
         }
         if(this.s_exitToVillage.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_TOWN_SQUARE2;
         }
         if(this.s_exitToBunnyField.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_BUNNY_FIELD;
         }
         return null;
      }
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(this.s_exitToFishingHole.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToVillage.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToBunnyField.hitTestPoint(mouseX,mouseY,true))
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
   }
}

