package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class BarnScene extends SceneRoot implements IScene
   {
      
      internal static const DEBUG:int = 0;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.75;
      
      public var s_spider:BarnSpider;
      
      internal var m_beam:BarnTopBeam;
      
      public var s_spawnEggs:Sprite;
      
      internal var m_leftPost:BarnLeftPost;
      
      public var s_chicken2:BarnChicken;
      
      public var s_exit:Sprite;
      
      internal var m_rightPost:BarnRightPost;
      
      public var s_chicken1:BarnChicken;
      
      internal var m_avatarScaleLimits:Array;
      
      public var barn_mc:Sprite;
      
      internal var m_btmPost:BarnBtmPost;
      
      internal var m_spawnPoint:Point;
      
      internal var m_web1:BarnSpiderWeb1;
      
      internal var m_web2:BarnSpiderWeb2;
      
      public function BarnScene()
      {
         var _loc1_:* = 0;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("DarkroomScene Constructor");
         m_spawnPoint = new Point(547,491);
         m_avatarScaleLimits = new Array(0.9,1);
         s_spawnEggs.visible = false;
         barn_mc.mouseEnabled = false;
         barn_mc.cacheAsBitmap = true;
         s_exit.visible = false;
         s_spider.gotoAndStop(1);
         m_leftPost = new BarnLeftPost();
         m_leftPost.x = 128;
         m_leftPost.y = 90;
         m_leftPost.width = 57;
         m_leftPost.height = 130;
         m_leftPost.setYDepth(210);
         m_rightPost = new BarnRightPost();
         m_rightPost.x = 657;
         m_rightPost.y = 90;
         m_rightPost.width = 57;
         m_rightPost.height = 130;
         m_rightPost.setYDepth(210);
         m_beam = new BarnTopBeam();
         m_beam.x = 128;
         m_beam.y = 0;
         m_beam.width = 586;
         m_beam.height = 90;
         m_beam.setYDepth(215);
         m_btmPost = new BarnBtmPost();
         m_btmPost.x = 453;
         m_btmPost.y = 240;
         m_btmPost.width = 121;
         m_btmPost.height = 211;
         m_btmPost.setYDepth(435);
         m_web1 = new BarnSpiderWeb1();
         m_web1.x = 126;
         m_web1.y = 88;
         m_web1.width = 115;
         m_web1.height = 93;
         m_web1.setYDepth(238);
         m_web2 = new BarnSpiderWeb2();
         m_web2.x = 578;
         m_web2.y = 88;
         m_web2.width = 136;
         m_web2.height = 68;
         m_web2.setYDepth(215);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_leftPost);
         m_sceneObjects.push(m_rightPost);
         m_sceneObjects.push(m_beam);
         m_sceneObjects.push(m_btmPost);
         m_sceneObjects.push(m_web1);
         m_sceneObjects.push(m_web2);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         s_chicken1.setYDepth(s_chicken1.y + 50);
         m_sceneObjects.push(s_chicken1);
         s_chicken2.setYDepth(s_chicken2.y + 50);
         m_sceneObjects.push(s_chicken2);
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         updateSceneTime();
      }
      
      override public function destroy() : void
      {
         s_chicken1.destroy();
         s_chicken2.destroy();
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
      
      override public function getSpawnPlaneSprite(param1:String) : Sprite
      {
         var _loc2_:* = param1;
         switch(_loc2_)
         {
            case GameCollectableSpawnPlane.SPAWN_GROUND:
               return s_spawnGround;
            case GameCollectableSpawnPlane.SPAWN_EGGS:
               return s_spawnEggs;
            default:
               return null;
         }
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         s_chicken1.update();
         s_chicken2.update();
         if(Math.random() * 1000 < 2)
         {
            if(!s_spider.isActive())
            {
               s_spider.playSpider();
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
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(s_exit.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_HARVEST_GROVE;
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
         if(s_exit.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

