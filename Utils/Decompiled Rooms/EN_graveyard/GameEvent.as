package
{
   import flash.events.*;
   
   public class GameEvent extends Event
   {
      
      public static const GAME_EVENT_HIDE_DATE_EVENT_MOUSE_OVER:String = "GAME_EVENT_HIDE_DATE_EVENT_MOUSE_OVER";
      
      public static const GAME_EVENT_SHOW_PURCHASE_PET_FOOD_DIALOG:String = "GAME_EVENT_SHOW_PURCHASE_PET_FOOD_DIALOG";
      
      public static const EVENT_PLAY_MINI_GAME:String = "EVENT_PLAY_MINI_GAME";
      
      public static const EVENT_UPDATE_MINI_GAME:String = "EVENT_UPDATE_MINI_GAME";
      
      public static const GAME_EVENT_SHOW_DROP_QUEST_CONFIRM_DIALOG:String = "GAME_EVENT_SHOW_DROP_QUEST_CONFIRM_DIALOG";
      
      public static const GAME_EVENT_OPEN_SHOPPING_CART:String = "GAME_EVENT_OPEN_SHOPPING_CART";
      
      public static const GAME_EVENT_NET_SWING_COMPLETE:String = "GAME_EVENT_NET_SWING_COMPLETE";
      
      public static const EVENT_UPDATE_USER_VARIABLES:String = "EVENT_UPDATE_USER_VARIABLES";
      
      public static const GAME_EVENT_PURCHAE_PET_FOOD:String = "GAME_EVENT_PURCHAE_PET_FOOD";
      
      public static const GAME_EVENT_DISPLAY_CONTEST_MESSAGE_DIALOG:String = "GAME_EVENT_DISPLAY_CONTEST_MESSAGE_DIALOG";
      
      public static const GAME_EVENT_MAGIC_SWIRL_COMPLETE:String = "GAME_EVENT_MAGIC_SWIRL_COMPLETE";
      
      public static const GAME_EVENT_CLOSE_SHOPPING_CART:String = "GAME_EVENT_CLOSE_SHOPPING_CART";
      
      public static const EVENT_SEND_FRIEND_REQUEST:String = "EVENT_SEND_FRIEND_REQUEST";
      
      public static const GAME_EVENT_TOGGLE_COMMUNITY_GAME:String = "GAME_EVENT_TOGGLE_COMMUNITY_GAME";
      
      public static const GAME_EVENT_TOGGLE_HOUSE_OPEN:String = "GAME_EVENT_TOGGLE_HOUSE_OPEN";
      
      public static const GAME_EVENT_COLLECTION_ANIMATION_COMPLETE:String = "GAME_EVENT_COLLECTION_ANIMATION_COMPLETE";
      
      public static const GAME_EVENT_SHOW_CANCEL_POTION_CONFIRM:String = "GAME_EVENT_SHOW_CANCEL_POTION_CONFIRM";
      
      public static const GAME_EVENT_PLACE_FURNITURE:String = "GAME_EVENT_PLACE_FURNITURE";
      
      public static const GAME_EVENT_SHOW_LEVEL_UP_DIALOG:String = "GAME_EVENT_SHOW_LEVEL_UP_DIALOG";
      
      public static const GAME_EVENT_SHOW_PANDA_GOLD_WEBSITE:String = "GAME_EVENT_SHOW_PANDA_GOLD_WEBSITE";
      
      public static const GAME_EVENT_ADD_SECRET_ITEM:String = "GAME_EVENT_ADD_SECRET_ITEM";
      
      public static const EVENT_DESTROY_CLIENT:String = "EVENT_DESTROY_CLIENT";
      
      public static const GAME_EVENT_CANCEL_FISHING:String = "GAME_EVENT_CANCEL_FISHING";
      
      public static const EVENT_ADD_ITEM_TO_BACKPACK:String = "EVENT_ADD_ITEM_TO_BACKPACK";
      
      public static const EVENT_SHOW_REMOVE_FRIEND_CONFIRM:String = "EVENT_SHOW_REMOVE_FRIEND_CONFIRM";
      
      public static const EVENT_BUY_ICECREAM:String = "EVENT_BUY_ICECREAM";
      
      public static const GAME_EVENT_GET_CLIENT_AVATAR_FOR_PLAYER_PANEL:String = "GAME_EVENT_GET_CLIENT_AVATAR_FOR_PLAYER_PANEL";
      
      public static const GAME_EVENT_SHOW_FESTIVAL_PRIZES_DIALOG:String = "GAME_EVENT_SHOW_FESTIVAL_PRIZES_DIALOG";
      
      public static const GAME_EVENT_SHOW_NPC_QUEST_DIALOG:String = "GAME_EVENT_SHOW_NPC_QUEST_DIALOG";
      
      public static const GAME_EVENT_SHOW_SIMPLE_DIALOG:String = "GAME_EVENT_SHOW_SIMPLE_DIALOG";
      
      public static const EVENT_VISIT_PLAYER_TREEHOUSE:String = "EVENT_VISIT_PLAYER_TREEHOUSE";
      
      public static const GAME_EVENT_CLOSE_CALENDAR:String = "GAME_EVENT_CLOSE_CALENDAR";
      
      public static const GAME_EVENT_ALLOW_FRIEND_REQUESTS:String = "GAME_EVENT_ALLOW_FRIEND_REQUESTS";
      
      public static const EVENT_BACKGROUND_CHANGED:String = "EVENT_BACKGROUND_CHANGED";
      
      public static const GAME_EVENT_CLOSE_CALENDAR_CANCEL_EVENT_DIALOG:String = "GAME_EVENT_CLOSE_CALENDAR_CANCEL_EVENT_DIALOG";
      
      public static const GAME_EVENT_SHOW_BANK:String = "GAME_EVENT_SHOW_BANK";
      
      public static const GAME_EVENT_SHOW_EMPTY_INVITE_LIST_MESSAGE:String = "GAME_EVENT_SHOW_EMPTY_INVITE_LIST_MESSAGE";
      
      public static const GAME_EVENT_CLOSE_NEWSPAPER:String = "GAME_EVENT_CLOSE_NEWSPAPER";
      
      public static const GAME_EVENT_ADD_BIRTHDAY_ITEM:String = "GAME_EVENT_ADD_BIRTHDAY_ITEM";
      
      public static const EVENT_PURCHASE_ITEM:String = "EVENT_PURCHASE_ITEM";
      
      public static const GAME_EVENT_UPDATE_BUNNY_GAME:String = "GAME_EVENT_UPDATE_BUNNY_GAME";
      
      public static const GAME_EVENT_OPEN_CALENDAR_CREATE_EVENT_DIALOG:String = "GAME_EVENT_OPEN_CALENDAR_CREATE_EVENT_DIALOG";
      
      public static const GAME_EVENT_SHOW_BIRTHDAY_PRIZES_DIALOG:String = "GAME_EVENT_SHOW_BIRTHDAY_PRIZES_DIALOG";
      
      public static const GAME_EVENT_SELL_PET:String = "GAME_EVENT_SELL_PET";
      
      public static const GAME_EVENT_TREASURE_CHEST_REWARDS:String = "GAME_EVENT_TREASURE_CHEST_REWARDS";
      
      public static const GAME_EVENT_OPEN_CALENDAR:String = "GAME_EVENT_OPEN_CALENDAR";
      
      public static const GAME_EVENT_PERFORM_PET_ACTION:String = "GAME_EVENT_PERFORM_PET_ACTION";
      
      public static const GAME_EVENT_COMPLETE_QUEST:String = "GAME_EVENT_COMPLETE_QUEST";
      
      public static const GAME_EVENT_CLEAR_ANIMATIONS:String = "GAME_EVENT_CLEAR_ANIMATIONS";
      
      public static const GAME_EVENT_SHOW_ELITE_MEMBERSHIP_ACKNOWLEDGEMENT_DIALOG:String = "GAME_EVENT_SHOW_ELITE_MEMBERSHIP_ACKNOWLEDGEMENT_DIALOG";
      
      public static const EVENT_DROP_ITEM_INTO_BACKPACK:String = "EVENT_DROP_ITEM_INTO_BACKPACK";
      
      public static const GAME_EVENT_GET_CALENDAR_EVENTS:String = "GAME_EVENT_GET_CALENDAR_EVENTS";
      
      public static const GAME_EVENT_RESET_PLAYER_POSITION:String = "GAME_EVENT_RESET_PLAYER_POSITION";
      
      public static const EVENT_IGNORE_PLAYER:String = "EVENT_IGNORE_PLAYER";
      
      public static const EVENT_SHOW_CATALOG_PURCHASE_CONFIRM:String = "EVENT_SHOW_CATALOG_PURCHASE_CONFIRM";
      
      public static const GAME_EVENT_GET_PANDA_GOLD_COUNT:String = "GAME_EVENT_GET_PANDA_GOLD_COUNT";
      
      public static const EVENT_CLEAR_GAME_UI:String = "EVENT_CLEAR_GAME_UI";
      
      public static const EVENT_ADD_ITEM_TO_CLOSET:String = "EVENT_ADD_ITEM_TO_CLOSET";
      
      public static const GAME_EVENT_LOAD_NEWSPAPER:String = "GAME_EVENT_LOAD_NEWSPAPER";
      
      public static const EVENT_CONFIRMATION_BUTTON_PRESSED:String = "EVENT_CONFIRMATION_BUTTON_PRESSED";
      
      public static const EVENT_ANIMATION_SELECTED:String = "EVENT_ANIMATION_SELECTED";
      
      public static const EVENT_ADD_FRIEND:String = "EVENT_ADD_FRIEND";
      
      public static const EVENT_CLOSE_CIRCLE_MENU:String = "EVENT_CLOSE_CIRCLE_MENU";
      
      public static const GAME_EVENT_DROP_QUEST:String = "GAME_EVENT_DROP_QUEST";
      
      public static const GAME_EVENT_CALL_MODERATOR_XT:String = "GAME_EVENT_CALL_MODERATOR_XT";
      
      public static const GAME_EVENT_AVATAR_MOUNT_CHANGED:String = "GAME_EVENT_AVATAR_MOUNT_CHANGED";
      
      public static const GAME_EVENT_CREATE_CALENDAR_EVENT:String = "GAME_EVENT_CREATE_CALENDAR_EVENT";
      
      public static const GAME_EVENT_REMOVE_MAGIC_EFFECT:String = "GAME_EVENT_REMOVE_MAGIC_EFFECT";
      
      public static const GAME_EVENT_PURCHASE_FESTIVAL_PRIZE:String = "GAME_EVENT_PURCHASE_FESTIVAL_PRIZE";
      
      public static const GAME_EVENT_REFRESH_PLAYER_PANEL:String = "GAME_EVENT_REFRESH_PLAYER_PANEL";
      
      public static const EVENT_FISHING_CAST_COMPLETE:String = "EVENT_FISHING_CAST_COMPLETE";
      
      public static const EVENT_MAP_SELECTION:String = "EVENT_MAP_SELECTION";
      
      public static const GAME_EVENT_UPDATE_GHOST_GAME:String = "GAME_EVENT_UPDATE_GHOST_GAME";
      
      public static const EVENT_SHOW_REPORT_PLAYER_DIALOG:String = "EVENT_SHOW_REPORT_PLAYER_DIALOG";
      
      public static const GAME_EVENT_CLOSE_CALENDAR_CREATE_EVENT_DIALOG:String = "GAME_EVENT_CLOSE_CALENDAR_CREATE_EVENT_DIALOG";
      
      public static const GAME_EVENT_GET_WEEKLY_TICKET_PRIZE:String = "GAME_EVENT_GET_WEEKLY_TICKET_PRIZE";
      
      public static const EVENT_DISPLAY_GAME_MESSAGE_DIALOG:String = "EVENT_DISPLAY_GAME_MESSAGE_DIALOG";
      
      public static const GAME_EVENT_SHOW_IGNORE_PLAYER_CONFIRM:String = "GAME_EVENT_SHOW_IGNORE_PLAYER_CONFIRM";
      
      public static const GAME_EVENT_PLAY_LEVEL_UP:String = "GAME_EVENT_PLAY_LEVEL_UP";
      
      public static const GAME_EVENT_SHOW_FESTIVAL_COLLECTION_DIALOG:String = "GAME_EVENT_SHOW_FESTIVAL_COLLECTION_DIALOG";
      
      public static const GAME_EVENT_CANCEL_CALENDAR_EVENT_CLICK:String = "GAME_EVENT_CANCEL_CALENDAR_EVENT_CLICK";
      
      public static const EVENT_ADD_MINI_GAME_TO_LIST:String = "EVENT_ADD_MINI_GAME_TO_LIST";
      
      public static const GAME_EVENT_FISHING_ANIMATION_COMPLETE:String = "GAME_EVENT_FISHING_ANIMATION_COMPLETE";
      
      public static const GAME_EVENT_UPDATE_AVATAR_COLOR:String = "GAME_EVENT_UPDATE_AVATAR_COLOR";
      
      public static const GAME_EVENT_SHOW_QUEST_LOG_QUEST_LIST:String = "GAME_EVENT_SHOW_QUEST_LOG_QUEST_LIST";
      
      public static const GAME_EVENT_SHOW_MEMBER_ONLY_DIALOG:String = "GAME_EVENT_SHOW_MEMBER_ONLY_DIALOG";
      
      public static const EVENT_REPORT_PLAYER:String = "EVENT_REPORT_PLAYER";
      
      public static const EVENT_SHOW_FRIEND_PLAYER_CARD:String = "EVENT_SHOW_FRIEND_PLAYER_CARD";
      
      public static const EVENT_SELL_ITEMS:String = "EVENT_SELL_ITEMS";
      
      public static const GAME_EVENT_PURCHASE_MULTIPLE_ITEMS:String = "GAME_EVENT_PURCHASE_MULTIPLE_ITEMS";
      
      public static const EVENT_EXIT_MINI_GAME:String = "EVENT_EXIT_MINI_GAME";
      
      public static const GAME_EVENT_SHOW_BUSY_BUBBLE:String = "GAME_EVENT_SHOW_BUSY_BUBBLE";
      
      public static const EVENT_TRAVEL_TO_PLAYER:String = "EVENT_TRAVEL_TO_PLAYER";
      
      public static const GAME_EVENT_REMOVE_MAGIC_EFFECT_NOTICE:String = "GAME_EVENT_REMOVE_MAGIC_EFFECT_NOTICE";
      
      public static const GAME_EVENT_SHOW_HOUSE_HELP:String = "GAME_EVENT_SHOW_HOUSE_HELP";
      
      public static const GAME_EVENT_SHOW_DATE_EVENT_MOUSE_OVER:String = "GAME_EVENT_SHOW_DATE_EVENT_MOUSE_OVER";
      
      public static const GAME_EVENT_SHOW_QUEST_DETAILS:String = "GAME_EVENT_SHOW_QUEST_DETAILS";
      
      public static const GAME_EVENT_SHOW_PET_PROFILE_CARD:String = "GAME_EVENT_SHOW_PET_PROFILE_CARD";
      
      public static const GAME_EVENT_PURCHASE_PET_EGG:String = "GAME_EVENT_PURCHASE_PET_EGG";
      
      public static const GAME_EVENT_CALENDAR_GRID_CLICK:String = "GAME_EVENT_CALENDAR_GRID_CLICK";
      
      public static const EVENT_MAIL_LETTER_BUTTON_PRESSED:String = "EVENT_MAIL_LETTER_BUTTON_PRESSED";
      
      public static const EVENT_SHOW_REMOVE_IGNORED_CONFIRM:String = "EVENT_SHOW_REMOVE_IGNORED_CONFIRM";
      
      public static const EVENT_CLEAR_UI_GREY_SCREEN:String = "EVENT_CLEAR_UI_GREY_SCREEN";
      
      public static const GAME_EVENT_GET_QUEST_LOG_NPC:String = "GAME_EVENT_GET_QUEST_LOG_NPC";
      
      public static const GAME_EVENT_CLOSE_GAME_UI_DIALOG:String = "GAME_EVENT_CLOSE_GAME_UI_DIALOG";
      
      public static const GAME_EVENT_SHOW_QUEST_DIALOG:String = "GAME_EVENT_SHOW_QUEST_DIALOG";
      
      public static const EVENT_GET_ITEM_PRICES:String = "EVENT_GET_ITEM_PRICES";
      
      public static const GAME_EVENT_GOTO_NEWSPAPER_PAGE:String = "GAME_EVENT_GOTO_NEWSPAPER_PAGE";
      
      public static const EVENT_REPORT_PLAYER_CONFIRM:String = "EVENT_REPORT_PLAYER_CONFIRM";
      
      public static const GAME_EVENT_GAME_ITEM_COLLECTED:String = "GAME_EVENT_GAME_ITEM_COLLECTED";
      
      public static const EVENT_REMOVE_FRIEND:String = "EVENT_REMOVE_FRIEND";
      
      public static const GAME_EVENT_CREATE_EVENT_DIALOG_BUTTON_PRESS:String = "GAME_EVENT_CREATE_EVENT_DIALOG_BUTTON_PRESS";
      
      public static const GAME_EVENT_RESET_SCENE_OBJECTS:String = "GAME_EVENT_RESET_SCENE_OBJECTS";
      
      public static const EVENT_RESPOND_TO_BUDDY_REQUEST:String = "EVENT_RESPOND_TO_BUDDY_REQUEST";
      
      public static const GAME_EVENT_REDEEM_GOLDEN_TICKETS:String = "GAME_EVENT_REDEEM_GOLDEN_TICKETS";
      
      public static const GAME_EVENT_SHOW_TICKET_COLLECTION_DIALOG:String = "GAME_EVENT_SHOW_TICKET_COLLECTION_DIALOG";
      
      public static const EVENT_LOAD_NPC_CATALOG:String = "EVENT_LOAD_NPC_CATALOG";
      
      public static const GAME_EVENT_USE_BACKPACK_ITEM:String = "GAME_EVENT_USE_BACKPACK_ITEM";
      
      public static const GAME_EVENT_CANCEL_CALENDAR_EVENT:String = "GAME_EVENT_CANCEL_CALENDAR_EVENT";
      
      public static const GAME_EVENT_PURCHASE_BANK_SPACE:String = "GAME_EVENT_PURCHASE_BANK_SPACE";
      
      public static const GAME_EVENT_UPDATE_BANK_CONTENTS:String = "GAME_EVENT_UPDATE_BANK_CONTENTS";
      
      public static const GAME_EVENT_ACCEPT_QUEST:String = "GAME_EVENT_ACCEPT_QUEST";
      
      public static const GAME_EVENT_TOGGLE_HOUSE_EDIT:String = "GAME_EVENT_TOGGLE_HOUSE_EDIT";
      
      public static const GAME_EVENT_GET_PET_LIST:String = "GAME_EVENT_GET_PET_LIST";
      
      public static const GAME_EVENT_UPDATE_HUD:String = "GAME_EVENT_UPDATE_HUD";
      
      public var params:Object;
      
      public function GameEvent(param1:String, param2:Object)
      {
         super(param1,true);
         this.params = param2;
      }
      
      override public function clone() : Event
      {
         return new GameEvent(this.type,this.params);
      }
      
      override public function toString() : String
      {
         return formatToString("GameEvent","type","bubbles","cancelable","eventPhase","params");
      }
   }
}

