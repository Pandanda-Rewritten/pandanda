package
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   
   public class GameSound
   {
      
      private static var m_instance:GameSound;
      
      private static var m_allowInstantiation:Boolean = false;
      
      private var m_ambience:Array;
      
      private var m_music:Sound;
      
      private var m_sounds:XMLList;
      
      private var m_ambienceChannel:Array;
      
      private var m_effectChannelList:Array;
      
      private var m_effectList:Array;
      
      private var m_effect:Sound;
      
      private var m_musicChannel:SoundChannel;
      
      private var m_musicTrack:int;
      
      public function GameSound()
      {
         super();
         trace("GameSound Constuctor");
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use GameSound.getInstance() instead of new.");
         }
         m_ambience = new Array();
         m_ambienceChannel = new Array();
         m_effectList = new Array();
         m_effectChannelList = new Array();
      }
      
      public static function getInstance() : GameSound
      {
         if(m_instance == null)
         {
            m_allowInstantiation = true;
            m_instance = new GameSound();
            m_allowInstantiation = false;
         }
         return m_instance;
      }
      
      private function ioEffectErrorListener(param1:Event) : void
      {
         trace("ioEffectErrorListener: " + param1);
      }
      
      public function getMusicListSize() : int
      {
         var _loc1_:XMLList = null;
         _loc1_ = m_sounds.MUSIC;
         return _loc1_.length();
      }
      
      public function playMusic(param1:String) : void
      {
         var music:String = param1;
         if(music == "")
         {
            return;
         }
         trace("play music : " + music);
         clearMusic();
         try
         {
            m_music = new Sound();
            m_music.addEventListener(IOErrorEvent.IO_ERROR,ioMusicErrorListener,false,0,true);
            m_music.load(new URLRequest(music));
            m_musicChannel = m_music.play(30,60);
            if(!GameOptions.getInstance().isMusicOn())
            {
               m_musicChannel.stop();
            }
         }
         catch(e:Error)
         {
            trace("Error loading sound " + music + ", " + e.message);
         }
      }
      
      public function playAmbience(param1:XMLList) : void
      {
         var i:int = 0;
         var st:SoundTransform = null;
         var ambienceList:XMLList = param1;
         clearAmbience();
         i = 0;
         for(; i < ambienceList.length(); i++)
         {
            trace("night is : " + GameClock.getInstance().isNight());
            trace("ambience night is : " + ambienceList[i].NIGHT);
            if(GameClock.getInstance().isNight())
            {
               if(ambienceList[i].NIGHT == false)
               {
                  continue;
               }
            }
            else if(ambienceList[i].NIGHT == true)
            {
               continue;
            }
            try
            {
               m_ambience[i] = new Sound();
               m_ambience[i].addEventListener(IOErrorEvent.IO_ERROR,ioAmbienceErrorListener,false,0,true);
               m_ambience[i].load(new URLRequest(ambienceList[i].NAME));
               m_ambienceChannel[i] = m_ambience[i].play(0,1000);
               if(ambienceList[i].VOLUME > 0 && ambienceList[i].VOLUME <= 1)
               {
                  trace("setting ambient volume : " + ambienceList[i].VOLUME);
                  st = m_ambienceChannel[i].soundTransform;
                  st.volume = ambienceList[i].VOLUME;
                  m_ambienceChannel[i].soundTransform = st;
               }
               if(!GameOptions.getInstance().isSoundOn())
               {
                  m_ambienceChannel[i].stop();
               }
            }
            catch(e:Error)
            {
               trace("Error loading sound " + ambienceList[i].NAME + ", " + e.message);
            }
         }
      }
      
      private function clearMusic() : void
      {
         if(m_music)
         {
            m_music.removeEventListener(IOErrorEvent.IO_ERROR,ioMusicErrorListener);
         }
         if(!m_musicChannel)
         {
            return;
         }
         try
         {
            m_musicChannel.stop();
         }
         catch(e:Error)
         {
            trace("error trying to stop sound; " + e.message);
         }
         try
         {
            m_music.close();
         }
         catch(e:Error)
         {
            trace("error trying to close sound; " + e.message);
         }
      }
      
      public function toggleSound() : void
      {
         if(GameOptions.getInstance().isSoundOn())
         {
            if(Boolean(m_sounds) && Boolean(m_sounds.AMBIENCE))
            {
               playAmbience(m_sounds.AMBIENCE);
            }
         }
         else
         {
            clearAmbience();
         }
      }
      
      public function getMusicTrack() : int
      {
         return m_musicTrack;
      }
      
      private function ioAmbienceErrorListener(param1:Event) : void
      {
         trace("ioAmbienceErrorListener: " + param1);
         clearAmbience();
      }
      
      public function setMusicTrack(param1:int) : void
      {
         var _loc2_:XMLList = null;
         _loc2_ = m_sounds.MUSIC;
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_[param1])
         {
            playMusic(_loc2_[param1].NAME);
            m_musicTrack = param1;
         }
      }
      
      private function clearAmbience() : void
      {
         var i:int = 0;
         if(!m_ambience)
         {
            return;
         }
         i = 0;
         while(i < m_ambience.length)
         {
            if(m_ambience[i])
            {
               m_ambience[i].removeEventListener(IOErrorEvent.IO_ERROR,ioAmbienceErrorListener);
               try
               {
                  m_ambienceChannel[i].stop();
               }
               catch(e:Error)
               {
                  trace("error trying to stop sound; " + e.message);
               }
               try
               {
                  m_ambience[i].close();
               }
               catch(e:Error)
               {
                  trace("error trying to close sound; " + e.message);
               }
            }
            i++;
         }
         m_ambience.length = 0;
         m_ambienceChannel.length = 0;
      }
      
      public function toggleMusic() : void
      {
         trace("toggle music");
         if(GameOptions.getInstance().isMusicOn())
         {
            if(Boolean(m_sounds) && Boolean(m_sounds.MUSIC))
            {
               setMusicTrack(m_musicTrack);
            }
         }
         else
         {
            clearMusic();
         }
      }
      
      public function play(param1:XMLList) : void
      {
         m_sounds = param1;
         m_musicTrack = 0;
         toggleSound();
         toggleMusic();
      }
      
      public function clearSounds() : void
      {
         clearMusic();
         clearAmbience();
      }
      
      public function playSoundEffect(param1:int) : void
      {
         var effectList:XMLList = null;
         var effect:Sound = null;
         var effectChannel:SoundChannel = null;
         var st:SoundTransform = null;
         var effectNumber:int = param1;
         effectList = m_sounds.EFFECT;
         if(GameOptions.getInstance().isSoundOn())
         {
            try
            {
               effect = new Sound();
               effect.addEventListener(IOErrorEvent.IO_ERROR,ioEffectErrorListener,false,0,true);
               effect.load(new URLRequest(effectList[effectNumber].NAME));
               effectChannel = effect.play(0,1);
               if(effectList[effectNumber].VOLUME > 0 && effectList[effectNumber].VOLUME <= 1)
               {
                  trace("setting effect volume : " + effectList[effectNumber].VOLUME);
                  st = effectChannel[effectNumber].soundTransform;
                  st.volume = effectList[effectNumber].VOLUME;
                  effectChannel[effectNumber].soundTransform = st;
               }
            }
            catch(e:Error)
            {
               trace("Error loading sound " + effectList[effectNumber].NAME + ", " + e.message);
            }
         }
      }
      
      private function ioMusicErrorListener(param1:Event) : void
      {
         trace("ioMusicErrorListener: " + param1);
         clearMusic();
      }
   }
}

