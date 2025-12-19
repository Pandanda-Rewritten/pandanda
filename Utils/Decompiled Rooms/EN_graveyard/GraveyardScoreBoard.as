package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class GraveyardScoreBoard extends Sprite
   {
      
      internal static const RANKING_ROW_Y_OFFSET:int = 237;
      
      internal static const RANKING_ROW_X_OFFSET:int = 269;
      
      internal static const SCORE_COINS_MULTIPLIER:Number = 2;
      
      internal static const MAX_COINS_PER_GAME:int = 200;
      
      internal static const RANKING_ROW_Y_SPACING:int = 22;
      
      internal static const RANKINGS_PER_PAGE:int = 10;
      
      public var s_close:SimpleButton;
      
      public var s_coins:TextField;
      
      public var s_place:TextField;
      
      public var s_navBar:UINavigationBar;
      
      public var s_points:TextField;
      
      internal var m_rows:Array;
      
      internal var m_pageCount:int;
      
      public var s_loading:MovieClip;
      
      public var s_headingPlace:TextField;
      
      internal var m_currPage:int;
      
      internal var m_yourRank:int;
      
      internal var m_rankings:Array;
      
      public var s_title:TextField;
      
      public var s_headingPoints:TextField;
      
      public var s_name:TextField;
      
      public var s_headingName:TextField;
      
      public var s_portrait:MovieClip;
      
      public function GraveyardScoreBoard()
      {
         var _loc1_:* = null;
         super();
         _loc1_ = new TextFormat("arial",18);
         _loc1_.bold = true;
         this.m_rankings = new Array();
         this.m_rows = new Array();
         this.m_yourRank = -1;
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_title.embedFonts = true;
            this.s_title.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_title.text = "Ghost Game Results";
         this.s_title.setTextFormat(_loc1_);
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_headingName.embedFonts = true;
            this.s_headingName.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_headingName.text = "Panda Name";
         this.s_headingName.setTextFormat(_loc1_);
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_headingPoints.embedFonts = true;
            this.s_headingPoints.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_headingPoints.text = "Total Points";
         this.s_headingPoints.setTextFormat(_loc1_);
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_headingPlace.embedFonts = true;
            this.s_headingPlace.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_headingPlace.text = "Place";
         this.s_headingPlace.setTextFormat(_loc1_);
         _loc1_ = new TextFormat("arial",15);
         _loc1_.bold = true;
         _loc1_ = new TextFormat("arial",16);
         _loc1_.bold = true;
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_name.embedFonts = true;
            this.s_name.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_name.text = PlayerAttributes.getInstance().getName();
         this.s_name.setTextFormat(_loc1_);
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_place.embedFonts = true;
            this.s_place.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_place.text = "calculating...";
         this.s_place.setTextFormat(_loc1_);
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_coins.embedFonts = true;
            this.s_coins.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_coins.text = "0";
         this.s_coins.setTextFormat(_loc1_);
         this.m_currPage = 0;
         addEventListener(CustomEvents.EVENT_NAVIGATION_BAR_LEFT,this.onNavBarLeftListener,false,0,true);
         addEventListener(CustomEvents.EVENT_NAVIGATION_BAR_RIGHT,this.onNavBarRightListener,false,0,true);
         this.s_navBar.visible = false;
         this.s_close.addEventListener(MouseEvent.CLICK,this.onCloseScoreBoardListener,false,0,true);
      }
      
      internal function showRankings() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_rows.length)
         {
            if(contains(this.m_rows[_loc1_]))
            {
               removeChild(this.m_rows[_loc1_]);
            }
            _loc1_++;
         }
         this.m_rows.length = 0;
         _loc2_ = this.m_rankings.length - this.m_currPage * RANKINGS_PER_PAGE;
         if(_loc2_ > RANKINGS_PER_PAGE)
         {
            _loc2_ = RANKINGS_PER_PAGE;
         }
         _loc3_ = this.m_currPage * RANKINGS_PER_PAGE;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_ + _loc1_;
            this.m_rows[_loc1_] = new GraveyardScoreBoardPlacementRow();
            this.m_rows[_loc1_].setScores(this.m_rankings[_loc4_]);
            this.m_rows[_loc1_].x = RANKING_ROW_X_OFFSET;
            this.m_rows[_loc1_].y = RANKING_ROW_Y_OFFSET + _loc1_ * RANKING_ROW_Y_SPACING;
            if(_loc4_ == this.m_yourRank)
            {
               this.m_rows[_loc1_].setHighlight();
            }
            addChild(this.m_rows[_loc1_]);
            _loc1_++;
         }
      }
      
      internal function onNavBarLeftListener(param1:Event) : void
      {
         if(this.m_currPage > 0)
         {
            --this.m_currPage;
            this.showRankings();
         }
         if(this.m_currPage == 0)
         {
            this.s_navBar.setLeftButtonVisible(false);
         }
         if(this.m_pageCount > 1)
         {
            this.s_navBar.setRightButtonVisible(true);
         }
         this.s_navBar.setText("Page " + (this.m_currPage + 1) + " of " + this.m_pageCount);
      }
      
      public function setClientScores(param1:int, param2:IAvatar, param3:int = -1) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = null;
         this.s_loading.visible = true;
         this.m_yourRank = -1;
         if(param2)
         {
            while(this.s_portrait.numChildren > 3)
            {
               this.s_portrait.removeChildAt(3);
            }
            _loc7_ = Sprite(param2.getPaperDoll());
            _loc7_.scaleX = 0.34;
            _loc7_.scaleY = 0.34;
            _loc7_.x = -1;
            _loc7_.y = -5;
            this.s_portrait.addChild(_loc7_);
         }
         _loc4_ = new TextFormat("arial",25);
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_points.embedFonts = true;
            this.s_points.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_points.text = String(param1);
         this.s_points.setTextFormat(_loc4_);
         _loc4_ = new TextFormat("arial",16);
         _loc4_.bold = true;
         if(param3 >= 0)
         {
            _loc5_ = param3;
         }
         else
         {
            _loc5_ = param1 * SCORE_COINS_MULTIPLIER;
            if(_loc5_ > MAX_COINS_PER_GAME)
            {
               _loc5_ = MAX_COINS_PER_GAME;
            }
            if(PlayerAttributes.getInstance().isGameDay())
            {
               _loc5_ *= 2;
            }
         }
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_coins.embedFonts = true;
            this.s_coins.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_coins.text = _loc5_ + " coins earned";
         this.s_coins.setTextFormat(_loc4_);
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_place.embedFonts = true;
            this.s_place.antiAliasType = AntiAliasType.ADVANCED;
         }
         if(param1 == 0)
         {
            this.s_place.text = "";
         }
         this.s_place.text = "calculating...";
         this.s_place.setTextFormat(_loc4_);
         _loc6_ = 0;
         while(_loc6_ < this.m_rows.length)
         {
            if(contains(this.m_rows[_loc6_]))
            {
               removeChild(this.m_rows[_loc6_]);
            }
            _loc6_++;
         }
         this.m_rows.length = 0;
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.cacheAsBitmap = true;
         }
      }
      
      internal function onNavBarRightListener(param1:Event) : void
      {
         if(this.m_currPage < this.m_pageCount - 1)
         {
            ++this.m_currPage;
            this.showRankings();
         }
         if(this.m_currPage >= this.m_pageCount - 1)
         {
            this.s_navBar.setRightButtonVisible(false);
         }
         this.s_navBar.setLeftButtonVisible(true);
         this.s_navBar.setText("Page " + (this.m_currPage + 1) + " of " + this.m_pageCount);
      }
      
      internal function onCloseScoreBoardListener(param1:MouseEvent) : void
      {
         trace("clicked on close button");
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function updateRankings(param1:String) : void
      {
         var _loc5_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         this.s_loading.visible = false;
         this.m_rankings = param1.split(";");
         _loc5_ = this.m_rankings;
         var _loc6_:* = _loc5_.length - 1;
         _loc5_.length = _loc6_;
         this.s_navBar.visible = true;
         this.m_pageCount = Math.ceil(this.m_rankings.length / RANKINGS_PER_PAGE);
         if(this.m_pageCount == 0)
         {
            this.m_pageCount = 1;
         }
         this.m_currPage = 0;
         this.s_navBar.setLeftButtonVisible(false);
         if(this.m_pageCount <= 1)
         {
            this.s_navBar.setRightButtonVisible(false);
         }
         else
         {
            this.s_navBar.setRightButtonVisible(true);
         }
         this.s_navBar.setText("Page " + (this.m_currPage + 1) + " of " + this.m_pageCount);
         _loc3_ = 0;
         while(_loc3_ < this.m_rankings.length)
         {
            _loc2_ = this.m_rankings[_loc3_].split(",");
            if(_loc2_[1] == PlayerAttributes.getInstance().getName())
            {
               _loc4_ = new TextFormat("arial",16);
               _loc4_.bold = true;
               if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
               {
                  this.s_place.embedFonts = true;
                  this.s_place.antiAliasType = AntiAliasType.ADVANCED;
               }
               if(_loc2_[0] != 1)
               {
                  if(_loc2_[0] != 2)
                  {
                     if(_loc2_[0] != 3)
                     {
                        this.s_place.text = _loc2_[0] + "th Place";
                     }
                     else
                     {
                        this.s_place.text = _loc2_[0] + "rd Place!";
                     }
                  }
                  else
                  {
                     this.s_place.text = _loc2_[0] + "nd Place!";
                  }
               }
               else
               {
                  this.s_place.text = _loc2_[0] + "st Place!";
               }
               this.s_place.setTextFormat(_loc4_);
               this.m_yourRank = _loc2_[0] - 1;
               break;
            }
            _loc3_++;
         }
         this.showRankings();
      }
      
      public function destroy() : void
      {
         removeEventListener(CustomEvents.EVENT_NAVIGATION_BAR_LEFT,this.onNavBarLeftListener);
         removeEventListener(CustomEvents.EVENT_NAVIGATION_BAR_RIGHT,this.onNavBarRightListener);
         this.s_close.removeEventListener(MouseEvent.CLICK,this.onCloseScoreBoardListener);
         this.m_rankings.length = 0;
         this.m_rankings = null;
         this.m_rows.length = 0;
         this.m_rows = null;
      }
   }
}

