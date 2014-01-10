/**
* CHANGELOG:
*
* 2011-12-01 11:39: Create file
*/
package pl.asria.tools.managers.animation 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class AnimationPathControlerEvent extends Event 
	{
		static public const REQUEST_MOVE_STOP:String = "requestMoveStop";
		static public const REQUEST_MOVE_UP:String = "requestMoveUp";
		static public const REQUEST_MOVE_DOWN:String = "requestMoveDown";
		
		public function AnimationPathControlerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AnimationPathControlerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AnimationPathControlerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}