package pl.asria.tools.event.display.ui 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ScrollbarEvent extends Event 
	{
		public var data:*;
		static public const CHANGE_INDEX:String = "changeIndex";
		
		/** When controller require to change lock status **/
		public static const REQUEST_LOCK:String = "requestLock";
		/** When controller require to change lock status **/
		public static const REQUEST_UNLOCK:String = "requestUnlock";
		
		public function ScrollbarEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.data = data;
			
		} 
		
		public override function clone():Event 
		{ 
			return new ScrollbarEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ScrollbarEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}