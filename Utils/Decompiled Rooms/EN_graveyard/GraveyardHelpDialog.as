package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class GraveyardHelpDialog extends Sprite
   {
      
      public var s_close:SimpleButton;
      
      public var s_title:TextField;
      
      public var s_heading1:TextField;
      
      public var s_heading3:TextField;
      
      public var s_heading2:TextField;
      
      public var s_body:TextField;
      
      public function GraveyardHelpDialog()
      {
         var _loc1_:* = null;
         super();
         _loc1_ = new TextFormat("arial",18);
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            this.s_title.embedFonts = true;
            this.s_title.antiAliasType = AntiAliasType.ADVANCED;
            this.s_body.embedFonts = true;
            this.s_body.antiAliasType = AntiAliasType.ADVANCED;
            this.s_heading1.embedFonts = true;
            this.s_heading1.antiAliasType = AntiAliasType.ADVANCED;
            this.s_heading2.embedFonts = true;
            this.s_heading2.antiAliasType = AntiAliasType.ADVANCED;
            this.s_heading3.embedFonts = true;
            this.s_heading3.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.s_title.text = "Rid Misty Hill of ghosts and earn coins at the same time!";
         this.s_title.setTextFormat(_loc1_);
         _loc1_ = new TextFormat("arial",14);
         this.s_body.text = "You’ll automatically  be fitted with a ghost catching backpack when the ghosts begin to sweep through Misty Hill. ";
         this.s_body.appendText("Suck them up by clicking on them. When you are close enough to a ghost to suck it up it will glow green.\n\n");
         this.s_body.appendText("Chilly blue ghosts will freeze you in your tracks if they touch you, so watch out! While you are frozen you won’t ");
         this.s_body.appendText("be able to catch any ghosts so be sure to avoid them.\n\n");
         this.s_body.appendText("Good luck,...and don’t be too scared!");
         this.s_body.setTextFormat(_loc1_);
         _loc1_ = new TextFormat("arial",12);
         this.s_heading1.text = "Catch these for coins!";
         this.s_heading1.setTextFormat(_loc1_);
         this.s_heading2.text = "Avoid these chilly ghosts or you’ll be temporarily frozen!";
         this.s_heading2.setTextFormat(_loc1_);
         this.s_heading3.text = "See how many ghosts you’ve caught (displayed in upper left)";
         this.s_heading3.setTextFormat(_loc1_);
         this.s_close.addEventListener(MouseEvent.CLICK,this.onMouseClickListener,false,0,true);
      }
      
      public function destroy() : void
      {
         this.s_close.removeEventListener(MouseEvent.CLICK,this.onMouseClickListener);
      }
      
      internal function onMouseClickListener(param1:MouseEvent) : void
      {
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

