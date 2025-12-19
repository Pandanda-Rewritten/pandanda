package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class TownSquareScene extends SceneRoot implements IScene
   {
      
      internal static const DEBUG:int = 1;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.58;
      
      internal var m_treePlanter:TownSquareTreePlanter;
      
      internal var m_leftLamp:TownSquareLeftLamp;
      
      internal var m_blueCart:TownSquareBlueCart;
      
      public var s_exitToOrchard:Sprite;
      
      internal var m_tower:TownSquareTower;
      
      internal var m_rightLamp:TownSquareRightLamp;
      
      public var s_clock:MovieClip;
      
      internal var m_pumpkinlights1:TownSquarePumpkinLights1;
      
      internal var m_vines2:TownSquareVines2;
      
      internal var m_redCart:TownSquareRedCart;
      
      internal var m_avatarScaleLimits:Array;
      
      public var s_exitToClothesStore:Sprite;
      
      public var townsquare_mc:Sprite;
      
      public var s_exitToVillage2:Sprite;
      
      public var s_exitToOldTown:Sprite;
      
      internal var m_column1:TownSquareColumn1;
      
      internal var m_column2:TownSquareColumn2;
      
      internal var m_spawnPoint:Point;
      
      internal var m_vines1:TownSquareVines1;
      
      internal var m_pumpkinCluster1:TownSquarePumpkinCluster1;
      
      internal var m_treeTop:TownSquareTreeTop;
      
      internal var m_pumpkinlights:TownSquarePumpkinLights;
      
      internal var m_pumpkinCluster2:TownSquarePumpkinCluster2;
      
      public function TownSquareScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         trace("TownSquareScene Constructor");
         this.m_spawnPoint = new Point(465,400);
         this.m_avatarScaleLimits = new Array(0.65,1);
         this.townsquare_mc.mouseEnabled = false;
         this.townsquare_mc.cacheAsBitmap = true;
         this.s_exitToOrchard.visible = false;
         this.s_exitToVillage2.visible = false;
         this.s_exitToClothesStore.visible = false;
         this.s_exitToOldTown.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         m_effectsContainerNightMask = new TownSquareNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         this.m_tower = new TownSquareTower();
         this.m_tower.x = 201;
         this.m_tower.y = -2;
         this.m_tower.width = 85;
         this.m_tower.height = 363;
         this.m_tower.setYDepth(333);
         this.m_column1 = new TownSquareColumn1();
         this.m_column1.x = 1;
         this.m_column1.y = 261;
         this.m_column1.width = 70;
         this.m_column1.height = 130;
         this.m_column1.setYDepth(379);
         this.m_column2 = new TownSquareColumn2();
         this.m_column2.x = 114;
         this.m_column2.y = 236;
         this.m_column2.width = 49;
         this.m_column2.height = 127;
         this.m_column2.setYDepth(353);
         this.m_blueCart = new TownSquareBlueCart();
         this.m_blueCart.x = 130;
         this.m_blueCart.y = 341;
         this.m_blueCart.width = 177;
         this.m_blueCart.height = 162;
         this.m_blueCart.setYDepth(466);
         this.m_redCart = new TownSquareRedCart();
         this.m_redCart.x = 657;
         this.m_redCart.y = 368;
         this.m_redCart.width = 192;
         this.m_redCart.height = 180;
         this.m_redCart.setYDepth(513);
         this.m_leftLamp = new TownSquareLeftLamp();
         this.m_leftLamp.x = 643;
         this.m_leftLamp.y = 243;
         this.m_leftLamp.width = 35;
         this.m_leftLamp.height = 160;
         this.m_leftLamp.setYDepth(393);
         this.m_rightLamp = new TownSquareRightLamp();
         this.m_rightLamp.x = 883;
         this.m_rightLamp.y = 286;
         this.m_rightLamp.width = 40;
         this.m_rightLamp.height = 178;
         this.m_rightLamp.setYDepth(454);
         this.m_treeTop = new TownSquareTreeTop();
         this.m_treeTop.x = 286;
         this.m_treeTop.y = 271;
         this.m_treeTop.width = 100;
         this.m_treeTop.height = 112;
         this.m_treeTop.setYDepth(431);
         this.m_treePlanter = new TownSquareTreePlanter();
         this.m_treePlanter.x = 286;
         this.m_treePlanter.y = 353;
         this.m_treePlanter.width = 138;
         this.m_treePlanter.height = 106;
         this.m_treePlanter.setYDepth(428);
         this.m_pumpkinlights = new TownSquarePumpkinLights();
         this.m_pumpkinlights.x = 0;
         this.m_pumpkinlights.y = 181;
         this.m_pumpkinlights.width = 249;
         this.m_pumpkinlights.height = 72;
         this.m_pumpkinlights.setYDepth(253);
         this.m_pumpkinlights1 = new TownSquarePumpkinLights1();
         this.m_pumpkinlights1.x = 416;
         this.m_pumpkinlights1.y = 130;
         this.m_pumpkinlights1.width = 252;
         this.m_pumpkinlights1.height = 69;
         this.m_pumpkinlights1.setYDepth(199);
         this.m_vines1 = new TownSquareVines1();
         this.m_vines1.x = -1;
         this.m_vines1.y = 171;
         this.m_vines1.width = 241;
         this.m_vines1.height = 75;
         this.m_vines1.setYDepth(266);
         this.m_vines2 = new TownSquareVines2();
         this.m_vines2.x = 416;
         this.m_vines2.y = 122;
         this.m_vines2.width = 241;
         this.m_vines2.height = 75;
         this.m_vines2.setYDepth(217);
         this.m_pumpkinCluster1 = new TownSquarePumpkinCluster1();
         this.m_pumpkinCluster1.x = 285;
         this.m_pumpkinCluster1.y = 317;
         this.m_pumpkinCluster1.width = 176;
         this.m_pumpkinCluster1.height = 125;
         this.m_pumpkinCluster1.setYDepth(417);
         this.m_pumpkinCluster2 = new TownSquarePumpkinCluster2();
         this.m_pumpkinCluster2.x = 261;
         this.m_pumpkinCluster2.y = 390;
         this.m_pumpkinCluster2.width = 78;
         this.m_pumpkinCluster2.height = 58;
         this.m_pumpkinCluster2.setYDepth(440);
         m_sceneObjects = new Array();
         m_sceneObjects.push(this.m_tower);
         m_sceneObjects.push(this.m_column1);
         m_sceneObjects.push(this.m_column2);
         m_sceneObjects.push(this.m_redCart);
         m_sceneObjects.push(this.m_blueCart);
         m_sceneObjects.push(this.m_leftLamp);
         m_sceneObjects.push(this.m_rightLamp);
         m_sceneObjects.push(this.m_pumpkinlights);
         m_sceneObjects.push(this.m_pumpkinlights1);
         m_sceneObjects.push(this.m_vines1);
         m_sceneObjects.push(this.m_vines2);
         m_sceneObjects.push(this.m_pumpkinCluster1);
         m_sceneObjects.push(this.m_pumpkinCluster2);
         m_sceneObjects.push(this.m_treePlanter);
         m_sceneObjects.push(this.m_treeTop);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         trace("SETTING CLOCK " + GameClock.getInstance().getHours() + ":" + GameClock.getInstance().getMinutes());
         this.s_clock.s_bigHand.rotation = GameClock.getInstance().getMinutes() * 6;
         this.s_clock.s_littleHand.rotation = GameClock.getInstance().getHours() * 30 + GameClock.getInstance().getMinutes() / 12 * 6;
         m_sceneTime = 5;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_TRASH);
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
      
      override protected function onTimerNotice() : void
      {
         trace("UPDATING CLOCK " + GameClock.getInstance().getHours() + ":" + GameClock.getInstance().getMinutes() + ":" + GameClock.getInstance().getSeconds());
         this.s_clock.s_bigHand.rotation = GameClock.getInstance().getMinutes() * 6;
         this.s_clock.s_littleHand.rotation = GameClock.getInstance().getHours() * 30 + GameClock.getInstance().getMinutes() / 12 * 6;
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      internal function updateFrame(param1:Event) : void
      {
         this.updateScene();
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(this.s_exitToOrchard.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_FOREST;
         }
         if(this.s_exitToOldTown.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_old_town";
         }
         if(this.s_exitToVillage2.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_TOWN_SQUARE2;
         }
         if(this.s_exitToClothesStore.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_CLOTHES_STORE;
         }
         return null;
      }
      
      override public function setSceneTime(param1:int, param2:Boolean = false) : void
      {
         super.setSceneTime(param1,param2);
         var _loc3_:* = m_sceneTime;
         var _loc4_:*;
         var _loc5_:* = _loc4_ = _loc3_;
         switch(_loc5_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return this.m_avatarScaleLimits;
      }
      
      public function getAvatarSpawnPoint() : Point
      {
         return this.m_spawnPoint;
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
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(this.s_exitToOrchard.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToVillage2.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToOldTown.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToClothesStore.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         var _loc1_:* = m_sceneTime;
         var _loc2_:* = _loc1_;
         var _loc3_:* = _loc2_;
         switch(_loc3_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
   }
}

