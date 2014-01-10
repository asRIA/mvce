/**
* CHANGELOG:
*
* 2011-11-23 13:25: Create file
*/
package pl.asria.tools.event.utils 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ShortkeysDetectorEvent extends Event 
	{
		public var seqwenceName:String;
		static public const MATCH_SEQWENCE:String = "matchSeqwence";
		static public const OVER_TIME:String = "overTime";
		public function ShortkeysDetectorEvent(type:String, seqwenceName:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.seqwenceName = seqwenceName;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ShortkeysDetectorEvent(type, seqwenceName, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ShortkeysDetectorEvent", "seqwenceName", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}