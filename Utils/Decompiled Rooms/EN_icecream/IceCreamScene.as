package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   
   public class IceCreamScene extends SceneRoot implements IScene
   {
      
      private static const DEBUG:* = 0;
      
      public var s_gameTable3:MiniGameHotSpot;
      
      public var stg_exitToVillage:MovieClip;
      
      public var s_gameTable2:MiniGameHotSpot;
      
      public var s_gameTable1:MiniGameHotSpot;
      
      private var m_table2:IceCreamTable2;
      
      private var m_table3:IceCreamTable2;
      
      private var m_table1:IceCreamTable1;
      
      private var m_rightchair2:IceCreamChair;
      
      private var m_rightchair3:IceCreamChair;
      
      private var m_rightchair:IceCreamChair;
      
      public var stg_icecream_mc:MovieClip;
      
      private var m_icecreamcounter:IceCreamCounter;
      
      private var m_avatarScaleLimits:Array;
      
      private var m_leftchair:IceCreamChair;
      
      private var m_spawnPoint:Point;
      
      private var m_leftchair2:IceCreamChair;
      
      private var m_leftchair3:IceCreamChair;
      
      private var m_light3:IceCreamLights;
      
      private var m_light1:IceCreamLights;
      
      private var m_light2:IceCreamLights;
      
      public function IceCreamScene()
      {
         var _loc1_:int = 0;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("IceCreamScene Constructor");
         m_spawnPoint = new Point(490,270);
         m_avatarScaleLimits = new Array(0.8,1.1);
         stg_icecream_mc.mouseEnabled = false;
         stg_icecream_mc.cacheAsBitmap = true;
         stg_exitToVillage.visible = false;
         m_icecreamcounter = new IceCreamCounter();
         m_icecreamcounter.x = 597;
         m_icecreamcounter.y = 225;
         m_icecreamcounter.width = 213;
         m_icecreamcounter.height = 58;
         m_icecreamcounter.setYDepth(273);
         m_table1 = new IceCreamTable1();
         m_table1.x = 135;
         m_table1.y = 361;
         m_table1.width = 102;
         m_table1.height = 117;
         m_table1.setYDepth(446);
         m_table2 = new IceCreamTable2();
         m_table2.x = 372;
         m_table2.y = 334;
         m_table2.width = 101;
         m_table2.height = 112;
         m_table2.setYDepth(419);
         m_table3 = new IceCreamTable2();
         m_table3.x = 234;
         m_table3.y = 254;
         m_table3.width = 81;
         m_table3.height = 82;
         m_table3.setYDepth(314);
         m_rightchair = new IceCreamChair();
         m_rightchair.x = 449;
         m_rightchair.y = 331;
         m_rightchair.width = 60;
         m_rightchair.height = 89;
         m_rightchair.setYDepth(361);
         m_leftchair = new IceCreamChair();
         m_leftchair.x = 392;
         m_leftchair.y = 331;
         m_leftchair.width = 60;
         m_leftchair.height = 89;
         m_leftchair.setYDepth(361);
         m_leftchair.scaleX = -1;
         m_rightchair2 = new IceCreamChair();
         m_rightchair2.x = 221;
         m_rightchair2.y = 355;
         m_rightchair2.width = 60;
         m_rightchair2.height = 89;
         m_rightchair2.setYDepth(385);
         m_leftchair2 = new IceCreamChair();
         m_leftchair2.x = 149;
         m_leftchair2.y = 362;
         m_leftchair2.width = 60;
         m_leftchair2.height = 89;
         m_leftchair2.setYDepth(392);
         m_leftchair2.scaleX = -1;
         m_rightchair3 = new IceCreamChair();
         m_rightchair3.x = 298;
         m_rightchair3.y = 243;
         m_rightchair3.width = 50;
         m_rightchair3.height = 75;
         m_rightchair3.setYDepth(273);
         m_leftchair3 = new IceCreamChair();
         m_leftchair3.x = 255;
         m_leftchair3.y = 237;
         m_leftchair3.width = 50;
         m_leftchair3.height = 75;
         m_leftchair3.setYDepth(267);
         m_leftchair3.scaleX = -1;
         m_light1 = new IceCreamLights();
         m_light1.x = 168;
         m_light1.y = 25;
         m_light1.width = 41;
         m_light1.height = 328;
         m_light1.setYDepth(600);
         m_light2 = new IceCreamLights();
         m_light2.x = 402;
         m_light2.y = 0;
         m_light2.width = 41;
         m_light2.height = 328;
         m_light2.setYDepth(601);
         m_light3 = new IceCreamLights();
         m_light3.x = 257;
         m_light3.y = 7;
         m_light3.width = 31;
         m_light3.height = 248;
         m_light3.setYDepth(602);
         m_sceneObjects = new Array();
         m_sceneObjects.push(m_rightchair2);
         m_sceneObjects.push(m_icecreamcounter);
         m_sceneObjects.push(m_table1);
         m_sceneObjects.push(m_table2);
         m_sceneObjects.push(m_table3);
         m_sceneObjects.push(m_rightchair);
         m_sceneObjects.push(m_leftchair);
         m_sceneObjects.push(m_leftchair2);
         m_sceneObjects.push(m_rightchair3);
         m_sceneObjects.push(m_leftchair3);
         m_sceneObjects.push(m_light1);
         m_sceneObjects.push(m_light2);
         m_sceneObjects.push(m_light3);
         m_sceneObjects.push(s_gameTable1);
         m_sceneObjects.push(s_gameTable2);
         m_sceneObjects.push(s_gameTable3);
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
         m_icecreamcounter = null;
         m_table1 = null;
         m_table2 = null;
         m_table3 = null;
         m_rightchair = null;
         m_leftchair = null;
         m_rightchair2 = null;
         m_leftchair2 = null;
         m_rightchair3 = null;
         m_leftchair3 = null;
         m_light1 = null;
         m_light2 = null;
         m_light3 = null;
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
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(stg_exitToVillage.hitTestPoint(param1.x,param1.y,true))
         {
            return "EN_village";
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
      
      override public function getMiniGameId() : String
      {
         if(s_gameTable1.hitTestPoint(mouseX,mouseY,true))
         {
            return "MG005a";
         }
         if(s_gameTable2.hitTestPoint(mouseX,mouseY,true))
         {
            return "MG005b";
         }
         if(s_gameTable3.hitTestPoint(mouseX,mouseY,true))
         {
            return "MG005c";
         }
         return new String();
      }
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(stg_exitToVillage.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
   }
}

