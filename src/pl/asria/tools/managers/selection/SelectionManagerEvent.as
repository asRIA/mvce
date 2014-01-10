/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-10 11:23</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers.selection 
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class SelectionManagerEvent extends Event 
	{
		public var addedElements:Dictionary;
		public var removedElements:Dictionary;
		/**  **/
		public static const CHANGE_SELECTION:String = "changeSelection";
		
		/**
		 * SelectionManagerEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SelectionManagerEvent(type:String, addedElements:Dictionary = null, removedElements:Dictionary = null,bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.addedElements = addedElements;
			this.removedElements = removedElements;
			
		} 
		
		public override function clone():Event 
		{ 
			return new SelectionManagerEvent(type, addedElements, removedElements, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SelectionManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}