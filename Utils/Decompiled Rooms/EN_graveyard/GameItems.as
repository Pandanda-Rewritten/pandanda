package
{
   import flash.display.*;
   
   public class GameItems
   {
      
      internal static var m_instance:GameItems;
      
      public static const RARITY_TIER_1:int = 0;
      
      public static const RARITY_TIER_2:int = 1;
      
      public static const RARITY_TIER_3:int = 2;
      
      public static const RARITY_TIER_4:int = 3;
      
      public static const RARITY_TIER_5:int = 4;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_clothesCatalog:IClothesCatalog;
      
      internal var m_gameItemsDoc:IGameItemsDoc;
      
      public function GameItems()
      {
         super();
         trace("GameItems Constuctor");
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use GameItems.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : GameItems
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new GameItems();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function getGameItem(param1:String) : IGameItem
      {
         var itemId:String = null;
         var loc1:* = undefined;
         var arg1:String = param1;
         itemId = arg1;
         try
         {
            if(itemId.indexOf("A") == 0)
            {
               return this.m_gameItemsDoc.getAward(itemId) as IGameItem;
            }
            if(itemId.indexOf("BG") == 0)
            {
               return Clothing.getInstance().getPlayerCardBackground(itemId) as IGameItem;
            }
            if(itemId.indexOf("C") == 0)
            {
               return this.m_clothesCatalog.getGameItem(itemId) as IGameItem;
            }
            if(itemId.indexOf("F") == 0)
            {
               return FurnitureItems.getInstance().getFurnitureItem(itemId) as IGameItem;
            }
            if(itemId.indexOf("M") == 0)
            {
               return AvatarModels.getInstance().getMountItem(itemId) as IGameItem;
            }
            return this.m_gameItemsDoc.getBackpackItem(itemId) as IGameItem;
         }
         catch(e:Error)
         {
            trace("ERROR: GameItems.getGameItem " + e.message);
         }
         return null;
      }
      
      public function getItemListFromCategoryList(param1:Array, param2:int = -1) : Array
      {
         if(this.m_gameItemsDoc)
         {
            return this.m_gameItemsDoc.getItemListFromCategoryList(param1,param2);
         }
         return new Array();
      }
      
      public function getBackpackItem(param1:String) : IBackpackItem
      {
         var itemId:String = null;
         var loc1:* = undefined;
         var arg1:String = param1;
         itemId = arg1;
         try
         {
            return this.m_gameItemsDoc.getBackpackItem(itemId) as IBackpackItem;
         }
         catch(e:Error)
         {
            trace("ERROR: GameItems.getBackpackItem " + e.message);
         }
         return null;
      }
      
      public function getColorList(param1:String) : Array
      {
         var list:Array = null;
         var itemId:String = null;
         var loc1:* = undefined;
         var arg1:String = param1;
         list = null;
         itemId = arg1;
         list = new Array();
         try
         {
            if(itemId.indexOf("C") == 0)
            {
               list.push(this.m_clothesCatalog.getItemColor(itemId));
               return list;
            }
            if(itemId.indexOf("F") == 0)
            {
               return FurnitureItems.getInstance().getFurnitureItem(itemId).getColorList();
            }
            if(itemId.indexOf("M") == 0)
            {
               return AvatarModels.getInstance().getAvatarColorArray(itemId);
            }
         }
         catch(e:Error)
         {
            trace("ERROR: GameItems.getPrimaryItemColor " + e.message);
         }
         return new Array(0);
      }
      
      public function getFishList(param1:int, param2:String) : Array
      {
         return this.m_gameItemsDoc.getFishList(param1,param2);
      }
      
      public function getBackpackItemPandaPaint(param1:String) : IGameItemPandaPaint
      {
         var item:String = null;
         var loc1:* = undefined;
         var arg1:String = param1;
         item = arg1;
         try
         {
            return IGameItemPandaPaint(this.m_gameItemsDoc.getBackpackItem(item));
         }
         catch(e:Error)
         {
            trace("ERROR: GameItems.getBackpackItemPandaPaint " + e.message);
         }
         return null;
      }
      
      public function getAward(param1:String) : IGameAward
      {
         return this.m_gameItemsDoc.getAward(param1);
      }
      
      public function getCatalogItemColor(param1:String) : uint
      {
         if(this.m_clothesCatalog)
         {
            return this.m_clothesCatalog.getItemColor(param1);
         }
         return 0;
      }
      
      public function setClothesCatalog(param1:IClothesCatalog) : void
      {
         this.m_clothesCatalog = param1;
      }
      
      public function getFishingContainer() : MovieClip
      {
         return this.m_gameItemsDoc.getFishingCollectionAnimation();
      }
      
      public function getBackpackSellList(param1:Array) : Array
      {
         if(this.m_gameItemsDoc)
         {
            return this.m_gameItemsDoc.getBackpackSellList(param1);
         }
         return new Array();
      }
      
      public function setGameItemsDoc(param1:IGameItemsDoc) : void
      {
         this.m_gameItemsDoc = param1;
      }
   }
}

