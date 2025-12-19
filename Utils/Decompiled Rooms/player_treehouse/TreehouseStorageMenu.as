package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TreehouseStorageMenu extends MovieClip
   {
      
      internal var m_backpack:TreehouseStorageBackpack;
      
      public var s_category3:MovieClip;
      
      public var s_category1:MovieClip;
      
      public var s_category4:MovieClip;
      
      public var s_category5:MovieClip;
      
      internal var m_iconList:Array;
      
      public var s_category2:MovieClip;
      
      internal var m_activeIcon:int;
      
      public var s_lid:MovieClip;
      
      public var s_boxInside:MovieClip;
      
      public var s_box:MovieClip;
      
      public function TreehouseStorageMenu()
      {
         var _loc1_:* = 0;
         super();
         m_iconList = new Array();
         m_iconList.push(s_category1);
         m_iconList.push(s_category2);
         m_iconList.push(s_category3);
         m_iconList.push(s_category4);
         m_iconList.push(s_category5);
         m_activeIcon = -1;
         m_backpack = new TreehouseStorageBackpack();
         m_backpack.x = -549;
         m_backpack.y = -380;
         s_box.mouseEnabled = false;
         s_lid.addEventListener(MouseEvent.CLICK,onMouseClickListener,false,0,true);
         s_boxInside.addEventListener(MouseEvent.CLICK,onMouseClickListener,false,0,true);
         _loc1_ = 0;
         while(_loc1_ < m_iconList.length)
         {
            m_iconList[_loc1_].addEventListener(MouseEvent.ROLL_OVER,onIconMouseOverListener,false,0,true);
            m_iconList[_loc1_].addEventListener(MouseEvent.ROLL_OUT,onIconMouseOutListener,false,0,true);
            m_iconList[_loc1_].addEventListener(MouseEvent.CLICK,onIconClickListener,false,0,true);
            _loc1_++;
         }
         addEventListener(PlayerTreehouseScene.TREEHOUSE_EVENT_CLOSE_BACKPACK,onCloseBackpack,false,0,true);
      }
      
      public function destroy() : void
      {
         var _loc1_:* = 0;
         s_lid.removeEventListener(MouseEvent.CLICK,onMouseClickListener);
         s_boxInside.removeEventListener(MouseEvent.CLICK,onMouseClickListener);
         _loc1_ = 0;
         while(_loc1_ < m_iconList.length)
         {
            m_iconList[_loc1_].removeEventListener(MouseEvent.ROLL_OVER,onIconMouseOverListener);
            m_iconList[_loc1_].removeEventListener(MouseEvent.ROLL_OUT,onIconMouseOutListener);
            m_iconList[_loc1_].removeEventListener(MouseEvent.CLICK,onIconClickListener);
            _loc1_++;
         }
         removeEventListener(PlayerTreehouseScene.TREEHOUSE_EVENT_CLOSE_BACKPACK,onCloseBackpack);
         removeEventListener(Event.ENTER_FRAME,onEnterFrameListener);
         m_backpack.destroy();
      }
      
      internal function onIconClickListener(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         _loc2_ = 0;
         while(_loc2_ < m_iconList.length)
         {
            m_iconList[_loc2_].gotoAndStop("off");
            _loc2_++;
         }
         param1.currentTarget.gotoAndStop("down");
         m_activeIcon = m_iconList.indexOf(param1.currentTarget);
         var _loc7_:* = m_activeIcon;
         switch(_loc7_)
         {
            case 0:
               _loc3_ = FurnitureCategory.FURNITURE_MAJOR;
               break;
            case 1:
               _loc3_ = FurnitureCategory.FURNITURE_LIGHTING;
               break;
            case 2:
               _loc3_ = FurnitureCategory.FURNITURE_CARPET;
               break;
            case 3:
               _loc3_ = FurnitureCategory.FURNITURE_PICTURES;
               break;
            case 4:
               _loc3_ = FurnitureCategory.FURNITURE_STRUCTURE;
         }
         _loc4_ = PlayerAttributes.getInstance().getFurnitureStorageList();
         _loc5_ = new Array();
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            _loc6_ = FurnitureItems.getInstance().getFurnitureItem(_loc4_[_loc2_]);
            if((_loc6_) && _loc6_.getCategory() == _loc3_)
            {
               _loc5_.push(_loc4_[_loc2_]);
            }
            _loc2_++;
         }
         m_backpack.fillBackpack(_loc5_);
         addChildAt(m_backpack,0);
      }
      
      public function closeStorage() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < m_iconList.length)
         {
            m_iconList[_loc1_].gotoAndStop("off");
            _loc1_++;
         }
         if(contains(m_backpack))
         {
            removeChild(m_backpack);
         }
         gotoAndPlay("close");
         addEventListener(Event.ENTER_FRAME,onEnterFrameListener,false,0,true);
      }
      
      internal function onIconMouseOutListener(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         _loc2_ = m_iconList.indexOf(param1.currentTarget);
         if(_loc2_ != m_activeIcon)
         {
            param1.currentTarget.gotoAndStop("off");
         }
      }
      
      internal function onEnterFrameListener(param1:Event) : void
      {
         if(this.currentFrame == this.totalFrames)
         {
            dispatchEvent(new Event(PlayerTreehouseScene.TREEHOUSE_EVENT_CLOSE_STORAGE,true));
            removeEventListener(Event.ENTER_FRAME,onEnterFrameListener);
         }
      }
      
      public function openStorage() : void
      {
         gotoAndPlay(2);
      }
      
      internal function onIconMouseOverListener(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         _loc2_ = m_iconList.indexOf(param1.currentTarget);
         if(_loc2_ != m_activeIcon)
         {
            param1.currentTarget.gotoAndStop("over");
         }
      }
      
      internal function onCloseBackpack(param1:Event) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < m_iconList.length)
         {
            m_iconList[_loc2_].gotoAndStop("off");
            _loc2_++;
         }
         if(contains(m_backpack))
         {
            removeChild(m_backpack);
         }
         m_activeIcon = -1;
      }
      
      internal function onMouseClickListener(param1:MouseEvent) : void
      {
         if(param1.currentTarget == s_boxInside || param1.currentTarget == s_lid)
         {
            closeStorage();
         }
      }
   }
}

