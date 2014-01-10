/**
* CHANGELOG:
*
* 2011-12-08 19:43: Create file
*/
package pl.asria.tools.fx.object 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class StageFXEvent extends Event 
	{
		static public const PLAY_FX:String = "playFx";
		/**  **/
		public static const REMOVED_FX:String = "removedFx";
		
		public function StageFXEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new StageFXEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StageFXEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}