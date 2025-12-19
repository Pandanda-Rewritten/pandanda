package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.text.*;
   
   public class TreeHouseLobbyScene extends SceneRoot implements IScene
   {
      
      internal static const DEBUG:int = 0;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.55;
      
      internal var m_tree:TreeHouseLobbyTree;
      
      public var s_exitLeft:Sprite;
      
      public var treehouseLobby_mc:Sprite;
      
      public var s_directionLeft:SimpleButton;
      
      public var s_exitBack:Sprite;
      
      public var s_residentSign:TreeHouseLobbyResidentSign;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_spawnPoint:Point;
      
      public var s_treeMask:MovieClip;
      
      public function TreeHouseLobbyScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("TreeHouseLobbyScene Constructor");
         m_spawnPoint = new Point(465,450);
         m_avatarScaleLimits = new Array(0.6,1);
         treehouseLobby_mc.mouseEnabled = false;
         treehouseLobby_mc.cacheAsBitmap = true;
         s_exitLeft.visible = false;
         s_exitBack.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         s_treeMask.s_mymask.cacheAsBitmap = true;
         s_treeMask.s_myclip.cacheAsBitmap = true;
         s_treeMask.s_myclip.mask = s_treeMask.s_mymask;
         m_effectsContainerNightMask = new TreeHouseLobbyNightMask();
         m_effectsContainerNightMask.x = 1;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         m_tree = new TreeHouseLobbyTree();
         m_tree.x = 150;
         m_tree.y = 270;
         m_tree.width = 116;
         m_tree.height = 198;
         m_tree.setYDepth(460);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_tree);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            _loc1_++;
         }
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_TRASH);
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
         s_residentSign.mouseEnabled = true;
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
         s_residentSign.destroy();
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
      
      public function getAvatarSpawnPoint() : Point
      {
         return m_spawnPoint;
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return m_avatarScaleLimits;
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
         if(s_exitLeft.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_TREEHOUSE;
         }
         if(s_exitBack.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.PLAYER_TREEHOUSE;
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
         if(s_residentSign.hitTestPoint(mouseX,mouseY,true))
         {
            return "ui";
         }
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(s_exitLeft.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(s_exitBack.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

