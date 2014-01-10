/**
* CHANGELOG:
*
* 2012-01-17 14:55: Create file
*/
package pl.asria.tools.media.sound 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ToolSoundsEvent extends Event 
	{
		public var data:*;
		static public const CHANGE_GLOBAL_VOLUME:String = "changeGlobalVolume";
		static public const CHANGE_GROUP_VOLUME:String = "changeGroupVolume";
		public function ToolSoundsEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ToolSoundsEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ToolSoundsEvent", "data", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}