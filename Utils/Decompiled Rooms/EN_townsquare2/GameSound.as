package
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   
   public class GameSound
   {
      
      internal static var m_instance:GameSound;
      
      internal static var m_allowInstantiation:Boolean = false;
      
      m_allowInstantiation = false;
      
      internal var m_ambience:Array;
      
      internal var m_music:Sound;
      
      internal var m_sounds:XMLList;
      
      internal var m_ambienceChannel:Array;
      
      internal var m_effectChannelList:Array;
      
      internal var m_effectList:Array;
      
      internal var m_effect:Sound;
      
      internal var m_musicChannel:SoundChannel;
      
      internal var m_musicTrack:int;
      
      public function GameSound()
      {
         super();
         trace("GameSound Constuctor");
         if(!m_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use GameSound.getInstance() instead of new.");
         }
         this.m_ambience = new Array();
         this.m_ambienceChannel = new Array();
         this.m_effectList = new Array();
         this.m_effectChannelList = new Array();
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
      
      internal function ioEffectErrorListener(param1:Event) : void
      {
         trace("ioEffectErrorListener: " + param1);
      }
      
      public function getMusicListSize() : int
      {
         var _loc1_:* = null;
         _loc1_ = this.m_sounds.MUSIC;
         return _loc1_.length();
      }
      
      public function playMusic(param1:String) : void
      {
         var music:String = null;
         var loc1:* = undefined;
         var arg1:String = param1;
         music = arg1;
         if(music == "")
         {
            return;
         }
         trace("play music : " + music);
         this.clearMusic();
         try
         {
            this.m_music = new Sound();
            this.m_music.addEventListener(IOErrorEvent.IO_ERROR,this.ioMusicErrorListener,false,0,true);
            this.m_music.load(new URLRequest(music));
            this.m_musicChannel = this.m_music.play(30,60);
            if(!GameOptions.getInstance().isMusicOn())
            {
               this.m_musicChannel.stop();
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
         var ambienceList:XMLList = null;
         var loc1:* = undefined;
         var arg1:XMLList = param1;
         i = 0;
         st = null;
         ambienceList = arg1;
         this.clearAmbience();
         i = 0;
         for(; i < ambienceList.length(); i++)
         {
            trace("night is : " + GameClock.getInstance().isNight());
            trace("ambience night is : " + ambienceList[i].NIGHT);
            if(GameClock.getInstance().isNight())
            {
               if(ambienceList[i].NIGHT != false)
               {
                  try
                  {
                     this.m_ambience[i] = new Sound();
                     this.m_ambience[i].addEventListener(IOErrorEvent.IO_ERROR,this.ioAmbienceErrorListener,false,0,true);
                     this.m_ambience[i].load(new URLRequest(ambienceList[i].NAME));
                     this.m_ambienceChannel[i] = this.m_ambience[i].play(0,1000);
                     if(ambienceList[i].VOLUME > 0 && ambienceList[i].VOLUME <= 1)
                     {
                        trace("setting ambient volume : " + ambienceList[i].VOLUME);
                        st = this.m_ambienceChannel[i].soundTransform;
                        st.volume = ambienceList[i].VOLUME;
                        this.m_ambienceChannel[i].soundTransform = st;
                     }
                     if(!GameOptions.getInstance().isSoundOn())
                     {
                        this.m_ambienceChannel[i].stop();
                     }
                  }
                  catch(e:Error)
                  {
                     trace("Error loading sound " + ambienceList[i].NAME + ", " + e.message);
                     continue;
                  }
               }
            }
            else if(ambienceList[i].NIGHT != true)
            {
               try
               {
                  this.m_ambience[i] = new Sound();
                  this.m_ambience[i].addEventListener(IOErrorEvent.IO_ERROR,this.ioAmbienceErrorListener,false,0,true);
                  this.m_ambience[i].load(new URLRequest(ambienceList[i].NAME));
                  this.m_ambienceChannel[i] = this.m_ambience[i].play(0,1000);
                  if(ambienceList[i].VOLUME > 0 && ambienceList[i].VOLUME <= 1)
                  {
                     trace("setting ambient volume : " + ambienceList[i].VOLUME);
                     st = this.m_ambienceChannel[i].soundTransform;
                     st.volume = ambienceList[i].VOLUME;
                     this.m_ambienceChannel[i].soundTransform = st;
                  }
                  if(!GameOptions.getInstance().isSoundOn())
                  {
                     this.m_ambienceChannel[i].stop();
                  }
               }
               catch(e:Error)
               {
                  trace("Error loading sound " + ambienceList[i].NAME + ", " + e.message);
                  continue;
               }
            }
         }
      }
      
      internal function clearMusic() : void
      {
         var loc1:* = undefined;
         if(this.m_music)
         {
            this.m_music.removeEventListener(IOErrorEvent.IO_ERROR,this.ioMusicErrorListener);
         }
         if(!this.m_musicChannel)
         {
            return;
         }
         try
         {
            this.m_musicChannel.stop();
         }
         catch(e:Error)
         {
            trace("error trying to stop sound; " + e.message);
         }
         try
         {
            this.m_music.close();
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
            if(Boolean(this.m_sounds) && Boolean(this.m_sounds.AMBIENCE))
            {
               this.playAmbience(this.m_sounds.AMBIENCE);
            }
         }
         else
         {
            this.clearAmbience();
         }
      }
      
      public function getMusicTrack() : int
      {
         return this.m_musicTrack;
      }
      
      internal function ioAmbienceErrorListener(param1:Event) : void
      {
         trace("ioAmbienceErrorListener: " + param1);
         this.clearAmbience();
      }
      
      public function setMusicTrack(param1:int) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.m_sounds.MUSIC;
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_[param1])
         {
            this.playMusic(_loc2_[param1].NAME);
            this.m_musicTrack = param1;
         }
      }
      
      internal function clearAmbience() : void
      {
         var i:int = 0;
         var loc1:* = undefined;
         i = 0;
         if(!this.m_ambience)
         {
            return;
         }
         i = 0;
         while(i < this.m_ambience.length)
         {
            if(this.m_ambience[i])
            {
               this.m_ambience[i].removeEventListener(IOErrorEvent.IO_ERROR,this.ioAmbienceErrorListener);
               try
               {
                  this.m_ambienceChannel[i].stop();
               }
               catch(e:Error)
               {
                  trace("error trying to stop sound; " + e.message);
               }
               try
               {
                  this.m_ambience[i].close();
               }
               catch(e:Error)
               {
                  trace("error trying to close sound; " + e.message);
               }
            }
            i++;
         }
         this.m_ambience.length = 0;
         this.m_ambienceChannel.length = 0;
      }
      
      public function toggleMusic() : void
      {
         trace("toggle music");
         if(GameOptions.getInstance().isMusicOn())
         {
            if(Boolean(this.m_sounds) && Boolean(this.m_sounds.MUSIC))
            {
               this.setMusicTrack(this.m_musicTrack);
            }
         }
         else
         {
            this.clearMusic();
         }
      }
      
      public function play(param1:XMLList) : void
      {
         this.m_sounds = param1;
         this.m_musicTrack = 0;
         this.toggleSound();
         this.toggleMusic();
      }
      
      public function clearSounds() : void
      {
         this.clearMusic();
         this.clearAmbience();
      }
      
      public function playSoundEffect(param1:int) : void
      {
         var effect:Sound = null;
         var st:SoundTransform = null;
         var effectChannel:SoundChannel = null;
         var effectNumber:int = 0;
         var effectList:XMLList = null;
         var loc1:* = undefined;
         var arg1:int = param1;
         effectList = null;
         effect = null;
         effectChannel = null;
         st = null;
         effectNumber = arg1;
         effectList = this.m_sounds.EFFECT;
         if(GameOptions.getInstance().isSoundOn())
         {
            try
            {
               effect = new Sound();
               effect.addEventListener(IOErrorEvent.IO_ERROR,this.ioEffectErrorListener,false,0,true);
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
      
      internal function ioMusicErrorListener(param1:Event) : void
      {
         trace("ioMusicErrorListener: " + param1);
         this.clearMusic();
      }
   }
}

