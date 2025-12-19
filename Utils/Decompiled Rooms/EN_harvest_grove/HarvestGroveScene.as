package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class HarvestGroveScene extends SceneRoot implements IScene
   {
      
      internal static const DEBUG:int = 0;
      
      internal static const MAX_SCENE_X_OFFSET:int = 935;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.7;
      
      internal static const GATE_X_OFFSET:int = 450;
      
      internal static const NIGHT_MASK_TOP_ALPHA:Number = 0.3;
      
      internal static const GATE1_X_OFFSET:int = 1196;
      
      internal static const SCROLL_SPEED:int = 4;
      
      internal static const MIN_SCENE_X_OFFSET:int = 0;
      
      public var s_exitToForest:Sprite;
      
      internal var m_sprout1:HarvestGroveSprout1;
      
      internal var m_sprout2:HarvestGroveSprout2;
      
      internal var m_sprout4:HarvestGroveSprout4;
      
      public var s_gate1:SimpleButton;
      
      internal var m_wellRoof:HarvestGroveWishingWellRoof;
      
      internal var m_wellBase:HarvestGroveWishingWellBase;
      
      internal var m_sprout3:HarvestGroveSprout3;
      
      internal var m_scrollRight:Boolean;
      
      public var s_gate:SimpleButton;
      
      internal var m_scarecrow:HarvestGroveScarecrow;
      
      internal var m_treeBack:HarvestGroveTreeBack;
      
      internal var m_sceneXOffset:int;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_pumpkins:HarvestGrovePumpkins;
      
      public var s_harvest:Sprite;
      
      internal var m_cart:HarvestGroveCart;
      
      public var s_exitToStonehenge:Sprite;
      
      public var s_horizon:HarvestGroveHorizon;
      
      public var s_spawnSoil:Sprite;
      
      public var s_exitToBarn:Sprite;
      
      internal var m_spawnPoint:Point;
      
      internal var m_wellBucket:HarvestGroveWishingWellBucket;
      
      internal var m_treeFront:HarvestGroveTreeFront;
      
      public function HarvestGroveScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         this.m_scrollRight = true;
         s_ground.cacheAsBitmap = true;
         this.s_spawnSoil.cacheAsBitmap = true;
         this.s_spawnSoil.visible = false;
         trace("BeachScene Constructor");
         this.m_spawnPoint = new Point(650,315);
         this.m_avatarScaleLimits = new Array(0.65,1);
         if(SHOW_FIREWORKS)
         {
            m_fireworks = new Fireworks(150);
         }
         this.s_harvest.mouseEnabled = false;
         this.s_harvest.cacheAsBitmap = true;
         this.s_horizon.mouseEnabled = false;
         this.s_horizon.cacheAsBitmap = true;
         this.s_exitToStonehenge.visible = false;
         this.s_exitToForest.visible = false;
         this.s_exitToBarn.visible = false;
         if(s_nightSky)
         {
            s_nightSky.gotoAndStop(1);
            s_nightSky.cacheAsBitmap = true;
         }
         this.m_wellBase = new HarvestGroveWishingWellBase();
         this.m_wellBase.x = 233;
         this.m_wellBase.y = 328;
         this.m_wellBase.width = 120;
         this.m_wellBase.height = 97;
         this.m_wellBase.setYDepth(400);
         this.m_wellRoof = new HarvestGroveWishingWellRoof();
         this.m_wellRoof.x = 177;
         this.m_wellRoof.y = 181;
         this.m_wellRoof.width = 237;
         this.m_wellRoof.height = 179;
         this.m_wellRoof.setYDepth(401);
         this.m_treeFront = new HarvestGroveTreeFront();
         this.m_treeFront.x = 0;
         this.m_treeFront.y = 0;
         this.m_treeFront.width = 357;
         this.m_treeFront.height = 586;
         this.m_treeFront.setYDepth(550);
         this.m_treeBack = new HarvestGroveTreeBack();
         this.m_treeBack.x = 9;
         this.m_treeBack.y = 244;
         this.m_treeBack.width = 116;
         this.m_treeBack.height = 259;
         this.m_treeBack.setYDepth(458);
         this.m_sprout1 = new HarvestGroveSprout1();
         this.m_sprout1.x = 1307;
         this.m_sprout1.y = 274;
         this.m_sprout1.width = 22;
         this.m_sprout1.height = 28;
         this.m_sprout1.setYDepth(296);
         this.m_sprout2 = new HarvestGroveSprout2();
         this.m_sprout2.x = 1575;
         this.m_sprout2.y = 324;
         this.m_sprout2.width = 31;
         this.m_sprout2.height = 43;
         this.m_sprout2.setYDepth(361);
         this.m_sprout3 = new HarvestGroveSprout3();
         this.m_sprout3.x = 1617;
         this.m_sprout3.y = 248;
         this.m_sprout3.width = 20;
         this.m_sprout3.height = 20;
         this.m_sprout3.setYDepth(262);
         this.m_sprout4 = new HarvestGroveSprout4();
         this.m_sprout4.x = 1810;
         this.m_sprout4.y = 256;
         this.m_sprout4.width = 22;
         this.m_sprout4.height = 31;
         this.m_sprout4.setYDepth(281);
         this.m_scarecrow = new HarvestGroveScarecrow();
         this.m_scarecrow.x = 1657;
         this.m_scarecrow.y = 129;
         this.m_scarecrow.width = 114;
         this.m_scarecrow.height = 133;
         this.m_scarecrow.setYDepth(256);
         this.m_wellBucket = new HarvestGroveWishingWellBucket();
         this.m_wellBucket.x = 237;
         this.m_wellBucket.y = 287;
         this.m_wellBucket.width = 89;
         this.m_wellBucket.height = 71;
         this.m_wellBucket.setYDepth(402);
         this.m_cart = new HarvestGroveCart();
         this.m_cart.x = 1540;
         this.m_cart.y = 326;
         this.m_cart.width = 306;
         this.m_cart.height = 244;
         this.m_cart.setYDepth(370);
         this.m_pumpkins = new HarvestGrovePumpkins();
         this.m_pumpkins.x = 1641;
         this.m_pumpkins.y = 379;
         this.m_pumpkins.width = 92;
         this.m_pumpkins.height = 80;
         this.m_pumpkins.setYDepth(434);
         m_sceneObjects = new Array();
         m_sceneObjects.push(this.m_wellBase);
         m_sceneObjects.push(this.m_wellRoof);
         m_sceneObjects.push(this.m_treeFront);
         m_sceneObjects.push(this.m_treeBack);
         m_sceneObjects.push(this.m_sprout1);
         m_sceneObjects.push(this.m_sprout2);
         m_sceneObjects.push(this.m_sprout3);
         m_sceneObjects.push(this.m_sprout4);
         m_sceneObjects.push(this.m_scarecrow);
         m_sceneObjects.push(this.m_wellBucket);
         m_sceneObjects.push(this.m_cart);
         m_sceneObjects.push(this.m_pumpkins);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            m_sceneObjects[_loc1_].cacheAsBitmap = true;
            _loc1_++;
         }
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         m_sceneTime = 5;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_VEGETABLE);
         if(DEBUG)
         {
            _loc2_ = new Sprite();
            addChild(_loc2_);
            this.getSceneObjects(_loc2_);
            addEventListener(Event.ENTER_FRAME,this.updateFrame,false,0,true);
            _loc2_ = new Sprite();
            this.setEffectsContainer(_loc2_);
            addChild(_loc2_);
         }
         this.m_sceneXOffset = 270;
         this.setSceneXOffset(this.m_sceneXOffset);
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
      
      public function getAvatarScaleLimits() : Array
      {
         return this.m_avatarScaleLimits;
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
         switch(_loc3_)
         {
            case SCENE_TIME_DAY:
               if(this.s_horizon)
               {
                  this.s_horizon.setNightMask(0);
               }
               break;
            case SCENE_TIME_EVENING:
               if(this.s_horizon)
               {
                  this.s_horizon.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               break;
            case SCENE_TIME_NIGHT:
               if(this.s_horizon)
               {
                  this.s_horizon.setNightMask(1);
               }
               break;
            case SCENE_TIME_MORNING:
               if(this.s_horizon)
               {
                  this.s_horizon.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                  break;
               }
         }
      }
      
      override public function getSpawnPlaneSprite(param1:String) : Sprite
      {
         if(param1 == GameCollectableSpawnPlane.SPAWN_GROUND)
         {
            return s_spawnGround;
         }
         if(param1 == GameCollectableSpawnPlane.SPAWN_GROUND_SOIL)
         {
            return this.s_spawnSoil;
         }
         return null;
      }
      
      override public function isScrollable() : Boolean
      {
         return true;
      }
      
      override public function setEffectsContainer(param1:Sprite) : void
      {
         super.setEffectsContainer(param1);
         m_effectsContainer.x = -this.m_sceneXOffset;
      }
      
      internal function updateFrame(param1:Event) : void
      {
         this.updateScene();
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         var _loc2_:* = m_sceneTime;
         switch(_loc2_)
         {
            case SCENE_TIME_DAY:
               break;
            case SCENE_TIME_EVENING:
               if(this.s_horizon)
               {
                  this.s_horizon.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
               }
               break;
            case SCENE_TIME_NIGHT:
               break;
            case SCENE_TIME_MORNING:
               if(this.s_horizon)
               {
                  this.s_horizon.setNightMask(m_transitionFrame / NIGHT_TRANSITION_FRAME_COUNT);
                  break;
               }
         }
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      override public function getSceneXOffset() : int
      {
         return this.m_sceneXOffset;
      }
      
      public function getMouseCursorType() : String
      {
         if(Boolean(s_water) && s_water.hitTestPoint(mouseX + this.m_sceneXOffset,mouseY,true))
         {
            return "fish";
         }
         if(!s_ground.hitTestPoint(mouseX + this.m_sceneXOffset,mouseY,true))
         {
            return "none";
         }
         if(this.s_exitToStonehenge.hitTestPoint(mouseX + this.m_sceneXOffset,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToForest.hitTestPoint(mouseX + this.m_sceneXOffset,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToBarn.hitTestPoint(mouseX + this.m_sceneXOffset,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(this.s_exitToStonehenge.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_stonehenge";
         }
         if(this.s_exitToForest.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_forest";
         }
         if(this.s_exitToBarn.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_barn";
         }
         return null;
      }
      
      public function getAvatarSpawnPoint() : Point
      {
         return this.m_spawnPoint;
      }
      
      override public function setSceneXOffset(param1:int) : void
      {
         var _loc2_:* = 0;
         if(param1 < MIN_SCENE_X_OFFSET)
         {
            this.m_sceneXOffset = MIN_SCENE_X_OFFSET;
         }
         else if(param1 > MAX_SCENE_X_OFFSET)
         {
            this.m_sceneXOffset = MAX_SCENE_X_OFFSET;
         }
         else
         {
            this.m_sceneXOffset = param1;
         }
         this.s_harvest.x = -this.m_sceneXOffset;
         s_nightMask.x = -this.m_sceneXOffset;
         _loc2_ = Math.floor(-this.m_sceneXOffset * 0.65);
         if(this.s_horizon.x != _loc2_)
         {
            this.s_horizon.x = _loc2_;
         }
         this.s_gate.x = GATE_X_OFFSET - this.m_sceneXOffset;
         this.s_gate1.x = GATE1_X_OFFSET - this.m_sceneXOffset;
         if(m_effectsContainer)
         {
            m_effectsContainer.x = -this.m_sceneXOffset;
         }
      }
   }
}

