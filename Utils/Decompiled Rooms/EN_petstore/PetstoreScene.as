package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class PetstoreScene extends SceneRoot implements IScene
   {
      
      private static const DEBUG:* = 0;
      
      private static const LAMP_TIMER:int = 1000;
      
      private var m_counter:PetstoreCounter;
      
      private var m_lamp:PetstoreHeatLamp;
      
      public var s_exitToWMS:MovieClip;
      
      private var m_beds:PetstoreBeds;
      
      private var m_nest:PetstoreNest;
      
      private var m_lampTimer:int;
      
      public var s_bigHeatLamp:PetstoreBigHeatLamp;
      
      public var s_petstore:MovieClip;
      
      private var m_avatarScaleLimits:Array;
      
      private var m_spawnPoint:Point;
      
      public function PetstoreScene()
      {
         var _loc1_:int = 0;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("PetstoreScene Constructor");
         m_spawnPoint = new Point(490,270);
         m_avatarScaleLimits = new Array(0.9,1.2);
         s_petstore.mouseEnabled = false;
         s_petstore.cacheAsBitmap = true;
         s_exitToWMS.visible = false;
         m_lampTimer = LAMP_TIMER;
         m_counter = new PetstoreCounter();
         m_counter.x = 265;
         m_counter.y = 173;
         m_counter.width = 225;
         m_counter.height = 115;
         m_counter.setYDepth(243);
         m_beds = new PetstoreBeds();
         m_beds.x = 0;
         m_beds.y = 244;
         m_beds.width = 200;
         m_beds.height = 300;
         m_beds.setYDepth(494);
         m_nest = new PetstoreNest();
         m_nest.x = 479;
         m_nest.y = 353;
         m_nest.width = 217;
         m_nest.height = 122;
         m_nest.setYDepth(428);
         m_lamp = new PetstoreHeatLamp();
         m_lamp.x = 513;
         m_lamp.y = 274;
         m_lamp.width = 151;
         m_lamp.height = 185;
         m_lamp.setYDepth(459);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_counter);
         m_sceneObjects.push(m_beds);
         m_sceneObjects.push(m_nest);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            _loc1_++;
         }
      }
      
      override public function destroy() : void
      {
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
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         --m_lampTimer;
         if(m_lampTimer <= 0)
         {
            if(!s_bigHeatLamp.isActive())
            {
               s_bigHeatLamp.playBigHeatLamp();
            }
            m_lampTimer = LAMP_TIMER;
         }
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(s_exitToWMS.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_townsquare2";
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
         if(s_exitToWMS.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

