/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-17 15:17</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui 
{
	import flash.events.Event;
	
	public class SlicerControllerEvent extends Event 
	{
		/**  when user change progress value by action**/
		public static const UPDATE_PROGRESS:String = "updateProgress";
		/** maual set progress **/
		public static const SET_PROGRESS:String = "setProgress";
		/**  **/
		public static const STOP_UPDATE_PROGRESS:String = "stopUpdateProgress";
	
		/**
		 * SlicerControllerEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SlicerControllerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SlicerControllerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SlicerControllerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}