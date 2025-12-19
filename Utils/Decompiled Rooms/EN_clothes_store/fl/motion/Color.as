package fl.motion
{
   import flash.display.*;
   import flash.geom.ColorTransform;
   
   public class Color extends ColorTransform
   {
      
      private var _tintMultiplier:Number = 0;
      
      private var _tintColor:Number = 0;
      
      public function Color(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function interpolateColor(param1:uint, param2:uint, param3:Number) : uint
      {
         var _loc4_:Number = NaN;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc12_:* = 0;
         var _loc13_:* = 0;
         var _loc14_:* = 0;
         var _loc15_:* = 0;
         var _loc16_:* = 0;
         var _loc17_:Number = 0;
         _loc4_ = 1 - param3;
         _loc5_ = uint(param1 >> 24 & 0xFF);
         _loc6_ = uint(param1 >> 16 & 0xFF);
         _loc7_ = uint(param1 >> 8 & 0xFF);
         _loc8_ = uint(param1 & 0xFF);
         _loc9_ = uint(param2 >> 24 & 0xFF);
         _loc10_ = uint(param2 >> 16 & 0xFF);
         _loc11_ = uint(param2 >> 8 & 0xFF);
         _loc12_ = uint(param2 & 0xFF);
         _loc13_ = _loc5_ * _loc4_ + _loc9_ * param3;
         _loc14_ = _loc6_ * _loc4_ + _loc10_ * param3;
         _loc15_ = _loc7_ * _loc4_ + _loc11_ * param3;
         _loc16_ = _loc8_ * _loc4_ + _loc12_ * param3;
         return uint(_loc13_ << 24 | _loc14_ << 16 | _loc15_ << 8 | _loc16_);
      }
      
      public static function interpolateTransform(param1:ColorTransform, param2:ColorTransform, param3:Number) : ColorTransform
      {
         var _loc4_:Number = NaN;
         var _loc5_:ColorTransform = null;
         _loc4_ = 1 - param3;
         return new ColorTransform(param1.redMultiplier * _loc4_ + param2.redMultiplier * param3,param1.greenMultiplier * _loc4_ + param2.greenMultiplier * param3,param1.blueMultiplier * _loc4_ + param2.blueMultiplier * param3,param1.alphaMultiplier * _loc4_ + param2.alphaMultiplier * param3,param1.redOffset * _loc4_ + param2.redOffset * param3,param1.greenOffset * _loc4_ + param2.greenOffset * param3,param1.blueOffset * _loc4_ + param2.blueOffset * param3,param1.alphaOffset * _loc4_ + param2.alphaOffset * param3);
      }
      
      public static function fromXML(param1:XML) : Color
      {
         return Color(new Color().parseXML(param1));
      }
      
      public function setTint(param1:uint, param2:Number) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         this._tintColor = param1;
         this._tintMultiplier = param2;
         var _loc6_:* = 1 - param2;
         this.blueMultiplier = 1 - param2;
         this.redMultiplier = this.greenMultiplier = _loc6_;
         _loc3_ = uint(param1 >> 16 & 0xFF);
         _loc4_ = uint(param1 >> 8 & 0xFF);
         _loc5_ = uint(param1 & 0xFF);
         this.redOffset = Math.round(_loc3_ * param2);
         this.greenOffset = Math.round(_loc4_ * param2);
         this.blueOffset = Math.round(_loc5_ * param2);
      }
      
      public function set tintColor(param1:uint) : void
      {
         this.setTint(param1,this.tintMultiplier);
      }
      
      public function get brightness() : Number
      {
         return this.redOffset ? 1 - this.redMultiplier : this.redMultiplier - 1;
      }
      
      private function deriveTintColor() : uint
      {
         var _loc1_:Number = NaN;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:Number = 0;
         _loc1_ = 1 / this.tintMultiplier;
         _loc2_ = Math.round(this.redOffset * _loc1_);
         _loc3_ = Math.round(this.greenOffset * _loc1_);
         _loc4_ = Math.round(this.blueOffset * _loc1_);
         return uint(_loc2_ << 16 | _loc3_ << 8 | _loc4_);
      }
      
      public function get tintMultiplier() : Number
      {
         return this._tintMultiplier;
      }
      
      public function get tintColor() : uint
      {
         return this._tintColor;
      }
      
      public function set brightness(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < -1)
         {
            param1 = -1;
         }
         _loc2_ = 1 - Math.abs(param1);
         _loc3_ = 0;
         if(param1 > 0)
         {
            _loc3_ = param1 * 255;
         }
         this.redMultiplier = this.greenMultiplier = this.blueMultiplier = _loc2_;
         this.redOffset = this.greenOffset = this.blueOffset = _loc3_;
      }
      
      public function set tintMultiplier(param1:Number) : void
      {
         this.setTint(this.tintColor,param1);
      }
      
      private function parseXML(param1:XML = null) : Color
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:* = 0;
         if(!param1)
         {
            return this;
         }
         _loc2_ = param1.elements()[0];
         if(!_loc2_)
         {
            return this;
         }
         for each(_loc3_ in _loc2_.attributes())
         {
            _loc4_ = _loc3_.localName();
            if(_loc4_ == "tintColor")
            {
               _loc5_ = Number(_loc3_.toString()) as uint;
               this.tintColor = _loc5_;
            }
            else
            {
               this[_loc4_] = Number(_loc3_.toString());
            }
         }
         return this;
      }
   }
}

