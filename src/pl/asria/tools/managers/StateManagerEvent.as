package pl.asria.tools.managers 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class StateManagerEvent extends Event 
	{
		public var state:String;
		static public const CHANGE:String = "change";
		static public const JOIN_STATE:String = "joinState";
		static public const PART_STATE:String = "partState";
		
		public function StateManagerEvent(type:String, state:String,  bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			this.state = state;
		} 
		
		public override function clone():Event 
		{ 
			return new StateManagerEvent(type, state,bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StateManagerEvent","state", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}