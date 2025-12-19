package
{
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class Avatar extends Sprite implements IInteractiveObject, IAvatar
   {
      
      internal static const WALK_SPEED_Y_ADJUST:Number = 0.45;
      
      internal static const AVATAR_DRAGON_MOUNT_BOUNCE_FREQUENCY:Number = 15;
      
      internal static const AVATAR_BOUNCE_POS1_AND_POS5_MULTIPLIER:Number = 1.5;
      
      internal static const DRAGON_MOUNT_NAME_Y_OFFSET:int = 28;
      
      internal static const NO_SCALE_ABOVE_Y:int = 450;
      
      internal static const AVATAR_DRAGON_MOUNT_BOUNCE_MAGNITUDE:Number = 50;
      
      internal static const AVATAR_NAME_Y_OFFSET:int = 8;
      
      internal static const SCREEN_ROW_HEIGHT:int = 20;
      
      internal static const GAME_FPS:int = 30;
      
      internal static const MAX_WALK_SPEED_PER_FRAME:int = 20;
      
      internal static const CELEBRITY_LIST:Array = ["Henry","Sheriff"];
      
      protected static const AVATAR_PIVOT_Y_OFFSET:int = 20;
      
      internal static const MIN_FACING_CHANGE_DIST:int = 40;
      
      internal static const FULL_SCALE_Y_OFFSET:int = 500;
      
      internal static const AVATAR_BOUNCE_MAGNITUDE:Number = 1.2;
      
      internal static const MENU_BAR_Y_OFFSET:int = 565;
      
      internal static const BUSY_BUBBLE_X_OFFSET:int = -25;
      
      internal static const BUSY_BUBBLE_Y_OFFSET:int = -100;
      
      internal static const AVATAR_BOUNCE_FREQUENCY:Number = 10;
      
      internal static const TWENTY_DEGREES:Number = 0.927;
      
      internal var m_walkCounter:int;
      
      internal var m_timeLastFrame:Number;
      
      protected var m_isWalking:Boolean;
      
      protected var m_isNameOnTopLayer:Boolean;
      
      protected var m_isBot:Boolean;
      
      internal var m_dx:Number;
      
      internal var m_dy:Number;
      
      protected var m_modelName:String;
      
      protected var m_yDepth:*;
      
      protected var m_avModel:IAvatarModel;
      
      protected var m_isModerator:Boolean;
      
      protected var m_direction:int;
      
      internal var m_prevY:int;
      
      protected var m_avName:AvatarName;
      
      protected var m_isCommunityGame:Boolean;
      
      protected var m_walkSpeed:Number;
      
      internal var m_currentRow:int;
      
      protected var m_magicEffect:int;
      
      protected var m_clothingList:Array;
      
      protected var m_isSafeChat:Boolean;
      
      internal var m_busyBubble:IBusyBubble;
      
      protected var m_effectsContainer:Sprite;
      
      protected var m_isCelebrity:Boolean;
      
      internal var m_walkPath:Array;
      
      internal var m_scaleLimits:Array;
      
      protected var m_messageBubble:IMessageBubble;
      
      protected var m_bounceOffset:Number;
      
      public function Avatar(param1:String, param2:Sprite = null)
      {
         super();
         this.m_isWalking = false;
         this.m_walkPath = new Array();
         this.m_scaleLimits = new Array(1,1);
         this.m_clothingList = new Array();
         this.x = 0;
         this.y = 0;
         this.m_currentRow = 0;
         this.m_prevY = 0;
         this.m_isBot = false;
         this.m_isModerator = false;
         this.m_isSafeChat = false;
         this.m_isCelebrity = false;
         this.m_walkCounter = 0;
         this.m_bounceOffset = 0;
         this.m_yDepth = this.y;
         this.m_direction = 0;
         this.setAvatarModel(param1);
         if(param2)
         {
            this.m_effectsContainer = param2;
         }
         else
         {
            this.m_effectsContainer = new Sprite();
         }
         this.m_messageBubble = this.m_avModel.getMessageBubble();
         this.m_busyBubble = this.m_avModel.getBusyBubble();
      }
      
      protected function scaleAvatar(param1:Boolean = true) : Number
      {
         var _loc2_:* = undefined;
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         var _loc5_:* = NaN;
         _loc2_ = this.y;
         _loc3_ = this.m_scaleLimits[0] + NO_SCALE_ABOVE_Y / FULL_SCALE_Y_OFFSET * (this.m_scaleLimits[1] - this.m_scaleLimits[0]);
         _loc4_ = Math.floor(_loc2_ / SCREEN_ROW_HEIGHT);
         if(_loc4_ != this.m_currentRow || param1)
         {
            _loc5_ = this.m_scaleLimits[0] + _loc2_ / FULL_SCALE_Y_OFFSET * (this.m_scaleLimits[1] - this.m_scaleLimits[0]);
            if(_loc5_ > _loc3_)
            {
               _loc5_ = _loc3_;
            }
            this.m_avModel.setScaleMultiplier(_loc5_);
            if(Boolean(this.m_avName) && !this.m_isNameOnTopLayer)
            {
               this.m_avName.y = 3 + 5 * _loc5_;
               if(this.m_avModel is IAvatarDragonMount)
               {
                  this.m_avName.y = DRAGON_MOUNT_NAME_Y_OFFSET;
               }
               else
               {
                  this.m_avName.y = 3 + 5 * _loc5_;
               }
            }
            this.m_currentRow = _loc4_;
            return _loc5_;
         }
         return -1;
      }
      
      public function setFacingDirection(param1:int) : void
      {
         if(Boolean(this.m_avModel.isSitting()) || Boolean(this.m_avModel.isDancing()) || Boolean(this.m_avModel.isSleeping()) || Boolean(this.m_avModel.isJumping()))
         {
            return;
         }
         this.m_direction = param1;
         this.setAnimation(AvatarModels.AVATAR_ANIMATION_STAND,param1);
      }
      
      public function setClothing(param1:Array, param2:String = "") : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         if(this.m_modelName == AvatarModels.AVATAR_MODEL_DRAGON)
         {
            return;
         }
         this.m_clothingList.length = 0;
         _loc3_ = "";
         if(param1)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(param1[_loc4_].indexOf("C") != -1)
               {
                  this.m_clothingList.push(param1[_loc4_]);
               }
               if(param1[_loc4_].indexOf("M") != -1)
               {
                  _loc3_ = param1[_loc4_];
               }
               _loc4_++;
            }
         }
         if(_loc3_ != "" && !Location.getInstance().isIndoorLocation(param2) && !this.m_isCommunityGame)
         {
            trace("going inside");
            this.setAvatarModel(IMountItem(AvatarModels.getInstance().getMountItem(_loc3_)).getAvatarModel());
            if(this.m_avModel is IAvatarMount)
            {
               IAvatarMount(this.m_avModel).setMountColorIndex(IMountItem(AvatarModels.getInstance().getMountItem(_loc3_)).getColorIndex());
            }
         }
         else if(this.m_avModel is IAvatarMount)
         {
            this.setAvatarModel(AvatarModels.AVATAR_MODEL_PANDA);
         }
         this.m_avModel.setClothing(this.m_clothingList);
      }
      
      public function getAvatarModel() : Sprite
      {
         return Sprite(this.m_avModel);
      }
      
      protected function isClientAvatar() : Boolean
      {
         return this.getName() == PlayerAttributes.getInstance().getName();
      }
      
      public function walkTo(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         if(param1.length == 0)
         {
            return;
         }
         this.m_walkPath = param1;
         this.m_isWalking = true;
         this.m_timeLastFrame = getTimer();
         _loc2_ = this.m_walkPath[0];
         _loc3_ = _loc2_.x - this.x;
         _loc4_ = _loc2_.y - this.y;
         this.m_direction = this.calculateFacingDirection(_loc3_,_loc4_ + AVATAR_PIVOT_Y_OFFSET);
         this.m_walkCounter = 0;
         this.m_bounceOffset = 0;
         this.setAnimation(AvatarModels.AVATAR_ANIMATION_WALK,this.m_direction);
      }
      
      public function isNPC() : Boolean
      {
         return false;
      }
      
      public function getModel() : IAvatarModel
      {
         return this.m_avModel;
      }
      
      public function setMessageBubble(param1:String, param2:int) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         this.m_messageBubble.setMessageBubble(0,-55,param1,param2,this.m_isModerator,this.m_isCelebrity);
         _loc3_ = this.m_effectsContainer.globalToLocal(localToGlobal(new Point(0,0)));
         Sprite(this.m_messageBubble).x = _loc3_.x;
         Sprite(this.m_messageBubble).y = _loc3_.y;
         if(this.m_effectsContainer)
         {
            _loc4_ = this.m_effectsContainer.numChildren;
            _loc5_ = 0;
            while(_loc5_ < this.m_effectsContainer.numChildren)
            {
               if(this.m_effectsContainer.getChildAt(_loc5_) is IMessageBubble)
               {
                  if(IMessageBubble(this.m_effectsContainer.getChildAt(_loc5_)).isModerator())
                  {
                     _loc4_ = _loc5_;
                     break;
                  }
               }
               _loc5_++;
            }
            if(this.m_isModerator)
            {
               this.m_effectsContainer.addChild(Sprite(this.m_messageBubble));
            }
            else if(_loc4_ < this.m_effectsContainer.numChildren)
            {
               this.m_effectsContainer.addChildAt(Sprite(this.m_messageBubble),_loc4_);
            }
            else
            {
               this.m_effectsContainer.addChild(Sprite(this.m_messageBubble));
            }
         }
      }
      
      public function updateAvatar() : void
      {
         var _loc1_:* = NaN;
         this.m_avModel.update();
         if(this.m_isWalking)
         {
            this.updatePosition();
         }
         this.m_yDepth = this.y;
         if(this.m_messageBubble.isActive())
         {
            this.m_messageBubble.updateBubble();
         }
      }
      
      public function getPaperDoll() : IAvatarPaperDoll
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         _loc1_ = AvatarModels.getInstance().getPaperDoll();
         _loc1_.setColor(this.getColorIndex());
         _loc1_.setClothing(this.m_clothingList);
         _loc2_ = PlayerAttributes.getInstance().getCurrentCardBackgroundId();
         if(_loc2_ != "BG001")
         {
            _loc3_ = GameItems.getInstance().getGameItem(_loc2_).getSprite();
            _loc1_.setBackground(_loc3_);
         }
         return _loc1_;
      }
      
      public function isBot() : Boolean
      {
         return this.m_isBot;
      }
      
      public function setScaleLimits(param1:Array) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            this.m_scaleLimits[_loc2_] = param1[_loc2_];
            _loc2_++;
         }
         this.m_prevY = 0;
         this.scaleAvatar(true);
      }
      
      public function setAvatarModel(param1:String) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         if(this.m_avModel)
         {
            _loc2_ = this.m_avModel.getColorIndex();
            if(contains(Sprite(this.m_avModel)))
            {
               removeChild(Sprite(this.m_avModel));
            }
            this.m_avModel.destroy();
            this.m_avModel = null;
         }
         this.m_direction = 0;
         this.m_avModel = AvatarModels.getInstance().getAvatarModel(param1);
         Sprite(this.m_avModel).mouseEnabled = false;
         Sprite(this.m_avModel).mouseChildren = false;
         this.setAnimation(AvatarModels.AVATAR_ANIMATION_STAND);
         this.scaleAvatar(true);
         addChild(Sprite(this.m_avModel));
         this.m_walkSpeed = this.m_avModel.getWalkSpeed();
         this.setColorIndex(_loc2_);
         if(this.m_clothingList)
         {
            this.m_avModel.setClothing(this.m_clothingList);
         }
         if(this.m_avModel is IAvatarMount)
         {
            Sprite(this.m_avModel).y = Sprite(this.m_avModel).y + IAvatarMount(this.m_avModel).getMountYOffset();
         }
         else
         {
            Sprite(this.m_avModel).y = 0;
         }
         this.m_modelName = param1;
      }
      
      protected function updateMessageBubblePosition() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.m_effectsContainer.globalToLocal(localToGlobal(new Point(0,0)));
         Sprite(this.m_messageBubble).x = _loc1_.x;
         Sprite(this.m_messageBubble).y = _loc1_.y;
      }
      
      public function clearBubbles() : void
      {
         if(this.m_busyBubble)
         {
            if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(Sprite(this.m_busyBubble))))
            {
               this.m_effectsContainer.removeChild(Sprite(this.m_busyBubble));
            }
            this.m_busyBubble.destroy();
         }
         if(this.m_messageBubble)
         {
            if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(Sprite(this.m_messageBubble))))
            {
               this.m_effectsContainer.removeChild(Sprite(this.m_messageBubble));
            }
            this.m_messageBubble.destroy();
         }
      }
      
      protected function calculateFacingDirection(param1:Number, param2:Number) : int
      {
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         _loc3_ = Math.sqrt(param1 * param1 + param2 * param2);
         if(_loc3_ < MIN_FACING_CHANGE_DIST && !this.m_isWalking)
         {
            return this.m_direction;
         }
         param1 /= _loc3_;
         param2 /= _loc3_;
         _loc4_ = 0;
         if(param1 > TWENTY_DEGREES)
         {
            _loc4_ = 2;
         }
         else if(param1 < -TWENTY_DEGREES)
         {
            _loc4_ = 6;
         }
         else if(param2 > TWENTY_DEGREES)
         {
            _loc4_ = 0;
         }
         else if(param2 < -TWENTY_DEGREES)
         {
            _loc4_ = 4;
         }
         else if(param2 > 0)
         {
            if(param1 > 0)
            {
               _loc4_ = 1;
            }
            else
            {
               _loc4_ = 7;
            }
         }
         else if(param1 > 0)
         {
            _loc4_ = 3;
         }
         else
         {
            _loc4_ = 5;
         }
         return _loc4_;
      }
      
      public function setAvatarName(param1:String, param2:Boolean = false) : void
      {
         this.m_isCelebrity = CELEBRITY_LIST.indexOf(param1) != -1;
         if(this.m_avName)
         {
            if(contains(this.m_avName))
            {
               removeChild(this.m_avName);
            }
            this.m_avName.destroy();
         }
         this.m_avName = new AvatarName(param1,this.m_isModerator,this.m_isCelebrity,this.m_isSafeChat);
         trace("name width : " + this.m_avName.width);
         this.m_avName.x = -this.m_avName.width / 2;
         if(this.m_avModel is IAvatarDragonMount)
         {
            this.m_avName.y = DRAGON_MOUNT_NAME_Y_OFFSET;
         }
         else
         {
            this.m_avName.y = AVATAR_NAME_Y_OFFSET;
         }
         addChild(this.m_avName);
         this.m_isNameOnTopLayer = false;
         if(param2)
         {
            this.m_avName.setBackground(true);
         }
         if(param1 != "")
         {
            this.m_avName.visible = true;
         }
         else
         {
            this.m_avName.visible = false;
         }
      }
      
      public function getFacingDirection() : int
      {
         return this.m_direction;
      }
      
      public function setHandAnimation(param1:String) : void
      {
         if(this.m_avModel is IAvatarPanda)
         {
            IAvatarPanda(this.m_avModel).setHandAnimation(param1);
         }
      }
      
      public function setSittingDirection(param1:int) : void
      {
         this.m_direction = param1;
         this.setAnimation(AvatarModels.AVATAR_ANIMATION_SIT,param1);
      }
      
      public function getHitZone() : Sprite
      {
         return this.m_avModel.getHitZone();
      }
      
      public function isHitHotSpot(param1:Number, param2:Number) : Boolean
      {
         return this.m_avModel.isHit(param1,param2);
      }
      
      public function setHandHeldObject(param1:IHandHeldObject) : void
      {
         if(this.m_avModel is IAvatarPanda)
         {
            IAvatarPanda(this.m_avModel).setHandHeldObject(param1);
         }
      }
      
      public function getPosition() : Point
      {
         return new Point(x,y);
      }
      
      public function setAvatarScale(param1:Number) : void
      {
         this.m_avModel.setScaleMultiplier(param1);
      }
      
      public function showBusyBubble(param1:Boolean, param2:int = 0) : void
      {
         var _loc3_:* = null;
         if(param1)
         {
            this.m_busyBubble.setType(param2);
            _loc3_ = this.m_effectsContainer.globalToLocal(localToGlobal(new Point(BUSY_BUBBLE_X_OFFSET,BUSY_BUBBLE_Y_OFFSET)));
            Sprite(this.m_busyBubble).x = _loc3_.x;
            Sprite(this.m_busyBubble).y = _loc3_.y;
            if(this.m_effectsContainer)
            {
               this.m_effectsContainer.addChild(Sprite(this.m_busyBubble));
            }
         }
         else if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(Sprite(this.m_busyBubble))))
         {
            this.m_busyBubble.destroy();
            this.m_effectsContainer.removeChild(Sprite(this.m_busyBubble));
         }
      }
      
      public function setModerator() : void
      {
         this.m_isModerator = true;
      }
      
      public function getYDepth() : int
      {
         if(this.m_avModel is IAvatarMount)
         {
            return this.m_yDepth + IAvatarMount(this.m_avModel).getMountYDepthOffset();
         }
         return this.m_yDepth;
      }
      
      public function rotateColor(param1:Boolean) : void
      {
         this.m_avModel.rotateColor(param1);
      }
      
      public function updateFacingDirection(param1:Number, param2:Number) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         if(this.m_isWalking)
         {
            return;
         }
         if(Boolean(this.m_avModel.isDancing()) || Boolean(this.m_avModel.isSleeping()) || Boolean(this.m_avModel.isJumping()))
         {
            return;
         }
         if(this.m_avModel.isSitting())
         {
            return;
         }
         _loc3_ = param1 - this.x;
         _loc4_ = param2 - this.y + AVATAR_PIVOT_Y_OFFSET;
         this.m_direction = this.calculateFacingDirection(_loc3_,_loc4_);
         this.scaleAvatar();
         this.setAnimation(AvatarModels.AVATAR_ANIMATION_STAND,this.m_direction);
      }
      
      public function getY() : int
      {
         return Math.floor(y);
      }
      
      public function moveNameToFront() : void
      {
         if(this.m_isModerator)
         {
            return;
         }
         if(!this.m_isNameOnTopLayer && this.m_effectsContainer && Boolean(this.m_avName))
         {
            this.m_avName.setBackground(true);
            this.m_avName.x = this.x + 5 - this.m_avName.width * 0.5;
            this.m_avName.y = this.y + 8;
            if(this.m_avModel is IAvatarDragonMount)
            {
               this.m_avName.y = this.y + DRAGON_MOUNT_NAME_Y_OFFSET;
            }
            else
            {
               this.m_avName.y = this.y + AVATAR_NAME_Y_OFFSET;
            }
            this.m_effectsContainer.addChild(this.m_avName);
            this.m_isNameOnTopLayer = true;
         }
      }
      
      public function setYDepth(param1:int) : void
      {
      }
      
      protected function updateBusyBubblePosition() : void
      {
         var _loc1_:* = null;
         if(this.m_busyBubble)
         {
            _loc1_ = this.m_effectsContainer.globalToLocal(localToGlobal(new Point(BUSY_BUBBLE_X_OFFSET,BUSY_BUBBLE_Y_OFFSET)));
            Sprite(this.m_busyBubble).x = _loc1_.x;
            Sprite(this.m_busyBubble).y = _loc1_.y;
         }
      }
      
      public function getX() : int
      {
         return Math.floor(x);
      }
      
      public function setWaterCoverage(param1:int) : void
      {
         var _loc2_:* = 0;
         if(this.m_avModel)
         {
            _loc2_ = 0;
            if(this.y > param1)
            {
               _loc2_ = AvatarModels.AVATAR_WATER_COVERAGE_Y_OFFSET + (this.y - param1) * 0.28;
            }
            if(this.y > 500)
            {
               _loc2_ = this.y - 500 + _loc2_;
            }
            this.m_avModel.setWaterCoverage(_loc2_);
         }
      }
      
      public function isCelebrity() : Boolean
      {
         return CELEBRITY_LIST.indexOf(this.getName()) != -1;
      }
      
      public function setNightMask(param1:Number) : void
      {
      }
      
      public function getScaleLimits() : Array
      {
         return this.m_scaleLimits;
      }
      
      public function isWalking() : Boolean
      {
         return this.m_isWalking;
      }
      
      public function resetNameLayer() : void
      {
         if(this.m_isModerator)
         {
            return;
         }
         if(this.m_isNameOnTopLayer)
         {
            if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(this.m_avName)))
            {
               this.m_effectsContainer.removeChild(this.m_avName);
            }
            this.m_avName.setBackground(false);
            this.m_avName.x = -this.m_avName.width * 0.5;
            if(this.m_avModel is IAvatarDragonMount)
            {
               this.m_avName.y = DRAGON_MOUNT_NAME_Y_OFFSET;
            }
            else
            {
               this.m_avName.y = AVATAR_NAME_Y_OFFSET;
            }
            addChild(this.m_avName);
            this.m_isNameOnTopLayer = false;
         }
      }
      
      public function destroy() : void
      {
         if(this.m_avModel)
         {
            this.m_avModel.destroy();
            this.m_avModel = null;
         }
         if(this.m_avName)
         {
            if(Boolean(this.m_effectsContainer) && Boolean(this.m_effectsContainer.contains(this.m_avName)))
            {
               this.m_effectsContainer.removeChild(this.m_avName);
            }
            this.m_avName.destroy();
            this.m_avName = null;
         }
         if(this.m_messageBubble)
         {
            if(this.m_effectsContainer.contains(Sprite(this.m_messageBubble)))
            {
               this.m_effectsContainer.removeChild(Sprite(this.m_messageBubble));
            }
            this.m_messageBubble.destroy();
            this.m_messageBubble = null;
         }
         if(this.m_busyBubble)
         {
            if(this.m_effectsContainer.contains(Sprite(this.m_busyBubble)))
            {
               this.m_effectsContainer.removeChild(Sprite(this.m_busyBubble));
            }
            this.m_busyBubble.destroy();
            this.m_busyBubble = null;
         }
         if(this.m_walkPath)
         {
            this.m_walkPath.length = 0;
            this.m_walkPath = null;
         }
         this.m_scaleLimits.length = 0;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      public function getName() : String
      {
         if(this.m_avName)
         {
            return this.m_avName.getName();
         }
         return new String();
      }
      
      public function isModerator() : Boolean
      {
         return this.m_isModerator;
      }
      
      public function updateSittingDirection(param1:Number, param2:Number) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         _loc3_ = param1 - this.x;
         _loc4_ = param2 - this.y + AVATAR_PIVOT_Y_OFFSET;
         this.m_direction = this.calculateFacingDirection(_loc3_,_loc4_);
         this.scaleAvatar();
         this.setAnimation(AvatarModels.AVATAR_ANIMATION_SIT,this.m_direction);
      }
      
      public function setModel(param1:IAvatarModel) : void
      {
         this.m_avModel = param1;
      }
      
      public function getPortrait() : IAvatar
      {
         var _loc1_:* = null;
         _loc1_ = new Avatar(AvatarModels.AVATAR_MODEL_PANDA);
         _loc1_.setColorIndex(this.getColorIndex());
         _loc1_.setClothing(this.m_clothingList);
         _loc1_.setAvatarName(this.getName());
         return _loc1_;
      }
      
      public function updatePosition() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc8_:* = 0;
         if(!this.m_isWalking || this.m_walkPath.length == 0)
         {
            this.m_isWalking = false;
            return;
         }
         this.y -= this.m_bounceOffset;
         _loc1_ = this.m_walkPath[0];
         _loc2_ = _loc1_.x - this.x;
         _loc3_ = _loc1_.y - this.y;
         if(_loc1_.y > MENU_BAR_Y_OFFSET && this.m_avModel is IAvatarPanda)
         {
            this.stopWalking();
            return;
         }
         _loc4_ = _loc2_ * _loc2_ + _loc3_ * _loc3_;
         _loc5_ = getTimer();
         _loc6_ = (_loc5_ - this.m_timeLastFrame) / 1000 * this.m_walkSpeed * GAME_FPS;
         this.m_timeLastFrame = _loc5_;
         if(_loc6_ > MAX_WALK_SPEED_PER_FRAME)
         {
            _loc6_ = MAX_WALK_SPEED_PER_FRAME;
         }
         if(this.y < 500)
         {
            _loc7_ = WALK_SPEED_Y_ADJUST * (500 - this.y) / 500;
            this.m_dx = _loc2_ / Math.sqrt(_loc4_) * _loc6_ * (1 - _loc7_ * 0.7);
            this.m_dy = _loc3_ / Math.sqrt(_loc4_) * _loc6_ * (1 - _loc7_);
         }
         else
         {
            this.m_dx = _loc2_ / Math.sqrt(_loc4_) * _loc6_;
            this.m_dy = _loc3_ / Math.sqrt(_loc4_) * _loc6_;
         }
         if(_loc4_ > _loc6_ * _loc6_)
         {
            this.x += this.m_dx;
            this.y += this.m_dy;
            if(this.m_magicEffect == MagicEffectType.MAGIC_EFFECT_AVATAR_BUBBLE || this.m_avModel is IAvatarGhost || this.m_avModel is IAvatarPetDragon)
            {
               this.m_bounceOffset = 0;
            }
            else if(!(this.m_avModel is IAvatarMount))
            {
               _loc8_ = this.m_walkCounter % AVATAR_BOUNCE_FREQUENCY;
               this.m_bounceOffset = Math.sin(_loc8_ / AVATAR_BOUNCE_FREQUENCY * Math.PI * 2) * AVATAR_BOUNCE_MAGNITUDE;
            }
            this.y += this.m_bounceOffset;
            ++this.m_walkCounter;
         }
         else
         {
            this.x = _loc1_.x;
            this.y = _loc1_.y;
            this.m_walkPath.shift();
            if(this.m_walkPath.length != 0)
            {
               _loc1_ = this.m_walkPath[0];
               _loc2_ = _loc1_.x - this.x;
               _loc3_ = _loc1_.y - this.y;
               this.m_direction = this.calculateFacingDirection(_loc2_,_loc3_ + AVATAR_PIVOT_Y_OFFSET);
               if(this.m_magicEffect != MagicEffectType.MAGIC_EFFECT_AVATAR_BUBBLE)
               {
                  this.setAnimation(AvatarModels.AVATAR_ANIMATION_WALK,this.m_direction);
               }
               else
               {
                  this.setAnimation(AvatarModels.AVATAR_ANIMATION_SIT,this.m_direction);
               }
            }
            else
            {
               this.stopWalking();
            }
         }
         this.scaleAvatar();
         if(this.m_messageBubble.isActive())
         {
            this.updateMessageBubblePosition();
         }
         if(this.m_busyBubble.isActive())
         {
            this.updateBusyBubblePosition();
         }
         if(this.m_isNameOnTopLayer)
         {
            this.m_avName.x = this.x + 5 - this.m_avName.width * 0.5;
            if(this.m_avModel is IAvatarDragonMount)
            {
               this.m_avName.y = this.y + DRAGON_MOUNT_NAME_Y_OFFSET;
            }
            else
            {
               this.m_avName.y = this.y + AVATAR_NAME_Y_OFFSET;
            }
         }
      }
      
      public function stopWalking() : void
      {
         if(!this.m_isWalking)
         {
            return;
         }
         this.y -= this.m_bounceOffset;
         this.m_isWalking = false;
         this.setAnimation(AvatarModels.AVATAR_ANIMATION_STAND,this.m_direction);
         if(this.isClientAvatar())
         {
            dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_CLEAR_ANIMATIONS,null));
         }
      }
      
      public function setNameBackground(param1:Boolean) : void
      {
         this.m_avName.setBackground(param1);
      }
      
      public function getObjectType() : String
      {
         return InteractiveObjectType.IOBJECT_AVATAR;
      }
      
      public function getAvatarNameObject() : AvatarName
      {
         return this.m_avName;
      }
      
      public function getColorIndex() : int
      {
         return this.m_avModel.getColorIndex();
      }
      
      public function isDancing() : Boolean
      {
         return this.m_avModel.isDancing();
      }
      
      public function setColorIndex(param1:int) : void
      {
         this.m_avModel.setColorIndex(param1);
      }
      
      public function setAnimation(param1:String, param2:int = 0) : void
      {
         if(param2 > 4)
         {
            this.m_avModel.setAnimation(param1,8 - param2,true);
         }
         else
         {
            this.m_avModel.setAnimation(param1,param2,false);
         }
      }
      
      public function jumpTo(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
         this.m_yDepth = this.y;
         this.scaleAvatar(true);
         if(this.m_busyBubble.isActive())
         {
            this.updateBusyBubblePosition();
         }
         if(this.m_isNameOnTopLayer)
         {
            this.m_avName.x = this.x + 5 - this.m_avName.width * 0.5;
            if(this.m_avModel is IAvatarDragonMount)
            {
               this.m_avName.y = this.y + DRAGON_MOUNT_NAME_Y_OFFSET;
            }
            else
            {
               this.m_avName.y = this.y + AVATAR_NAME_Y_OFFSET;
            }
         }
      }
   }
}

