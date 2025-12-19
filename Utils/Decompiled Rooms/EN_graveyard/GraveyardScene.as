package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.text.*;
   
   public class GraveyardScene extends SceneRoot implements IScene, ICommunityGameScene
   {
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.67;
      
      internal static const MAX_GHOST_COUNT:int = 6;
      
      internal static const MAX_GHOST_WALK_DISTANCE:int = 700;
      
      internal static const ICE_BLOCK_TIMER:int = 90;
      
      internal static const MAX_SQUARED_DISTANCE_TO_COLLECT_GHOST:int = 9000;
      
      internal static const MIN_GHOSTS_UNTIL_COLORED_SPAWN:int = 15;
      
      internal static const DEBUG:int = 0;
      
      internal var m_interactiveContainer:Sprite;
      
      internal var m_date:GraveyardDateHeadstone;
      
      internal var m_ghostList:Array;
      
      internal var m_hasShownScoreBoard:Boolean;
      
      internal var m_serverCoinsEarned:int = -1;
      
      internal var m_scoreBoard:GraveyardScoreBoard;
      
      public var direction_left:SimpleButton;
      
      internal var m_ghostExits:Array;
      
      internal var m_fluffy:GraveyardFluffyHeadstone;
      
      internal var m_helpDialog:GraveyardHelpDialog;
      
      public var graveyard_mc:Sprite;
      
      public var s_eyes2:GraveyardEyes;
      
      internal var m_hasGameStarted:Boolean;
      
      internal var m_iceBlockTimer:int;
      
      public var s_eyes1:GraveyardEyes;
      
      public var s_eyes3:GraveyardEyes;
      
      internal var m_clientAvatar:IAvatar;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_exitGhosts:Boolean;
      
      public var s_help:SimpleButton;
      
      internal var m_fog1:GraveyardFog1;
      
      internal var m_window:GraveyardWindow;
      
      public var direction_right:SimpleButton;
      
      internal var m_isInProgress:Boolean;
      
      public var s_score:MovieClip;
      
      internal var m_headstone1:GraveyardHeadstone1;
      
      internal var m_uiContainer:Sprite;
      
      internal var m_spawnPoint:Point;
      
      public var s_exitToHH:Sprite;
      
      internal var m_rightrailing:GraveyardRightRailing;
      
      internal var m_fog2:GraveyardFog1;
      
      public var s_lightning:GraveyardLightning;
      
      internal var m_headstone2:GraveyardHeadstone1;
      
      public var s_exitToForest:Sprite;
      
      internal var m_cross:GraveyardCross;
      
      internal var m_flat:GraveyardFlatHeadstone;
      
      internal var m_slimeList:Array;
      
      internal var m_leftrailing:GraveyardLeftRailing;
      
      internal var m_rip:GraveyardRIPheadstone;
      
      internal var m_ghostsCaught:int;
      
      public function GraveyardScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("GraveyardScene Constructor");
         this.m_spawnPoint = new Point(50,520);
         this.m_avatarScaleLimits = new Array(0.35,1);
         this.m_helpDialog = new GraveyardHelpDialog();
         this.graveyard_mc.mouseEnabled = false;
         this.graveyard_mc.cacheAsBitmap = true;
         this.s_exitToHH.visible = false;
         this.s_exitToForest.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         this.s_lightning.gotoAndStop(1);
         this.s_eyes1.gotoAndStop(1);
         this.s_eyes2.gotoAndStop(1);
         this.s_eyes3.gotoAndStop(1);
         this.s_score.mouseEnabled = false;
         this.s_score.visible = false;
         this.m_scoreBoard = new GraveyardScoreBoard();
         this.m_isInProgress = false;
         this.m_hasShownScoreBoard = false;
         this.m_ghostList = new Array();
         this.m_slimeList = new Array();
         this.m_hasGameStarted = false;
         this.m_exitGhosts = false;
         this.m_iceBlockTimer = 0;
         this.m_ghostExits = new Array();
         this.m_ghostExits.push(new Point(960,620));
         this.m_ghostExits.push(new Point(-60,180));
         this.m_ghostExits.push(new Point(960,183));
         this.m_ghostExits.push(new Point(610,700));
         this.m_ghostExits.push(new Point(-60,600));
         this.m_ghostsCaught = 0;
         this.m_serverCoinsEarned = -1;
         this.m_uiContainer = new Sprite();
         m_effectsContainerNightMask = new GraveyardNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         this.m_rip = new GraveyardRIPheadstone();
         this.m_rip.x = 35;
         this.m_rip.y = 417;
         this.m_rip.width = 95;
         this.m_rip.height = 85;
         this.m_rip.setYDepth(485);
         this.m_flat = new GraveyardFlatHeadstone();
         this.m_flat.x = 423;
         this.m_flat.y = 365;
         this.m_flat.width = 111;
         this.m_flat.height = 72;
         this.m_flat.setYDepth(390);
         this.m_fluffy = new GraveyardFluffyHeadstone();
         this.m_fluffy.x = 693;
         this.m_fluffy.y = 342;
         this.m_fluffy.width = 101;
         this.m_fluffy.height = 89;
         this.m_fluffy.setYDepth(414);
         this.m_date = new GraveyardDateHeadstone();
         this.m_date.x = 799;
         this.m_date.y = 241;
         this.m_date.width = 75;
         this.m_date.height = 57;
         this.m_date.setYDepth(283);
         this.m_cross = new GraveyardCross();
         this.m_cross.x = 520;
         this.m_cross.y = 232;
         this.m_cross.width = 67;
         this.m_cross.height = 87;
         this.m_cross.setYDepth(307);
         this.m_headstone1 = new GraveyardHeadstone1();
         this.m_headstone1.x = 377;
         this.m_headstone1.y = 288;
         this.m_headstone1.width = 57;
         this.m_headstone1.height = 45;
         this.m_headstone1.setYDepth(318);
         this.m_headstone2 = new GraveyardHeadstone1();
         this.m_headstone2.x = 460;
         this.m_headstone2.y = 243;
         this.m_headstone2.width = 30;
         this.m_headstone2.height = 24;
         this.m_headstone2.setYDepth(253);
         this.m_leftrailing = new GraveyardLeftRailing();
         this.m_leftrailing.x = 39;
         this.m_leftrailing.y = 316;
         this.m_leftrailing.width = 134;
         this.m_leftrailing.height = 43;
         this.m_leftrailing.setYDepth(351);
         this.m_rightrailing = new GraveyardRightRailing();
         this.m_rightrailing.x = 226;
         this.m_rightrailing.y = 304;
         this.m_rightrailing.width = 115;
         this.m_rightrailing.height = 38;
         this.m_rightrailing.setYDepth(332);
         this.m_fog1 = new GraveyardFog1();
         this.m_fog1.x = 268;
         this.m_fog1.y = 103;
         this.m_fog1.width = 667;
         this.m_fog1.height = 247;
         this.m_fog1.setYDepth(383);
         this.m_fog2 = new GraveyardFog1();
         this.m_fog2.x = 17;
         this.m_fog2.y = 313;
         this.m_fog2.width = 907;
         this.m_fog2.height = 299;
         this.m_fog2.setYDepth(763);
         this.m_window = new GraveyardWindow();
         this.m_window.x = 215;
         this.m_window.y = 90;
         this.m_window.width = 44;
         this.m_window.height = 66;
         this.m_window.setYDepth(156);
         m_sceneObjects = new Array();
         m_sceneObjects.push(this.m_rip);
         m_sceneObjects.push(this.m_flat);
         m_sceneObjects.push(this.m_fluffy);
         m_sceneObjects.push(this.m_date);
         m_sceneObjects.push(this.m_cross);
         m_sceneObjects.push(this.m_headstone1);
         m_sceneObjects.push(this.m_headstone2);
         m_sceneObjects.push(this.m_leftrailing);
         m_sceneObjects.push(this.m_rightrailing);
         m_sceneObjects.push(this.m_fog1);
         m_sceneObjects.push(this.m_fog2);
         m_sceneObjects.push(this.m_window);
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
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_MUSHROOM);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_GEM);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_TREASURE);
         this.s_help.addEventListener(MouseEvent.CLICK,this.onShowHelpDialogListener,false,0,true);
         if(DEBUG)
         {
            _loc2_ = new Sprite();
            addChild(_loc2_);
            this.getSceneObjects(_loc2_);
            addEventListener(Event.ENTER_FRAME,this.updateFrame,false,0,true);
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:* = 0;
         removeEventListener(MouseEvent.CLICK,this.onShowHelpDialogListener);
         m_sceneObjects.length = 0;
         this.m_helpDialog.destroy();
         if(m_effectsContainer)
         {
            while(m_effectsContainer.numChildren > 0)
            {
               m_effectsContainer.removeChildAt(0);
            }
         }
         m_effectsContainer = null;
         if(this.m_uiContainer)
         {
            if(this.m_uiContainer.contains(this.s_score))
            {
               this.m_uiContainer.removeChild(this.s_score);
            }
            if(this.m_uiContainer.contains(this.s_help))
            {
               this.m_uiContainer.removeChild(this.s_help);
            }
            if(this.m_uiContainer.contains(this.m_helpDialog))
            {
               this.m_uiContainer.removeChild(this.m_helpDialog);
            }
         }
         this.m_uiContainer = null;
         _loc1_ = 0;
         while(_loc1_ < this.m_ghostList.length)
         {
            this.m_ghostList[_loc1_].destroy();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.m_slimeList.length)
         {
            this.m_slimeList[_loc1_].destroy();
            _loc1_++;
         }
         this.m_ghostList.length = 0;
         this.m_slimeList.length = 0;
         this.m_ghostExits.length = 0;
         if(this.m_scoreBoard)
         {
            this.m_scoreBoard.destroy();
         }
         super.destroy();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      internal function doAvatarAndSlimeIntersect(param1:Point, param2:IAvatar) : Boolean
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         _loc3_ = param2.getHitZone();
         _loc4_ = this.m_clientAvatar.getAvatarModel();
         if(_loc3_.hitTestObject(_loc4_))
         {
            return true;
         }
         return false;
      }
      
      public function updateScoreBoard(param1:String) : void
      {
         trace("FINAL SCORES");
         trace(param1);
         var playerName:String = PlayerAttributes.getInstance().getName();
         var scoreEntries:Array = param1.split(";");
         var i:int = 0;
         while(i < scoreEntries.length)
         {
            if(scoreEntries[i] && scoreEntries[i].length > 0)
            {
               var entry:Array = scoreEntries[i].split(",");
               if(entry.length >= 4 && entry[1] == playerName)
               {
                  this.m_serverCoinsEarned = parseInt(entry[3]);
                  trace("Found server coins earned for player: " + this.m_serverCoinsEarned);
                  break;
               }
            }
            i++;
         }
         this.showScoreBoard();
         this.m_scoreBoard.updateRankings(param1);
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
      
      internal function initSlimes(param1:String) : void
      {
      }
      
      internal function updateFrame(param1:Event) : void
      {
         this.updateScene();
      }
      
      override public function updateScene() : void
      {
         super.updateScene();
         if(Math.random() * 1000 < 2)
         {
            if(!this.s_lightning.isActive())
            {
               this.s_lightning.playLightning();
            }
         }
         if(Math.random() * 1000 < 2)
         {
            if(!this.s_eyes1.isActive())
            {
               this.s_eyes1.playBlinkingEyes();
            }
         }
         if(Math.random() * 1000 < 2)
         {
            if(!this.s_eyes2.isActive())
            {
               this.s_eyes2.playBlinkingEyes();
            }
         }
         if(Math.random() * 1000 < 2)
         {
            if(!this.s_eyes3.isActive())
            {
               this.s_eyes3.playBlinkingEyes();
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
         if(Boolean(this.m_hasGameStarted) || Boolean(this.m_exitGhosts))
         {
            this.updateGhosts();
         }
      }
      
      internal function moveSlimes(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         _loc2_ = param1.split(";");
         _loc7_ = 0;
         while(_loc7_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc7_].split(",");
            if(_loc4_.length == 3)
            {
               _loc5_ = _loc4_[0];
               if(this.m_slimeList[_loc5_])
               {
                  _loc3_ = new Point(_loc4_[1],_loc4_[2]);
                  this.m_slimeList[_loc5_].walkTo(new Array(_loc3_));
               }
            }
            _loc7_++;
         }
      }
      
      internal function onShowHelpDialogListener(param1:MouseEvent) : void
      {
         if(this.m_uiContainer)
         {
            this.m_uiContainer.addChild(this.m_helpDialog);
         }
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
      }
      
      override public function setMouseClick(param1:Point, param2:Point = null) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         _loc3_ = 0;
         _loc4_ = new Object();
         if(this.m_iceBlockTimer > 0)
         {
            return;
         }
         _loc5_ = 0;
         while(_loc5_ < this.m_ghostList.length)
         {
            if(Boolean(this.m_ghostList[_loc5_].hitTestPoint(param1.x,param1.y)) && Boolean(this.m_ghostList[_loc5_].isActive()))
            {
               if(Boolean(this.m_exitGhosts) && !this.m_ghostList[_loc5_].isWalking())
               {
                  return;
               }
               _loc4_.score = 1;
               dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_UPDATE_GHOST_GAME,_loc4_));
               ++this.m_ghostsCaught;
               this.setGhostScore();
               this.m_ghostList[_loc5_].setFade();
               break;
            }
            _loc5_++;
         }
      }
      
      internal function showScoreBoard() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         if(this.m_hasShownScoreBoard)
         {
            return;
         }
         this.m_hasShownScoreBoard = true;
         _loc1_ = 0;
         this.m_exitGhosts = false;
         this.s_score.visible = false;
         _loc1_ = 0;
         while(_loc1_ < this.m_slimeList.length)
         {
            if(this.m_interactiveContainer.contains(this.m_slimeList[_loc1_]))
            {
               this.m_interactiveContainer.removeChild(this.m_slimeList[_loc1_]);
            }
            this.m_slimeList[_loc1_].destroy();
            _loc1_++;
         }
         this.m_slimeList.length = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_ghostList.length)
         {
            if(this.m_interactiveContainer.contains(this.m_ghostList[_loc1_]))
            {
               this.m_interactiveContainer.removeChild(this.m_ghostList[_loc1_]);
            }
            this.m_ghostList[_loc1_].destroy();
            _loc1_++;
         }
         this.m_ghostList.length = 0;
         trace("ghosts have left the building");
         _loc2_ = new Object();
         _loc2_.isGame = false;
         _loc2_.game = GameConstants.COMMUNITY_GAME_GHOST_CATCH;
         this.m_interactiveContainer.dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_TOGGLE_COMMUNITY_GAME,_loc2_));
         _loc2_ = new Object();
         _loc2_.isFinal = true;
         dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_UPDATE_GHOST_GAME,_loc2_));
         if(this.m_ghostsCaught > 0)
         {
            this.m_scoreBoard.setClientScores(this.m_ghostsCaught,this.m_clientAvatar,this.m_serverCoinsEarned);
            this.m_uiContainer.addChild(this.m_scoreBoard);
         }
      }
      
      internal function updateGhosts() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = false;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc10_:* = 0;
         var _loc11_:* = null;
         var _loc12_:* = null;
         var _loc13_:* = null;
         _loc1_ = 0;
         _loc6_ = true;
         _loc7_ = 0;
         while(_loc7_ < this.m_ghostList.length)
         {
            if(this.m_ghostList[_loc7_].isFadeComplete())
            {
               if(this.m_interactiveContainer.contains(this.m_ghostList[_loc7_]))
               {
                  this.m_interactiveContainer.removeChild(this.m_ghostList[_loc7_]);
               }
               this.m_ghostList[_loc7_].destroy();
               _loc1_ = Math.floor(Math.random() * this.m_ghostExits.length);
               if(_loc1_ >= this.m_ghostExits.length)
               {
                  _loc1_ = 0;
               }
               _loc12_ = new AIGhost(this.m_ghostExits[_loc1_].x,this.m_ghostExits[_loc1_].y,this.pickGhostIndex());
               _loc12_.setScaleLimits(this.m_avatarScaleLimits);
               this.m_interactiveContainer.addChildAt(_loc12_,0);
               this.m_ghostList[_loc7_] = _loc12_;
            }
            _loc7_++;
         }
         if(this.m_clientAvatar)
         {
            _loc8_ = new Point(Sprite(this.m_clientAvatar).x,Sprite(this.m_clientAvatar).y);
         }
         _loc7_ = 0;
         while(_loc7_ < this.m_slimeList.length)
         {
            this.m_slimeList[_loc7_].update();
            if(Boolean(this.m_slimeList[_loc7_].isActive()) && Boolean(this.m_clientAvatar))
            {
               _loc9_ = new Point(this.m_slimeList[_loc7_].x,this.m_slimeList[_loc7_].y);
               _loc10_ = (_loc8_.x - _loc9_.x) * (_loc8_.x - _loc9_.x) + (_loc8_.y - _loc9_.y) * (_loc8_.y - _loc9_.y);
               if(_loc10_ < MAX_SQUARED_DISTANCE_TO_COLLECT_GHOST)
               {
                  if(this.doAvatarAndSlimeIntersect(_loc8_,this.m_slimeList[_loc7_]))
                  {
                     if(this.m_iceBlockTimer <= 0)
                     {
                        trace("freezing");
                        this.m_iceBlockTimer = ICE_BLOCK_TIMER;
                        _loc13_ = new Object();
                        _loc13_.freeze = true;
                        dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_UPDATE_GHOST_GAME,_loc13_));
                        GameSound.getInstance().playSoundEffect(1);
                        break;
                     }
                     this.m_iceBlockTimer = ICE_BLOCK_TIMER;
                  }
               }
            }
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.m_ghostList.length)
         {
            this.m_ghostList[_loc7_].update();
            if(Boolean(this.m_ghostList[_loc7_].isActive()) && Boolean(this.m_clientAvatar))
            {
               _loc9_ = new Point(this.m_ghostList[_loc7_].x,this.m_ghostList[_loc7_].y);
               _loc10_ = (Sprite(this.m_clientAvatar).x - _loc9_.x) * (Sprite(this.m_clientAvatar).x - _loc9_.x) + (Sprite(this.m_clientAvatar).y - _loc9_.y) * (Sprite(this.m_clientAvatar).y - _loc9_.y);
               if(_loc10_ < MAX_SQUARED_DISTANCE_TO_COLLECT_GHOST)
               {
                  if(this.m_iceBlockTimer <= 0)
                  {
                     this.m_ghostList[_loc7_].setPulse(true);
                  }
               }
               else
               {
                  this.m_ghostList[_loc7_].setPulse(false);
               }
            }
            if(Boolean(this.m_ghostList[_loc7_].isWalking()) || Boolean(this.m_ghostList[_loc7_].isFading()))
            {
               _loc6_ = false;
            }
            else if(!this.m_exitGhosts)
            {
               _loc11_ = this.m_ghostList[_loc7_].getPosition();
               _loc3_ = Math.floor(Math.random() * MAX_GHOST_WALK_DISTANCE * 2) - MAX_GHOST_WALK_DISTANCE + _loc11_.x;
               _loc4_ = Math.floor(Math.random() * MAX_GHOST_WALK_DISTANCE * 2) - MAX_GHOST_WALK_DISTANCE + _loc11_.y;
               _loc5_ = new Point(_loc3_,_loc4_);
               if(s_ground.hitTestPoint(_loc3_,_loc4_,true))
               {
                  _loc2_ = new Array();
                  _loc2_.push(_loc5_);
                  this.m_ghostList[_loc7_].walkTo(_loc2_);
                  this.m_ghostList[_loc7_].setActive(true);
               }
            }
            _loc7_++;
         }
         if(this.m_iceBlockTimer > 0)
         {
            --this.m_iceBlockTimer;
            if(this.m_iceBlockTimer == 0 && PlayerAttributes.getInstance().getMagicEffect() == MagicEffectType.MAGIC_EFFECT_AVATAR_ICE_BLOCK)
            {
               dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_REMOVE_MAGIC_EFFECT,null));
            }
         }
         if(Boolean(this.m_exitGhosts) && _loc6_)
         {
            this.showScoreBoard();
            if(PlayerAttributes.getInstance().getMagicEffect() == MagicEffectType.MAGIC_EFFECT_AVATAR_ICE_BLOCK)
            {
               dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_REMOVE_MAGIC_EFFECT,null));
            }
         }
      }
      
      public function getMouseCursorType() : String
      {
         if(!s_ground.hitTestPoint(mouseX,mouseY,true))
         {
            return "none";
         }
         if(this.s_exitToHH.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         if(this.s_exitToForest.hitTestPoint(mouseX,mouseY,true))
         {
            return "exit";
         }
         return "ground";
      }
      
      public function startGame(param1:String) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = null;
         var _loc8_:* = 0;
         var _loc9_:* = null;
         var _loc10_:* = null;
         var _loc11_:* = 0;
         var _loc12_:* = 0;
         var _loc15_:* = null;
         var _loc16_:* = null;
         _loc9_ = param1.split(";");
         _loc12_ = 0;
         while(_loc12_ < _loc9_.length)
         {
            _loc10_ = _loc9_[_loc12_].split(",");
            if(_loc10_.length >= 3)
            {
               _loc11_ = _loc10_[0];
               this.m_slimeList[_loc11_] = new AISlime(_loc10_[1],_loc10_[2]);
               this.m_slimeList[_loc12_].setActive(true);
               this.m_slimeList[_loc12_].setScaleLimits(this.m_avatarScaleLimits);
               this.m_interactiveContainer.addChild(this.m_slimeList[_loc12_]);
            }
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < MAX_GHOST_COUNT)
         {
            if(this.m_isInProgress)
            {
               do
               {
                  _loc2_ = Math.floor(Math.random() * 935);
                  _loc3_ = 200 + Math.floor(Math.random() * 400);
               }
               while(!s_ground.hitTestPoint(_loc2_,_loc3_,true));
               
               this.m_ghostList[_loc12_] = new AIGhost(_loc2_,_loc3_,this.pickGhostIndex());
               this.m_ghostList[_loc12_].setActive(true);
               _loc2_ = Math.floor(Math.random() * 1000);
               if(_loc2_ > 500)
               {
                  _loc16_ = this.m_ghostList[_loc12_].getPosition();
                  _loc5_ = Math.floor(Math.random() * MAX_GHOST_WALK_DISTANCE * 2) - MAX_GHOST_WALK_DISTANCE + _loc16_.x;
                  _loc6_ = Math.floor(Math.random() * MAX_GHOST_WALK_DISTANCE * 2) - MAX_GHOST_WALK_DISTANCE + _loc16_.y;
                  _loc7_ = new Point(_loc5_,_loc6_);
                  if(s_ground.hitTestPoint(_loc5_,_loc6_,true))
                  {
                     _loc4_ = new Array();
                     _loc4_.push(_loc7_);
                     this.m_ghostList[_loc12_].walkTo(_loc4_);
                  }
               }
            }
            else
            {
               _loc8_ = Math.floor(Math.random() * 935);
               this.m_ghostList[_loc12_] = new AIGhost(_loc8_,-80,this.pickGhostIndex());
            }
            this.m_ghostList[_loc12_].setScaleLimits(this.m_avatarScaleLimits);
            this.m_interactiveContainer.addChild(this.m_ghostList[_loc12_]);
            _loc12_++;
         }
         this.m_hasGameStarted = true;
         this.m_exitGhosts = false;
         this.m_serverCoinsEarned = -1;
         this.m_ghostsCaught = 0;
         this.setGhostScore();
         this.s_score.visible = true;
         if(this.m_uiContainer)
         {
            this.m_uiContainer.addChild(this.s_score);
         }
         _loc15_ = new Object();
         _loc15_.isGame = true;
         _loc15_.game = GameConstants.COMMUNITY_GAME_GHOST_CATCH;
         this.m_interactiveContainer.dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_TOGGLE_COMMUNITY_GAME,_loc15_));
         this.m_hasShownScoreBoard = false;
         trace("game has started");
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(this.s_exitToHH.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_PARLOUR;
         }
         if(this.s_exitToForest.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_FOREST;
         }
         return null;
      }
      
      public function getAvatarSpawnPoint() : Point
      {
         return this.m_spawnPoint;
      }
      
      override public function serverExtensionResponse(param1:String, param2:Object) : void
      {
         var _loc3_:* = undefined;
         if(param1 != "ghostGame")
         {
            return;
         }
         if(param2.cmd2)
         {
            _loc3_ = param2.cmd2;
            switch(_loc3_)
            {
               case "start":
                  if(param2.inProgress)
                  {
                     this.m_isInProgress = true;
                  }
                  if(this.m_interactiveContainer)
                  {
                     this.startGame(param2.slimeStart);
                     if(param2.slimeMove)
                     {
                        this.moveSlimes(param2.slimeMove);
                     }
                     break;
                  }
                  this.m_hasGameStarted = true;
                  break;
               case "end":
                  this.endGame();
                  if(param2.slimeMove)
                  {
                     this.moveSlimes(param2.slimeMove);
                  }
                  break;
               case "update":
                  if(param2.slimeMove)
                  {
                     this.moveSlimes(param2.slimeMove);
                  }
                  if(!param2.ice)
                  {
                  }
                  break;
               case "scores":
                  this.updateScoreBoard(param2.scores);
            }
         }
      }
      
      public function setUIContainer(param1:Sprite) : void
      {
         this.m_uiContainer = param1;
         this.m_uiContainer.addChild(this.s_help);
      }
      
      public function setClientAvatar(param1:IAvatar) : void
      {
         this.m_clientAvatar = param1;
      }
      
      public function getSceneObjects(param1:Sprite) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         this.m_interactiveContainer = param1;
         _loc2_ = 0;
         while(_loc2_ < m_sceneObjects.length)
         {
            if(m_sceneObjects[_loc2_])
            {
               param1.addChild(m_sceneObjects[_loc2_]);
            }
            _loc2_++;
         }
         _loc3_ = new Object();
         _loc3_.startCheck = true;
         dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_UPDATE_GHOST_GAME,_loc3_));
      }
      
      internal function setGhostScore() : void
      {
         var _loc1_:* = null;
         _loc1_ = new TextFormat("arial",20);
         _loc1_.color = 65280;
         _loc1_.bold = true;
         this.s_score.s_text.s_text.embedFonts = true;
         this.s_score.s_text.s_text.antiAliasType = AntiAliasType.ADVANCED;
         this.s_score.s_text.s_text.text = this.m_ghostsCaught;
         this.s_score.s_text.s_text.setTextFormat(_loc1_);
      }
      
      internal function pickGhostIndex() : int
      {
         var _loc1_:* = 0;
         _loc1_ = Math.floor(Math.random() * 100);
         if(_loc1_ < 70)
         {
            return 0;
         }
         if(_loc1_ < 98)
         {
            return 1;
         }
         return 2;
      }
      
      public function getAvatarScaleLimits() : Array
      {
         return this.m_avatarScaleLimits;
      }
      
      public function endGame() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         this.m_hasGameStarted = false;
         this.m_isInProgress = false;
         this.m_exitGhosts = true;
         _loc1_ = 0;
         _loc3_ = 0;
         _loc5_ = 0;
         while(_loc5_ < this.m_ghostList.length)
         {
            if(this.m_ghostList[_loc5_].isActive())
            {
               _loc1_ = Math.floor(Math.random() * 600) + 170;
               _loc2_ = new Point(_loc1_,-50);
               _loc4_ = new Array();
               _loc4_.push(_loc2_);
               this.m_ghostList[_loc5_].walkTo(_loc4_);
            }
            _loc5_++;
         }
         trace("game has ended");
      }
   }
}

