/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-18 09:36</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui 
{
	import flash.events.Event;
	
	public class BaloonTipEvent extends Event 
	{
		/** Begin of show animation **/
		public static const SHOW_BEGIN:String = "showBegin";
		/**  **/
		public static const SHOW_END:String = "showEnd";
		/**  **/
		public static const HIDE_END:String = "hideEnd";
		/**  **/
		public static const HIDE_BEGIN:String = "hideBegin";
	
		/**
		 * BaloonTipEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function BaloonTipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new BaloonTipEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BaloonTipEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}