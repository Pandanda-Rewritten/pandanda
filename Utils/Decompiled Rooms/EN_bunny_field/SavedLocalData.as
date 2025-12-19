package
{
   import flash.net.*;
   
   public class SavedLocalData
   {
      
      internal static var m_instance:SavedLocalData;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_characterList:Array;
      
      internal var m_timeStamp:Date;
      
      internal var m_soTimeStamp:SharedObject;
      
      internal var m_so:SharedObject;
      
      internal var m_lastPlayedIndex:int;
      
      public function SavedLocalData()
      {
         super();
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use SavedLocalData.getInstance() instead of new.");
         }
         trace("SavedLocalData Constuctor");
         this.m_characterList = new Array();
         this.m_lastPlayedIndex = 0;
         this.m_so = SharedObject.getLocal("pandanda");
         this.m_so.clear();
         this.m_so = SharedObject.getLocal("pandanda","/");
         if(Boolean(this.m_so.data) && Boolean(this.m_so.data.characters))
         {
            this.m_characterList = this.m_so.data.characters;
            if(this.m_so.data.lastIndex)
            {
               this.m_lastPlayedIndex = this.m_so.data.lastIndex;
            }
         }
      }
      
      public static function getInstance() : SavedLocalData
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new SavedLocalData();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function removeCharacter(param1:String) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = -1;
         _loc3_ = 0;
         while(_loc3_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc3_].name,param1))
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != -1)
         {
            this.m_characterList.splice(_loc2_,1);
            this.m_so.data.characters = this.m_characterList;
            this.m_so.flush();
         }
      }
      
      public function addCharacter(param1:String, param2:String) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         _loc3_ = false;
         _loc4_ = 0;
         while(_loc4_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc4_].name,param1))
            {
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         if(!_loc3_)
         {
            _loc5_ = new Object();
            _loc5_.name = param1;
            _loc5_.password = param2;
            _loc5_.color = 0;
            _loc5_.wearing = "";
            _loc5_.cardColor = 0;
            _loc5_.music = true;
            _loc5_.effects = true;
            _loc5_.smoothing = GameOptions.OPTIONS_ANTIALIASING_HIGH;
            _loc5_.borderColor = 0;
            this.m_characterList.push(_loc5_);
            this.m_so.data.characters = this.m_characterList;
            this.m_lastPlayedIndex = this.m_characterList.length - 1;
            this.m_so.data.lastIndex = this.m_lastPlayedIndex;
            this.m_so.flush();
         }
      }
      
      public function getNames() : Array
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         _loc1_ = new Array();
         _loc2_ = 0;
         while(_loc2_ < this.m_characterList.length)
         {
            _loc1_.push(this.m_characterList[_loc2_].name);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setWearing(param1:String, param2:String) : void
      {
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc3_].name,param1))
            {
               this.m_characterList[_loc3_].wearing = param2;
               trace("SavedLocalData: Saving wearing " + param2);
               this.m_so.flush();
            }
            _loc3_++;
         }
      }
      
      public function changeName(param1:String, param2:String) : void
      {
         var _loc3_:* = false;
         var _loc4_:* = 0;
         _loc3_ = false;
         _loc4_ = 0;
         while(_loc4_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc4_].name,param1))
            {
               this.m_characterList[_loc4_].name = param2;
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            this.m_so.flush();
         }
      }
      
      public function getCharacterCount() : int
      {
         return this.m_characterList.length;
      }
      
      public function setPassword(param1:String, param2:String) : void
      {
         var _loc3_:* = false;
         var _loc4_:* = 0;
         _loc3_ = false;
         _loc4_ = 0;
         while(_loc4_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc4_].name,param1))
            {
               this.m_characterList[_loc4_].password = param2;
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            this.m_so.flush();
         }
         else
         {
            this.addCharacter(param1,param2);
         }
      }
      
      public function saveOptions(param1:String) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc2_].name,param1))
            {
               this.m_characterList[_loc2_].music = GameOptions.getInstance().isMusicOn();
               this.m_characterList[_loc2_].effects = GameOptions.getInstance().isSoundOn();
               this.m_characterList[_loc2_].smoothing = GameOptions.getInstance().getAntiAliasing();
               this.m_characterList[_loc2_].borderColor = GameOptions.getInstance().getBorderColorIndex();
               this.m_so.flush();
            }
            _loc2_++;
         }
      }
      
      public function setColor(param1:String, param2:int) : void
      {
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc3_].name,param1))
            {
               this.m_characterList[_loc3_].color = param2;
               trace("SavedLocalData: Saving color " + param2);
               this.m_so.flush();
            }
            _loc3_++;
         }
      }
      
      public function setCardColor(param1:String, param2:int) : void
      {
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc3_].name,param1))
            {
               this.m_characterList[_loc3_].cardColor = param2;
            }
            _loc3_++;
         }
         this.m_so.flush();
      }
      
      public function getCharacter(param1:String) : Object
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < this.m_characterList.length)
         {
            if(this.stringMatchIgnoreCase(this.m_characterList[_loc2_].name,param1))
            {
               this.m_lastPlayedIndex = _loc2_;
               this.m_so.data.lastIndex = this.m_lastPlayedIndex;
               this.m_so.flush();
               return this.m_characterList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      internal function stringMatchIgnoreCase(param1:String, param2:String) : Boolean
      {
         param1 = param1.toLowerCase();
         param2 = param2.toLowerCase();
         return param1 == param2;
      }
      
      public function getLastPlayed() : int
      {
         return this.m_lastPlayedIndex;
      }
   }
}

