/**
* CHANGELOG:
*
* 2011-11-24 17:35: Create file
*/
package pl.asria.tools.managers.animation 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class AnimationManagerEvent extends Event 
	{
		static public const EMPTY_QUEYE:String = "emptyQueye";
		static public const PLAY_LABEL:String = "playLabel";
		static public const COMPLETE_LABEL:String = "completeLabel";
		
		public function AnimationManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AnimationManagerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AnimationManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}