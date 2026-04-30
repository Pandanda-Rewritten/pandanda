package
{
   import flash.utils.ByteArray;
   
   public class Base64
   {
      
      private static var lineBreak:Boolean;
      
      private static var _b64Chars:Array = new Array("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/");
      
      private static var lookupObject:Object = buildLookUpObject();
      
      public function Base64()
      {
         super();
      }
      
      public static function encode64String(param1:String) : String
      {
         var _loc2_:ByteArray = null;
         _loc2_ = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return _encodeBytes(_loc2_);
      }
      
      private static function _decodeStringPacket(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         _loc2_ = new ByteArray();
         _loc3_ = uint(Base64.lookupObject[param1.charAt(0)]);
         _loc4_ = uint(Base64.lookupObject[param1.charAt(1)]);
         _loc5_ = uint(Base64.lookupObject[param1.charAt(2)]);
         _loc6_ = uint(Base64.lookupObject[param1.charAt(3)]);
         _loc2_.writeByte(_loc3_ << 2 | _loc4_ >> 4);
         if(param1.charAt(2) != "=")
         {
            _loc2_.writeByte(_loc4_ << 4 | _loc5_ >> 2);
         }
         if(param1.charAt(3) != "=")
         {
            _loc2_.writeByte(_loc5_ << 6 | _loc6_);
         }
         return _loc2_;
      }
      
      private static function buildLookUpObject() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         _loc1_ = new Object();
         _loc2_ = 0;
         while(_loc2_ < _b64Chars.length)
         {
            _loc1_[_b64Chars[_loc2_]] = _loc2_;
            _loc2_++;
         }
         return _loc1_;
      }
      
      private static function _encodeBytePacket(param1:ByteArray) : String
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         _loc2_ = "";
         _loc3_ = param1.length;
         _loc2_ += _b64Chars[param1[0] >> 2];
         if(_loc3_ == 1)
         {
            _loc2_ += _b64Chars[param1[0] << 4 & 0x3F];
            _loc2_ += "==";
         }
         else if(_loc3_ == 2)
         {
            _loc2_ += _b64Chars[param1[0] << 4 & 0x3F | param1[1] >> 4];
            _loc2_ += _b64Chars[param1[1] << 2 & 0x3F];
            _loc2_ += "=";
         }
         else
         {
            _loc2_ += _b64Chars[param1[0] << 4 & 0x3F | param1[1] >> 4];
            _loc2_ += _b64Chars[param1[1] << 2 & 0x3F | param1[2] >> 6];
            _loc2_ += _b64Chars[param1[2] & 0x3F];
         }
         return _loc2_;
      }
      
      public static function decode64(param1:String) : ByteArray
      {
         return _decodeString(param1);
      }
      
      public static function encode64(param1:ByteArray, param2:Boolean) : String
      {
         lineBreak = param2;
         return _encodeBytes(param1);
      }
      
      private static function _encodeBytes(param1:ByteArray) : String
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         _loc2_ = "";
         param1.position = 0;
         _loc4_ = 0;
         while(true)
         {
            _loc3_ = int(param1.bytesAvailable);
            if(!_loc3_)
            {
               break;
            }
            _loc3_ = Math.min(3,_loc3_);
            _loc5_ = new ByteArray();
            param1.readBytes(_loc5_,0,_loc3_);
            _loc2_ += _encodeBytePacket(_loc5_);
            _loc4_ += 4;
            if(lineBreak && _loc4_ % 76 == 0)
            {
               _loc2_ += "\n";
               _loc4_ = 0;
            }
         }
         return _loc2_;
      }
      
      private static function _decodeString(param1:String) : ByteArray
      {
         var _loc2_:String = null;
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = param1;
         _loc3_ = new ByteArray();
         _loc4_ = "";
         _loc5_ = _loc2_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ += _loc2_.charAt(_loc6_);
            if(_loc4_.length == 4)
            {
               _loc3_.writeBytes(_decodeStringPacket(_loc4_));
               _loc4_ = "";
            }
            _loc6_++;
         }
         return _loc3_;
      }
   }
}

