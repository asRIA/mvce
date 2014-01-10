/**
* CHANGELOG:
*
* 2012-01-15 20:11: Create file
*/
package pl.asria.tools.media.sound 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SoundLoaderEvent extends Event 
	{
		public var soundClass:Class;
		static public const GET_SOUND_COMPLETE:String = "getSoundComplete";
		public function SoundLoaderEvent(type:String, soundClass:Class, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.soundClass = soundClass;
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new SoundLoaderEvent(type, soundClass, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SoundLoaderEvent", "soundClass", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}