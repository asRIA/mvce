package pl.asria.tools.event.display.ui 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class RightClickEvent extends MouseEvent 
	{
		public static const RIGHT_CLICK:String = "rightClick";
		
		public function RightClickEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, localX:Number = 0, localY:Number = 0) 
		{ 
			super(type, bubbles, cancelable,localX, localY);
			
		} 
		
		public override function clone():Event 
		{ 
			return new RightClickEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("RightClickEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}