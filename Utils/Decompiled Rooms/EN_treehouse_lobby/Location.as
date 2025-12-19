package
{
   internal class Location
   {
      
      internal static var m_instance:Location;
      
      public static const EN_LIBRARY:String = "EN_library";
      
      public static const EN_GRAVEYARD:String = "EN_graveyard";
      
      public static const EN_TREEHOUSE:String = "EN_treehouse";
      
      public static const EN_BARN:String = "EN_barn";
      
      public static const EN_PET_SHOP:String = "EN_petstore";
      
      public static const EN_ORCHARD:String = "EN_orchard";
      
      public static const EN_BUNNY_FIELD:String = "EN_bunny_field";
      
      public static const EN_PURPLE_DOOR:String = "EN_purple_door";
      
      public static const EN_STONEHENGE:String = "EN_stonehenge";
      
      public static const EN_TREEHOUSE_LOBBY:String = "EN_treehouse_lobby";
      
      public static const PLAYER_TREEHOUSE:String = "player_treehouse";
      
      public static const OW_TOWN1:String = "OW_town1";
      
      public static const EN_FISHING_HOLE:String = "EN_fishing_hole";
      
      public static const EN_PARLOUR:String = "EN_parlour";
      
      public static const EN_CLOTHES_STORE:String = "EN_clothes_store";
      
      public static const EN_TOWN_SQUARE:String = "EN_townsquare";
      
      public static const EN_ICE_CREAM_SHOP:String = "EN_icecream";
      
      public static const EN_TOWN_SQUARE2:String = "EN_townsquare2";
      
      public static const EN_HARVEST_GROVE:String = "EN_harvest_grove";
      
      public static const EN_FOREST:String = "EN_forest";
      
      public static const EN_DARK_ROOM:String = "EN_darkroom";
      
      public static const EN_VILLAGE:String = "EN_village";
      
      public static const SINGLE_MINI_GAME_ROOM:String = "minigame";
      
      public static const EN_BEACH:String = "EN_beach";
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_indoorList:Array;
      
      internal var m_locationNameList:Object;
      
      internal var m_swfNameList:Object;
      
      public function Location()
      {
         super();
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use Location.getInstance() instead of new.");
         }
         trace("Location Constuctor");
         m_locationNameList = new Object();
         m_locationNameList[SINGLE_MINI_GAME_ROOM] = "MiniGame";
         m_locationNameList[EN_VILLAGE] = "Bear Hollow";
         m_locationNameList[EN_STONEHENGE] = "Shady Glen";
         m_locationNameList[EN_ICE_CREAM_SHOP] = "Ice Cream Parlor";
         m_locationNameList[EN_FISHING_HOLE] = "Fishing Hole";
         m_locationNameList[EN_FOREST] = "Pawthorne Forest";
         m_locationNameList[EN_ORCHARD] = "The Orchard";
         m_locationNameList[EN_TREEHOUSE] = "The Den";
         m_locationNameList[EN_TREEHOUSE_LOBBY] = "Treehouse Lobby";
         m_locationNameList[EN_TOWN_SQUARE] = "East Market Street";
         m_locationNameList[EN_TOWN_SQUARE2] = "West Market Street";
         m_locationNameList[EN_CLOTHES_STORE] = "Clothing Co.";
         m_locationNameList[EN_LIBRARY] = "Book Nook";
         m_locationNameList[EN_BUNNY_FIELD] = "Darby Field";
         m_locationNameList[EN_PURPLE_DOOR] = "Purple Door";
         m_locationNameList[EN_GRAVEYARD] = "Misty Hill";
         m_locationNameList[EN_PARLOUR] = "The Parlour";
         m_locationNameList[EN_DARK_ROOM] = "Haunted Hallway";
         m_locationNameList[EN_PET_SHOP] = "Pet Shop";
         m_locationNameList[EN_BEACH] = "Coconut Beach";
         m_locationNameList[EN_HARVEST_GROVE] = "Harvest Grove";
         m_locationNameList[EN_BARN] = "Farmer Ned\'s Barn";
         m_locationNameList[PLAYER_TREEHOUSE] = "Treehouse";
         m_locationNameList[OW_TOWN1] = "Old West Town Center";
         m_swfNameList = new Object();
         m_swfNameList[EN_VILLAGE] = "EN_village.swf";
         m_swfNameList[EN_STONEHENGE] = "EN_stonehenge.swf";
         m_swfNameList[EN_ICE_CREAM_SHOP] = "EN_icecream.swf";
         m_swfNameList[EN_FISHING_HOLE] = "EN_fishing_hole.swf";
         m_swfNameList[EN_FOREST] = "EN_forest.swf";
         m_swfNameList[EN_ORCHARD] = "EN_orchard.swf";
         m_swfNameList[EN_TREEHOUSE] = "EN_treehouse.swf";
         m_swfNameList[EN_TREEHOUSE_LOBBY] = "EN_treehouse_lobby.swf";
         m_swfNameList[EN_TOWN_SQUARE] = "EN_townsquare.swf";
         m_swfNameList[EN_TOWN_SQUARE2] = "EN_townsquare2.swf";
         m_swfNameList[EN_CLOTHES_STORE] = "EN_clothes_store.swf";
         m_swfNameList[EN_LIBRARY] = "EN_library.swf";
         m_swfNameList[EN_BUNNY_FIELD] = "EN_bunny_field.swf";
         m_swfNameList[EN_PURPLE_DOOR] = "EN_purpledoor.swf";
         m_swfNameList[EN_GRAVEYARD] = "EN_graveyard.swf";
         m_swfNameList[EN_PARLOUR] = "EN_parlour.swf";
         m_swfNameList[EN_DARK_ROOM] = "EN_darkroom.swf";
         m_swfNameList[EN_PET_SHOP] = "EN_petstore.swf";
         m_swfNameList[EN_BEACH] = "EN_beach.swf";
         m_swfNameList[EN_HARVEST_GROVE] = "EN_harvest_grove.swf";
         m_swfNameList[EN_BARN] = "EN_barn.swf";
         m_swfNameList[PLAYER_TREEHOUSE] = "player_treehouse.swf";
         m_swfNameList[OW_TOWN1] = "OW_town1.swf";
         m_indoorList = new Array();
         m_indoorList.push(EN_ICE_CREAM_SHOP);
         m_indoorList.push(EN_TREEHOUSE);
         m_indoorList.push(EN_CLOTHES_STORE);
         m_indoorList.push(EN_LIBRARY);
         m_indoorList.push(EN_PURPLE_DOOR);
         m_indoorList.push(EN_PET_SHOP);
         m_indoorList.push(EN_PARLOUR);
         m_indoorList.push(EN_DARK_ROOM);
      }
      
      public static function getInstance() : Location
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new Location();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function destroy() : void
      {
         m_locationNameList.length = 0;
         m_locationNameList = null;
         m_swfNameList.length = 0;
         m_swfNameList = null;
      }
      
      public function isIndoorLocation(param1:String) : Boolean
      {
         return m_indoorList.indexOf(param1) != -1;
      }
      
      public function getLocationName(param1:String) : String
      {
         var _loc2_:* = null;
         if(m_locationNameList[param1])
         {
            return m_locationNameList[param1];
         }
         if(param1.indexOf("TH_") != -1)
         {
            _loc2_ = param1.substring(3);
            trace("connecting to .... " + _loc2_ + " treehouse");
            return _loc2_ + " Treehouse";
         }
         return "Location";
      }
      
      public function getSWFName(param1:String) : String
      {
         if(m_swfNameList[param1])
         {
            return m_swfNameList[param1];
         }
         if(param1.indexOf("TH_") == 0)
         {
            return m_swfNameList[PLAYER_TREEHOUSE];
         }
         return new String();
      }
   }
}

