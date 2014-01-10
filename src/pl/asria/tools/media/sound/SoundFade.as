package pl.asria.tools.media.sound
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import pl.asria.tools.managers.IJugglable;
	import pl.asria.tools.managers.SEnterFrameJuggler;
	import pl.asria.tools.utils.trace.etrace;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SoundFade implements IJugglable
	{
		protected var __currentTime:int;
		protected static var _dActive:Dictionary = new Dictionary(true);
		protected static var _killAllProcess:Boolean;
		private var __easeFunction:Function;
		private var __fromVolume:Number;
		private var __soundChannel:SoundChannel;
		private var __toVolume:Number;
		private var __time:int;
		private var __callback:Function;
		private var __args:Array;
		private var __volumeDiff:Number;
		
		public static function killAllFadesOf(soundChannel:SoundChannel):void
		{
			if (soundChannel == null) return;
			_killAllProcess = true;
			if (_dActive[soundChannel])
			{
				while(_dActive[soundChannel].length) 
				{
					_dActive[soundChannel][0].clean();
				}
				delete _dActive[soundChannel];
			}
			_killAllProcess = false;
		}
		
		/**
		 *
		 * @param	soundChannel
		 * @param	fromVolume	0..1
		 * @param	toVolume	0..1
		 * @param	time		time in ms during this fade is calculated
		 * @param	ease		some ease function from  fl.transformations.ease.* or fl.motion.ease.* etc...
		 * @param	callback	calback on en of the fade,  running to when sounds is stoped
		 * @param	...args
		 */
		public function SoundFade(soundChannel:SoundChannel, fromVolume:Number = 1, toVolume:Number = 0, time:int = 400, ease:Function = null, callback:Function = null, ... args)
		{
			if (!soundChannel)
			{
				etrace("null soundChannel");
				return;
			}
			
			__args = args;
			__callback = callback;
			__time = time;
			__soundChannel = soundChannel;
			
			__toVolume = toVolume;
			__fromVolume = fromVolume;
			__volumeDiff = __toVolume - __fromVolume;
			
			__soundChannel.soundTransform.volume = __fromVolume;
			
			__easeFunction = (ease as Function) || easeInOut;

			__currentTime = 0;
			__soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
			if (!_dActive[soundChannel]) _dActive[soundChannel] = [];
			_dActive[soundChannel].push(this);
			SEnterFrameJuggler.register(this);
		}
		
		
		public function get enableJuggler():Boolean 
		{
			return true;
		}
		
		public function update(offestTime:int):void 
		{
			__currentTime += offestTime;
			if (__currentTime > __time) __currentTime = __time;
			
			var value:Number = __easeFunction(__currentTime, 0, 1, __time); // range between 0 and 1
			
			var _transform:SoundTransform = __soundChannel.soundTransform;
			_transform.volume = __fromVolume + __volumeDiff * value;
			__soundChannel.soundTransform = _transform;
			
			if (__currentTime == __time)
			{
				_endFade();
			}
		}
		
		protected function onSoundComplete(e:Event):void
		{
			_endFade();
		}
		

		protected function clean():void
		{
			var index:int = _dActive[__soundChannel].indexOf(this);
			if (index) _dActive[__soundChannel].splice(index, 1);
			__soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
			SEnterFrameJuggler.unregister(this);
			// if it is a kill proces invoke, then for sure this array will be destroyed anyway
			if (!_killAllProcess && _dActive[__soundChannel].length == 0) delete _dActive[__soundChannel];
			
			
			__soundChannel = null;
			__args = null;
			__callback = null;
		}
		
		
		protected function _endFade():void
		{
			if (__callback != null)
				__callback.apply(null, __args);
			clean();
		}
		
		protected function easeInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * 0.5 * (Math.cos(Math.PI * t / d) - 1) + b;
		}
	
	}

}