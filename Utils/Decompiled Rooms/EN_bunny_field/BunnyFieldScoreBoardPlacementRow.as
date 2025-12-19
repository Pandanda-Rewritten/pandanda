package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class BunnyFieldScoreBoardPlacementRow extends Sprite
   {
      
      internal static const RANKING_INFO_LENGTH:int = 6;
      
      public var s_points:TextField;
      
      public var s_place:TextField;
      
      public var s_bunny1:TextField;
      
      public var s_bunny3:TextField;
      
      public var s_bunny2:TextField;
      
      public var s_name:TextField;
      
      public var s_highlight:MovieClip;
      
      public function BunnyFieldScoreBoardPlacementRow()
      {
         super();
         this.s_highlight.visible = false;
      }
      
      public function setScores(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         _loc2_ = param1.split(",");
         _loc3_ = new TextFormat("arial",16);
         this.s_place.embedFonts = true;
         this.s_place.antiAliasType = AntiAliasType.ADVANCED;
         this.s_place.text = _loc2_[0];
         this.s_place.setTextFormat(_loc3_);
         this.s_name.embedFonts = true;
         this.s_name.antiAliasType = AntiAliasType.ADVANCED;
         this.s_name.text = _loc2_[1];
         this.s_name.setTextFormat(_loc3_);
         this.s_bunny1.embedFonts = true;
         this.s_bunny1.antiAliasType = AntiAliasType.ADVANCED;
         this.s_bunny1.text = _loc2_[2];
         this.s_bunny1.setTextFormat(_loc3_);
         this.s_bunny2.embedFonts = true;
         this.s_bunny2.antiAliasType = AntiAliasType.ADVANCED;
         this.s_bunny2.text = _loc2_[3];
         this.s_bunny2.setTextFormat(_loc3_);
         this.s_bunny3.embedFonts = true;
         this.s_bunny3.antiAliasType = AntiAliasType.ADVANCED;
         this.s_bunny3.text = _loc2_[4];
         this.s_bunny3.setTextFormat(_loc3_);
         this.s_points.embedFonts = true;
         this.s_points.antiAliasType = AntiAliasType.ADVANCED;
         this.s_points.text = _loc2_[5];
         this.s_points.setTextFormat(_loc3_);
      }
      
      public function setHighlight() : void
      {
         var _loc1_:* = null;
         _loc1_ = new TextFormat("arial",16);
         if(this.s_highlight.s_you)
         {
            this.s_highlight.s_you.embedFonts = true;
            this.s_highlight.s_you.antiAliasType = AntiAliasType.ADVANCED;
            this.s_highlight.s_you.text = "You";
            this.s_highlight.s_you.setTextFormat(_loc1_);
         }
         this.s_highlight.visible = true;
      }
      
      public function destroy() : void
      {
      }
   }
}

