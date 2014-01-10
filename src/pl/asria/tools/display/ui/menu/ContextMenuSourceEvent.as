/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-09 17:25</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	import flash.events.Event;
	
	public class ContextMenuSourceEvent extends Event 
	{
		protected var _source:ContextMenuSource;
		internal var internal_description:ContextMenuDescription;
		/** Dispatched by context menu source, this is request to observers to fill description **/
		public static const REQUEST_DESCRIPTION:String = "requestDescription";
		/**  **/
		public static const GLOBAL_REQUEST_DESCRIPTION:String = "globalRequestDescription";
		
		/**
		 * ContextMenuSourceEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ContextMenuSourceEvent(type:String, source:ContextMenuSource, bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
			_source = source;
		} 
		
		public function get description():ContextMenuDescription
		{
			internal_description = internal_description || new ContextMenuDescription();
			return internal_description
		}
		
		public override function clone():Event 
		{ 
			var clone:ContextMenuSourceEvent = new ContextMenuSourceEvent(type, _source, bubbles, cancelable);
			clone.internal_description = internal_description;
			return clone
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ContextMenuSourceEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get source():ContextMenuSource 
		{
			return _source;
		}
		
	}
	
}