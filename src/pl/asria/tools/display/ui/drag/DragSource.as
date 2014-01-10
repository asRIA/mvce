/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-03 19:56</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.drag 
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/** 
	* Dispatched when DragManager is preparateing curreent displayed object
	**/
	[Event(name="requestPreparateDescription", type="pl.asria.tools.display.ui.drag.DragManagerEvent")]
	public class DragSource extends EventDispatcher
	{
		public var triggerDispatcher:IEventDispatcher;
		public var triggerDrop:String;
		public var trigger:String;
		public var triggerDropDispatcher:IEventDispatcher;
		public var payload:*;

		/**
		 * DragSource - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	trigger	exent after this, drag object will be activated
		 * @param	triggerDispatcher	source object, on this object will be dispatched DragEvent.REQUEST_PREPARATE_DESCRIPTION, and this event have to be handler, and event.data have to be set
		 * @param	triggerDrop this is oposition to trigger, after triggerDrop current draged element is released
		 * @param	triggerDropDispatcher in most cases this is stage. for example, if trigger is MOUSE_DOWN, then stage is waiting for MOUSE_UP, and release current dragged object
		 * @param	payload user data
		 */
		public function DragSource(trigger:String,triggerDispatcher:IEventDispatcher,  triggerDrop:String, triggerDropDispatcher:IEventDispatcher, payload:* = null)
		{
			this.payload = payload;
			this.triggerDispatcher = triggerDispatcher;
			this.trigger = trigger;
			this.triggerDrop = triggerDrop;
			this.triggerDropDispatcher = triggerDropDispatcher;
			
		}
		
	}

}