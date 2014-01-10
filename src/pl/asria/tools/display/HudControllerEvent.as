/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-23 11:27</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	import flash.events.Event;
	
	public class HudControllerEvent extends Event 
	{
		public var data:*;
		/** in data is target **/
		public static const END_HIDE:String = "endHide";
		/** in data is target **/
		public static const END_SHOW:String = "endShow";
	
		/**
		 * HudControllerEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function HudControllerEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.data = data;
			
		} 
		
		public override function clone():Event 
		{ 
			return new HudControllerEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("HudControllerEvent", "data","type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}