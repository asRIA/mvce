/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-03 22:01</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.drag 
{
	import flash.events.Event;
	
	public class DragManagerEvent extends Event 
	{
		protected var _terminated:Boolean;
		public var description:DragDescription;
		/**  **/
		public static const REQUEST_PREPARATE_DESCRIPTION:String = "requestPreparateDescription";
		/**  **/
		public static const DROP_CONTENT_SUPPORTED:String = "dropContent";
		/**  **/
		public static const ROLL_ON_SUPPORTED:String = "rollOnSupported";
		/**  **/
		public static const ROLL_ON_UNSUPPORTED:String = "rollOnUnsupported";
		/**  **/
		public static const ROLL_OUT_UNSUPPORTED:String = "rollOutUnsupported";
		/**  **/
		public static const ROLL_OUT_SUPPORTED:String = "rollOutSupported";
		/**  **/
		public static const START_DRAG_SUPPORTED_ITEM:String = "startDragSupportedItem";
		public static const START_DRAG_UNSUPPORTED_ITEM:String = "startDragUnsupportedItem";
		/**  **/
		public static const DROP_CONTENT_UNSUPPORTED:String = "dropContentUnsupported";
	
		/**
		 * DragManagerEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function DragManagerEvent(type:String, description:DragDescription, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.description = description;
			
		} 
		
		public override function clone():Event 
		{ 
			return new DragManagerEvent(type, description, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DragManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public override function stopPropagation():void 
		{
			super.stopPropagation();
			_terminated = true
		}
		
		public override function stopImmediatePropagation():void 
		{
			super.stopImmediatePropagation();
			_terminated = true
		}
		
		public function get terminated():Boolean 
		{
			return _terminated;
		}
	}
	
}