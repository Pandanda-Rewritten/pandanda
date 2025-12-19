package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.text.*;
   
   public class BunnyFieldScene extends SceneRoot implements IScene, ICommunityGameScene
   {
      
      internal static const MAX_BUNNY_INDEXES:int = 3;
      
      internal static const HUTCH_SPAWN_X:int = 880;
      
      internal static const MAX_SQUARED_DISTANCE_TO_COLLECT_BUNNY:int = 9000;
      
      internal static const HUTCH_SPAWN_Y:int = 390;
      
      internal static const DEBUG:int = 0;
      
      internal static const MIN_BUNNIES_UNTIL_COLORED_SPAWN:int = 15;
      
      internal static const MAX_BUNNY_WALK_DISTANCE:int = 400;
      
      internal static const MAX_BUNNY_COUNT:int = 12;
      
      public static const BUNNY_POINTS:Array = [1,2,6];
      
      public static const NIGHT_MASK_SCENE_ALPHA:Number = 0.67;
      
      internal var m_exitArch:BunnyFieldExitArch;
      
      internal var m_clientAvatar:IAvatar;
      
      internal var m_avatarScaleLimits:Array;
      
      internal var m_frontFlowers:BunnyFieldFrontFlowers;
      
      internal var m_bunnyExits:Array;
      
      public var direction_back:SimpleButton;
      
      internal var m_bushLeft:BunnyFieldBushLeft;
      
      internal var m_bushRight:BunnyFieldBushRight;
      
      public var s_score:MovieClip;
      
      internal var m_backFlowers:BunnyFieldBackFlowers;
      
      internal var m_isInProgress:Boolean;
      
      internal var m_interactiveContainer:Sprite;
      
      internal var m_spawnPoint:Point;
      
      internal var m_hasShownScoreBoard:Boolean;
      
      internal var m_serverCoinsEarned:int = -1;
      
      internal var m_bunniesCaught:Array;
      
      internal var m_bunnyList:Array;
      
      internal var m_rock:BunnyFieldRock;
      
      internal var m_scoreBoard:BunnyFieldScoreBoard;
      
      public var bunnyField_mc:Sprite;
      
      public var s_exitToOrchard:Sprite;
      
      internal var m_bushCenter:BunnyFieldBushCenter;
      
      internal var m_exitBunnies:Boolean;
      
      internal var m_grassRight:BunnyFieldGrassRight;
      
      internal var m_hasGameStarted:Boolean;
      
      internal var m_hutch:BunnyFieldHutch;
      
      internal var m_uiContainer:Sprite;
      
      public var s_groundBunny:Sprite;
      
      internal var m_grassLeft:BunnyFieldGrassLeft;
      
      public function BunnyFieldScene()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         if(!WebSiteValidator.isValid(loaderInfo.url))
         {
            return;
         }
         trace("BunnyFieldScene Constructor");
         this.m_spawnPoint = new Point(465,250);
         this.m_avatarScaleLimits = new Array(0.45,1);
         if(SHOW_FIREWORKS)
         {
            m_fireworks = new Fireworks(100);
         }
         this.s_score.mouseEnabled = false;
         this.s_score.visible = false;
         this.m_scoreBoard = new BunnyFieldScoreBoard();
         this.m_isInProgress = false;
         this.m_hasShownScoreBoard = false;
         this.m_bunniesCaught = new Array();
         _loc1_ = 0;
         while(_loc1_ < MAX_BUNNY_INDEXES)
         {
            this.m_bunniesCaught[_loc1_] = 0;
            _loc1_++;
         }
         this.m_uiContainer = new Sprite();
         this.bunnyField_mc.mouseEnabled = false;
         this.bunnyField_mc.cacheAsBitmap = true;
         this.s_exitToOrchard.visible = false;
         s_nightSky.gotoAndStop(1);
         s_nightSky.cacheAsBitmap = true;
         m_effectsContainerNightMask = new BunnyFieldNightMask();
         m_effectsContainerNightMask.x = 0;
         m_effectsContainerNightMask.y = 0;
         m_effectsContainerNightMask.width = 935;
         m_effectsContainerNightMask.height = 600;
         m_effectsContainerNightMask.cacheAsBitmap = true;
         this.s_groundBunny.cacheAsBitmap = true;
         this.s_groundBunny.visible = false;
         this.m_bunnyList = new Array();
         this.m_hasGameStarted = false;
         this.m_exitBunnies = false;
         this.m_serverCoinsEarned = -1;
         this.m_bunnyExits = new Array();
         this.m_bunnyExits.push(new Point(900,590));
         this.m_bunnyExits.push(new Point(10,180));
         this.m_bunnyExits.push(new Point(850,183));
         this.m_bunnyExits.push(new Point(610,360));
         this.m_bunnyExits.push(new Point(-25,500));
         this.m_frontFlowers = new BunnyFieldFrontFlowers();
         this.m_frontFlowers.x = 706;
         this.m_frontFlowers.y = 332;
         this.m_frontFlowers.width = 230;
         this.m_frontFlowers.height = 268;
         this.m_frontFlowers.setYDepth(600);
         this.m_grassRight = new BunnyFieldGrassRight();
         this.m_grassRight.x = 568;
         this.m_grassRight.y = 458;
         this.m_grassRight.width = 108;
         this.m_grassRight.height = 142;
         this.m_grassRight.setYDepth(600);
         this.m_grassLeft = new BunnyFieldGrassLeft();
         this.m_grassLeft.x = 0;
         this.m_grassLeft.y = 365;
         this.m_grassLeft.width = 283;
         this.m_grassLeft.height = 235;
         this.m_grassLeft.setYDepth(600);
         this.m_bushCenter = new BunnyFieldBushCenter();
         this.m_bushCenter.x = 516;
         this.m_bushCenter.y = 299;
         this.m_bushCenter.width = 175;
         this.m_bushCenter.height = 106;
         this.m_bushCenter.setYDepth(369);
         this.m_bushLeft = new BunnyFieldBushLeft();
         this.m_bushLeft.x = 0;
         this.m_bushLeft.y = 42;
         this.m_bushLeft.width = 175;
         this.m_bushLeft.height = 187;
         this.m_bushLeft.setYDepth(217);
         this.m_backFlowers = new BunnyFieldBackFlowers();
         this.m_backFlowers.x = 703;
         this.m_backFlowers.y = 157;
         this.m_backFlowers.width = 89;
         this.m_backFlowers.height = 49;
         this.m_backFlowers.setYDepth(197);
         this.m_bushRight = new BunnyFieldBushRight();
         this.m_bushRight.x = 811;
         this.m_bushRight.y = 158;
         this.m_bushRight.width = 116;
         this.m_bushRight.height = 48;
         this.m_bushRight.setYDepth(197);
         this.m_rock = new BunnyFieldRock();
         this.m_rock.x = -3;
         this.m_rock.y = 159;
         this.m_rock.width = 222;
         this.m_rock.height = 91;
         this.m_rock.setYDepth(232);
         this.m_exitArch = new BunnyFieldExitArch();
         this.m_exitArch.x = 430;
         this.m_exitArch.y = 112;
         this.m_exitArch.width = 80;
         this.m_exitArch.height = 77;
         this.m_exitArch.setYDepth(182);
         this.m_hutch = new BunnyFieldHutch();
         this.m_hutch.x = 801;
         this.m_hutch.y = 268;
         this.m_hutch.width = 131;
         this.m_hutch.height = 145;
         this.m_hutch.setYDepth(358);
         m_sceneObjects = new Array();
         m_sceneObjects.push(this.m_frontFlowers);
         m_sceneObjects.push(this.m_grassRight);
         m_sceneObjects.push(this.m_grassLeft);
         m_sceneObjects.push(this.m_bushCenter);
         m_sceneObjects.push(this.m_bushLeft);
         m_sceneObjects.push(this.m_backFlowers);
         m_sceneObjects.push(this.m_bushRight);
         m_sceneObjects.push(this.m_rock);
         m_sceneObjects.push(this.m_exitArch);
         m_sceneObjects.push(this.m_hutch);
         _loc1_ = 0;
         while(_loc1_ < m_sceneObjects.length)
         {
            m_sceneObjects[_loc1_].mouseEnabled = false;
            m_sceneObjects[_loc1_].mouseChildren = false;
            m_sceneObjects[_loc1_].cacheAsBitmap = true;
            _loc1_++;
         }
         m_sceneTimeCounter = 0;
         m_transitionFrame = 0;
         updateSceneTime();
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_MUSHROOM);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_VEGETABLE);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_GEM);
         m_gameItemCategoryList.push(GameItemCategory.CATEGORY_TREASURE);
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
         }
         this.m_uiContainer = null;
         _loc1_ = 0;
         while(_loc1_ < this.m_bunnyList.length)
         {
            this.m_bunnyList[_loc1_].destroy();
            _loc1_++;
         }
         m_sceneObjects.length = 0;
         this.m_bunnyList.length = 0;
         this.m_bunnyExits.length = 0;
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
      
      internal function updateFrame(param1:Event) : void
      {
         this.updateScene();
      }
      
      public function startGame() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc9_:* = null;
         _loc7_ = 0;
         while(_loc7_ < MAX_BUNNY_COUNT)
         {
            if(this.m_isInProgress)
            {
               do
               {
                  _loc1_ = Math.floor(Math.random() * 935);
                  _loc2_ = 200 + Math.floor(Math.random() * 400);
               }
               while(!this.s_groundBunny.hitTestPoint(_loc1_,_loc2_,true));
               
               this.m_bunnyList[_loc7_] = new AIBunny(_loc1_,_loc2_,this.pickBunnyIndex());
               this.m_bunnyList[_loc7_].setActive(true);
               _loc1_ = Math.floor(Math.random() * 1000);
               if(_loc1_ > 500)
               {
                  _loc9_ = this.m_bunnyList[_loc7_].getPosition();
                  _loc4_ = Math.floor(Math.random() * MAX_BUNNY_WALK_DISTANCE * 2) - MAX_BUNNY_WALK_DISTANCE + _loc9_.x;
                  _loc5_ = Math.floor(Math.random() * MAX_BUNNY_WALK_DISTANCE * 2) - MAX_BUNNY_WALK_DISTANCE + _loc9_.y;
                  _loc6_ = new Point(_loc4_,_loc5_);
                  if(this.s_groundBunny.hitTestPoint(_loc4_,_loc5_,true))
                  {
                     _loc3_ = new Array();
                     _loc3_.push(_loc6_);
                     this.m_bunnyList[_loc7_].walkTo(_loc3_);
                  }
               }
            }
            else if(_loc7_ & 1)
            {
               _loc1_ = Math.floor(Math.random() * this.m_bunnyExits.length);
               if(_loc1_ >= this.m_bunnyExits.length)
               {
                  _loc1_ = 0;
               }
               this.m_bunnyList[_loc7_] = new AIBunny(this.m_bunnyExits[_loc1_].x,this.m_bunnyExits[_loc1_].y,this.pickBunnyIndex());
            }
            else
            {
               this.m_bunnyList[_loc7_] = new AIBunny(HUTCH_SPAWN_X,HUTCH_SPAWN_Y,this.pickBunnyIndex());
            }
            this.m_bunnyList[_loc7_].setScaleLimits(this.m_avatarScaleLimits);
            this.m_interactiveContainer.addChild(this.m_bunnyList[_loc7_]);
            _loc7_++;
         }
         this.m_hasGameStarted = true;
         this.m_exitBunnies = false;
         _loc7_ = 0;
         while(_loc7_ < MAX_BUNNY_INDEXES)
         {
            this.m_bunniesCaught[_loc7_] = 0;
            _loc7_++;
         }
         this.setBunnyScore();
         this.s_score.visible = true;
         if(this.m_uiContainer)
         {
            this.m_uiContainer.addChild(this.s_score);
         }
         this.m_hutch.openDoors(true);
         _loc8_ = new Object();
         _loc8_.isGame = true;
         _loc8_.game = GameConstants.COMMUNITY_GAME_BUNNY_CATCH;
         this.m_interactiveContainer.dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_TOGGLE_COMMUNITY_GAME,_loc8_));
         this.m_hasShownScoreBoard = false;
         trace("game has started");
      }
      
      public function checkForExit(param1:Point) : String
      {
         if(this.s_exitToOrchard.hitTestPoint(param1.x,param1.y,true))
         {
            return Location.EN_ORCHARD;
         }
         return null;
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
               if(entry.length >= 7 && entry[1] == playerName)
               {
                  this.m_serverCoinsEarned = parseInt(entry[6]);
                  trace("Found server coins earned for player: " + this.m_serverCoinsEarned);
                  break;
               }
            }
            i++;
         }
         this.showScoreBoard();
         this.m_scoreBoard.updateRankings(param1);
      }
      
      internal function showScoreBoard() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         if(this.m_hasShownScoreBoard)
         {
            return;
         }
         this.m_hasShownScoreBoard = true;
         _loc1_ = 0;
         this.m_exitBunnies = false;
         this.s_score.visible = false;
         _loc1_ = 0;
         while(_loc1_ < this.m_bunnyList.length)
         {
            if(this.m_interactiveContainer.contains(this.m_bunnyList[_loc1_]))
            {
               this.m_interactiveContainer.removeChild(this.m_bunnyList[_loc1_]);
            }
            this.m_bunnyList[_loc1_].destroy();
            _loc1_++;
         }
         this.m_bunnyList.length = 0;
         this.m_hutch.openDoors(false);
         trace("bunnies have left the building");
         _loc2_ = new Object();
         _loc2_.isGame = false;
         _loc2_.game = GameConstants.COMMUNITY_GAME_BUNNY_CATCH;
         this.m_interactiveContainer.dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_TOGGLE_COMMUNITY_GAME,_loc2_));
         _loc2_ = new Object();
         _loc2_.isFinal = true;
         dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_UPDATE_BUNNY_GAME,_loc2_));
         _loc3_ = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_bunniesCaught.length)
         {
            _loc3_ += this.m_bunniesCaught[_loc1_] * BUNNY_POINTS[_loc1_];
            _loc1_++;
         }
         if(_loc3_ > 0)
         {
            this.m_scoreBoard.setClientScores(this.m_bunniesCaught,_loc3_,this.m_clientAvatar,this.m_serverCoinsEarned);
            this.m_uiContainer.addChild(this.m_scoreBoard);
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
         if(Boolean(this.m_hasGameStarted) || Boolean(this.m_exitBunnies))
         {
            this.updateBunnies();
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
      
      override public function serverExtensionResponse(param1:String, param2:Object) : void
      {
         var _loc3_:* = undefined;
         if(param1 != "bunnyGame")
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
                     this.startGame();
                     break;
                  }
                  this.m_hasGameStarted = true;
                  break;
               case "end":
                  this.endGame();
                  break;
               case "scores":
                  this.updateScoreBoard(param2.scores);
            }
         }
      }
      
      override protected function getNightMaskSceneAlpha() : Number
      {
         return NIGHT_MASK_SCENE_ALPHA;
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
         dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_UPDATE_BUNNY_GAME,_loc3_));
      }
      
      public function setUIContainer(param1:Sprite) : void
      {
         this.m_uiContainer = param1;
      }
      
      internal function setBunnyScore() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc1_ = new TextFormat("arial",20);
         _loc1_.color = 2646463;
         _loc1_.bold = true;
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_bunniesCaught.length)
         {
            _loc2_ += this.m_bunniesCaught[_loc3_] * BUNNY_POINTS[_loc3_];
            _loc3_++;
         }
         this.s_score.s_text.s_text.embedFonts = true;
         this.s_score.s_text.s_text.antiAliasType = AntiAliasType.ADVANCED;
         this.s_score.s_text.s_text.text = _loc2_;
         this.s_score.s_text.s_text.setTextFormat(_loc1_);
      }
      
      public function setClientAvatar(param1:IAvatar) : void
      {
         this.m_clientAvatar = param1;
      }
      
      public function endGame() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         this.m_hasGameStarted = false;
         this.m_isInProgress = false;
         this.m_exitBunnies = true;
         _loc1_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_bunnyList.length)
         {
            if(this.m_bunnyList[_loc3_].isActive())
            {
               _loc1_ = Math.floor(Math.random() * this.m_bunnyExits.length);
               if(_loc1_ >= this.m_bunnyExits.length)
               {
                  _loc1_ = 0;
               }
               _loc2_ = new Array();
               _loc2_.push(this.m_bunnyExits[_loc1_]);
               this.m_bunnyList[_loc3_].walkTo(_loc2_);
            }
            _loc3_++;
         }
         trace("game has ended");
      }
      
      internal function updateBunnies() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = false;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc9_:* = 0;
         var _loc10_:* = null;
         var _loc11_:* = null;
         _loc1_ = 0;
         _loc6_ = true;
         _loc7_ = 0;
         while(_loc7_ < this.m_bunnyList.length)
         {
            if(this.m_bunnyList[_loc7_].isFadeComplete())
            {
               if(this.m_interactiveContainer.contains(this.m_bunnyList[_loc7_]))
               {
                  this.m_interactiveContainer.removeChild(this.m_bunnyList[_loc7_]);
               }
               this.m_bunnyList[_loc7_].destroy();
               _loc1_ = Math.floor(Math.random() * this.m_bunnyExits.length);
               if(_loc1_ >= this.m_bunnyExits.length)
               {
                  _loc1_ = 0;
               }
               _loc10_ = new AIBunny(this.m_bunnyExits[_loc1_].x,this.m_bunnyExits[_loc1_].y,this.pickBunnyIndex());
               _loc10_.setScaleLimits(this.m_avatarScaleLimits);
               this.m_interactiveContainer.addChildAt(_loc10_,0);
               this.m_bunnyList[_loc7_] = _loc10_;
            }
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.m_bunnyList.length)
         {
            this.m_bunnyList[_loc7_].update();
            if(Boolean(this.m_bunnyList[_loc7_].isActive()) && Boolean(this.m_clientAvatar))
            {
               _loc8_ = new Point(this.m_bunnyList[_loc7_].x,this.m_bunnyList[_loc7_].y);
               _loc9_ = (Sprite(this.m_clientAvatar).x - _loc8_.x) * (Sprite(this.m_clientAvatar).x - _loc8_.x) + (Sprite(this.m_clientAvatar).y - _loc8_.y) * (Sprite(this.m_clientAvatar).y - _loc8_.y);
               if(_loc9_ < MAX_SQUARED_DISTANCE_TO_COLLECT_BUNNY)
               {
                  this.m_bunnyList[_loc7_].setPulse(true);
               }
               else
               {
                  this.m_bunnyList[_loc7_].setPulse(false);
               }
            }
            if(Boolean(this.m_bunnyList[_loc7_].isWalking()) || Boolean(this.m_bunnyList[_loc7_].isFading()))
            {
               _loc6_ = false;
            }
            else if(!this.m_exitBunnies)
            {
               _loc1_ = Math.floor(Math.random() * 1000);
               if(_loc1_ > 970)
               {
                  _loc11_ = this.m_bunnyList[_loc7_].getPosition();
                  _loc3_ = Math.floor(Math.random() * MAX_BUNNY_WALK_DISTANCE * 2) - MAX_BUNNY_WALK_DISTANCE + _loc11_.x;
                  _loc4_ = Math.floor(Math.random() * MAX_BUNNY_WALK_DISTANCE * 2) - MAX_BUNNY_WALK_DISTANCE + _loc11_.y;
                  _loc5_ = new Point(_loc3_,_loc4_);
                  if(this.s_groundBunny.hitTestPoint(_loc3_,_loc4_,true))
                  {
                     _loc2_ = new Array();
                     _loc2_.push(_loc5_);
                     this.m_bunnyList[_loc7_].walkTo(_loc2_);
                     this.m_bunnyList[_loc7_].setActive(true);
                  }
               }
            }
            _loc7_++;
         }
         if(Boolean(this.m_exitBunnies) && _loc6_)
         {
            this.showScoreBoard();
         }
      }
      
      override public function setMouseClick(param1:Point, param2:Point = null) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         _loc3_ = 0;
         _loc4_ = new Object();
         _loc5_ = 0;
         while(_loc5_ < this.m_bunnyList.length)
         {
            if(Boolean(this.m_bunnyList[_loc5_].hitTestPoint(param1.x,param1.y)) && Boolean(this.m_bunnyList[_loc5_].isActive()))
            {
               if(Boolean(this.m_exitBunnies) && !this.m_bunnyList[_loc5_].isWalking())
               {
                  return;
               }
               _loc4_.score = BUNNY_POINTS[this.m_bunnyList[_loc5_].getIndex()];
               dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_UPDATE_BUNNY_GAME,_loc4_));
               _loc6_ = this.m_bunniesCaught;
               _loc8_ = _loc6_[_loc7_ = this.m_bunnyList[_loc5_].getIndex()] + 1;
               _loc6_[_loc7_] = _loc8_;
               this.setBunnyScore();
               this.m_bunnyList[_loc5_].setFade();
               break;
            }
            _loc5_++;
         }
      }
      
      internal function pickBunnyIndex() : int
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
         return "ground";
      }
   }
}

