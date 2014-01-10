/**
* CHANGELOG:
*
* 2011-11-24 18:41: Create file
*/
package pl.asria.tools.managers.ui 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class IdleManagerEvent extends Event 
	{
		static public const IDLE_JOIN:String = "idleJoin";
		static public const WAKE_UP:String = "wakeUp";
		/** when idle animation is sill in idle mode, also this is trigger **/
		public static const IDLE_REFRESH:String = "idleRefresh";
		
		public function IdleManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new IdleManagerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("IdleManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}