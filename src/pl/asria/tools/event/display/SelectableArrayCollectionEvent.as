package pl.asria.tools.event.display 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class SelectableArrayCollectionEvent extends Event 
	{
		static public const NOT_FULL_SELECTED:String = "notFullSelected";
		public static const FULL_SELECTED:String = "fullSelected";
		public function SelectableArrayCollectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SelectableArrayCollectionEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SelectableArrayCollectionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}