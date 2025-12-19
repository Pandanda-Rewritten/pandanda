package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class FishingHoleScene extends SceneRoot implements IScene
   {
      
      internal static const DEBUG:int = 1;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.58;
      
      internal var m_counter:FishingHoleCounter;
      
      internal var m_sign:FishingHoleSign;
      
      public var s_exitToOrchard:Sprite;
      
      internal var m_flame:FishingHoleFlameLeft;
      
      internal var m_pumpkinlights:FishingHolePumpkinLights;
      
      internal var m_post1:FishingHolePost1;
      
      internal var m_post3:FishingHolePost3;
      
      internal var m_post4:FishingHolePost4;
      
      internal var m_post2:FishingHolePost2;
      
      public var s_exitToVillage:Sprite;
      
      internal var m_flame1:FishingHoleFlameRight;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_flowers:FishingHoleFlowers;
      
      internal var m_torch:FishingHoleTorch;
      
      public var fishinghole_mc:Sprite;
      
      internal var m_torch1:FishingHoleTorch1;
      
      internal var m_spawnPoint:Point;
      
      internal var m_firepit:FishingHoleFirepit;
      
      public function FishingHoleScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         trace("FishingHoleScene Constructor");
         m_spawnPoint = new Point(485,250);
         m_avatarScaleLimits = new Array(0.65,1);
         fishinghole_mc.mouseEnabled = false;
         fishinghole_mc.cacheAsBitmap = true;
         s_exitToOrchard.visible = false;
         s_exitToVillage.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         m_effectsContainerNightMask = new FishingHoleNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         m_sign = new FishingHoleSign();
         m_sign.x = 299;
         m_sign.y = 226;
         m_sign.width = 79;
         m_sign.height = 64;
         m_sign.setYDepth(266);
         m_flowers = new FishingHoleFlowers();
         m_flowers.x = 429;
         m_flowers.y = 174;
         m_flowers.width = 43;
         m_flowers.height = 39;
         m_flowers.setYDepth(203);
         m_post1 = new FishingHolePost1();
         m_post1.x = 633;
         m_post1.y = 323;
         m_post1.width = 17;
         m_post1.height = 55;
         m_post1.setYDepth(368);
         m_post2 = new FishingHolePost2();
         m_post2.x = 660;
         m_post2.y = 369;
         m_post2.width = 20;
         m_post2.height = 86;
         m_post2.setYDepth(445);
         m_post3 = new FishingHolePost3();
         m_post3.x = 796;
         m_post3.y = 369;
         m_post3.width = 20;
         m_post3.height = 80;
         m_post3.setYDepth(439);
         m_post4 = new FishingHolePost4();
         m_post4.x = 767;
         m_post4.y = 321;
         m_post4.width = 17;
         m_post4.height = 50;
         m_post4.setYDepth(346);
         m_counter = new FishingHoleCounter();
         m_counter.x = 139;
         m_counter.y = 219;
         m_counter.width = 154;
         m_counter.height = 36;
         m_counter.setYDepth(255);
         m_torch1 = new FishingHoleTorch1();
         m_torch1.x = 56;
         m_torch1.y = 428;
         m_torch1.width = 30;
         m_torch1.height = 135;
         m_torch1.setYDepth(563);
         m_torch = new FishingHoleTorch();
         m_torch.x = 879;
         m_torch.y = 247;
         m_torch.width = 37;
         m_torch.height = 134;
         m_torch.setYDepth(381);
         m_flame = new FishingHoleFlameLeft();
         m_flame.x = 36;
         m_flame.y = 351;
         m_flame.width = 66;
         m_flame.height = 88;
         m_flame.setYDepth(565);
         m_flame1 = new FishingHoleFlameRight();
         m_flame1.x = 876;
         m_flame1.y = 172;
         m_flame1.width = 66;
         m_flame1.height = 87;
         m_flame1.setYDepth(386);
         m_firepit = new FishingHoleFirepit();
         m_firepit.x = 654;
         m_firepit.y = 197;
         m_firepit.width = 87;
         m_firepit.height = 114;
         m_firepit.setYDepth(217);
         m_pumpkinlights = new FishingHolePumpkinLights();
         m_pumpkinlights.x = 90;
         m_pumpkinlights.y = 92;
         m_pumpkinlights.width = 188;
         m_pumpkinlights.height = 40;
         m_pumpkinlights.setYDepth(132);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_sign);
         m_sceneObjects.push(m_flowers);
         m_sceneObjects.push(m_post1);
         m_sceneObjects.push(m_post2);
         m_sceneObjects.push(m_post3);
         m_sceneObjects.push(m_post4);
         m_sceneObjects.push(m_counter);
         m_sceneObjects.push(m_torch);
         m_sceneObjects.push(m_torch1);
         m_sceneObjects.push(m_flame);
         m_sceneObjects.push(m_flame1);
         m_sceneObjects.push(m_firepit);
         m_sceneObjects.push(m_pumpkinlights);
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
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_FISH);
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
         super.destroy();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      internal function updateFrame(param1:Event) : void
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
         var _loc3_:* = m_sceneTime;
         switch(_loc3_)
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
         var _loc1_:* = m_sceneTime;
         switch(_loc1_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
               break;
            case SCENE_TIME_NIGHT:
               updateFireflies();
               break;
            case SCENE_TIME_MORNING:
         }
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(s_exitToOrchard.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_orchard";
         }
         if(s_exitToVillage.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_village";
         }
         return null;
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
            if(Boolean(s_water) && s_water.hitTestPoint(mouseX,mouseY,true))
            {
               return "fish";
            }
            return "none";
         }
         if(s_exitToOrchard.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitToVillage.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

