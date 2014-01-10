/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-09-18 16:28</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.model 
{
	import flash.events.Event;
	
	public class ModelEvent extends Event 
	{
		public var value:*;
		public var key:String;
		/**  **/
		public static const CHANGE:String = "change";
		/**  **/
		public static const UPDATE_LEVEL_STRUCTURES_DEFINIIOTNS:String = "updateLevelStructuresDefiniiotns";
		
		/**
		 * ModelEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ModelEvent(type:String, key:String, value:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.value = value;
			this.key = key;
			
		} 
		
		public override function clone():Event 
		{ 
			return new ModelEvent(type, key, value, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ModelEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}