package
{
   public class Clothing
   {
      
      internal static var m_instance:Clothing;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_paperDoll:IPaperDollClothes;
      
      internal var m_avatarClothes1:IAvatarClothes;
      
      internal var m_avatarClothes2:IAvatarClothes;
      
      public function Clothing()
      {
         super();
         trace("Clothing Constuctor");
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use Clothing.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : Clothing
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new Clothing();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function setAvatarClothes1(param1:IAvatarClothes) : void
      {
         this.m_avatarClothes1 = param1;
      }
      
      public function getPaperDollClothing(param1:String) : Array
      {
         param1 = this.removeItemColor(param1);
         if(this.m_paperDoll)
         {
            return this.m_paperDoll.getClothesList(param1);
         }
         return new Array();
      }
      
      public function setAvatarClothes2(param1:IAvatarClothes) : void
      {
         this.m_avatarClothes2 = param1;
      }
      
      public function getPlayerCardBackground(param1:String) : IGameItem
      {
         if(this.m_paperDoll)
         {
            return this.m_paperDoll.getPlayerCardBackground(param1);
         }
         return null;
      }
      
      internal function removeItemColor(param1:String) : String
      {
         if(param1.charAt(param1.length - 1) >= "a")
         {
            return param1.substr(0,param1.length - 1);
         }
         return param1;
      }
      
      public function getAvatarClothingItemList(param1:Array) : Array
      {
         var c:int = 0;
         var clothes:Array = null;
         var i:int = 0;
         var color:uint = 0;
         var itemList:Array = null;
         var piecesArray:Array = null;
         var obj:IAvatarClothesItem = null;
         var loc1:* = undefined;
         var arg1:Array = param1;
         piecesArray = null;
         obj = null;
         itemList = null;
         c = 0;
         i = 0;
         color = 0;
         clothes = arg1;
         piecesArray = new Array();
         itemList = new Array();
         c = 0;
         while(c < clothes.length)
         {
            try
            {
               color = GameItems.getInstance().getCatalogItemColor(clothes[c]);
               piecesArray = this.getClothing(clothes[c]);
            }
            catch(e:Error)
            {
               trace("ERROR: getAvatarClothingItemList " + e.message);
            }
            i = 0;
            while(i < piecesArray.length)
            {
               try
               {
                  obj = new piecesArray[i]();
                  if(color != 0)
                  {
                     obj.setColor(color);
                  }
                  itemList.push(obj);
               }
               catch(e:Error)
               {
                  trace("ERROR: getAvatarClothingItemList " + e.message);
               }
               i++;
            }
            c++;
         }
         return itemList;
      }
      
      public function getClothesCatalogItem(param1:String) : IClothesCatalogItem
      {
         return GameItems.getInstance().getGameItem(param1) as IClothesCatalogItem;
      }
      
      public function getClothingPositions(param1:String) : Array
      {
         var _loc2_:* = null;
         param1 = this.removeItemColor(param1);
         if(this.m_avatarClothes1)
         {
            _loc2_ = this.m_avatarClothes1.getClothingPositions(param1);
         }
         if(this.m_avatarClothes2)
         {
            _loc2_ = _loc2_.concat(this.m_avatarClothes2.getClothingPositions(param1));
         }
         return _loc2_;
      }
      
      public function setPaperDoll(param1:IPaperDollClothes) : void
      {
         this.m_paperDoll = param1;
      }
      
      public function getClothing(param1:String) : Array
      {
         var _loc2_:* = null;
         param1 = this.removeItemColor(param1);
         if(this.m_avatarClothes1)
         {
            _loc2_ = this.m_avatarClothes1.getClothesList(param1);
         }
         if(this.m_avatarClothes2)
         {
            _loc2_ = _loc2_.concat(this.m_avatarClothes2.getClothesList(param1));
         }
         return _loc2_;
      }
   }
}

