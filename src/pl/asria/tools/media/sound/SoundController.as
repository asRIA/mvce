/**
* CHANGELOG:
*
* 2012-01-15 19:56: Create file
*/
package pl.asria.tools.media.sound 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[Event(name="soundLoopComplete", type="pl.asria.tools.media.sound.SoundControllerEvent")]
	[Event(name="soundComplete", type="pl.asria.tools.media.sound.SoundControllerEvent")]
	public class SoundController extends EventDispatcher
	{
		private var _sound:Sound;
		private var _loader:SoundLoader;
		
		private static const _dSoundPlayed:Dictionary = new Dictionary(true);
		
		static public const STATE_PAUSED:uint = 0x1;
		static public const STATE_STOP:uint = 0x2;
		static public const STATE_PLAYING:uint = 0x4;
		static public const STATE_NOTINIT:uint = 0x8;
		
		private var state:uint = 0x0;
		private var _soundChannel:SoundChannel;
		private var _currentLoop:int;
		private var _soundTransform:SoundTransform = new SoundTransform();
		private var startTime:Number;
		private var _isPlaying:Boolean;
		private var _totalLoops:int;
		private var _stateDump:Object;
		
		
		internal var lastGroup:String = null;
		private var _group:String = null;
		private var __concanateSoundTransform:SoundTransform;
		
		/**
		 * ...
		 * @author Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SoundController() 
		{
			ToolSounds.dispatcher.addEventListener(ToolSoundsEvent.CHANGE_GLOBAL_VOLUME, changeVolumeHandler, false, 0, true);
			ToolSounds.dispatcher.addEventListener(ToolSoundsEvent.CHANGE_GROUP_VOLUME, changeVolumGroupeHandler, false, 0, true);
		}
		
		private function changeVolumGroupeHandler(e:ToolSoundsEvent):void 
		{
			if (e.data == _group)
			{
				if (_soundChannel) _soundChannel.soundTransform = globalSoundTransform();
			}
		}
		
		private function changeVolumeHandler(e:ToolSoundsEvent):void 
		{
			if (_soundChannel) _soundChannel.soundTransform = globalSoundTransform();
		}
		
		public function play(startTime:Number = 0, loops:int = 1, duplicate:Boolean = false):void 
		{
			_currentLoop = 0;
			_totalLoops = loops;
			this.startTime = startTime;
			if (_sound)
			{
				if (duplicate ||  !_dSoundPlayed[_sound])
				{
					_play(startTime);
					_dSoundPlayed[_sound]++;
				}
			}
			state = STATE_PLAYING;
		}
		
		private function globalSoundTransform():SoundTransform
		{
			return concatenateSoundTransform(ToolSounds.soundTransform, ToolSounds.makeGroup(_group), _soundTransform);
		}
		
		private function _play(startTime:Number):void
		{
			_isPlaying = true;
			_currentLoop++;
			if (_sound) 
			{
				_soundChannel = _sound.play(startTime, 1, globalSoundTransform());
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, completeSoundPlayHandler);
			}
		}
		
		private function completeSoundPlayHandler(e:Event):void 
		{
			if (_soundChannel) _soundChannel.removeEventListener(Event.SOUND_COMPLETE, completeSoundPlayHandler);
			_soundChannel = null;
			
			if (_currentLoop < _totalLoops)
			{
				dispatchEvent(new SoundControllerEvent(SoundControllerEvent.SOUND_LOOP_COMPLETE));
				_play(startTime);
			}
			else
			{
				dispatchEvent(new SoundControllerEvent(SoundControllerEvent.SOUND_COMPLETE));
				_dSoundPlayed[_sound]--;
				_isPlaying = false;
			}
		}
		
		public function pause():void
		{ 
			if (!(state & STATE_PLAYING)) return;
			state = STATE_PAUSED;
			if (_sound) 
			{
				_stateDump = { time:_soundChannel.position, totalLoops:_totalLoops, currentLoop:_currentLoop, startTime:startTime };
				_isPlaying = false;
				_dSoundPlayed[_sound]--;
				_stop();
			}
			
		}
		
		public function resume():void
		{
			if (state & STATE_PAUSED)
			{
				state = STATE_PLAYING;
				
				_play(_stateDump.time);
				_totalLoops = _stateDump.totalLoops;
				_currentLoop = _stateDump.currentLoop;
				startTime = _stateDump.startTime;

			}
		}
		
		public function stop(time:uint = 0):void
		{
			if (!(state & STATE_STOP))
			{
				if(time == 0 || !_soundChannel)
					_stop();
				else 
				{
					new SoundFade(_soundChannel, _soundChannel.soundTransform.volume, 0, time, null, _stop );
				}
				state = STATE_STOP;
			}
		}
		
		
		public function clear():void
		{ 
			_stop();
			_sound = null;
		}
		
		public function setSound(sound:Sound):void 
		{
			this._sound = sound;
			if (undefined == _dSoundPlayed[sound]) 
				_dSoundPlayed[sound] = 0;
		}
		
		
		private function _stop():void 
		{
			if (_soundChannel)
			{
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, completeSoundPlayHandler);
				_soundChannel = null;
			}
		}
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		public function get totalLoops():int 
		{
			return _totalLoops;
		}
		
		public function get currentLoop():int 
		{
			return _currentLoop;
		}
		
		public function get soundTransform():SoundTransform 
		{
			return _soundTransform;
		}
		
		public function set soundTransform(value:SoundTransform):void 
		{
			_soundTransform = value || new SoundTransform();
		}
		
		public function get soundChannel():SoundChannel 
		{
			return _soundChannel;
		}
		
		public function get sound():Sound 
		{
			return _sound;
		}
		
		public function get group():String 
		{
			return _group;
		}
		
		public function set group(value:String):void 
		{
			if(_group != value)
			{
				lastGroup = _group;
				_group = value;
				__concanateSoundTransform = concatenateSoundTransform(ToolSounds.soundTransform, ToolSounds.makeGroup(value), _soundTransform)
			}
		}
		
		

	}

}