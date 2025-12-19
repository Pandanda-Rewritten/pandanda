package
{
   import flash.display.*;
   
   public class AvatarModels
   {
      
      internal static var m_instance:AvatarModels;
      
      public static const AVATAR_ANIMATION_SIT:String = "AVATAR_ANIMATION_SIT";
      
      public static const AVATAR_ANIMATION_BEANIE_JUMP:String = "AVATAR_ANIMATION_BEANIE_JUMP";
      
      public static const AVATAR_WATER_COVERAGE_Y_OFFSET:int = 30;
      
      public static const AVATAR_MODEL_CAULDRON:String = "AVATAR_MODEL_CAULDRON";
      
      public static const AVATAR_HAND_STAND:String = "AVATAR_HAND_STAND";
      
      public static const AVATAR_ANIMATION_DANCE:String = "AVATAR_ANIMATION_DANCE";
      
      public static const AVATAR_ANIMATION_LOVE:String = "AVATAR_ANIMATION_LOVE";
      
      public static const AVATAR_MODEL_PET_DRAGON_EGG:String = "AVATAR_MODEL_PET_DRAGON_EGG";
      
      public static const AVATAR_MODEL_HORSE_TIER_3_MOUNT:String = "AVATAR_MODEL_HORSE_TIER_3_MOUNT";
      
      public static const AVATAR_ANIMATION_FLY:String = "AVATAR_ANIMATION_FLY";
      
      public static const AVATAR_ANIMATION_WAVE:String = "AVATAR_ANIMATION_WAVE";
      
      public static const AVATAR_MODEL_SNOWMAN_BOT:String = "AVATAR_MODEL_SNOWMAN_BOT";
      
      public static const AVATAR_MODEL_PANDA:String = "AVATAR_MODEL_PANDA";
      
      public static const AVATAR_HAND_HOLD:String = "AVATAR_HAND_HOLD";
      
      public static const AVATAR_MODEL_HORSE_TIER_2_MOUNT:String = "AVATAR_MODEL_HORSE_TIER_2_MOUNT";
      
      public static const AVATAR_MODEL_DRAGON:String = "AVATAR_MODEL_DRAGON";
      
      public static const AVATAR_ANIMATION_EAT_TREAT:String = "AVATAR_ANIMATION_EAT_TREAT";
      
      public static const AVATAR_HAND_WALK:String = "AVATAR_HAND_WALK";
      
      public static const AVATAR_ANIMATION_STAND:String = "AVATAR_ANIMATION_STAND";
      
      public static const AVATAR_ANIMATION_SLEEP:String = "AVATAR_ANIMATION_SLEEP";
      
      public static const AVATAR_HAND_NET_HOLD:String = "AVATAR_HAND_NET_HOLD";
      
      public static const AVATAR_MODEL_SNOWMAN:String = "AVATAR_MODEL_SNOWMAN";
      
      public static const AVATAR_MODEL_SNOWMAN_NPC:String = "AVATAR_MODEL_SNOWMAN_NPC";
      
      public static const AVATAR_MODEL_GHOST1:String = "AVATAR_MODEL_GHOST1";
      
      public static const AVATAR_MODEL_GHOST2:String = "AVATAR_MODEL_GHOST2";
      
      public static const AVATAR_HAND_FISHING:String = "AVATAR_HAND_FISHING";
      
      public static const AVATAR_HAND_NET_WALK:String = "AVATAR_HAND_NET_WALK";
      
      public static const AVATAR_HAND_FISH_HOLD:String = "AVATAR_HAND_FISH_HOLD";
      
      public static const AVATAR_MODEL_BUNNY:String = "AVATAR_MODEL_BUNNY";
      
      public static const AVATAR_MODEL_SLED_MOUNT:String = "AVATAR_MODEL_SLED_MOUNT";
      
      public static const AVATAR_ANIMATION_JUMP:String = "AVATAR_ANIMATION_JUMP";
      
      public static const AVATAR_ANIMATION_FIRE:String = "AVATAR_ANIMATION_FIRE";
      
      public static const AVATAR_MODEL_SCARECROW:String = "AVATAR_MODEL_SCARECROW";
      
      public static const AVATAR_HAND_WAVE:String = "AVATAR_HAND_WAVE";
      
      public static const AVATAR_SIT:String = "AVATAR_SIT";
      
      public static const AVATAR_MODEL_DRAGON_MOUNT:String = "AVATAR_MODEL_DRAGON_MOUNT";
      
      public static const AVATAR_MODEL_HORSE_TIER_1_MOUNT:String = "AVATAR_MODEL_HORSE_TIER_1_MOUNT";
      
      public static const AVATAR_HAND_GHOST_PACK:String = "AVATAR_HAND_GHOST_PACK";
      
      public static const AVATAR_MODEL_PET_DRAGON:String = "AVATAR_MODEL_PET_DRAGON";
      
      public static const AVATAR_MAGIC_EFFECT_GROW:int = 1;
      
      public static const AVATAR_ANIMATION_WALK:String = "AVATAR_ANIMATION_WALK";
      
      public static const AVATAR_HAND_NET_SWING:String = "AVATAR_HAND_NET_SWING";
      
      public static const AVATAR_ANIMATION_EAT:String = "AVATAR_ANIMATION_EAT";
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_avatarDoc:IAvatarDoc;
      
      public function AvatarModels()
      {
         super();
         trace("GameItems Constuctor");
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use AvatarModels.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : AvatarModels
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new AvatarModels();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function getAvatarColorArray(param1:String) : Array
      {
         if(this.m_avatarDoc)
         {
            return this.m_avatarDoc.getAvatarColorArray(param1);
         }
         return null;
      }
      
      public function getPaperDoll() : IAvatarPaperDoll
      {
         return this.m_avatarDoc.getAvatarPaperDoll();
      }
      
      public function getAvatarModel(param1:String) : IAvatarModel
      {
         return this.m_avatarDoc.getAvatarModel(param1);
      }
      
      public function getModeratorSymbol() : Sprite
      {
         return this.m_avatarDoc.getModeratorSymbol();
      }
      
      public function getSafeChatSymbol() : MovieClip
      {
         return this.m_avatarDoc.getSafeChatSymbol();
      }
      
      public function getMountItem(param1:String) : IGameItem
      {
         if(this.m_avatarDoc)
         {
            return this.m_avatarDoc.getMountItem(param1);
         }
         return null;
      }
      
      public function getLevelUpAnimation(param1:int) : MovieClip
      {
         return this.m_avatarDoc.getLevelUpAnimation(param1);
      }
      
      public function setAvatarDoc(param1:IAvatarDoc) : void
      {
         this.m_avatarDoc = param1;
      }
      
      public function getMagicEffectMC(param1:int) : MovieClip
      {
         return this.m_avatarDoc.getMagicEffectMC(param1);
      }
   }
}

