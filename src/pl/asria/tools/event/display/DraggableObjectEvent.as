package pl.asria.tools.event.display 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class DraggableObjectEvent extends Event 
	{
		static public const UPDATE_POINT:String = "updatePoint";
		
		public function DraggableObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DraggableObjectEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DraggableObjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}