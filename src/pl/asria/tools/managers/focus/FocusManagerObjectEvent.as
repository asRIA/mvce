package pl.asria.tools.managers.focus 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public final class FocusManagerObjectEvent extends Event 
	{
		static public const CHANGE_FOCUS:String = "changeFocus";
		static public const SET_STATE_FOCUS:String = "setStateFocus";
		static public const CHANGE_TO_FOCUS:String = "changeToFocus";
		static public const CHANGE_TO_UNFOCUS:String = "changeToUnfocus";
		public function FocusManagerObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new FocusManagerObjectEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FocusManagerObjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}