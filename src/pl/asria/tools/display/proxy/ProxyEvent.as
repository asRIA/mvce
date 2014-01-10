/**
* CHANGELOG:
*
* 2012-01-05 12:41: Create file
*/
package pl.asria.tools.display.proxy 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ProxyEvent extends Event 
	{
		public var uri:String;
		static public const REQUEST_URI:String = "requestUri";
		public function ProxyEvent(type:String, uri:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.uri = uri;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ProxyEvent(type, uri, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ProxyEvent", "uri", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}