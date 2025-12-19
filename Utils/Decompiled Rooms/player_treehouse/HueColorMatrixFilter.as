package
{
   import flash.filters.*;
   
   public class HueColorMatrixFilter
   {
      
      internal var _h:Number = 0;
      
      internal var m_matrix:Array;
      
      public function HueColorMatrixFilter()
      {
         _h = 0;
         super();
         m_matrix = new Array();
         Identity();
      }
      
      public function getHue() : Number
      {
         return _h;
      }
      
      internal function multiply(param1:Number, param2:Array) : Array
      {
         var _loc3_:* = null;
         var _loc4_:* = NaN;
         _loc3_ = [];
         var _loc6_:* = param2;
         for each(_loc4_ in _loc6_)
         {
            if(_loc4_ == 0)
            {
               _loc3_.push(0);
            }
            else
            {
               _loc3_.push(param1 * _loc4_);
            }
         }
         return _loc3_;
      }
      
      internal function add(param1:Array, param2:Array) : Array
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         _loc3_ = [];
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.push(param1[_loc4_] + param2[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getFilter() : ColorMatrixFilter
      {
         return new ColorMatrixFilter(m_matrix);
      }
      
      public function reset() : void
      {
         Identity();
      }
      
      public function setSaturation(param1:Number) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         param1 = param1 > 1 ? 1 : (param1 < 0 ? 0 : param1);
         _loc2_ = [0.213,0.715,0.072,0.213,0.715,0.072,0.213,0.715,0.072];
         _loc3_ = [0.787,-0.715,-0.072,-0.212,0.285,-0.072,-0.213,-0.715,0.928];
         _loc4_ = add(_loc2_,multiply(param1,_loc3_));
         concat([_loc4_[0],_loc4_[1],_loc4_[2],0,0,_loc4_[3],_loc4_[4],_loc4_[5],0,0,_loc4_[6],_loc4_[7],_loc4_[8],0,0,0,0,0,1,0]);
      }
      
      public function setHue(param1:Number) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         _h = param1;
         param1 = _h * 0.0174532925;
         _loc2_ = [0.213,0.715,0.072,0.213,0.715,0.072,0.213,0.715,0.072];
         _loc3_ = [0.787,-0.715,-0.072,-0.212,0.285,-0.072,-0.213,-0.715,0.928];
         _loc4_ = [-0.213,-0.715,0.928,0.143,0.14,-0.283,-0.787,0.715,0.072];
         _loc5_ = add(_loc2_,add(multiply(Math.cos(param1),_loc3_),multiply(Math.sin(param1),_loc4_)));
         concat([_loc5_[0],_loc5_[1],_loc5_[2],0,0,_loc5_[3],_loc5_[4],_loc5_[5],0,0,_loc5_[6],_loc5_[7],_loc5_[8],0,0,0,0,0,1,0]);
      }
      
      internal function concat(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         _loc2_ = [];
         _loc3_ = m_matrix;
         _loc2_[0] = _loc3_[0] * param1[0] + _loc3_[1] * param1[5] + _loc3_[2] * param1[10];
         _loc2_[1] = _loc3_[0] * param1[1] + _loc3_[1] * param1[6] + _loc3_[2] * param1[11];
         _loc2_[2] = _loc3_[0] * param1[2] + _loc3_[1] * param1[7] + _loc3_[2] * param1[12];
         _loc2_[3] = 0;
         _loc2_[4] = 0;
         _loc2_[5] = _loc3_[5] * param1[0] + _loc3_[6] * param1[5] + _loc3_[7] * param1[10];
         _loc2_[6] = _loc3_[5] * param1[1] + _loc3_[6] * param1[6] + _loc3_[7] * param1[11];
         _loc2_[7] = _loc3_[5] * param1[2] + _loc3_[6] * param1[7] + _loc3_[7] * param1[12];
         _loc2_[8] = 0;
         _loc2_[9] = 0;
         _loc2_[10] = _loc3_[10] * param1[0] + _loc3_[11] * param1[5] + _loc3_[12] * param1[10];
         _loc2_[11] = _loc3_[10] * param1[1] + _loc3_[11] * param1[6] + _loc3_[12] * param1[11];
         _loc2_[12] = _loc3_[10] * param1[2] + _loc3_[11] * param1[7] + _loc3_[12] * param1[12];
         _loc2_[13] = 0;
         _loc2_[14] = 0;
         _loc2_[15] = 0;
         _loc2_[16] = 0;
         _loc2_[17] = 0;
         _loc2_[18] = 1;
         _loc2_[19] = 0;
         m_matrix = _loc2_;
      }
      
      internal function Identity() : void
      {
         m_matrix = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      }
   }
}

