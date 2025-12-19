package
{
   public class AvatarColors
   {
      
      internal static var m_instance:AvatarColors;
      
      public static const BUNNY_COLOR_BROWN_INDEX:int = 0;
      
      public static const BUNNY_COLOR_WHITE_INDEX:int = 11;
      
      public static const BUNNY_COLOR_GREY_INDEX:int = 12;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_horseTier1Colors:Array;
      
      internal var m_horseTier2Colors:Array;
      
      internal var m_horseTier3Colors:Array;
      
      internal var m_sledColors:Array;
      
      internal var m_petColors:Array;
      
      internal var m_dragonColors:Array;
      
      internal var m_avatarColors:Array;
      
      public function AvatarColors()
      {
         super();
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use AvatarColors.getInstance() instead of new.");
         }
         trace("AvatarColors Constuctor");
         this.m_avatarColors = new Array();
         this.m_avatarColors.push([9264689,5979423,11104314]);
         this.m_avatarColors.push([2970878,1980845,5875711]);
         this.m_avatarColors.push([976746,630857,1769413]);
         this.m_avatarColors.push([16406228,11549845,16745471]);
         this.m_avatarColors.push([11560662,7882130,14122239]);
         this.m_avatarColors.push([16678406,12410116,16761609]);
         this.m_avatarColors.push([58089,43181,65535]);
         this.m_avatarColors.push([12434114,8420995,16118268]);
         this.m_avatarColors.push([823802,550061,1101055]);
         this.m_avatarColors.push([16067914,11149107,16730488]);
         this.m_avatarColors.push([15786549,11905576,16777046]);
         this.m_avatarColors.push([16777215,16777215,16777215]);
         this.m_avatarColors.push([4473924,4473924,4473924]);
         this.m_avatarColors.push([328965,328965,328965]);
         this.m_avatarColors.push([13152873,10389580,15521161]);
         this.m_avatarColors.push([6698638,4531296,11427058]);
         this.m_avatarColors.push([1980103,1320071,3696383]);
         this.m_avatarColors.push([3487029,1907997,7303023]);
         this.m_avatarColors.push([1012254,675605,1553711]);
         this.m_avatarColors.push([10295618,7934771,13566017]);
         this.m_petColors = new Array();
         this.m_petColors.push([15539833,16776338]);
         this.m_petColors.push([13959168,16041747]);
         this.m_petColors.push([1276994,16776960]);
         this.m_petColors.push([3947580,8092539]);
         this.m_petColors.push([4235711,16776338]);
         this.m_petColors.push([5724379,10353913]);
         this.m_petColors.push([10180822,10353913]);
         this.m_petColors.push([10066329,10353913]);
         this.m_petColors.push([15898125,16776338]);
         this.m_petColors.push([12318328,16775523]);
         this.m_dragonColors = new Array();
         this.m_dragonColors.push([10066329,10353913]);
         this.m_dragonColors.push([5724379,10353913]);
         this.m_dragonColors.push([1276994,16776960]);
         this.m_dragonColors.push([13959168,16041747]);
         this.m_dragonColors.push([3947580,8092539]);
         this.m_dragonColors.push([4235711,16776338]);
         this.m_dragonColors.push([10180822,10353913]);
         this.m_dragonColors.push([15898125,16776338]);
         this.m_dragonColors.push([12318328,16775523]);
         this.m_sledColors = new Array();
         this.m_sledColors.push([8736558,16122884]);
         this.m_sledColors.push([8736558,15898125]);
         this.m_sledColors.push([8736558,1325000]);
         this.m_sledColors.push([3345415,5901456]);
         this.m_horseTier1Colors = new Array();
         this.m_horseTier1Colors.push([15527148,16777215,16752834,2530116,0]);
         this.m_horseTier1Colors.push([15527148,16777215,12418027,2530116,0]);
         this.m_horseTier1Colors.push([15527148,16777215,5901456,2530116,1]);
         this.m_horseTier1Colors.push([15527148,16777215,9088764,2530116,0]);
         this.m_horseTier1Colors.push([15527148,16777215,1325000,2530116,1]);
         this.m_horseTier1Colors.push([15527148,16777215,41628,2530116,1]);
         this.m_horseTier1Colors.push([15527148,16777215,13434880,2530116,1]);
         this.m_horseTier1Colors.push([15527148,16777215,2236962,2530116,1]);
         this.m_horseTier2Colors = new Array();
         this.m_horseTier2Colors.push([6305811,13016173,16049826,10643717,0]);
         this.m_horseTier2Colors.push([3345415,12875870,16049826,10643717,0]);
         this.m_horseTier2Colors.push([3345415,12875870,2236962,10643717,1]);
         this.m_horseTier2Colors.push([3345415,12875870,2689285,10643717,1]);
         this.m_horseTier2Colors.push([7895188,16777215,2236962,2530116,1]);
         this.m_horseTier2Colors.push([7895188,16777215,15592941,2530116,0]);
         this.m_horseTier2Colors.push([1842216,7895188,13753064,7303167,0]);
         this.m_horseTier2Colors.push([2236962,4473924,14869218,7303167,0]);
         this.m_horseTier3Colors = new Array();
         this.m_horseTier3Colors.push([1513245,11230871,9634655,2530116,1]);
         this.m_horseTier3Colors.push([1513245,7429803,5901456,7303167,1]);
         this.m_horseTier3Colors.push([12388447,16777215,15580870,7303167,0]);
         this.m_horseTier3Colors.push([1513245,7429803,12418027,7303167,0]);
         this.m_horseTier3Colors.push([5901456,12418027,12418027,2530116,0]);
         this.m_horseTier3Colors.push([1325000,9088764,9088764,2530116,0]);
         this.m_horseTier3Colors.push([657990,604621,9088764,7303167,0]);
         this.m_horseTier3Colors.push([1513245,6204539,15592941,3458431,0]);
      }
      
      public static function getInstance() : AvatarColors
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new AvatarColors();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      public function getPetColorCount() : int
      {
         return this.m_petColors.length;
      }
      
      public function getHorseTier2Color(param1:int) : Array
      {
         if(param1 >= 0 && param1 <= this.m_horseTier2Colors.length)
         {
            return this.m_horseTier2Colors[param1];
         }
         return this.m_horseTier2Colors[0];
      }
      
      public function getPetColor(param1:int) : Array
      {
         if(param1 >= 0 && param1 <= this.m_petColors.length)
         {
            return this.m_petColors[param1];
         }
         return this.m_petColors[0];
      }
      
      public function getPandaBorderColor(param1:int) : uint
      {
         if(param1 >= 0 && param1 <= this.m_avatarColors.length)
         {
            return this.m_avatarColors[param1][1];
         }
         return 0;
      }
      
      public function getHorseTier3Color(param1:int) : Array
      {
         if(param1 >= 0 && param1 <= this.m_horseTier3Colors.length)
         {
            return this.m_horseTier3Colors[param1];
         }
         return this.m_horseTier3Colors[0];
      }
      
      public function getHorseTier1Color(param1:int) : Array
      {
         if(param1 >= 0 && param1 <= this.m_horseTier1Colors.length)
         {
            return this.m_horseTier1Colors[param1];
         }
         return this.m_horseTier1Colors[0];
      }
      
      public function getDragonColorCount() : int
      {
         return this.m_dragonColors.length;
      }
      
      public function getPandaColor(param1:int) : uint
      {
         if(param1 >= 0 && param1 <= this.m_avatarColors.length)
         {
            return this.m_avatarColors[param1][0];
         }
         return 0;
      }
      
      public function getDragonColor(param1:int) : Array
      {
         if(param1 >= 0 && param1 <= this.m_dragonColors.length)
         {
            return this.m_dragonColors[param1];
         }
         return this.m_dragonColors[0];
      }
      
      public function getAvatarColorCount() : int
      {
         return this.m_avatarColors.length;
      }
      
      public function getPandaFurColor(param1:int) : uint
      {
         if(param1 >= 0 && param1 <= this.m_avatarColors.length)
         {
            return this.m_avatarColors[param1][2];
         }
         return 0;
      }
      
      public function getSledColorCount() : int
      {
         return this.m_sledColors.length;
      }
      
      public function getSledColor(param1:int) : Array
      {
         if(param1 >= 0 && param1 < this.m_sledColors.length)
         {
            return this.m_sledColors[param1];
         }
         return this.m_sledColors[0];
      }
      
      public function getBunnyColor(param1:int) : uint
      {
         if(param1 >= 0 && param1 <= this.m_avatarColors.length)
         {
            return this.m_avatarColors[param1][0];
         }
         return this.m_avatarColors[0][0];
      }
      
      public function getHorseTier1ColorCount() : int
      {
         return this.m_horseTier1Colors.length;
      }
      
      public function getHorseTier2ColorCount() : int
      {
         return this.m_horseTier2Colors.length;
      }
      
      public function getHorseTier3ColorCount() : int
      {
         return this.m_horseTier3Colors.length;
      }
   }
}

