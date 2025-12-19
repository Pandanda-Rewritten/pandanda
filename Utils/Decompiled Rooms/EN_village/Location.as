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
      
      public static const EN_TREEHOUSE_LOBBY:String = "EN_treehouse_lobby";
      
      public static const PLAYER_TREEHOUSE:String = "player_treehouse";
      
      internal static var m_allowInstantiation:Boolean = false;
      
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
         this.m_locationNameList = new Object();
         this.m_locationNameList[SINGLE_MINI_GAME_ROOM] = "MiniGame";
         this.m_locationNameList[EN_VILLAGE] = "Bear Hollow";
         this.m_locationNameList[EN_STONEHENGE] = "Shady Glen";
         this.m_locationNameList[EN_ICE_CREAM_SHOP] = "Ice Cream Parlor";
         this.m_locationNameList[EN_FISHING_HOLE] = "Fishing Hole";
         this.m_locationNameList[EN_FOREST] = "Pawthorne Forest";
         this.m_locationNameList[EN_ORCHARD] = "The Orchard";
         this.m_locationNameList[EN_TREEHOUSE] = "The Den";
         this.m_locationNameList[EN_TREEHOUSE_LOBBY] = "Treehouse Lobby";
         this.m_locationNameList[EN_TOWN_SQUARE] = "East Market Street";
         this.m_locationNameList[EN_TOWN_SQUARE2] = "West Market Street";
         this.m_locationNameList[EN_CLOTHES_STORE] = "Clothing Co.";
         this.m_locationNameList[EN_LIBRARY] = "Book Nook";
         this.m_locationNameList[EN_BUNNY_FIELD] = "Darby Field";
         this.m_locationNameList[EN_PURPLE_DOOR] = "Purple Door";
         this.m_locationNameList[EN_GRAVEYARD] = "Misty Hill";
         this.m_locationNameList[EN_PARLOUR] = "The Parlour";
         this.m_locationNameList[EN_DARK_ROOM] = "Haunted Hallway";
         this.m_locationNameList[EN_PET_SHOP] = "Pet Shop";
         this.m_locationNameList[EN_BEACH] = "Coconut Beach";
         this.m_locationNameList[EN_HARVEST_GROVE] = "Harvest Grove";
         this.m_locationNameList[EN_BARN] = "Farmer Ned\'s Barn";
         this.m_locationNameList[PLAYER_TREEHOUSE] = "Treehouse";
         this.m_locationNameList[OW_TOWN1] = "Old West Town Center";
         this.m_swfNameList = new Object();
         this.m_swfNameList[EN_VILLAGE] = "EN_village.swf";
         this.m_swfNameList[EN_STONEHENGE] = "EN_stonehenge.swf";
         this.m_swfNameList[EN_ICE_CREAM_SHOP] = "EN_icecream.swf";
         this.m_swfNameList[EN_FISHING_HOLE] = "EN_fishing_hole.swf";
         this.m_swfNameList[EN_FOREST] = "EN_forest.swf";
         this.m_swfNameList[EN_ORCHARD] = "EN_orchard.swf";
         this.m_swfNameList[EN_TREEHOUSE] = "EN_treehouse.swf";
         this.m_swfNameList[EN_TREEHOUSE_LOBBY] = "EN_treehouse_lobby.swf";
         this.m_swfNameList[EN_TOWN_SQUARE] = "EN_townsquare.swf";
         this.m_swfNameList[EN_TOWN_SQUARE2] = "EN_townsquare2.swf";
         this.m_swfNameList[EN_CLOTHES_STORE] = "EN_clothes_store.swf";
         this.m_swfNameList[EN_LIBRARY] = "EN_library.swf";
         this.m_swfNameList[EN_BUNNY_FIELD] = "EN_bunny_field.swf";
         this.m_swfNameList[EN_PURPLE_DOOR] = "EN_purpledoor.swf";
         this.m_swfNameList[EN_GRAVEYARD] = "EN_graveyard.swf";
         this.m_swfNameList[EN_PARLOUR] = "EN_parlour.swf";
         this.m_swfNameList[EN_DARK_ROOM] = "EN_darkroom.swf";
         this.m_swfNameList[EN_PET_SHOP] = "EN_petstore.swf";
         this.m_swfNameList[EN_BEACH] = "EN_beach.swf";
         this.m_swfNameList[EN_HARVEST_GROVE] = "EN_harvest_grove.swf";
         this.m_swfNameList[EN_BARN] = "EN_barn.swf";
         this.m_swfNameList[PLAYER_TREEHOUSE] = "player_treehouse.swf";
         this.m_swfNameList[OW_TOWN1] = "OW_town1.swf";
         this.m_indoorList = new Array();
         this.m_indoorList.push(EN_ICE_CREAM_SHOP);
         this.m_indoorList.push(EN_TREEHOUSE);
         this.m_indoorList.push(EN_CLOTHES_STORE);
         this.m_indoorList.push(EN_LIBRARY);
         this.m_indoorList.push(EN_PURPLE_DOOR);
         this.m_indoorList.push(EN_PET_SHOP);
         this.m_indoorList.push(EN_PARLOUR);
         this.m_indoorList.push(EN_DARK_ROOM);
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
         this.m_locationNameList.length = 0;
         this.m_locationNameList = null;
         this.m_swfNameList.length = 0;
         this.m_swfNameList = null;
      }
      
      public function isIndoorLocation(param1:String) : Boolean
      {
         return this.m_indoorList.indexOf(param1) != -1;
      }
      
      public function getLocationName(param1:String) : String
      {
         var _loc2_:* = null;
         if(this.m_locationNameList[param1])
         {
            return this.m_locationNameList[param1];
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
         if(this.m_swfNameList[param1])
         {
            return this.m_swfNameList[param1];
         }
         if(param1.indexOf("TH_") == 0)
         {
            return this.m_swfNameList[PLAYER_TREEHOUSE];
         }
         return new String();
      }
   }
}

