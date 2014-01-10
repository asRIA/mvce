package pl.asria.tools.event.display 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class SelectableObjectEvent extends Event 
	{
		public static const CHANGE:String = "selectableChange";
		public static const SELECT:String = "selectableSelect";
		public static const UNSELECT:String = "selectableUnselect";
		public function SelectableObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SelectableObjectEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SelectableObjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}