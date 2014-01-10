/**
* CHANGELOG:
*
* 2011-11-10 08:36: Create file
*/
package pl.asria.tools.event.data 
{
	import flash.events.Event;
	import pl.asria.tools.data.SimpleDataProvider;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SimpleDataProviderEvent extends Event 
	{
		static public const SET_DATA:String = "setData";
		static public const UPDATE:String = "update";
		static public const CLEAN:String = "clean";
		public function SimpleDataProviderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new SimpleDataProviderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SimpleDataProviderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		public function get targetTypped():SimpleDataProvider
		{
			return currentTarget as SimpleDataProvider;
		}
		
	}
	
}