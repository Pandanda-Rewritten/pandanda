package
{
   import flash.net.*;
   
   public class WebSiteValidator
   {
      
      public function WebSiteValidator()
      {
         super();
      }
      
      public static function isValid(param1:String) : *
      {
         if(param1 != null && param1.indexOf("file") == -1)
         {
            navigateToURL(new URLRequest("http://www.pandanda.com"),"_self");
            return false;
         }
         return true;
      }
   }
}

