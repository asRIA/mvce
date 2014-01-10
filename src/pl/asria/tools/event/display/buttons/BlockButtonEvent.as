package pl.asria.tools.event.display.buttons 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class BlockButtonEvent extends Event 
	{
		public static const BUTTON_CLICK:String = "buttonClick";
		static public const REMOVE_FROM_STAGE_EVENT:String = "removeFromStageEvent";
		/** When button is blocked, useful to add some FX from code **/
		public static const BUTTON_BLOCKED:String = "buttonBlocked";
		/** When button is unblocked, useful to add some FX from code **/
		public static const BUTTON_UNBLOCKED:String = "buttonUnblocked";
		public function BlockButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new BlockButtonEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BlockButtonEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}