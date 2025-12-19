package
{
   public class MiniGame
   {
      
      internal var m_playedCount:int;
      
      internal var m_id:String;
      
      internal var m_totalCoins:int;
      
      internal var m_highScore:int;
      
      public function MiniGame(param1:String, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         trace("MiniGame Constuctor");
         this.m_id = param1;
         this.m_playedCount = param2;
         this.m_totalCoins = param3;
         this.m_highScore = param4;
      }
      
      public function getPlayedCount() : int
      {
         return this.m_playedCount;
      }
      
      public function setPlayedCount(param1:int) : void
      {
         this.m_playedCount = param1;
      }
      
      public function getId() : String
      {
         return this.m_id;
      }
      
      public function getHighScore() : int
      {
         return this.m_highScore;
      }
      
      public function setTotalCoins(param1:int) : void
      {
         this.m_totalCoins = param1;
      }
      
      public function getTotalCoins() : int
      {
         return this.m_totalCoins;
      }
   }
}

