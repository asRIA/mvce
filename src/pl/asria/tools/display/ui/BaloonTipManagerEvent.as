/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-17 11:52</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui 
{
	import flash.events.Event;
	import pl.asria.tools.event.ExtendEvent;
	
	public class BaloonTipManagerEvent extends ExtendEvent
	{
		/** When mouse is over some target register in BaloonTipManager **/
		public static const TARGET_START_DELAY:String = "targetStartDelay";
		/**  **/
		public static const SHOW_BALOONTIP:String = "showBaloontip";
		/** When mouse focused on some target, you can switch default register content to some condytion one **/
		public static const PREPARATE_BALOONTIP_CONTENT:String = "preparateBaloontipContent";
		/**  **/
		public static const PARAM_TARGET:String = "paramTarget";
		/**  **/
		public static const PARAM_CONTENT:String = "paramContent";
	
		/**
		 * BaloonTipManagerEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function BaloonTipManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new BaloonTipManagerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BaloonTipManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}