package pl.asria.tools.event.display 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class WindowEvent extends Event 
	{
		static public const CLOSE_WINDOW:String = "closeWindow";
		static public const MINIMALIZE_WINDOW:String = "minimalizeWindow";
		static public const MAXYMALIZE_WINDOW:String = "maxymalizeWindow";
		
		public function WindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new WindowEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WindowEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}