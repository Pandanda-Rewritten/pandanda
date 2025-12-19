package
{
   public class PlayerAttributes
   {
      
      internal static var m_instance:PlayerAttributes;
      
      public static const MONTH_NAMES:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
      
      internal static const MAX_ZING_TICKETS:int = 10;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_birthday:String;
      
      internal var m_furnitureDisplayed:Array;
      
      internal var m_isStealth:Boolean;
      
      internal var m_isModerator:Boolean;
      
      internal var m_age:int;
      
      internal var m_lastAnimationTime:uint;
      
      internal var m_clothesList:Array;
      
      internal var m_specialItemList:Object;
      
      internal var m_questCount:int;
      
      internal var m_lastFishCastTime:uint;
      
      internal var m_isGameDay:Boolean;
      
      internal var m_lastLoginDate:String;
      
      internal var m_equipped:Array;
      
      internal var m_memberOnly:Array;
      
      internal var m_mailList:Array;
      
      internal var m_bankList:Array;
      
      internal var m_isChristmas:Boolean;
      
      internal var m_lastPlayedGame:int;
      
      internal var m_doBirthdayNotice:Boolean;
      
      internal var m_paintList:Array;
      
      internal var m_magicEffect:int;
      
      internal var m_membershipEnd:String;
      
      internal var m_cardColor:int;
      
      internal var m_isSafeChat:Boolean;
      
      internal var m_doLevelUp:Boolean;
      
      internal var m_petsDying:String;
      
      internal var m_pets:Array;
      
      internal var m_sitting:int;
      
      internal var m_furnitureStorage:Array;
      
      internal var m_name:String;
      
      internal var m_id:uint;
      
      internal var m_gameList:Array;
      
      internal var m_mounts:Array;
      
      internal var m_isDancing:Boolean;
      
      internal var m_closet:Array;
      
      internal var m_bankVaultCount:int;
      
      internal var m_avatarColorIndex:int;
      
      internal var m_xpLevel:uint;
      
      internal var m_email:String;
      
      internal var m_heldObject:IHandHeldObject;
      
      internal var m_isEmailValidated:Boolean;
      
      internal var m_level:int;
      
      internal var m_isZingEligible:Boolean;
      
      internal var m_cardBackgroundList:Array;
      
      internal var m_isZingActive:Boolean;
      
      internal var m_isMember:Boolean;
      
      internal var m_coins:uint;
      
      internal var m_lastWalkTime:uint;
      
      internal var m_backpack:Array;
      
      internal var m_isSleeping:Boolean;
      
      internal var m_notificationList:Array;
      
      internal var m_xp:uint;
      
      internal var m_ipAddress:String;
      
      public function PlayerAttributes()
      {
         super();
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use Clothing.getInstance() instead of new.");
         }
         trace("PlayerAttributes Constuctor");
         m_id = 0;
         m_ipAddress = new String();
         m_name = new String("Player");
         m_email = new String("email");
         m_isEmailValidated = true;
         m_isModerator = false;
         m_isMember = false;
         m_isStealth = false;
         m_coins = 0;
         m_level = 0;
         m_xp = 0;
         m_xpLevel = 0;
         m_questCount = 0;
         m_avatarColorIndex = 0;
         m_bankVaultCount = 0;
         m_bankList = new Array();
         m_equipped = new Array();
         m_closet = new Array();
         m_clothesList = new Array();
         m_cardBackgroundList = new Array();
         m_paintList = new Array();
         m_memberOnly = new Array();
         m_backpack = new Array();
         m_gameList = new Array();
         m_mounts = new Array();
         m_mailList = new Array();
         m_notificationList = new Array();
         m_furnitureStorage = new Array();
         m_furnitureDisplayed = new Array();
         m_pets = new Array();
         m_sitting = -1;
         m_lastFishCastTime = 0;
         m_isSafeChat = false;
         m_lastPlayedGame = 0;
         m_magicEffect = MagicEffectType.MAGIC_EFFECT_NONE;
         m_lastLoginDate = new String();
         m_specialItemList = new Object();
         m_isZingEligible = false;
         m_isZingActive = false;
         m_membershipEnd = new String();
         m_petsDying = new String();
         m_doLevelUp = false;
         m_isChristmas = false;
         m_isGameDay = false;
      }
      
      public static function getInstance() : PlayerAttributes
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new PlayerAttributes();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function addBackpackItem(param1:String) : void
      {
         m_backpack.splice(0,0,param1);
      }
      
      public function setLastPlayedGame(param1:String) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = 0;
         while(_loc2_ < m_gameList.length)
         {
            if(m_gameList[_loc2_].getId() == param1)
            {
               m_lastPlayedGame = _loc2_;
               break;
            }
            _loc2_++;
         }
      }
      
      public function setEquippedList(param1:String) : void
      {
         if(param1 != "")
         {
            if(param1.indexOf(",") == 0)
            {
               param1 = param1.substr(1);
            }
            m_equipped = param1.split(",");
         }
         else
         {
            m_equipped.length = 0;
         }
      }
      
      public function clearCardBackground() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < m_equipped.length)
         {
            if(m_equipped[_loc1_].indexOf("BG") != -1)
            {
               m_equipped.splice(_loc1_,1);
               break;
            }
            _loc1_++;
         }
      }
      
      public function setName(param1:String) : void
      {
         m_name = param1;
      }
      
      public function getMountList() : Array
      {
         return m_mounts;
      }
      
      public function setSitting(param1:int) : void
      {
         m_sitting = param1;
      }
      
      public function getCardBackgroundList() : Array
      {
         return m_cardBackgroundList;
      }
      
      public function setPetsDying(param1:String) : void
      {
         m_petsDying = param1;
         if(m_petsDying.charAt(m_petsDying.length - 1) == ",")
         {
            m_petsDying = m_petsDying.substring(0,m_petsDying.length - 1);
         }
      }
      
      public function setMountList(param1:String) : void
      {
         if(param1.length == 0)
         {
            m_mounts.length = 0;
            return;
         }
         if(param1.indexOf(",") == 0)
         {
            param1 = param1.substr(1);
         }
         m_mounts = param1.split(",");
      }
      
      public function getTotalLevelXP() : uint
      {
         return m_xpLevel;
      }
      
      public function getPetsDying() : String
      {
         return m_petsDying;
      }
      
      public function setMemberOnlyList(param1:String) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         if(param1.indexOf(",") == 0)
         {
            param1 = param1.substr(1);
         }
         m_memberOnly = param1.split(",");
      }
      
      public function getPets() : Array
      {
         return m_pets;
      }
      
      public function getBackpackCount() : int
      {
         return m_backpack.length;
      }
      
      public function addNotification(param1:INotificationItem) : void
      {
         m_notificationList.push(param1);
      }
      
      public function getClosetCount() : int
      {
         if(m_closet)
         {
            return m_closet.length;
         }
         return 0;
      }
      
      public function addFurnitureToStorage(param1:String) : void
      {
         m_furnitureStorage.splice(0,0,param1);
      }
      
      public function isGameDay() : Boolean
      {
         return m_isGameDay;
      }
      
      public function setGameList(param1:String, param2:String) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         if(param1.length == 0)
         {
            m_gameList.length = 0;
            return;
         }
         m_gameList.length = 0;
         _loc3_ = ["MG006","MG007","MG001","MG002","MG003","MG004","MG005"];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            m_gameList.push(new MiniGame(_loc3_[_loc4_]));
            if(_loc3_[_loc4_] == param2)
            {
               m_lastPlayedGame = _loc4_;
            }
            _loc4_++;
         }
      }
      
      public function setBackpackList(param1:String) : void
      {
         var _loc2_:* = null;
         if(param1.length == 0)
         {
            m_backpack.length = 0;
            return;
         }
         if(param1.indexOf(",") == 0)
         {
            param1 = param1.substr(1);
         }
         _loc2_ = param1.split(",");
         m_backpack = _loc2_;
      }
      
      public function getIPAddress() : String
      {
         return m_ipAddress;
      }
      
      public function doLevelUp() : Boolean
      {
         return m_doLevelUp;
      }
      
      public function hasClosetItem(param1:String) : Boolean
      {
         if(m_closet.indexOf(param1) != -1 || m_equipped.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function doFreeItemsExceedLimit(param1:Array) : Boolean
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(m_isMember)
         {
            return false;
         }
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < m_equipped.length)
         {
            if(!isMemberOnly(m_equipped[_loc3_]))
            {
               _loc2_++;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(!isMemberOnly(param1[_loc3_]))
            {
               _loc2_++;
            }
            _loc3_++;
         }
         if(_loc2_ >= GameConstants.MAX_CLOSET_SIZE_FREEBIES)
         {
            return true;
         }
         return false;
      }
      
      public function addClosetItem(param1:String) : void
      {
         m_closet.splice(0,0,param1);
         if(param1.indexOf("C") == -1)
         {
            if(param1.indexOf("BG") == -1)
            {
               if(param1.indexOf("P") == 0)
               {
                  m_paintList.push(param1);
               }
            }
            else
            {
               m_cardBackgroundList.push(param1);
            }
         }
         else
         {
            m_clothesList.push(param1);
         }
      }
      
      public function hasUnreadMail() : Boolean
      {
         return m_mailList.length > 0;
      }
      
      public function setClosetList(param1:String) : void
      {
         var _loc2_:* = 0;
         if(param1.length == 0)
         {
            m_closet.length = 0;
            m_clothesList.length = 0;
            m_cardBackgroundList.length = 0;
            m_paintList.length = 0;
            return;
         }
         if(param1.indexOf(",") == 0)
         {
            param1 = param1.substr(1);
         }
         m_closet = param1.split(",");
         m_clothesList.length = 0;
         m_cardBackgroundList.length = 0;
         m_paintList.length = 0;
         _loc2_ = 0;
         while(_loc2_ < m_closet.length)
         {
            if(m_closet[_loc2_].indexOf("C") == -1)
            {
               if(m_closet[_loc2_].indexOf("BG") == -1)
               {
                  if(m_closet[_loc2_].indexOf("P") == 0)
                  {
                     m_paintList.push(m_closet[_loc2_]);
                  }
               }
               else
               {
                  m_cardBackgroundList.push(m_closet[_loc2_]);
               }
            }
            else
            {
               m_clothesList.push(m_closet[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function setSleeping(param1:Boolean) : void
      {
         m_isSleeping = param1;
      }
      
      public function getClosetList() : Array
      {
         return m_closet;
      }
      
      public function isSitting() : Boolean
      {
         return m_sitting != -1;
      }
      
      public function getCoins() : uint
      {
         return m_coins;
      }
      
      public function getMostPlayedGame() : MiniGame
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc1_ = 0;
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < m_gameList.length)
         {
            if(m_gameList[_loc3_].getPlayedCount() > _loc2_)
            {
               _loc2_ = m_gameList[_loc3_].getPlayedCount();
               _loc1_ = _loc3_;
            }
            _loc3_++;
         }
         return m_gameList[_loc1_];
      }
      
      public function getBankVaultCount() : int
      {
         return m_bankVaultCount;
      }
      
      public function getLastFishCastTime() : uint
      {
         return m_lastFishCastTime;
      }
      
      public function setLevel(param1:int) : void
      {
         m_level = param1;
      }
      
      public function getGameItemCount(param1:String) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < m_backpack.length)
         {
            if(m_backpack[_loc3_] == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function setZingActive(param1:Boolean) : void
      {
         m_isZingActive = param1;
      }
      
      public function getLevel() : int
      {
         return m_level;
      }
      
      public function setBankVaultCount(param1:int) : void
      {
         m_bankVaultCount = param1;
      }
      
      public function isMemberOnly(param1:String) : Boolean
      {
         if(m_memberOnly.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function getAge() : int
      {
         return m_age;
      }
      
      public function setEmail(param1:String) : void
      {
         m_email = param1;
      }
      
      public function isMember() : Boolean
      {
         return m_isMember;
      }
      
      public function addEquippedItem(param1:String) : void
      {
         if(m_equipped.indexOf(param1) != -1)
         {
            return;
         }
         if(m_closet.indexOf(param1) == -1)
         {
            if(m_mounts.indexOf(param1) != -1)
            {
               m_equipped.push(param1);
            }
         }
         else
         {
            m_equipped.push(param1);
         }
      }
      
      public function hasBackpackItem(param1:String) : Boolean
      {
         if(m_backpack.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function getClothesList() : Array
      {
         return m_clothesList;
      }
      
      public function addGameToList(param1:String) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = 0;
         _loc2_ = false;
         _loc3_ = 0;
         while(_loc3_ < m_gameList.length)
         {
            if(m_gameList[_loc3_].getId() == param1)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         if(!_loc2_)
         {
            m_gameList.push(new MiniGame(param1));
         }
      }
      
      public function getBankList() : Array
      {
         return m_bankList;
      }
      
      public function setMagicEffect(param1:int) : void
      {
         m_magicEffect = param1;
      }
      
      public function setLastWalkTime(param1:uint) : void
      {
         m_lastWalkTime = param1;
      }
      
      public function getMagicEffect() : int
      {
         return m_magicEffect;
      }
      
      public function hasShovel() : Boolean
      {
         if(m_backpack.indexOf("GI604") != -1)
         {
            return true;
         }
         return false;
      }
      
      public function getSpecialItemCount(param1:String) : int
      {
         if(m_specialItemList[param1])
         {
            return m_specialItemList[param1];
         }
         return 0;
      }
      
      public function setLevelUp(param1:Boolean) : void
      {
         m_doLevelUp = param1;
      }
      
      public function isBackpackFull() : Boolean
      {
         var _loc1_:* = 0;
         _loc1_ = GameConstants.MAX_BACKPACK_SIZE;
         if(m_isMember)
         {
            _loc1_ = GameConstants.MAX_BACKPACK_SIZE_MEMBER;
         }
         if(m_backpack.length >= _loc1_)
         {
            return true;
         }
         return false;
      }
      
      public function setMembershipEnd(param1:String) : void
      {
         m_membershipEnd = param1 + " PST";
      }
      
      public function getGame(param1:String) : MiniGame
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < m_gameList.length)
         {
            if(m_gameList[_loc2_].getId() == param1)
            {
               return m_gameList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setFurnitureStorageList(param1:String) : void
      {
         if(param1 != "")
         {
            if(param1.indexOf(",") == 0)
            {
               param1 = param1.substr(1);
            }
            m_furnitureStorage = param1.split(",");
         }
         else
         {
            m_furnitureStorage = new Array();
            m_furnitureStorage.length = 0;
         }
      }
      
      public function toggleZingEligible(param1:Boolean) : void
      {
         m_isZingEligible = param1;
      }
      
      public function hasFishingPole() : Boolean
      {
         if(m_backpack.indexOf("GI602") != -1)
         {
            return true;
         }
         return false;
      }
      
      public function getEquippedList() : Array
      {
         if(m_equipped)
         {
            return m_equipped;
         }
         return new Array();
      }
      
      public function removeItemFromBackpack(param1:String) : void
      {
         var _loc2_:* = 0;
         _loc2_ = m_backpack.indexOf(param1);
         if(_loc2_ != -1)
         {
            m_backpack.splice(_loc2_,1);
         }
      }
      
      public function hasNotification() : Boolean
      {
         return m_notificationList.length > 0;
      }
      
      public function setAvatarColorIndex(param1:int) : void
      {
         m_avatarColorIndex = param1;
      }
      
      public function setIPAddress(param1:String) : void
      {
         m_ipAddress = param1;
      }
      
      public function playerHasItem(param1:String) : Boolean
      {
         if(m_closet.indexOf(param1) != -1 || m_mounts.indexOf(param1) != -1 || m_backpack.indexOf(param1) != -1 || m_furnitureStorage.indexOf(param1) != -1 || m_furnitureDisplayed.indexOf(param1) != -1 || m_bankList.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function getEmail() : String
      {
         return m_email;
      }
      
      public function setCardColor(param1:int) : void
      {
         m_cardColor = param1;
         SavedLocalData.getInstance().setCardColor(m_name,param1);
      }
      
      public function getBackpackList() : Array
      {
         return m_backpack;
      }
      
      public function setPets(param1:String) : void
      {
         if(param1 == "")
         {
            return;
         }
         m_pets = param1.split(";");
      }
      
      public function setBirthdayNotice(param1:Boolean) : void
      {
         m_doBirthdayNotice = param1;
      }
      
      public function setCoins(param1:uint) : void
      {
         m_coins = param1;
      }
      
      public function setModerator(param1:Boolean) : void
      {
         m_isModerator = param1;
      }
      
      public function getLastAnimationTime() : uint
      {
         return m_lastAnimationTime;
      }
      
      public function getBirthday() : String
      {
         return m_birthday;
      }
      
      public function addMount(param1:String) : void
      {
         if(m_mounts.indexOf(param1) == -1)
         {
            m_mounts.splice(0,0,param1);
         }
      }
      
      public function addPet(param1:String) : void
      {
         trace("adding pet : " + param1);
         m_pets.push(param1);
      }
      
      public function getHeldObject() : IHandHeldObject
      {
         if(m_heldObject)
         {
            return m_heldObject;
         }
         return null;
      }
      
      public function removeFurnitureFromStorage(param1:String) : void
      {
         var _loc2_:* = 0;
         _loc2_ = m_furnitureStorage.indexOf(param1);
         if(_loc2_ != -1)
         {
            m_furnitureStorage.splice(_loc2_,1);
         }
      }
      
      public function destroy() : void
      {
         m_clothesList.length = 0;
         m_clothesList = null;
         m_cardBackgroundList.length = 0;
         m_cardBackgroundList = null;
         m_paintList.length = 0;
         m_paintList = null;
      }
      
      public function setEmailValidated(param1:Boolean) : void
      {
         m_isEmailValidated = param1;
      }
      
      public function setHeldObject(param1:IHandHeldObject) : void
      {
         if(m_heldObject)
         {
            m_heldObject.destroy();
            m_heldObject = null;
         }
         m_heldObject = param1;
      }
      
      public function updateMiniGame(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < m_gameList.length)
         {
            if(m_gameList[_loc4_].getId() == param1)
            {
               m_gameList[_loc4_].setPlayedCount(param2);
               m_gameList[_loc4_].setTotalCoins(param3);
               break;
            }
            _loc4_++;
         }
      }
      
      public function getMailItem() : IMailItem
      {
         var _loc1_:* = null;
         if(m_mailList.length > 0)
         {
            _loc1_ = m_mailList[0];
            m_mailList.splice(0,1);
            return _loc1_;
         }
         return null;
      }
      
      public function addMail(param1:IMailItem) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < m_mailList.length)
         {
            if(param1.getSender() == m_mailList[_loc2_].getSender() && param1.getType() == m_mailList[_loc2_].getType())
            {
               return;
            }
            _loc2_++;
         }
         m_mailList.push(param1);
      }
      
      public function doSpawnTicket() : Boolean
      {
         if(isZingActive())
         {
            if(getSpecialItemCount(GameConstants.GOLDEN_TICKET) < MAX_ZING_TICKETS)
            {
               return true;
            }
         }
         else if(GameConstants.ACTIVE_FESTIVAL != "")
         {
            return true;
         }
         return false;
      }
      
      public function getFurnitureStorageList() : Array
      {
         return m_furnitureStorage;
      }
      
      public function getAvatarColorIndex() : int
      {
         return m_avatarColorIndex;
      }
      
      public function setIsMember(param1:Boolean) : void
      {
         m_isMember = param1;
      }
      
      public function hasRockHammer() : Boolean
      {
         if(m_backpack.indexOf("GI603") != -1)
         {
            return true;
         }
         return false;
      }
      
      public function setDancing(param1:Boolean) : void
      {
         m_isDancing = param1;
      }
      
      public function getNextNotification() : INotificationItem
      {
         var _loc1_:* = null;
         if(m_notificationList[0])
         {
            _loc1_ = m_notificationList[0];
            m_notificationList.splice(0,1);
         }
         return _loc1_;
      }
      
      public function isSleeping() : Boolean
      {
         return m_isSleeping;
      }
      
      public function isSafeChat() : Boolean
      {
         return m_isSafeChat;
      }
      
      public function isModerator() : Boolean
      {
         return m_isModerator;
      }
      
      public function setBirthday(param1:String) : void
      {
         var _loc2_:* = null;
         _loc2_ = param1.split(",");
         m_birthday = _loc2_[0];
         m_age = int(_loc2_[1]);
      }
      
      public function getName() : String
      {
         return m_name;
      }
      
      public function getFurnitureDisplayedCount() : int
      {
         return m_furnitureDisplayed.length;
      }
      
      public function getLastLoginDate() : String
      {
         return m_lastLoginDate;
      }
      
      public function getId() : uint
      {
         return m_id;
      }
      
      public function setTotalLevelXP(param1:uint) : void
      {
         m_xpLevel = param1;
      }
      
      public function doBirthdayNotice() : Boolean
      {
         return m_doBirthdayNotice;
      }
      
      public function setId(param1:uint) : void
      {
         m_id = param1;
      }
      
      public function isDancing() : Boolean
      {
         return m_isDancing;
      }
      
      public function isZingActive() : Boolean
      {
         return m_isZingActive;
      }
      
      public function setSafeChat(param1:Boolean) : void
      {
         m_isSafeChat = param1;
      }
      
      public function getGameList() : Array
      {
         return m_gameList;
      }
      
      public function removeEquippedItem(param1:String) : void
      {
         var _loc2_:* = 0;
         _loc2_ = m_equipped.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         m_equipped.splice(_loc2_,1);
      }
      
      public function setLastAnimationTime(param1:uint) : void
      {
         m_lastAnimationTime = param1;
      }
      
      public function setChristmas(param1:Boolean) : void
      {
         m_isChristmas = param1;
      }
      
      public function setStealth(param1:Boolean) : void
      {
         m_isStealth = param1;
      }
      
      public function getQuestCount() : int
      {
         return m_questCount;
      }
      
      public function subtractCoins(param1:int) : void
      {
         m_coins -= param1;
      }
      
      public function setQuestCount(param1:int) : void
      {
         m_questCount = param1;
      }
      
      public function hasMountItem(param1:String) : Boolean
      {
         if(m_mounts.indexOf(param1) != -1 || m_equipped.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function setLastFishCastTime(param1:uint) : void
      {
         m_lastFishCastTime = param1;
      }
      
      public function getLastWalkTime() : uint
      {
         return m_lastWalkTime;
      }
      
      public function getPaintList() : Array
      {
         return m_paintList;
      }
      
      public function getExperience() : uint
      {
         return m_xp;
      }
      
      public function isZingEligible() : Boolean
      {
         return m_isZingEligible;
      }
      
      public function setExperience(param1:uint) : void
      {
         m_xp = param1;
      }
      
      public function getMembershipEnd() : String
      {
         return m_membershipEnd;
      }
      
      public function isChristmas() : Boolean
      {
         return m_isChristmas;
      }
      
      public function isStealth() : Boolean
      {
         return m_isStealth;
      }
      
      public function setBankList(param1:String) : void
      {
         if(param1.length == 0)
         {
            m_bankList.length = 0;
            return;
         }
         if(param1.indexOf(",") == 0)
         {
            param1 = param1.substr(1);
         }
         m_bankList = param1.split(",");
      }
      
      public function setLastLoginDate(param1:String) : void
      {
         m_lastLoginDate = param1;
      }
      
      public function getCurrentCardBackgroundId() : String
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < m_equipped.length)
         {
            if(m_equipped[_loc1_].indexOf("BG") == 0)
            {
               return m_equipped[_loc1_];
            }
            _loc1_++;
         }
         return "BG001";
      }
      
      public function getCardColor() : int
      {
         return m_cardColor;
      }
      
      public function setSpecialItemCount(param1:String, param2:int) : void
      {
         m_specialItemList[param1] = param2;
      }
      
      public function setGameDay(param1:Boolean) : void
      {
         m_isGameDay = param1;
      }
      
      public function getLastPlayedGame() : MiniGame
      {
         return m_gameList[m_lastPlayedGame];
      }
      
      public function getBankCount() : int
      {
         if(m_bankList)
         {
            return m_bankList.length;
         }
         return 0;
      }
      
      public function isEmailValidated() : Boolean
      {
         return m_isEmailValidated;
      }
   }
}

