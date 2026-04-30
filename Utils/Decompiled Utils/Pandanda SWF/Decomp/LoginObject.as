package
{
   public class LoginObject
   {
      
      private var serverName:String;
      
      private var userName:String;
      
      private var port:int;
      
      private var password:String;
      
      private var ip:String;
      
      private var zone:String;
      
      public function LoginObject()
      {
         super();
         this.serverName = new String();
         this.userName = new String();
         this.password = new String();
         this.zone = new String();
         this.ip = new String();
         this.port = 9339;
      }
      
      public function setPort(param1:int) : void
      {
         port = param1;
      }
      
      public function getPassword() : String
      {
         return password;
      }
      
      public function setPassword(param1:String) : void
      {
         password = param1;
      }
      
      public function getZone() : String
      {
         return zone;
      }
      
      public function getServerName() : String
      {
         return serverName;
      }
      
      public function setIp(param1:String) : void
      {
         ip = param1;
      }
      
      public function getUserName() : String
      {
         return userName;
      }
      
      public function setZone(param1:String) : void
      {
         zone = param1;
      }
      
      public function setServerName(param1:String) : void
      {
         serverName = param1;
      }
      
      public function getIp() : String
      {
         return ip;
      }
      
      public function getPort() : int
      {
         return port;
      }
      
      public function setUserName(param1:String) : void
      {
         userName = param1;
      }
   }
}

