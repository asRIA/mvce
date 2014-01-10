package pl.asria.tools.event.display.ui 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - trzeci.eu
	 */
	public class EventProgress extends Event 
	{
		public var progress:Number;
		static public const UPDATE:String = "updateProgress";
		
		public function EventProgress(type:String, progress:Number, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.progress = progress;
			
		} 
		
		public override function clone():Event 
		{ 
			return new EventProgress(type, progress, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EventProgress","progress", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}