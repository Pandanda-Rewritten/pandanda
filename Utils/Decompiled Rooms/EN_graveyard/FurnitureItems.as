package
{
   import flash.display.*;
   
   public class FurnitureItems
   {
      
      internal static var m_instance:FurnitureItems;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_furniturePack1Doc:IFurnitureItemsDoc;
      
      public function FurnitureItems()
      {
         super();
         trace("FurnitureItems Constuctor");
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use FurnitureItems.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : FurnitureItems
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new FurnitureItems();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function getFurnitureItem(param1:String) : IFurnitureItem
      {
         var itemId:String = null;
         var loc1:* = undefined;
         var arg1:String = param1;
         itemId = arg1;
         try
         {
            return this.m_furniturePack1Doc.getFurnitureItem(itemId) as IFurnitureItem;
         }
         catch(e:Error)
         {
            trace("ERROR: FurnitureItems.getFurnitureItem " + e.message);
         }
         return null;
      }
      
      public function setFurnitureItemsDoc(param1:IFurnitureItemsDoc) : void
      {
         this.m_furniturePack1Doc = param1;
      }
      
      public function getBackpackSprite(param1:String) : Sprite
      {
         var itemId:String = null;
         var loc1:* = undefined;
         var arg1:String = param1;
         itemId = arg1;
         try
         {
            return Sprite(this.m_furniturePack1Doc.getBackpackSprite(itemId));
         }
         catch(e:Error)
         {
            trace("ERROR: FurnitureItems.getSprite " + e.message);
         }
         return null;
      }
   }
}

