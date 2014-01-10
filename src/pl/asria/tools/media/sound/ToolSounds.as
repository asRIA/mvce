package pl.asria.tools.media.sound 
{
	import flash.events.EventDispatcher;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import pl.asria.framework.media.sounds.SoundManager;
	import pl.asria.tools.utils.trace.dtrace;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="changeGlobalVolume", type="pl.asria.tools.media.sound.ToolSoundsEvent")]
	public class ToolSounds 
	{
		private static const _dSounds:Dictionary = new Dictionary();
		private static const _dVolumes:Dictionary = new Dictionary();
		private static const _dTransforms:Dictionary = new Dictionary();
		
		private static var _globalRatio:Number = 1;
		private static var _mute:Boolean = false;
		internal static const soundTransform:SoundTransform = new SoundTransform();
		public static const dispatcher:EventDispatcher = new EventDispatcher();
		public static const DISPACH_CHANGE_GROUP:uint = 0x1;
		public static const DISPATCH_CHANGE_GLOBAL:uint = 0x2;
		public static const DISPATCH_ALL:uint = DISPACH_CHANGE_GROUP | DISPATCH_CHANGE_GLOBAL;
		public static var dispatchMask:uint = DISPATCH_ALL;
		
		/**
		 * 
		 * @param	volume
		 * @param	group	if null then set volume for all sounds, otherwise only for specyfic group
		 */
		public static function setVolume(volume:Number, group:String = null, toSharedObject:Boolean = false):void
		{
			if (group == null) 
			{
				soundTransform.volume = volume;
				if(dispatchMask & DISPATCH_CHANGE_GLOBAL) dispatcher.dispatchEvent(new ToolSoundsEvent(ToolSoundsEvent.CHANGE_GLOBAL_VOLUME, ToolSounds.volume));
			}
			else
			{
				if (_dTransforms[group] == undefined) _dTransforms[group]  = new SoundTransform(volume);
				else _dTransforms[group].volume = volume;
				_dVolumes[group] = volume;
				if(dispatchMask & DISPACH_CHANGE_GROUP) dispatcher.dispatchEvent(new ToolSoundsEvent(ToolSoundsEvent.CHANGE_GROUP_VOLUME, group));
				if (toSharedObject)
				{
					try {
						
						var so:SharedObject = SharedObject.getLocal("ToolSoundsVolumes");
						so.data[group] = volume;
						so.flush(512);
						so.close();
					}
					catch (e:Error)
					{
						dtrace("No space to storage SharedObjects")
					}
				}
			}
		}
		
		static internal function makeGroup(value:String):SoundTransform 
		{
			if (value == null) return null;
			if (_dTransforms[value] == undefined)
			{
				_dTransforms[value] = new SoundTransform();
				if (SoundManager.instance.muteArray["group"][value])
					_dTransforms[value].volume = 0;
			}
			return _dTransforms[value]
		}
		
		public static function get volume():Number
		{
			return _mute ? 0 : soundTransform.volume;
		}
		
		public static function getVolume(group:String):Number
		{
			var result:Number = soundTransform.volume;
			if (_dVolumes[group] != undefined)
			{
				result *= _dVolumes[group];
			}
			return result;
		}
		
		public static function getFromSharedObject():void
		{
			var so:SharedObject = SharedObject.getLocal("ToolSoundsVolumes");
			for (var key:Object in _dVolumes) 
			{
				if (undefined != so.data[key])
				{
					_dVolumes[key] = so.data[key];
					if(dispatchMask & DISPACH_CHANGE_GROUP) dispatcher.dispatchEvent(new ToolSoundsEvent(ToolSoundsEvent.CHANGE_GROUP_VOLUME, key));
				}
			}
			so.close();
		}
		
		public static function initVolume(group:String, defaultVolume:Number):void
		{
			var so:SharedObject = SharedObject.getLocal("ToolSoundsVolumes");
			if (undefined == so.data[group])
			{
				setVolume(defaultVolume, group, true);
			}
			else
			{
				setVolume(so.data[group], group, false);
			}
			so.close();
			
		}
		
		public static function getTransform(gorup:String):SoundTransform
		{
			if (_dTransforms[gorup] != undefined)
			{
				return concatenateSoundTransform(soundTransform, _dTransforms[gorup]);
			}
			return soundTransform;
		}
		
		public static function getVolumeFromSO(group:String, defaultVolume:Number = 1):Number 
		{
			var volume:Number = defaultVolume;
			var so:SharedObject = SharedObject.getLocal("ToolSoundsVolumes");
			if (undefined != so.data[group])
			{
				volume = so.data[group];
			}
			
			so.close();
			return volume;
		}
		
		static public function get mute():Boolean 
		{
			return _mute;
		}
		
		static public function set mute(value:Boolean):void 
		{
			if (_mute != value)
			{
				_mute = value;
				if(dispatchMask & DISPATCH_CHANGE_GLOBAL) dispatcher.dispatchEvent(new ToolSoundsEvent(ToolSoundsEvent.CHANGE_GLOBAL_VOLUME, ToolSounds.volume));
			}
			
		}
		
	}

}