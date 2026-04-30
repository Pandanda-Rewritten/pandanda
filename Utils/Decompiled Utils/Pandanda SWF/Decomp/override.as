package
{
   import flash.utils.ByteArray;
   
   public class override
   {
      
      private static var § var§:override;
      
      private static const final:String = "d02adaa4cf8fe4859fda09ae936aadbf138001925203340fa89d6c99b546d97e";
      
      private static var §true §:Boolean = false;
      
      public function override()
      {
         super();
         if(!§true §)
         {
            throw new Error("Error: Instantiation failed: Use SWFDecryption.getInstance() instead of new.");
         }
         trace("FileDecryption Constuctor");
      }
      
      public static function § for§() : override
      {
         if(§ var§ == null)
         {
            §true § = true;
            § var§ = new override();
            §true § = false;
         }
         return § var§;
      }
      
      public function § if§(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc2_ = final;
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            param1[_loc4_] ^= _loc2_.charCodeAt(_loc3_);
            _loc3_++;
            if(_loc3_ >= _loc2_.length)
            {
               _loc3_ = 0;
            }
            _loc4_++;
         }
      }
   }
}

