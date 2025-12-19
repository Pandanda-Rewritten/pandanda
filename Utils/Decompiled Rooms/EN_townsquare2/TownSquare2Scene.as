package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class TownSquare2Scene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.58;
      
      internal static const DEBUG:int = 0;
      
      internal var m_pillar1:TownSquare2Pillar1;
      
      internal var m_pillar2:TownSquare2Pillar2;
      
      public var s_exitToOrchard:Sprite;
      
      public var s_exitToPurpleDoor:Sprite;
      
      internal var m_pumpkinLights:TownSquare2PumpkinLights;
      
      internal var m_vines1:TownSquare2Vines1;
      
      internal var m_vines2:TownSquare2Vines2;
      
      internal var m_vines4:TownSquare2Vines4;
      
      internal var m_vines6:TownSquare2Vines6;
      
      internal var m_pumpkin1:TownSquare2Pumpkin1;
      
      internal var m_vines3:TownSquare2Vines3;
      
      internal var m_cones:TownSquare2Cones;
      
      internal var m_archway1:TownSquare2Archway1;
      
      internal var m_pumpkin2:TownSquare2Pumpkin2;
      
      internal var m_vines5:TownSquare2Vines5;
      
      public var townsquare2_mc:Sprite;
      
      internal var m_rightLight:TownSquare2RightLight;
      
      internal var m_topFence:TownSquare2TopFence;
      
      internal var m_pumpkinCluster:TownSquare2PumpkinCluster;
      
      internal var m_archway2:TownSquare2Archway2;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_jackolantern:TownSquare2Jackolantern;
      
      internal var m_archway3:TownSquare2Archway3;
      
      internal var m_clubCorner:TownSquare2ClubCorner;
      
      public var s_exitToPetstore:Sprite;
      
      internal var m_sawhorse2:TownSquare2Sawhorse2;
      
      internal var m_sawhorse1:TownSquare2Sawhorse1;
      
      public var s_exitToTownSquare:Sprite;
      
      internal var m_spawnPoint:Point;
      
      internal var m_leftLight:TownSquare2LeftLight;
      
      internal var m_purpleCart:TownSquare2PurpleCart;
      
      internal var m_treeLeft:TownSquare2TreeLeft;
      
      internal var m_treeRight:TownSquare2TreeRight;
      
      public function TownSquare2Scene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("TownSquare2Scene Constructor");
         this.m_spawnPoint = new Point(465,400);
         this.m_avatarScaleLimits = new Array(0.65,1);
         this.townsquare2_mc.mouseEnabled = false;
         this.townsquare2_mc.cacheAsBitmap = true;
         this.s_exitToOrchard.visible = false;
         this.s_exitToTownSquare.visible = false;
         this.s_exitToPurpleDoor.visible = false;
         this.s_exitToPetstore.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         m_effectsContainerNightMask = new TownSquare2NightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         this.m_purpleCart = new TownSquare2PurpleCart();
         this.m_purpleCart.x = 60;
         this.m_purpleCart.y = 360;
         this.m_purpleCart.width = 198;
         this.m_purpleCart.height = 185;
         this.m_purpleCart.setYDepth(498);
         this.m_archway1 = new TownSquare2Archway1();
         this.m_archway1.x = 0;
         this.m_archway1.y = 121;
         this.m_archway1.width = 85;
         this.m_archway1.height = 157;
         this.m_archway1.setYDepth(263);
         this.m_archway2 = new TownSquare2Archway2();
         this.m_archway2.x = 85;
         this.m_archway2.y = 113;
         this.m_archway2.width = 135;
         this.m_archway2.height = 149;
         this.m_archway2.setYDepth(248);
         this.m_archway3 = new TownSquare2Archway3();
         this.m_archway3.x = 219;
         this.m_archway3.y = 112;
         this.m_archway3.width = 47;
         this.m_archway3.height = 135;
         this.m_archway3.setYDepth(235);
         this.m_pillar1 = new TownSquare2Pillar1();
         this.m_pillar1.x = 360;
         this.m_pillar1.y = 471;
         this.m_pillar1.width = 20;
         this.m_pillar1.height = 42;
         this.m_pillar1.setYDepth(508);
         this.m_pillar2 = new TownSquare2Pillar2();
         this.m_pillar2.x = 415;
         this.m_pillar2.y = 518;
         this.m_pillar2.width = 24;
         this.m_pillar2.height = 46;
         this.m_pillar2.setYDepth(553);
         this.m_rightLight = new TownSquare2RightLight();
         this.m_rightLight.x = 292;
         this.m_rightLight.y = 395;
         this.m_rightLight.width = 40;
         this.m_rightLight.height = 79;
         this.m_rightLight.setYDepth(460);
         this.m_leftLight = new TownSquare2LeftLight();
         this.m_leftLight.x = 142;
         this.m_leftLight.y = 343;
         this.m_leftLight.width = 40;
         this.m_leftLight.height = 76;
         this.m_leftLight.setYDepth(404);
         this.m_topFence = new TownSquare2TopFence();
         this.m_topFence.x = -5;
         this.m_topFence.y = 347;
         this.m_topFence.width = 149;
         this.m_topFence.height = 52;
         this.m_topFence.setYDepth(384);
         this.m_clubCorner = new TownSquare2ClubCorner();
         this.m_clubCorner.x = 313;
         this.m_clubCorner.y = 175;
         this.m_clubCorner.width = 21;
         this.m_clubCorner.height = 70;
         this.m_clubCorner.setYDepth(240);
         this.m_sawhorse1 = new TownSquare2Sawhorse1();
         this.m_sawhorse1.x = 293;
         this.m_sawhorse1.y = 235;
         this.m_sawhorse1.width = 64;
         this.m_sawhorse1.height = 61;
         this.m_sawhorse1.setYDepth(282);
         this.m_sawhorse2 = new TownSquare2Sawhorse2();
         this.m_sawhorse2.x = 403;
         this.m_sawhorse2.y = 228;
         this.m_sawhorse2.width = 64;
         this.m_sawhorse2.height = 55;
         this.m_sawhorse2.setYDepth(269);
         this.m_cones = new TownSquare2Cones();
         this.m_cones.x = 361;
         this.m_cones.y = 270;
         this.m_cones.width = 48;
         this.m_cones.height = 30;
         this.m_cones.setYDepth(287);
         this.m_treeRight = new TownSquare2TreeRight();
         this.m_treeRight.x = 862;
         this.m_treeRight.y = 282;
         this.m_treeRight.width = 62;
         this.m_treeRight.height = 208;
         this.m_treeRight.setYDepth(482);
         this.m_treeLeft = new TownSquare2TreeLeft();
         this.m_treeLeft.x = 615;
         this.m_treeLeft.y = 200;
         this.m_treeLeft.width = 49;
         this.m_treeLeft.height = 148;
         this.m_treeLeft.setYDepth(338);
         this.m_pumpkinLights = new TownSquare2PumpkinLights();
         this.m_pumpkinLights.x = 659;
         this.m_pumpkinLights.y = 209;
         this.m_pumpkinLights.width = 221;
         this.m_pumpkinLights.height = 79;
         this.m_pumpkinLights.setYDepth(288);
         this.m_jackolantern = new TownSquare2Jackolantern();
         this.m_jackolantern.x = 644;
         this.m_jackolantern.y = 313;
         this.m_jackolantern.width = 34;
         this.m_jackolantern.height = 42;
         this.m_jackolantern.setYDepth(348);
         this.m_vines1 = new TownSquare2Vines1();
         this.m_vines1.x = 2;
         this.m_vines1.y = 153;
         this.m_vines1.width = 258;
         this.m_vines1.height = 56;
         this.m_vines1.setYDepth(268);
         this.m_vines2 = new TownSquare2Vines2();
         this.m_vines2.x = 255;
         this.m_vines2.y = 101;
         this.m_vines2.width = 26;
         this.m_vines2.height = 131;
         this.m_vines2.setYDepth(232);
         this.m_vines3 = new TownSquare2Vines3();
         this.m_vines3.x = 248;
         this.m_vines3.y = 76;
         this.m_vines3.width = 222;
         this.m_vines3.height = 67;
         this.m_vines3.setYDepth(143);
         this.m_vines4 = new TownSquare2Vines4();
         this.m_vines4.x = 439;
         this.m_vines4.y = 100;
         this.m_vines4.width = 22;
         this.m_vines4.height = 117;
         this.m_vines4.setYDepth(217);
         this.m_vines5 = new TownSquare2Vines5();
         this.m_vines5.x = 447;
         this.m_vines5.y = 124;
         this.m_vines5.width = 124;
         this.m_vines5.height = 51;
         this.m_vines5.setYDepth(175);
         this.m_vines6 = new TownSquare2Vines6();
         this.m_vines6.x = 569;
         this.m_vines6.y = 119;
         this.m_vines6.width = 62;
         this.m_vines6.height = 92;
         this.m_vines6.setYDepth(211);
         this.m_pumpkin1 = new TownSquare2Pumpkin1();
         this.m_pumpkin1.x = 283;
         this.m_pumpkin1.y = 213;
         this.m_pumpkin1.width = 51;
         this.m_pumpkin1.height = 51;
         this.m_pumpkin1.setYDepth(257);
         this.m_pumpkin2 = new TownSquare2Pumpkin2();
         this.m_pumpkin2.x = 408;
         this.m_pumpkin2.y = 206;
         this.m_pumpkin2.width = 53;
         this.m_pumpkin2.height = 38;
         this.m_pumpkin2.setYDepth(236);
         this.m_pumpkinCluster = new TownSquare2PumpkinCluster();
         this.m_pumpkinCluster.x = 0;
         this.m_pumpkinCluster.y = 504;
         this.m_pumpkinCluster.width = 199;
         this.m_pumpkinCluster.height = 97;
         this.m_pumpkinCluster.setYDepth(601);
         m_sceneObjects = new Array();
         m_sceneObjects.push(this.m_purpleCart);
         m_sceneObjects.push(this.m_archway1);
         m_sceneObjects.push(this.m_archway2);
         m_sceneObjects.push(this.m_archway3);
         m_sceneObjects.push(this.m_pillar1);
         m_sceneObjects.push(this.m_pillar2);
         m_sceneObjects.push(this.m_rightLight);
         m_sceneObjects.push(this.m_leftLight);
         m_sceneObjects.push(this.m_topFence);
         m_sceneObjects.push(this.m_clubCorner);
         m_sceneObjects.push(this.m_treeRight);
         m_sceneObjects.push(this.m_treeLeft);
         m_sceneObjects.push(this.m_pumpkinLights);
         m_sceneObjects.push(this.m_jackolantern);
         m_sceneObjects.push(this.m_vines1);
         m_sceneObjects.push(this.m_vines2);
         m_sceneObjects.push(this.m_vines3);
         m_sceneObjects.push(this.m_vines4);
         m_sceneObjects.push(this.m_vines5);
         m_sceneObjects.push(this.m_vines6);
         m_sceneObjects.push(this.m_pumpkin1);
         m_sceneObjects.push(this.m_pumpkin2);
         m_sceneObjects.push(this.m_pumpkinCluster);
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
      
      public function getAvatarScaleLimits() : Array
      {
         return this.m_avatarScaleLimits;
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
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
      
      public function getAvatarSpawnPoint() : Point
      {
         return this.m_spawnPoint;
      }
      
      internal function updateFrame(param1:Event) : void
      {
         this.updateScene();
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         var _loc1_:* = m_sceneTime;
         switch(_loc1_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(this.s_exitToOrchard.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_orchard";
         }
         if(this.s_exitToTownSquare.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_townsquare";
         }
         if(this.s_exitToPurpleDoor.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_purple_door";
         }
         if(this.s_exitToPetstore.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_petstore";
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
            return "none";
         }
         if(this.s_exitToOrchard.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToTownSquare.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToPurpleDoor.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToPetstore.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

