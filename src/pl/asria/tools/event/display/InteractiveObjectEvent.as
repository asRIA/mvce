package pl.asria.tools.event.display 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class InteractiveObjectEvent extends Event 
	{
		static public const UPDATE_POSITION:String = "updatePosition";
		static public const DOUBLE_CLICK:String = "doubleClickIteam";
		static public const RIGHT_CLICK:String = "rightClick";
		static public const STOP_DRAG:String = "stopDrag";
		static public const START_DRAG:String = "startDrag";
		static public const ONCE_CLICK:String = "onceClick";
		static public const HOLD_CLICK:String = "holdClick";
		static public const REQUEST_REMOVE:String = "requestRemove";
		
		public function InteractiveObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new InteractiveObjectEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("InteractiveObjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}