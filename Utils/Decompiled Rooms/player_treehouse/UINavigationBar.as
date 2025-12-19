package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   public class UINavigationBar extends Sprite
   {
      
      public var s_right:MovieClip;
      
      public var s_left:MovieClip;
      
      public var s_center:Sprite;
      
      public var s_title:TextField;
      
      public function UINavigationBar()
      {
         super();
         s_left.s_leftArrow.addEventListener(MouseEvent.CLICK,mouseClickListener,false,0,true);
         s_right.s_rightArrow.addEventListener(MouseEvent.CLICK,mouseClickListener,false,0,true);
      }
      
      public function setRightButtonVisible(param1:Boolean) : void
      {
         s_right.s_rightArrow.visible = param1;
      }
      
      public function setText(param1:String, param2:Boolean = false, param3:int = 18) : void
      {
         var _loc4_:* = null;
         _loc4_ = new TextFormat("arial",param3);
         _loc4_.bold = true;
         if(param2)
         {
            _loc4_.align = TextFormatAlign.CENTER;
         }
         else
         {
            _loc4_.align = TextFormatAlign.LEFT;
         }
         if(GameOptions.getInstance().getAntiAliasing() != GameOptions.OPTIONS_ANTIALIASING_LOW)
         {
            s_title.embedFonts = true;
         }
         s_title.text = param1;
         s_title.setTextFormat(_loc4_);
      }
      
      internal function mouseClickListener(param1:MouseEvent) : void
      {
         if(param1.currentTarget != s_left.s_leftArrow)
         {
            if(param1.currentTarget == s_right.s_rightArrow)
            {
               dispatchEvent(new Event(CustomEvents.EVENT_NAVIGATION_BAR_RIGHT,true));
            }
         }
         else
         {
            dispatchEvent(new Event(CustomEvents.EVENT_NAVIGATION_BAR_LEFT,true));
         }
      }
      
      public function setLeftButtonVisible(param1:Boolean) : void
      {
         s_left.s_leftArrow.visible = param1;
      }
      
      public function destroy() : void
      {
         s_left.s_leftArrow.removeEventListener(MouseEvent.CLICK,mouseClickListener);
         s_right.s_rightArrow.removeEventListener(MouseEvent.CLICK,mouseClickListener);
      }
   }
}

