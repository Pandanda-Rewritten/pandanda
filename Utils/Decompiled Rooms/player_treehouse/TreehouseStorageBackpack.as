package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TreehouseStorageBackpack extends Sprite
   {
      
      internal static const ITEM_Y_OFFSET:int = 44;
      
      internal static const ITEM_X_OFFSET:int = 9;
      
      internal static const ITEM_BOX_WIDTH:int = 125;
      
      internal static const ITEM_BOX_HEIGHT:int = 84;
      
      internal static const ITEMS_PER_PAGE:int = 12;
      
      internal static const ITEM_Y_SPACING:int = 89;
      
      internal static const ITEM_COLUMN_COUNT:int = 4;
      
      internal static const ITEM_X_SPACING:int = 130;
      
      internal static const ITEM_ROW_COUNT:int = 3;
      
      internal var m_spriteList:Array;
      
      public var s_close:MovieClip;
      
      public var s_navBar:UINavigationBar;
      
      internal var m_boxes:Array;
      
      internal var m_spriteContainer:Sprite;
      
      internal var m_pageCount:int;
      
      internal var m_itemIdList:Array;
      
      internal var m_currPage:int;
      
      public function TreehouseStorageBackpack()
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         super();
         m_spriteList = new Array();
         m_spriteContainer = new Sprite();
         m_spriteContainer.x = 9;
         m_spriteContainer.y = 44;
         addChild(m_spriteContainer);
         m_currPage = 0;
         m_pageCount = 0;
         m_spriteContainer.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener,false,0,true);
         m_spriteContainer.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener,false,0,true);
         m_spriteContainer.addEventListener(MouseEvent.CLICK,onClickListener,false,0,true);
         m_boxes = new Array();
         _loc1_ = 0;
         while(_loc1_ < ITEMS_PER_PAGE)
         {
            m_boxes[_loc1_] = new TreehouseBackpackBox(ITEM_X_SPACING * (_loc1_ % ITEM_COLUMN_COUNT),ITEM_Y_SPACING * Math.floor(_loc1_ / ITEM_COLUMN_COUNT));
            m_spriteContainer.addChild(m_boxes[_loc1_]);
            _loc1_++;
         }
         _loc2_ = new TextFormat("arial",20);
         _loc2_.align = TextFormatAlign.CENTER;
         s_close.s_text.s_text.text = "Close";
         s_close.s_text.s_text.embedFonts = true;
         s_close.s_text.s_text.antiAliasType = AntiAliasType.ADVANCED;
         s_close.s_text.s_text.setTextFormat(_loc2_);
         s_close.gotoAndStop("off");
         s_close.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener,false,0,true);
         s_close.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener,false,0,true);
         s_close.addEventListener(MouseEvent.CLICK,onClickListener,false,0,true);
         addEventListener(CustomEvents.EVENT_NAVIGATION_BAR_LEFT,onNavBarLeftListener,false,0,true);
         addEventListener(CustomEvents.EVENT_NAVIGATION_BAR_RIGHT,onNavBarRightListener,false,0,true);
      }
      
      internal function resetIcons() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = NaN;
         var _loc6_:* = null;
         var _loc7_:* = null;
         clearBackpack();
         trace("curr page " + m_currPage);
         _loc1_ = m_currPage * ITEMS_PER_PAGE;
         trace("listStart " + _loc1_);
         _loc3_ = _loc1_;
         while(_loc3_ < m_spriteList.length)
         {
            _loc2_ = _loc3_ - _loc1_;
            if(_loc2_ >= m_boxes.length)
            {
               break;
            }
            if(m_spriteList[_loc3_])
            {
               _loc4_ = m_spriteList[_loc3_];
               if(_loc4_)
               {
                  if(_loc4_.width < _loc4_.height * 1.48)
                  {
                     _loc5_ = (ITEM_BOX_HEIGHT - 10) / _loc4_.height;
                  }
                  else
                  {
                     _loc5_ = (ITEM_BOX_WIDTH - 10) / _loc4_.width;
                  }
                  _loc4_.height *= _loc5_;
                  _loc4_.width *= _loc5_;
                  _loc4_.x = (ITEM_BOX_WIDTH - _loc4_.width) / 2;
                  _loc4_.y = (ITEM_BOX_HEIGHT - _loc4_.height) / 2;
                  m_boxes[_loc2_].gotoAndStop("on");
                  if(PlayerAttributes.getInstance().isMemberOnly(m_itemIdList[_loc3_]))
                  {
                     _loc6_ = new HueColorMatrixFilter();
                     _loc6_.setSaturation(0.4);
                     _loc4_.filters = new Array(_loc6_.getFilter());
                  }
                  m_boxes[_loc2_].addChild(_loc4_);
                  if(PlayerAttributes.getInstance().isMemberOnly(m_itemIdList[_loc3_]))
                  {
                     _loc7_ = new Sprite();
                     _loc7_ = new Sprite();
                     _loc7_.graphics.beginFill(0);
                     _loc7_.graphics.drawRect(0,0,ITEM_BOX_WIDTH,ITEM_BOX_HEIGHT);
                     _loc7_.graphics.endFill();
                     _loc7_.alpha = 0.4;
                     _loc7_.cacheAsBitmap = true;
                     mask = new TreehouseBackpackBoxMask();
                     mask.x = 1 + m_boxes[_loc2_].x;
                     mask.y = 1 + m_boxes[_loc2_].y;
                     m_spriteContainer.addChild(mask);
                     _loc7_.mask = mask;
                     m_boxes[_loc2_].addChild(_loc7_);
                  }
               }
            }
            _loc3_++;
         }
      }
      
      public function fillBackpack(param1:Array) : void
      {
         var _loc2_:* = 0;
         m_itemIdList = param1;
         m_spriteList.length = 0;
         clearBackpack();
         _loc2_ = 0;
         while(_loc2_ < m_itemIdList.length)
         {
            m_spriteList[_loc2_] = FurnitureItems.getInstance().getBackpackSprite(m_itemIdList[_loc2_]);
            _loc2_++;
         }
         m_pageCount = Math.ceil(m_itemIdList.length / ITEMS_PER_PAGE);
         if(m_pageCount == 0)
         {
            m_pageCount = 1;
         }
         m_currPage = 0;
         s_navBar.setLeftButtonVisible(false);
         if(m_pageCount <= 1)
         {
            s_navBar.setRightButtonVisible(false);
         }
         else
         {
            s_navBar.setRightButtonVisible(true);
         }
         s_navBar.setText("Page " + (m_currPage + 1) + " of " + m_pageCount);
         resetIcons();
      }
      
      internal function onMouseOutListener(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(param1.currentTarget == s_close)
         {
            s_close.gotoAndStop("off");
         }
         if(param1.target is TreehouseBackpackBox)
         {
            _loc2_ = m_boxes.indexOf(param1.target);
            _loc3_ = _loc2_ + m_currPage * ITEMS_PER_PAGE;
            if(_loc3_ < m_spriteList.length)
            {
               if(!PlayerAttributes.getInstance().isMemberOnly(m_itemIdList[_loc3_]))
               {
                  m_boxes[_loc2_].gotoAndStop("on");
                  if(m_spriteList[_loc3_])
                  {
                     m_boxes[_loc2_].addChild(m_spriteList[_loc3_]);
                  }
               }
            }
         }
      }
      
      internal function onNavBarLeftListener(param1:Event) : void
      {
         if(m_currPage > 0)
         {
            --m_currPage;
            resetIcons();
         }
         if(m_currPage == 0)
         {
            s_navBar.setLeftButtonVisible(false);
         }
         if(m_pageCount > 1)
         {
            s_navBar.setRightButtonVisible(true);
         }
         s_navBar.setText("Page " + (m_currPage + 1) + " of " + m_pageCount);
      }
      
      internal function onNavBarRightListener(param1:Event) : void
      {
         if(m_currPage < m_pageCount - 1)
         {
            ++m_currPage;
            resetIcons();
         }
         if(m_currPage >= m_pageCount - 1)
         {
            s_navBar.setRightButtonVisible(false);
         }
         s_navBar.setLeftButtonVisible(true);
         s_navBar.setText("Page " + (m_currPage + 1) + " of " + m_pageCount);
      }
      
      internal function onClickListener(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(param1.currentTarget == s_close)
         {
            dispatchEvent(new Event(PlayerTreehouseScene.TREEHOUSE_EVENT_CLOSE_BACKPACK,true));
         }
         if(param1.target is TreehouseBackpackBox)
         {
            _loc2_ = m_boxes.indexOf(param1.target);
            _loc3_ = _loc2_ + m_currPage * ITEMS_PER_PAGE;
            if(_loc3_ < m_itemIdList.length)
            {
               if(PlayerAttributes.getInstance().isMemberOnly(m_itemIdList[_loc3_]))
               {
                  _loc5_ = new Object();
                  _loc5_.type = GameConstants.PLACE_FURNITURE;
                  dispatchEvent(new GameEvent(GameEvent.GAME_EVENT_SHOW_MEMBER_ONLY_DIALOG,_loc5_));
               }
               else
               {
                  _loc4_ = new Object();
                  _loc4_.itemId = m_itemIdList[_loc3_];
                  dispatchEvent(new GameEvent(PlayerTreehouseScene.TREEHOUSE_EVENT_ADD_FURNITURE_TO_ROOM,_loc4_));
               }
            }
         }
      }
      
      internal function onMouseOverListener(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(param1.currentTarget == s_close)
         {
            s_close.gotoAndStop("over");
         }
         if(param1.target is TreehouseBackpackBox)
         {
            _loc2_ = m_boxes.indexOf(param1.target);
            _loc3_ = _loc2_ + m_currPage * ITEMS_PER_PAGE;
            if(_loc3_ < m_spriteList.length)
            {
               if(!PlayerAttributes.getInstance().isMemberOnly(m_itemIdList[_loc3_]))
               {
                  m_boxes[_loc2_].gotoAndStop("over");
                  if(m_spriteList[_loc3_])
                  {
                     m_boxes[_loc2_].addChild(m_spriteList[_loc3_]);
                  }
               }
            }
         }
      }
      
      internal function clearBackpack() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < m_boxes.length)
         {
            while(m_boxes[_loc1_].numChildren > 1)
            {
               m_boxes[_loc1_].removeChildAt(1);
            }
            m_boxes[_loc1_].gotoAndStop("empty");
            _loc1_++;
         }
         _loc2_ = m_spriteContainer.numChildren - 1;
         while(_loc2_ > 0)
         {
            if(m_spriteContainer.getChildAt(_loc2_) is TreehouseBackpackBoxMask)
            {
               m_spriteContainer.removeChildAt(_loc2_);
            }
            _loc2_--;
         }
      }
      
      public function destroy() : void
      {
         clearBackpack();
         m_spriteContainer.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener);
         m_spriteContainer.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener);
         m_spriteContainer.removeEventListener(MouseEvent.CLICK,onClickListener);
         s_close.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverListener);
         s_close.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutListener);
         s_close.removeEventListener(MouseEvent.CLICK,onClickListener);
         removeEventListener(CustomEvents.EVENT_NAVIGATION_BAR_LEFT,onNavBarLeftListener);
         removeEventListener(CustomEvents.EVENT_NAVIGATION_BAR_RIGHT,onNavBarRightListener);
      }
   }
}

