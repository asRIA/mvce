package pl.asria.tools.media.sound 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SoundControllerEvent extends Event 
	{
		static public const SOUND_COMPLETE:String = "soundComplete";
		static public const SOUND_LOOP_COMPLETE:String = "soundLoopComplete";
		
		public function SoundControllerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SoundControllerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SoundControllerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}