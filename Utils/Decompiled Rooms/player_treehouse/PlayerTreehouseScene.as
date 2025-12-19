package
{
   import flash.display.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.text.*;
   import flash.ui.*;
   
   public class PlayerTreehouseScene extends SceneRoot implements IScene, ITreeHouse
   {
      
      internal static const SIDE_WALL_WIDTH:int = 102;
      
      internal static const STRUCTURE_FLOOR_Y_OFFSET:int = 361;
      
      internal static const LEFT_STRUCTURE_WALL_PLACEMENT_X_OFFSET:int = 0;
      
      internal static const STRUCTURE_CEILING_Y_OFFSET:int = 0;
      
      internal static const DEFAULT_STRUCTURE_WALL_PLACEMENT_Y_OFFSET:int = 225;
      
      internal static const FURNITURE_CEILING_MINIMUM_SCALE_Y_OFFSET:int = 70;
      
      internal static const RIGHT_STRUCTURE_WALL_PLACEMENT_Y_OFFSET:int = 45;
      
      internal static const DEFAULT_STRUCTURE_WALL_PLACEMENT_X_OFFSET:int = 467;
      
      internal static const STRUCTURE_CEILING_X_OFFSET:int = 0;
      
      internal static const RIGHT_WALL_X_OFFSET:int = 786;
      
      internal static const RIGHT_WALL_MOUSE_X_LIMIT:int = 685;
      
      internal static const DEBUG:int = 0;
      
      internal static const STRUCTURE_FLOOR_X_OFFSET:int = 0;
      
      internal static const RIGHT_STRUCTURE_WALL_PLACEMENT_X_OFFSET:int = 783;
      
      internal static const LEFT_WALL_MOUSE_X_LIMIT:int = 250;
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.55;
      
      internal static const DEFAULT_FURNITURE_CEILING_PLACEMENT_Y_OFFSET:int = 50;
      
      internal static const BACK_STRUCTURE_WALL_PLACEMENT_Y_OFFSET:int = 88;
      
      internal static const MAX_FURNITURE_FLOOR_PLACEMENT_Y_OFFSET:int = 550;
      
      internal static const DEFAULT_FURNITURE_FLOOR_PLACEMENT_Y_OFFSET:int = 450;
      
      public static const TREEHOUSE_EVENT_CLOSE_STORAGE:String = "TREEHOUSE_EVENT_CLOSE_STORAGE";
      
      internal static const FURNITURE_FLOOR_FULL_SCALE_Y_OFFSET:int = 500;
      
      public static const TREEHOUSE_EVENT_ADD_FURNITURE_TO_ROOM:String = "TREEHOUSE_EVENT_ADD_FURNITURE_TO_ROOM";
      
      internal static const LEFT_STRUCTURE_WALL_PLACEMENT_Y_OFFSET:int = 45;
      
      internal static const BACK_STRUCTURE_WALL_PLACEMENT_X_OFFSET:int = 172;
      
      public static const TREEHOUSE_EVENT_CLOSE_BACKPACK:String = "TREEHOUSE_EVENT_CLOSE_BACKPACK";
      
      internal static const FURNITURE_LEFT_WALL_MINIMUM_SCALE_X_OFFSET:int = 148;
      
      internal static const MAX_PLACED_FURNITURE:int = 127;
      
      internal static const DEFAULT_FURNITURE_WALL_PLACEMENT_Y_OFFSET:int = 250;
      
      internal static const DEFAULT_FURNITURE_PLACEMENT_X_OFFSET:int = 467;
      
      internal var m_treeRight:PlayerTreehouseTreeRight;
      
      internal var m_leavesLeft:PlayerTreehouseLeavesLeft;
      
      internal var m_spawnPoint:Point;
      
      public var s_iconHelp:SimpleButton;
      
      public var s_exitEdit:MovieClip;
      
      public var s_iconStorage:MovieClip;
      
      internal var m_structureObjects:Array;
      
      public var s_iconRemove:Sprite;
      
      internal var m_leavesRight:PlayerTreehouseLeavesRight;
      
      internal var m_selectedFurniture:IFurnitureItem;
      
      internal var m_treeLeft:PlayerTreehouseTreeLeft;
      
      internal var m_isReturnToStorage:Boolean;
      
      internal var m_storageMenu:TreehouseStorageMenu;
      
      public var s_groundFurniture:MovieClip;
      
      public var s_left:Sprite;
      
      internal var m_selectedStartPosition:Point;
      
      internal var m_petList:Array;
      
      public var s_background:Sprite;
      
      internal var m_interactiveContainer:Sprite;
      
      public var s_ceiling:Sprite;
      
      internal var m_rugObjects:Array;
      
      internal var m_furnitureStructureContainer:Sprite;
      
      internal var m_selectedOffset:Point;
      
      internal var m_furnitureWallContainer:Sprite;
      
      internal var m_isEditMode:Boolean;
      
      internal var m_furnitureRugContainer:Sprite;
      
      internal var m_furnitureWallScaleLimits:Array;
      
      internal var m_furnitureFloorScaleLimits:Array;
      
      internal var m_wallObjects:Array;
      
      internal var m_furnitureContainer:Sprite;
      
      public var s_back:Sprite;
      
      public var s_right:Sprite;
      
      public var player_treehouse_mc:Sprite;
      
      internal var m_isStorageOpen:Boolean;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_furnitureCeilingScaleLimits:Array;
      
      internal var m_leavesTop:PlayerTreehouseLeavesTop;
      
      public var s_iconCatalog:SimpleButton;
      
      public function PlayerTreehouseScene()
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         super();
         trace("PlayerTreehouseScene Constructor");
         m_lastSinceAction = new Array();
         m_sceneObjects = new Array();
         m_wallObjects = new Array();
         m_structureObjects = new Array();
         m_rugObjects = new Array();
         setEditMode(false);
         m_petList = new Array();
         m_furnitureContainer = new Sprite();
         addChildAt(m_furnitureContainer,getChildIndex(player_treehouse_mc) + 2);
         m_furnitureWallContainer = new Sprite();
         addChildAt(m_furnitureWallContainer,getChildIndex(player_treehouse_mc) + 2);
         m_furnitureRugContainer = new Sprite();
         addChildAt(m_furnitureRugContainer,getChildIndex(player_treehouse_mc) + 2);
         m_furnitureStructureContainer = new Sprite();
         addChildAt(m_furnitureStructureContainer,getChildIndex(player_treehouse_mc) + 1);
         m_storageMenu = new TreehouseStorageMenu();
         m_storageMenu.x = s_iconStorage.x;
         m_storageMenu.y = s_iconStorage.y;
         m_spawnPoint = new Point(465,450);
         m_avatarScaleLimits = new Array(0.75,1.1);
         m_furnitureFloorScaleLimits = new Array(0.55,1);
         m_furnitureCeilingScaleLimits = new Array(0.75,1);
         m_furnitureWallScaleLimits = new Array(1,1.5);
         player_treehouse_mc.mouseEnabled = false;
         player_treehouse_mc.cacheAsBitmap = true;
         s_background.cacheAsBitmap = true;
         s_iconRemove.visible = false;
         m_leavesTop = new PlayerTreehouseLeavesTop();
         m_leavesTop.x = 205;
         m_leavesTop.y = 0;
         m_leavesTop.width = 568;
         m_leavesTop.height = 69;
         m_leavesTop.setYDepth(69);
         m_leavesLeft = new PlayerTreehouseLeavesLeft();
         m_leavesLeft.x = 0;
         m_leavesLeft.y = 0;
         m_leavesLeft.width = 81;
         m_leavesLeft.height = 297;
         m_leavesLeft.setYDepth(297);
         m_leavesRight = new PlayerTreehouseLeavesRight();
         m_leavesRight.x = 851;
         m_leavesRight.y = 0;
         m_leavesRight.width = 84;
         m_leavesRight.height = 310;
         m_leavesRight.setYDepth(310);
         m_treeLeft = new PlayerTreehouseTreeLeft();
         m_treeLeft.x = 0;
         m_treeLeft.y = 381;
         m_treeLeft.width = 270;
         m_treeLeft.height = 219;
         m_treeLeft.setYDepth(651);
         m_treeRight = new PlayerTreehouseTreeRight();
         m_treeRight.x = 654;
         m_treeRight.y = 364;
         m_treeRight.width = 281;
         m_treeRight.height = 236;
         m_treeRight.setYDepth(600);
         m_sceneObjects.push(m_leavesTop);
         m_sceneObjects.push(m_leavesLeft);
         m_sceneObjects.push(m_leavesRight);
         m_sceneObjects.push(m_treeLeft);
         m_sceneObjects.push(m_treeRight);
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         updateSceneTime();
         m_isReturnToStorage = false;
         s_iconStorage.mouseChildren = false;
         s_iconStorage.addEventListener(MouseEvent.ROLL_OVER,onMouseOverListener,false,0,true);
         s_iconStorage.addEventListener(MouseEvent.ROLL_OUT,onMouseOutListener,false,0,true);
         s_exitEdit.mouseChildren = false;
         _loc1_ = new TextFormat("arial",18);
         _loc1_.align = TextFormatAlign.CENTER;
         s_exitEdit.s_text.s_text.text = "Tree House Edit Mode";
         s_exitEdit.s_text.s_text.embedFonts = true;
         s_exitEdit.s_text.s_text.antiAliasType = AntiAliasType.ADVANCED;
         s_exitEdit.s_text.s_text.setTextFormat(_loc1_);
         s_exitEdit.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener,false,0,true);
         s_exitEdit.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener,false,0,true);
         addEventListener(MouseEvent.CLICK,onClickListener,false,0,true);
         addEventListener(TREEHOUSE_EVENT_CLOSE_STORAGE,onCloseStorageListener,false,0,true);
         addEventListener(TREEHOUSE_EVENT_ADD_FURNITURE_TO_ROOM,onAddFurnitureToRoom,false,0,true);
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
         ExternalInterface.addCallback("updatePets",this.updateRandomPet);
      }
      
      override public function destroy() : void
      {
         var _loc1_:* = 0;
         ExternalInterface.addCallback("updatePets",null);
         s_iconStorage.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener);
         s_iconStorage.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener);
         s_exitEdit.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener);
         s_exitEdit.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener);
         removeEventListener(TREEHOUSE_EVENT_CLOSE_STORAGE,onCloseStorageListener);
         removeEventListener(TREEHOUSE_EVENT_ADD_FURNITURE_TO_ROOM,onAddFurnitureToRoom);
         m_storageMenu.destroy();
         m_sceneObjects.length = 0;
         m_wallObjects.length = 0;
         m_structureObjects.length = 0;
         m_rugObjects.length = 0;
         if(m_effectsContainer)
         {
            while(m_effectsContainer.numChildren > 0)
            {
               m_effectsContainer.removeChildAt(0);
            }
         }
         if(m_interactiveContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < m_petList.length)
            {
               if(m_interactiveContainer.contains(m_petList[_loc1_]))
               {
                  m_interactiveContainer.removeChild(m_petList[_loc1_]);
               }
               _loc1_++;
            }
         }
         m_effectsContainer = null;
         super.destroy();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      public function updatePets(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         _loc2_ = param1.split(";");
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_].split(",");
            _loc5_ = _loc4_[0];
            if(_loc4_[1].indexOf("anim") == 0)
            {
               _loc6_ = _loc4_[1].split(":");
               m_petList[_loc5_].performActionAnimation(_loc6_[1]);
               m_lastSinceAction[_loc5_] = new Date().valueOf();
               trace("since last: " + m_lastSinceAction[_loc5_]);
            }
            if(_loc4_[1].indexOf("pos") == 0)
            {
               _loc7_ = _loc4_[1].split(":");
               _loc8_ = new Point(_loc7_[1],_loc7_[2]);
               if(!m_petList[_loc5_].isEgg())
               {
                  if(m_lastSinceAction[_loc5_])
                  {
                     if(new Date().valueOf() - m_lastSinceAction[_loc5_] > 20000)
                     {
                        m_petList[_loc5_].walkTo(new Array(_loc8_));
                     }
                  }
                  else
                  {
                     m_petList[_loc5_].walkTo(new Array(_loc8_));
                  }
               }
            }
            if(_loc4_[1].indexOf("hide") == 0)
            {
               m_petList[_loc5_].visible = false;
            }
            if(_loc4_[1].indexOf("show") == 0)
            {
               m_petList[_loc5_].visible = true;
            }
            _loc3_++;
         }
      }
      
      public function updateRandomPet() : void
      {
         var _loc1_:* = Math.floor(Math.random() * 601) + 150;
         var _loc2_:* = Math.floor(Math.random() * 171) + 380;
         var _loc3_:* = Math.floor(Math.random() * m_petList.length);
         if(m_petList.length > 2)
         {
            this.updatePets(String(_loc3_) + "," + "pos:" + String(_loc1_) + ":" + String(_loc2_));
         }
         else if(new Date().valueOf() % 2 == 0)
         {
            this.updatePets(String(_loc3_) + "," + "pos:" + String(_loc1_) + ":" + String(_loc2_));
         }
      }
      
      internal function removeDulpicateFurnitureStructures() : void
      {
         var _loc1_:* = false;
         var _loc2_:* = false;
         var _loc3_:* = false;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:* = false;
         var _loc7_:* = 0;
         _loc1_ = false;
         _loc2_ = false;
         _loc3_ = false;
         _loc4_ = false;
         _loc5_ = false;
         _loc6_ = false;
         _loc7_ = m_structureObjects.length - 1;
         while(_loc7_ >= 0)
         {
            _loc6_ = false;
            if(m_structureObjects[_loc7_] is IFurnitureItem)
            {
               if(IFurnitureItem(m_structureObjects[_loc7_]).getAttachment() != FurnitureCategory.FURNITURE_ATTACH_CEILING)
               {
                  if(IFurnitureItem(m_structureObjects[_loc7_]).getAttachment() != FurnitureCategory.FURNITURE_ATTACH_FLOOR)
                  {
                     if(IFurnitureItem(m_structureObjects[_loc7_]).getAttachment() == FurnitureCategory.FURNITURE_ATTACH_WALL)
                     {
                        if(IFurnitureItem(m_structureObjects[_loc7_]).getWallIndex() != FurnitureCategory.FURNITURE_WALL_LEFT)
                        {
                           if(IFurnitureItem(m_structureObjects[_loc7_]).getWallIndex() != FurnitureCategory.FURNITURE_WALL_RIGHT)
                           {
                              if(IFurnitureItem(m_structureObjects[_loc7_]).getWallIndex() == FurnitureCategory.FURNITURE_WALL_BACK)
                              {
                                 if(_loc3_)
                                 {
                                    _loc6_ = true;
                                 }
                                 _loc3_ = true;
                              }
                           }
                           else
                           {
                              if(_loc2_)
                              {
                                 _loc6_ = true;
                              }
                              _loc2_ = true;
                           }
                        }
                        else
                        {
                           if(_loc1_)
                           {
                              _loc6_ = true;
                           }
                           _loc1_ = true;
                        }
                     }
                  }
                  else
                  {
                     if(_loc5_)
                     {
                        _loc6_ = true;
                     }
                     _loc5_ = true;
                  }
               }
               else
               {
                  if(_loc4_)
                  {
                     _loc6_ = true;
                  }
                  _loc4_ = true;
               }
               if(_loc6_)
               {
                  if(m_furnitureStructureContainer.contains(Sprite(m_structureObjects[_loc7_])))
                  {
                     m_furnitureStructureContainer.removeChild(Sprite(m_structureObjects[_loc7_]));
                  }
                  PlayerAttributes.getInstance().addFurnitureToStorage(m_structureObjects[_loc7_].getId());
                  m_structureObjects.splice(_loc7_,1);
               }
            }
            _loc7_--;
         }
      }
      
      override public function setEffectsContainer(param1:Sprite) : void
      {
         m_effectsContainer = param1;
      }
      
      internal function updateFrame(param1:Event) : void
      {
         updateScene();
      }
      
      override public function isTreehouse() : Boolean
      {
         return true;
      }
      
      internal function onMouseOutListener(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(param1.currentTarget != s_exitEdit)
         {
            if(param1.currentTarget == s_iconStorage)
            {
               if(!m_isStorageOpen)
               {
                  s_iconStorage.gotoAndStop("off");
               }
            }
         }
         else
         {
            s_exitEdit.gotoAndStop("off");
            _loc2_ = new TextFormat("arial",18);
            _loc2_.align = TextFormatAlign.CENTER;
            s_exitEdit.s_text.s_text.text = "Tree House Edit Mode";
            s_exitEdit.s_text.s_text.embedFonts = true;
            s_exitEdit.s_text.s_text.antiAliasType = AntiAliasType.ADVANCED;
            s_exitEdit.s_text.s_text.setTextFormat(_loc2_);
         }
      }
      
      public function getStructureObjects(param1:Sprite) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < m_structureObjects.length)
         {
            if(m_structureObjects[_loc2_])
            {
               param1.addChild(m_structureObjects[_loc2_]);
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
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
      }
      
      public function setFurniture(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         getSceneObjects(m_furnitureContainer);
         while(m_furnitureContainer.numChildren > 0)
         {
            m_furnitureContainer.removeChildAt(0);
         }
         getWallObjects(m_furnitureWallContainer);
         while(m_furnitureWallContainer.numChildren > 0)
         {
            m_furnitureWallContainer.removeChildAt(0);
         }
         getStructureObjects(m_furnitureStructureContainer);
         while(m_furnitureStructureContainer.numChildren > 0)
         {
            m_furnitureStructureContainer.removeChildAt(0);
         }
         getRugObjects(m_furnitureRugContainer);
         while(m_furnitureRugContainer.numChildren > 0)
         {
            m_furnitureRugContainer.removeChildAt(0);
         }
         m_sceneObjects.length = 5;
         m_wallObjects.length = 0;
         m_structureObjects.length = 0;
         m_rugObjects.length = 0;
         _loc2_ = param1.split(",");
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc5_].split(":");
            if(_loc3_.length == 4)
            {
               _loc4_ = FurnitureItems.getInstance().getFurnitureItem(_loc3_[0]);
               if(_loc4_)
               {
                  _loc4_.setSpriteIndex(_loc3_[1]);
                  Sprite(_loc4_).x = _loc3_[2];
                  Sprite(_loc4_).y = _loc3_[3];
                  if(_loc4_.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
                  {
                     scaleFurniture(_loc4_);
                     if(_loc4_.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_WALL)
                     {
                        if(_loc4_.getCategory() != FurnitureCategory.FURNITURE_CARPET)
                        {
                           m_sceneObjects.push(_loc4_);
                        }
                        else
                        {
                           m_rugObjects.push(_loc4_);
                           m_furnitureRugContainer.addChild(Sprite(_loc4_));
                        }
                     }
                     else
                     {
                        m_wallObjects.push(_loc4_);
                        m_furnitureWallContainer.addChild(Sprite(_loc4_));
                     }
                  }
                  else
                  {
                     m_structureObjects.push(_loc4_);
                     m_furnitureStructureContainer.addChild(Sprite(_loc4_));
                  }
               }
            }
            _loc5_++;
         }
         sortDepths();
         dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_RESET_SCENE_OBJECTS,null));
      }
      
      internal function onCloseStorageListener(param1:Event) : void
      {
         removeChild(m_storageMenu);
         m_isStorageOpen = false;
         s_iconStorage.gotoAndStop("off");
      }
      
      internal function onMouseOverListener(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(param1.currentTarget != s_exitEdit)
         {
            if(param1.currentTarget == s_iconStorage)
            {
               if(!m_isStorageOpen)
               {
                  s_iconStorage.gotoAndStop("over");
               }
            }
         }
         else
         {
            _loc2_ = new TextFormat("arial",18);
            _loc2_.align = TextFormatAlign.CENTER;
            s_exitEdit.s_text.s_text.text = "Save and Exit";
            s_exitEdit.s_text.s_text.embedFonts = true;
            s_exitEdit.s_text.s_text.antiAliasType = AntiAliasType.ADVANCED;
            s_exitEdit.s_text.s_text.setTextFormat(_loc2_);
            s_exitEdit.gotoAndStop("over");
         }
      }
      
      internal function scaleFurniture(param1:IFurnitureItem) : void
      {
         var _loc2_:* = NaN;
         if(param1.getCategory() == FurnitureCategory.FURNITURE_STRUCTURE)
         {
            return;
         }
         _loc2_ = 1;
         if(param1.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_FLOOR)
         {
            if(param1.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_CEILING)
            {
               if(param1.getAttachment() == FurnitureCategory.FURNITURE_ATTACH_WALL)
               {
                  if(s_left.hitTestPoint(Sprite(param1).x,Sprite(param1).y,true))
                  {
                     _loc2_ = m_furnitureWallScaleLimits[0] + (FURNITURE_LEFT_WALL_MINIMUM_SCALE_X_OFFSET - Sprite(param1).x) / SIDE_WALL_WIDTH * (m_furnitureWallScaleLimits[1] - m_furnitureWallScaleLimits[0]);
                  }
                  else if(s_right.hitTestPoint(Sprite(param1).x,Sprite(param1).y,true))
                  {
                     _loc2_ = m_furnitureWallScaleLimits[0] + (Sprite(param1).x - RIGHT_WALL_X_OFFSET) / SIDE_WALL_WIDTH * (m_furnitureWallScaleLimits[1] - m_furnitureWallScaleLimits[0]);
                  }
                  Sprite(param1).scaleX = _loc2_;
                  Sprite(param1).scaleY = _loc2_;
               }
            }
            else
            {
               _loc2_ = m_furnitureCeilingScaleLimits[1] - Sprite(param1).y / FURNITURE_CEILING_MINIMUM_SCALE_Y_OFFSET * (m_furnitureCeilingScaleLimits[1] - m_furnitureCeilingScaleLimits[0]);
               if(_loc2_ > m_furnitureCeilingScaleLimits[1])
               {
                  _loc2_ = m_furnitureCeilingScaleLimits[1];
               }
               else if(_loc2_ < m_furnitureCeilingScaleLimits[0])
               {
                  _loc2_ = m_furnitureCeilingScaleLimits[0];
               }
               Sprite(param1).scaleX = _loc2_;
               Sprite(param1).scaleY = _loc2_;
            }
         }
         else
         {
            _loc2_ = m_furnitureFloorScaleLimits[0] + Sprite(param1).y / FURNITURE_FLOOR_FULL_SCALE_Y_OFFSET * (m_furnitureFloorScaleLimits[1] - m_furnitureFloorScaleLimits[0]);
            Sprite(param1).scaleX = _loc2_;
            Sprite(param1).scaleY = _loc2_;
         }
      }
      
      override public function updateScene() : void
      {
         var _loc1_:* = 0;
         super.updateScene();
         var _loc2_:* = m_sceneTime;
         switch(_loc2_)
         {
            case SCENE_TIME_DAY:
            case SCENE_TIME_EVENING:
            case SCENE_TIME_NIGHT:
            case SCENE_TIME_MORNING:
         }
         if(m_petList.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < m_petList.length)
            {
               IAvatar(m_petList[_loc1_]).updateAvatar();
               _loc1_++;
            }
         }
      }
      
      public function getAvatarSpawnPoint() : Point
      {
         return m_spawnPoint;
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      public function sortDepths() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < m_furnitureContainer.numChildren - 1)
         {
            _loc1_ = IInteractiveObject(m_furnitureContainer.getChildAt(_loc3_));
            _loc5_ = _loc3_ + 1;
            while(_loc5_ < m_furnitureContainer.numChildren)
            {
               _loc2_ = IInteractiveObject(m_furnitureContainer.getChildAt(_loc5_));
               if(_loc2_.getYDepth() < _loc1_.getYDepth())
               {
                  m_furnitureContainer.swapChildrenAt(_loc3_,_loc5_);
                  _loc1_ = _loc2_;
               }
               _loc5_++;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < m_furnitureWallContainer.numChildren - 1)
         {
            _loc1_ = IInteractiveObject(m_furnitureWallContainer.getChildAt(_loc3_));
            _loc5_ = _loc3_ + 1;
            while(_loc5_ < m_furnitureWallContainer.numChildren)
            {
               _loc2_ = IInteractiveObject(m_furnitureWallContainer.getChildAt(_loc5_));
               if(_loc2_.getYDepth() < _loc1_.getYDepth())
               {
                  m_furnitureWallContainer.swapChildrenAt(_loc3_,_loc5_);
                  _loc1_ = _loc2_;
               }
               _loc5_++;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < m_furnitureRugContainer.numChildren - 1)
         {
            _loc1_ = IInteractiveObject(m_furnitureRugContainer.getChildAt(_loc3_));
            _loc5_ = _loc3_ + 1;
            while(_loc5_ < m_furnitureRugContainer.numChildren)
            {
               _loc2_ = IInteractiveObject(m_furnitureRugContainer.getChildAt(_loc5_));
               if(_loc2_.getYDepth() < _loc1_.getYDepth())
               {
                  m_furnitureRugContainer.swapChildrenAt(_loc3_,_loc5_);
                  _loc1_ = _loc2_;
               }
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      public function setEditMode(param1:Boolean) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         m_isEditMode = param1;
         if(m_isEditMode)
         {
            s_iconCatalog.visible = true;
            s_iconStorage.visible = true;
            s_iconHelp.visible = true;
            s_exitEdit.visible = true;
            s_exitEdit.gotoAndStop("off");
            getRugObjects(m_furnitureRugContainer);
            getWallObjects(m_furnitureWallContainer);
            getStructureObjects(m_furnitureStructureContainer);
            getSceneObjects(m_furnitureContainer);
            addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveListener,false,0,true);
            addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener,false,0,true);
            sortDepths();
         }
         else
         {
            s_iconCatalog.visible = false;
            s_iconStorage.visible = false;
            s_iconHelp.visible = false;
            s_exitEdit.visible = false;
            m_isReturnToStorage = false;
            m_selectedFurniture = null;
            s_iconStorage.gotoAndStop("off");
            m_isStorageOpen = false;
            if(Boolean(m_storageMenu) && contains(m_storageMenu))
            {
               removeChild(m_storageMenu);
            }
            removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveListener);
            removeEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
            _loc2_ = new String();
            while(s_ground.numChildren > 1)
            {
               s_ground.removeChildAt(1);
            }
            _loc4_ = 0;
            while(_loc4_ < m_sceneObjects.length)
            {
               if(m_sceneObjects[_loc4_] is IFurnitureItem)
               {
                  returnFurnitureToValidPositions(m_sceneObjects[_loc4_]);
                  _loc3_ = new String(IFurnitureItem(m_sceneObjects[_loc4_]).getId());
                  _loc3_ = _loc3_.concat(":" + IFurnitureItem(m_sceneObjects[_loc4_]).getSpriteIndex());
                  _loc3_ = _loc3_.concat(":" + Math.round(Sprite(m_sceneObjects[_loc4_]).x));
                  _loc3_ = _loc3_.concat(":" + Math.round(Sprite(m_sceneObjects[_loc4_]).y));
                  if(_loc2_.length != 0)
                  {
                     _loc2_ = _loc2_.concat("," + _loc3_);
                  }
                  else
                  {
                     _loc2_ = _loc2_.concat(_loc3_);
                  }
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < m_wallObjects.length)
            {
               if(m_wallObjects[_loc4_] is IFurnitureItem)
               {
                  returnFurnitureToValidPositions(m_wallObjects[_loc4_]);
                  _loc3_ = new String(IFurnitureItem(m_wallObjects[_loc4_]).getId());
                  _loc3_ = _loc3_.concat(":" + IFurnitureItem(m_wallObjects[_loc4_]).getSpriteIndex());
                  _loc3_ = _loc3_.concat(":" + Math.round(Sprite(m_wallObjects[_loc4_]).x));
                  _loc3_ = _loc3_.concat(":" + Math.round(Sprite(m_wallObjects[_loc4_]).y));
                  if(_loc2_.length != 0)
                  {
                     _loc2_ = _loc2_.concat("," + _loc3_);
                  }
                  else
                  {
                     _loc2_ = _loc2_.concat(_loc3_);
                  }
               }
               _loc4_++;
            }
            removeDulpicateFurnitureStructures();
            _loc4_ = 0;
            while(_loc4_ < m_structureObjects.length)
            {
               if(m_structureObjects[_loc4_] is IFurnitureItem)
               {
                  returnFurnitureToValidPositions(m_structureObjects[_loc4_]);
                  _loc3_ = new String(IFurnitureItem(m_structureObjects[_loc4_]).getId());
                  _loc3_ = _loc3_.concat(":" + IFurnitureItem(m_structureObjects[_loc4_]).getSpriteIndex());
                  _loc3_ = _loc3_.concat(":" + Math.round(Sprite(m_structureObjects[_loc4_]).x));
                  _loc3_ = _loc3_.concat(":" + Math.round(Sprite(m_structureObjects[_loc4_]).y));
                  if(_loc2_.length != 0)
                  {
                     _loc2_ = _loc2_.concat("," + _loc3_);
                  }
                  else
                  {
                     _loc2_ = _loc2_.concat(_loc3_);
                  }
                  Sprite(m_structureObjects[_loc4_]).cacheAsBitmap = true;
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < m_rugObjects.length)
            {
               if(m_rugObjects[_loc4_] is IFurnitureItem)
               {
                  returnFurnitureToValidPositions(m_rugObjects[_loc4_]);
                  _loc3_ = new String(IFurnitureItem(m_rugObjects[_loc4_]).getId());
                  _loc3_ = _loc3_.concat(":" + IFurnitureItem(m_rugObjects[_loc4_]).getSpriteIndex());
                  _loc3_ = _loc3_.concat(":" + Math.round(Sprite(m_rugObjects[_loc4_]).x));
                  _loc3_ = _loc3_.concat(":" + Math.round(Sprite(m_rugObjects[_loc4_]).y));
                  if(_loc2_.length != 0)
                  {
                     _loc2_ = _loc2_.concat("," + _loc3_);
                  }
                  else
                  {
                     _loc2_ = _loc2_.concat(_loc3_);
                  }
               }
               _loc4_++;
            }
            _loc5_ = new Object();
            _loc5_.furniture = _loc2_;
            _loc5_.storage = PlayerAttributes.getInstance().getFurnitureStorageList();
            dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_PLACE_FURNITURE,_loc5_));
            dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_RESET_SCENE_OBJECTS,null));
            _loc6_ = new Object();
            _loc6_.doEdit = m_isEditMode;
            dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_TOGGLE_HOUSE_EDIT,_loc6_));
         }
         m_isStorageOpen = false;
      }
      
      public function getWallObjects(param1:Sprite) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < m_wallObjects.length)
         {
            if(m_wallObjects[_loc2_])
            {
               if(m_wallObjects[_loc2_].getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
               {
                  param1.addChild(m_wallObjects[_loc2_]);
               }
               else
               {
                  param1.addChildAt(m_wallObjects[_loc2_],0);
               }
            }
            _loc2_++;
         }
      }
      
      public function setPets(param1:Array) : void
      {
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(m_petList[_loc2_])
            {
               m_petList[_loc2_].updatePetInfo(param1[_loc2_]);
               return;
            }
            m_petList.push(param1[_loc2_]);
            _loc2_++;
         }
         _loc6_ = 0;
         _loc2_ = 0;
         while(_loc2_ < m_petList.length)
         {
            if(IPet(m_petList[_loc2_]).isEgg())
            {
               _loc4_ = 150 + 90 * (_loc6_ % 8);
               _loc5_ = 530 - 65 * Math.floor(_loc6_ / 8);
               _loc6_++;
            }
            else
            {
               do
               {
                  _loc4_ = Math.random() * 935;
                  _loc5_ = Math.random() * 350 + 200;
               }
               while(!s_ground.hitTestPoint(_loc4_,_loc5_,true));
               
            }
            m_petList[_loc2_].x = _loc4_;
            m_petList[_loc2_].y = _loc5_;
            m_interactiveContainer.addChild(m_petList[_loc2_]);
            _loc2_++;
         }
      }
      
      internal function onClickListener(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         if(param1.target == s_exitEdit)
         {
            setEditMode(false);
            return;
         }
         if(param1.target != s_iconHelp)
         {
            if(param1.target != s_iconCatalog)
            {
               if(param1.target == s_iconStorage)
               {
                  if(!m_selectedFurniture)
                  {
                     m_isStorageOpen = !m_isStorageOpen;
                     if(m_isStorageOpen)
                     {
                        s_iconStorage.gotoAndStop("off");
                        addChild(m_storageMenu);
                        m_storageMenu.openStorage();
                     }
                     else
                     {
                        s_iconStorage.gotoAndStop("off");
                        if(contains(m_storageMenu))
                        {
                           removeChild(m_storageMenu);
                        }
                     }
                  }
               }
            }
            else
            {
               trace("load the furniture catalog");
               _loc2_ = new Object();
               _loc2_.type = GameConstants.SHOPPING_CART_FURNITURE;
               dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_OPEN_SHOPPING_CART,_loc2_));
            }
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_SHOW_HOUSE_HELP,null));
         }
         if(m_isEditMode)
         {
            if(m_selectedFurniture)
            {
               if(s_iconStorage.hitTestPoint(mouseX,mouseY))
               {
                  if(contains(Sprite(m_selectedFurniture)))
                  {
                     removeChild(Sprite(m_selectedFurniture));
                     s_iconRemove.visible = false;
                  }
                  PlayerAttributes.getInstance().addFurnitureToStorage(m_selectedFurniture.getId());
                  _loc3_ = 0;
                  while(_loc3_ < m_sceneObjects.length)
                  {
                     if(m_sceneObjects[_loc3_] == m_selectedFurniture)
                     {
                        m_sceneObjects.splice(_loc3_,1);
                        break;
                     }
                     _loc3_++;
                  }
                  _loc3_ = 0;
                  while(_loc3_ < m_wallObjects.length)
                  {
                     if(m_wallObjects[_loc3_] == m_selectedFurniture)
                     {
                        m_wallObjects.splice(_loc3_,1);
                        break;
                     }
                     _loc3_++;
                  }
                  _loc3_ = 0;
                  while(_loc3_ < m_structureObjects.length)
                  {
                     if(m_structureObjects[_loc3_] == m_selectedFurniture)
                     {
                        m_structureObjects.splice(_loc3_,1);
                        break;
                     }
                     _loc3_++;
                  }
                  _loc3_ = 0;
                  while(_loc3_ < m_rugObjects.length)
                  {
                     if(m_rugObjects[_loc3_] == m_selectedFurniture)
                     {
                        m_rugObjects.splice(_loc3_,1);
                        break;
                     }
                     _loc3_++;
                  }
               }
               else if(m_selectedFurniture.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
               {
                  if(Sprite(m_selectedFurniture).alpha != 1)
                  {
                     Sprite(m_selectedFurniture).x = m_selectedStartPosition.x;
                     Sprite(m_selectedFurniture).y = m_selectedStartPosition.y;
                     Sprite(m_selectedFurniture).alpha = 1;
                     if(m_selectedFurniture.getAttachment() == FurnitureCategory.FURNITURE_ATTACH_WALL)
                     {
                        if(s_left.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_LEFT);
                        }
                        if(s_right.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_RIGHT);
                        }
                        if(s_back.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_BACK);
                        }
                     }
                  }
                  scaleFurniture(m_selectedFurniture);
                  if(m_selectedFurniture.getAttachment() == FurnitureCategory.FURNITURE_ATTACH_WALL)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < m_wallObjects.length)
                     {
                        if(m_wallObjects[_loc3_] == m_selectedFurniture)
                        {
                           m_wallObjects.splice(_loc3_,1);
                           m_wallObjects.push(m_selectedFurniture);
                        }
                        _loc3_++;
                     }
                  }
                  if(m_selectedFurniture.getCategory() == FurnitureCategory.FURNITURE_CARPET)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < m_rugObjects.length)
                     {
                        if(m_rugObjects[_loc3_] == m_selectedFurniture)
                        {
                           m_rugObjects.splice(_loc3_,1);
                           m_rugObjects.push(m_selectedFurniture);
                        }
                        _loc3_++;
                     }
                  }
               }
               else
               {
                  Sprite(m_selectedFurniture).alpha = 1;
                  if(m_selectedFurniture.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_WALL)
                  {
                     if(m_selectedFurniture.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_FLOOR)
                     {
                        if(m_selectedFurniture.getAttachment() == FurnitureCategory.FURNITURE_ATTACH_CEILING)
                        {
                           Sprite(m_selectedFurniture).x = STRUCTURE_CEILING_X_OFFSET;
                           Sprite(m_selectedFurniture).y = STRUCTURE_CEILING_Y_OFFSET;
                        }
                     }
                     else
                     {
                        Sprite(m_selectedFurniture).x = STRUCTURE_FLOOR_X_OFFSET;
                        Sprite(m_selectedFurniture).y = STRUCTURE_FLOOR_Y_OFFSET;
                     }
                  }
                  else if(mouseX < LEFT_WALL_MOUSE_X_LIMIT && mouseY < 500)
                  {
                     Sprite(m_selectedFurniture).x = LEFT_STRUCTURE_WALL_PLACEMENT_X_OFFSET;
                     Sprite(m_selectedFurniture).y = LEFT_STRUCTURE_WALL_PLACEMENT_Y_OFFSET;
                  }
                  else if(mouseX > RIGHT_WALL_MOUSE_X_LIMIT && mouseY < 500)
                  {
                     Sprite(m_selectedFurniture).x = RIGHT_STRUCTURE_WALL_PLACEMENT_X_OFFSET;
                     Sprite(m_selectedFurniture).y = RIGHT_STRUCTURE_WALL_PLACEMENT_Y_OFFSET;
                  }
                  else
                  {
                     Sprite(m_selectedFurniture).x = BACK_STRUCTURE_WALL_PLACEMENT_X_OFFSET;
                     Sprite(m_selectedFurniture).y = BACK_STRUCTURE_WALL_PLACEMENT_Y_OFFSET;
                  }
               }
               s_iconHelp.visible = true;
               m_selectedFurniture.setGlow(false);
               m_selectedFurniture = null;
               sortDepths();
            }
            else if(param1.target is IFurnitureItem)
            {
               m_selectedFurniture = IFurnitureItem(param1.target);
               if(m_selectedFurniture.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
               {
                  m_selectedOffset = new Point(Sprite(m_selectedFurniture).x - mouseX,Sprite(m_selectedFurniture).y - mouseY);
               }
               else
               {
                  m_selectedOffset = new Point(-m_selectedFurniture.getSpriteWidth() / 2,-m_selectedFurniture.getSpriteHeight() / 2);
               }
               m_selectedFurniture.setGlow(true);
               m_selectedStartPosition = new Point(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y);
               s_iconHelp.visible = false;
            }
         }
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return m_avatarScaleLimits;
      }
      
      internal function onMouseMoveListener(param1:MouseEvent) : void
      {
         if(!m_isEditMode)
         {
            return;
         }
         if(Boolean(m_selectedFurniture) && Boolean(m_selectedOffset))
         {
            Sprite(m_selectedFurniture).x = Math.round(mouseX + m_selectedOffset.x);
            Sprite(m_selectedFurniture).y = Math.round(mouseY + m_selectedOffset.y);
            Sprite(m_selectedFurniture).alpha = 1;
            if(s_iconStorage.hitTestPoint(mouseX,mouseY))
            {
               Sprite(m_selectedFurniture).alpha = 0.5;
               addChild(Sprite(m_selectedFurniture));
               s_iconRemove.x = mouseX - 29;
               s_iconRemove.y = mouseY - 60;
               s_iconRemove.visible = true;
               addChild(s_iconRemove);
               if(!m_isReturnToStorage)
               {
                  m_isReturnToStorage = true;
                  Sprite(m_selectedFurniture).scaleX = 0.5;
                  Sprite(m_selectedFurniture).scaleY = 0.5;
               }
            }
            else
            {
               if(contains(Sprite(m_selectedFurniture)))
               {
                  if(m_selectedFurniture.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
                  {
                     if(m_selectedFurniture.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_WALL)
                     {
                        if(m_selectedFurniture.getCategory() != FurnitureCategory.FURNITURE_CARPET)
                        {
                           m_furnitureContainer.addChild(Sprite(m_selectedFurniture));
                        }
                        else
                        {
                           m_furnitureRugContainer.addChild(Sprite(m_selectedFurniture));
                        }
                     }
                     else
                     {
                        m_furnitureWallContainer.addChild(Sprite(m_selectedFurniture));
                        if(s_left.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_LEFT);
                        }
                        if(s_right.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_RIGHT);
                        }
                        if(s_back.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_BACK);
                        }
                     }
                  }
                  else
                  {
                     m_furnitureStructureContainer.addChild(Sprite(m_selectedFurniture));
                     if(m_selectedFurniture.getAttachment() == FurnitureCategory.FURNITURE_ATTACH_WALL)
                     {
                        if(mouseX < LEFT_WALL_MOUSE_X_LIMIT && mouseY < 500)
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_LEFT);
                        }
                        else if(mouseX > RIGHT_WALL_MOUSE_X_LIMIT && mouseY < 500)
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_RIGHT);
                        }
                        else
                        {
                           m_selectedFurniture.setWall(FurnitureCategory.FURNITURE_WALL_BACK);
                        }
                     }
                     m_selectedOffset = new Point(-m_selectedFurniture.getSpriteWidth() / 2,-m_selectedFurniture.getSpriteHeight() / 2);
                     Sprite(m_selectedFurniture).x = Math.round(mouseX + m_selectedOffset.x);
                     Sprite(m_selectedFurniture).y = Math.round(mouseY + m_selectedOffset.y);
                  }
                  s_iconRemove.visible = false;
                  m_isReturnToStorage = false;
                  Sprite(m_selectedFurniture).scaleX = 1;
                  Sprite(m_selectedFurniture).scaleY = 1;
               }
               if(m_selectedFurniture.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_FLOOR)
               {
                  if(m_selectedFurniture.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_CEILING)
                  {
                     if(m_selectedFurniture.getAttachment() == FurnitureCategory.FURNITURE_ATTACH_WALL)
                     {
                        if(m_selectedFurniture.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
                        {
                           if(!s_left.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true) && !s_right.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true) && !s_back.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
                           {
                              Sprite(m_selectedFurniture).alpha = 0.5;
                           }
                        }
                        else if(mouseY > 500)
                        {
                           Sprite(m_selectedFurniture).alpha = 0.5;
                        }
                     }
                  }
                  else if(!s_ceiling.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
                  {
                     Sprite(m_selectedFurniture).alpha = 0.5;
                  }
               }
               else if(!s_groundFurniture.hitTestPoint(Sprite(m_selectedFurniture).x,Sprite(m_selectedFurniture).y,true))
               {
                  Sprite(m_selectedFurniture).alpha = 0.5;
               }
               if(m_selectedFurniture.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
               {
                  scaleFurniture(m_selectedFurniture);
               }
               sortDepths();
            }
         }
      }
      
      internal function returnFurnitureToValidPositions(param1:IFurnitureItem) : void
      {
         if(param1.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_FLOOR)
         {
            if(param1.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_CEILING)
            {
               if(param1.getAttachment() == FurnitureCategory.FURNITURE_ATTACH_WALL)
               {
                  if(param1.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
                  {
                     if(!s_left.hitTestPoint(Sprite(param1).x,Sprite(param1).y,true) && !s_right.hitTestPoint(Sprite(param1).x,Sprite(param1).y,true) && !s_back.hitTestPoint(Sprite(param1).x,Sprite(param1).y,true))
                     {
                        Sprite(param1).x = DEFAULT_FURNITURE_PLACEMENT_X_OFFSET;
                        Sprite(param1).y = DEFAULT_FURNITURE_WALL_PLACEMENT_Y_OFFSET;
                        scaleFurniture(IFurnitureItem(param1));
                        Sprite(param1).alpha = 1;
                        param1.setGlow(false);
                     }
                  }
                  else
                  {
                     if(param1.getWallIndex() != 2)
                     {
                        if(param1.getWallIndex() != 1)
                        {
                           Sprite(param1).x = BACK_STRUCTURE_WALL_PLACEMENT_X_OFFSET;
                           Sprite(param1).y = BACK_STRUCTURE_WALL_PLACEMENT_Y_OFFSET;
                        }
                        else
                        {
                           Sprite(param1).x = RIGHT_STRUCTURE_WALL_PLACEMENT_X_OFFSET;
                           Sprite(param1).y = RIGHT_STRUCTURE_WALL_PLACEMENT_Y_OFFSET;
                        }
                     }
                     else
                     {
                        Sprite(param1).x = LEFT_STRUCTURE_WALL_PLACEMENT_X_OFFSET;
                        Sprite(param1).y = LEFT_STRUCTURE_WALL_PLACEMENT_Y_OFFSET;
                     }
                     Sprite(param1).alpha = 1;
                     param1.setGlow(false);
                  }
               }
            }
            else if(param1.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
            {
               if(!s_ceiling.hitTestPoint(Sprite(param1).x,Sprite(param1).y,true))
               {
                  Sprite(param1).x = DEFAULT_FURNITURE_PLACEMENT_X_OFFSET;
                  Sprite(param1).y = DEFAULT_FURNITURE_CEILING_PLACEMENT_Y_OFFSET;
                  scaleFurniture(IFurnitureItem(param1));
                  Sprite(param1).alpha = 1;
                  param1.setGlow(false);
               }
            }
            else
            {
               Sprite(param1).x = STRUCTURE_CEILING_X_OFFSET;
               Sprite(param1).y = STRUCTURE_CEILING_Y_OFFSET;
               scaleFurniture(IFurnitureItem(param1));
               Sprite(param1).alpha = 1;
               param1.setGlow(false);
            }
         }
         else if(param1.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
         {
            if(!s_groundFurniture.hitTestPoint(Sprite(param1).x,Sprite(param1).y,true) || Sprite(param1).y > MAX_FURNITURE_FLOOR_PLACEMENT_Y_OFFSET)
            {
               Sprite(param1).x = DEFAULT_FURNITURE_PLACEMENT_X_OFFSET;
               Sprite(param1).y = DEFAULT_FURNITURE_FLOOR_PLACEMENT_Y_OFFSET;
               scaleFurniture(IFurnitureItem(param1));
               Sprite(param1).alpha = 1;
               param1.setGlow(false);
            }
         }
         else
         {
            Sprite(param1).x = STRUCTURE_FLOOR_X_OFFSET;
            Sprite(param1).y = STRUCTURE_FLOOR_Y_OFFSET;
            scaleFurniture(IFurnitureItem(param1));
            Sprite(param1).alpha = 1;
            param1.setGlow(false);
         }
      }
      
      public function handleKeyboardInput(param1:uint) : void
      {
         if(Boolean(m_isEditMode) && Boolean(m_selectedFurniture))
         {
            trace("rotate furniture");
            if(param1 != Keyboard.LEFT)
            {
               if(param1 == Keyboard.RIGHT)
               {
                  m_selectedFurniture.rotateSprite(true);
               }
            }
            else
            {
               m_selectedFurniture.rotateSprite(false);
            }
         }
      }
      
      internal function onAddFurnitureToRoom(param1:GameEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(param1.params.itemId)
         {
            m_storageMenu.closeStorage();
            _loc2_ = m_sceneObjects.length + m_wallObjects.length + m_rugObjects.length;
            if(_loc2_ > MAX_PLACED_FURNITURE)
            {
               _loc4_ = new Object();
               _loc4_.title = "Room Too Crowded";
               _loc4_.msg = "You have reached the maximum amount furniture you can place in your tree house. You must put some furniture back into storage before you can place any more new furniture.";
               dispatchEvent(new GameEvent(GameEvent.EVENT_DISPLAY_GAME_MESSAGE_DIALOG,_loc4_));
               return;
            }
            _loc3_ = FurnitureItems.getInstance().getFurnitureItem(param1.params.itemId);
            if(_loc3_)
            {
               if(_loc3_.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_FLOOR)
               {
                  if(_loc3_.getAttachment() != FurnitureCategory.FURNITURE_ATTACH_CEILING)
                  {
                     if(_loc3_.getAttachment() == FurnitureCategory.FURNITURE_ATTACH_WALL)
                     {
                        if(_loc3_.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
                        {
                           Sprite(_loc3_).x = DEFAULT_FURNITURE_PLACEMENT_X_OFFSET;
                           Sprite(_loc3_).y = DEFAULT_FURNITURE_WALL_PLACEMENT_Y_OFFSET;
                           m_wallObjects.push(_loc3_);
                        }
                        else
                        {
                           Sprite(_loc3_).x = BACK_STRUCTURE_WALL_PLACEMENT_X_OFFSET;
                           Sprite(_loc3_).y = BACK_STRUCTURE_WALL_PLACEMENT_Y_OFFSET + 150;
                           m_structureObjects.push(_loc3_);
                        }
                     }
                  }
                  else if(_loc3_.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
                  {
                     Sprite(_loc3_).x = DEFAULT_FURNITURE_PLACEMENT_X_OFFSET;
                     Sprite(_loc3_).y = DEFAULT_FURNITURE_CEILING_PLACEMENT_Y_OFFSET;
                     m_sceneObjects.push(_loc3_);
                  }
                  else
                  {
                     Sprite(_loc3_).x = STRUCTURE_CEILING_X_OFFSET;
                     Sprite(_loc3_).y = STRUCTURE_CEILING_Y_OFFSET;
                     m_structureObjects.push(_loc3_);
                  }
               }
               else if(_loc3_.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
               {
                  Sprite(_loc3_).x = DEFAULT_FURNITURE_PLACEMENT_X_OFFSET;
                  Sprite(_loc3_).y = DEFAULT_FURNITURE_FLOOR_PLACEMENT_Y_OFFSET;
                  if(_loc3_.getCategory() != FurnitureCategory.FURNITURE_CARPET)
                  {
                     m_sceneObjects.push(_loc3_);
                  }
                  else
                  {
                     m_rugObjects.push(_loc3_);
                  }
               }
               else
               {
                  Sprite(_loc3_).x = STRUCTURE_FLOOR_X_OFFSET;
                  Sprite(_loc3_).y = STRUCTURE_FLOOR_Y_OFFSET;
                  m_structureObjects.push(_loc3_);
               }
               PlayerAttributes.getInstance().removeFurnitureFromStorage(_loc3_.getId());
               if(_loc3_.getCategory() != FurnitureCategory.FURNITURE_STRUCTURE)
               {
                  scaleFurniture(_loc3_);
               }
               getRugObjects(m_furnitureRugContainer);
               getWallObjects(m_furnitureWallContainer);
               getStructureObjects(m_furnitureStructureContainer);
               getSceneObjects(m_furnitureContainer);
            }
         }
      }
      
      public function checkForExit(param1:Point) : String
      {
         return null;
      }
      
      public function getSceneObjects(param1:Sprite) : void
      {
         var _loc2_:* = 0;
         m_interactiveContainer = param1;
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
      
      internal function keyDownListener(param1:KeyboardEvent) : void
      {
         trace(param1.keyCode);
         if(param1.keyCode != Keyboard.LEFT)
         {
            if(param1.keyCode == Keyboard.RIGHT)
            {
               trace("right.....");
            }
         }
         else
         {
            trace("left.....");
         }
      }
      
      public function getRugObjects(param1:Sprite) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < m_rugObjects.length)
         {
            if(m_rugObjects[_loc2_])
            {
               param1.addChild(m_rugObjects[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function getMouseCursorType() : String
      {
         if(m_isEditMode)
         {
            return "ui";
         }
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         return "ground";
      }
   }
}

