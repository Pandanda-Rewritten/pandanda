package
{
   import flash.events.Event;
   
   public class LoginEvent extends Event
   {
      
      public static const EVENT_LOGIN_SUCCESS:String = "EVENT_LOGIN_SUCCESS";
      
      public static const EVENT_LOGIN_CLIENT:String = "EVENT_LOGIN_CLIENT";
      
      public static const EVENT_RETURN_TO_LOGIN:String = "EVENT_RETURN_TO_LOGIN";
      
      public static const EVENT_GO_TO_REGISTRATION:String = "EVENT_GO_TO_REGISTRATION";
      
      public static const EVENT_SHOW_LOGIN_FRESH:String = "EVENT_SHOW_LOGIN_FRESH";
      
      public static const EVENT_SHOW_LOGIN:String = "EVENT_SHOW_LOGIN";
      
      public static const EVENT_SHOW_LOGIN_EXISTING:String = "EVENT_SHOW_LOGIN_EXISTING";
      
      public static const EVENT_SHOW_SERVERS:String = "EVENT_SHOW_SERVERS";
      
      public static const EVENT_SERVER_SELECTED:String = "EVENT_SERVER_SELECTED";
      
      public static const EVENT_SHOW_CHARACTER_SELECT:String = "EVENT_SHOW_CHARACTER_SELECT";
      
      public static const EVENT_CLEAR_POPUP:String = "EVENT_CLEAR_POPUP";
      
      public static const EVENT_FORGET_PANDA:String = "EVENT_FORGET_PANDA";
      
      public static const EVENT_SHOW_CREATE_ACCOUNT:String = "EVENT_SHOW_CREATE_ACCOUNT";
      
      public static const EVENT_SHOW_REGISTRATION_COMPLETE:String = "EVENT_SHOW_REGISTRATION_COMPLETE";
      
      public static const EVENT_REGISTRATION_AVATAR_COLOR:String = "EVENT_REGISTRATION_AVATAR_COLOR";
      
      public static const EVENT_SHOW_FORGOT_PASSWORD:String = "EVENT_SHOW_FORGOT_PASSWORD";
      
      public static const EVENT_SHOW_CHANGE_PASSWORD:String = "EVENT_SHOW_CHANGE_PASSWORD";
      
      public static const LOGIN_EVENT_SHOW_CHANGE_NAME:String = "LOGIN_EVENT_SHOW_CHANGE_NAME";
      
      public static const EVENT_SEND_SFS_MESSAGE:String = "EVENT_SEND_SFS_MESSAGE";
      
      public static const LOGIN_EVENT_PANDA_SELECTED:String = "LOGIN_EVENT_PANDA_SELECTED";
      
      public static const LOGIN_EVENT_RESEND_EMAIL:String = "LOGIN_EVENT_RESEND_EMAIL";
      
      public var params:Object;
      
      public function LoginEvent(param1:String, param2:Object)
      {
         super(param1,true);
         this.params = param2;
      }
      
      override public function toString() : String
      {
         return formatToString("LoginEvent","type","bubbles","cancelable","eventPhase","params");
      }
      
      override public function clone() : Event
      {
         return new LoginEvent(this.type,this.params);
      }
   }
}

