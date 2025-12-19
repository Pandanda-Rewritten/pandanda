package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class DarkroomScene extends SceneRoot implements IScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 1;
      
      private static const DEBUG:* = 0;
      
      private var m_darkLeft:DarkroomDarkLeft;
      
      private var m_chair:DarkroomChair;
      
      public var s_exitLeft:Sprite;
      
      private var m_darkBtm:DarkroomDarkBtm;
      
      public var darkroom_mc:Sprite;
      
      private var m_table:DarkroomTable;
      
      private var m_avatarScaleLimits:Array;
      
      private var m_spawnPoint:Point;
      
      public function DarkroomScene()
      {
         var _loc1_:int = 0;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("DarkroomScene Constructor");
         m_spawnPoint = new Point(547,491);
         m_avatarScaleLimits = new Array(0.8,1);
         darkroom_mc.mouseEnabled = false;
         darkroom_mc.cacheAsBitmap = true;
         s_exitLeft.visible = false;
         m_chair = new DarkroomChair();
         m_chair.x = 700;
         m_chair.y = 372;
         m_chair.width = 101;
         m_chair.height = 119;
         m_chair.setYDepth(432);
         m_table = new DarkroomTable();
         m_table.x = 592;
         m_table.y = 396;
         m_table.width = 111;
         m_table.height = 96;
         m_table.setYDepth(456);
         m_darkBtm = new DarkroomDarkBtm();
         m_darkBtm.x = 303;
         m_darkBtm.y = 119;
         m_darkBtm.width = 632;
         m_darkBtm.height = 481;
         m_darkBtm.setYDepth(600);
         m_darkLeft = new DarkroomDarkLeft();
         m_darkLeft.x = 0;
         m_darkLeft.y = 0;
         m_darkLeft.width = 316;
         m_darkLeft.height = 600;
         m_darkLeft.setYDepth(600);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_chair);
         m_sceneObjects.push(m_table);
         m_sceneObjects.push(m_darkBtm);
         m_sceneObjects.push(m_darkLeft);
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
         if(Math.random() * 1000 < 2)
         {
            if(!m_darkLeft.isActive())
            {
               m_darkLeft.playMonster();
            }
         }
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

